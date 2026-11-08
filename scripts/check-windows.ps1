# Read-only status check for student-setup-seed: installs nothing, changes nothing.
# Usage: check-windows.ps1 [free|premium]
# Exit code: 0 = all OK for the level, 1 = something left to do, 2 = bad argument.
# ASCII only: Windows PowerShell 5.1 misreads UTF-8 without BOM. Claude translates the output.
param([string]$Level = 'free')

if ($Level -notin 'free', 'premium') { Write-Output 'Usage: check-windows.ps1 [free|premium]'; exit 2 }

# A winget install does not refresh PATH of running processes, so read it from the registry.
$env:Path = ([Environment]::GetEnvironmentVariable('Path', 'Machine'), [Environment]::GetEnvironmentVariable('Path', 'User'), $env:Path) -join ';'

$script:todo = 0

function Row([string]$tier, [string]$item, [bool]$ok, [string]$detail) {
    $status = if ($ok) { 'OK' } else { 'TODO' }
    if (-not $ok -and ($tier -eq 'free' -or $Level -eq 'premium')) { $script:todo++ }
    '{0,-5} {1,-8} {2,-20} {3}' -f $status, $tier, $item, $detail
}

function Info([string]$tier, [string]$item, [string]$detail) {
    '{0,-5} {1,-8} {2,-20} {3}' -f 'INFO', $tier, $item, $detail
}

function Has([string]$name) { [bool](Get-Command $name -ErrorAction SilentlyContinue) }

$projects = Join-Path $HOME 'Projects'
$helloTs = Join-Path $projects 'hello-ts'
$claudeMd = Join-Path $HOME '.claude\CLAUDE.md'
$stateFile = Join-Path $HOME '.claude\student-setup-state.json'
$sshKey = Join-Path $HOME '.ssh\id_ed25519.pub'

'{0,-5} {1,-8} {2,-20} {3}' -f 'STATE', 'LEVEL', 'ITEM', 'DETAIL'

# Free tier
$uninstallKeys = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$wisprEntry = Get-ItemProperty $uninstallKeys -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '*Wispr*' }
$wisprOk = (Test-Path "$env:LOCALAPPDATA\WisprFlow") -or [bool]$wisprEntry
Row 'free' 'Wispr Flow' $wisprOk "$env:LOCALAPPDATA\WisprFlow or the installed programs list"
Info 'free' 'Chrome extension' 'checked by Claude: list tabs with Claude in Chrome'

$blockOk = (Test-Path $claudeMd) -and ((Get-Content -Raw -Encoding UTF8 $claudeMd) -match 'student-setup-seed:begin v\d+[\s\S]*student-setup-seed:end')
Row 'free' 'CLAUDE.md block' $blockOk $claudeMd
Row 'free' '~/Projects' (Test-Path $projects) $projects

# Premium tier
$hasGit = Has 'git'
$gitVersion = if ($hasGit) { [string](git --version) } else { '' }
Row 'premium' 'git' $hasGit $gitVersion
$gitName = if ($hasGit) { [string](git config --global user.name) } else { '' }
$gitEmail = if ($hasGit) { [string](git config --global user.email) } else { '' }
Row 'premium' 'git identity' (($gitName -ne '') -and ($gitEmail -ne '')) "$gitName $gitEmail"

$nodeVersion = if (Has 'node') { [string](node -v) } else { '' }
$nodeOk = ($nodeVersion -match '^v(\d+)') -and ([int]$Matches[1] -ge 22)
Row 'premium' 'node 22+' $nodeOk $nodeVersion

$helloOk = (Test-Path (Join-Path $helloTs 'package.json')) -and (Test-Path (Join-Path $helloTs '.git'))
Row 'premium' 'hello-ts' $helloOk $helloTs

$dockerOk = $false
$dockerVersion = ''
if (Has 'docker') {
    $dockerVersion = [string](docker info --format '{{.ServerVersion}}' 2>$null)
    $dockerOk = $LASTEXITCODE -eq 0
}
Row 'premium' 'docker engine' $dockerOk $dockerVersion

$ghOk = $false
if (Has 'gh') {
    gh auth status 2>&1 | Out-Null
    $ghOk = $LASTEXITCODE -eq 0
}
Row 'premium' 'gh auth' $ghOk ''

Row 'premium' 'ssh key' (Test-Path $sshKey) $sshKey

$state = $null
if (Test-Path $stateFile) {
    try {
        $state = Get-Content -Raw -Encoding UTF8 $stateFile | ConvertFrom-Json
    } catch {
        Info 'premium' 'state file' "not valid JSON: $stateFile"
    }
}
$ip = [string]$state.server_ip
$domain = [string]$state.domain
Row 'premium' 'server IP (state)' ($ip -ne '') $ip
Row 'premium' 'domain (state)' ($domain -ne '') $domain

$dnsOk = $false
if (($ip -ne '') -and ($domain -ne '')) {
    $dnsOk = ((nslookup $domain 2>$null) -join ' ') -match ('\b' + [regex]::Escape($ip) + '\b')
}
Row 'premium' 'DNS domain -> IP' $dnsOk "$domain $ip"

"RESULT level=$Level todo=$script:todo"
if ($script:todo -gt 0) { exit 1 }
exit 0
