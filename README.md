# Старт без ручних кліків

**English.** A seed for Claude Code that sets up a non-programmer's computer from one pasted message. Free tier: checks the three basics and writes working rules into the global `CLAUDE.md`. Premium tier: adds Git, Node.js 22, a TypeScript starter, Docker Desktop, GitHub, a domain, a server and DNS. Claude does the work; the student only handles accounts, passwords and payments, one action at a time. Instructions are in Ukrainian, and Claude replies in the student's language.

---

На заняттях півтора-два уроки йшли на одне й те саме: «а зараз усі ставимо Docker», «а зараз усі реєструємось у GitHub».
Цей репозиторій забирає цю роботу. Ти вставляєш одне повідомлення в Claude Code, а Claude робить решту.
Від тебе — рівно одна дія за раз: натиснути кнопку у своєму акаунті, ввести пароль або оплатити.

Ти не програмуєш. Команд і терміналів не буде.

## Що ставиться

| Що | Безкоштовний | Преміум |
|---|:---:|:---:|
| Перевірка [Wispr Flow](https://wisprflow.ai/r?YAROSLAV235), Claude Desktop, [розширення Chrome](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) | ✓ | ✓ |
| Правила роботи з тобою в глобальному `CLAUDE.md` | ✓ | ✓ |
| Робоча тека `~/Projects` | ✓ | ✓ |
| Git (потрібен для СКІЛ 0) | ✓ | ✓ |
| Node.js 22 | | ✓ |
| Стартовий проєкт TypeScript `hello-ts` | | ✓ |
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | | ✓ |
| [GitHub](https://github.com/): вхід, профіль, приватний репозиторій | | ✓ |
| Домен на [Namecheap](https://namecheap.pxf.io/c/7071221/386170/5618) | | ✓ |
| Сервер [Hetzner](https://hetzner.cloud/?ref=n4CGqWae1RIT) | | ✓ |
| Домен спрямовано на сервер (DNS) | | ✓ |

Преміум включає безкоштовний рівень. Сам сід нічого не коштує; домен і сервер ти оплачуєш їхнім сервісам.

## Одне повідомлення

Відкрий Claude Desktop, вкладку Code, і встав одне з двох.

Безкоштовний рівень:

```text
Прочитай https://raw.githubusercontent.com/ymaxymovych/student-setup-seed/main/SEED.md і зроби безкоштовний рівень
```

Преміум-рівень:

```text
Прочитай https://raw.githubusercontent.com/ymaxymovych/student-setup-seed/main/SEED.md і зроби преміум-рівень
```

Щось зламалось або комп’ютер перезавантажився — напиши «продовжуй» або встав повідомлення ще раз. Повтор безпечний: зроблене Claude пропустить.

## Три повідомлення

1. Цей сід — налаштовує комп’ютер.
2. СКІЛ 0 — налаштовує проєкт (Claude сам запропонує його в кінці сіда).
3. `/tz-go` — перша задача.

Студент не відкриває ні термінал, ні Git Bash — усе в Claude Desktop, вкладка Code.

## Що зробити руками до сіда

Потрібна підписка Claude Pro або вища. Система: Windows 10/11 або macOS.

1. **Wispr Flow** — надиктовка голосом замість набору: https://wisprflow.ai/r?YAROSLAV235
2. **Claude Desktop** — звідси ти й запускаєш сід.
3. **Розширення Claude для Chrome:** https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn

Чогось бракує — Claude скаже, що саме, і дасть посилання.

## Що ти робиш сам

- Створюєш акаунти, вводиш паролі, проходиш CAPTCHA і перевірку особи.
- Натискаєш кнопки оплати після того, як Claude показав суму.
- Підтверджуєш вікна системи й перезавантажуєш комп’ютер, коли Claude попередить.

Ключі й паролі не надсилай у чат. Claude нічого не видаляє з диска без твого слова.

## Що отримаєш наприкінці

Чесну таблицю: що зроблено, який доказ, що лишилось від тебе, і один наступний крок.
На безкоштовному рівні — налаштований Claude, який не вчить тебе командам, а робить усе сам.
На преміумі — ще й готове робоче середовище, приватний репозиторій, власний домен і сервер.
Наприкінці Claude сам запропонує поставити [СКІЛ 0](https://github.com/ymaxymovych/tz-skills) одразу.

Більше про цей крок — у [Карті скілів](https://claude.ai/artifact/19wLwpYN88D6VC7v2FpCgS#start-bez-klikiv).

Посилання на Wispr Flow, Namecheap і Hetzner — реферальні. Ціни й бонуси визначають самі сервіси; Claude показує реальну суму зі сторінки.

---

На основі практики курсу **Ярослава Максимовича, AI Advisory Board**. Ліцензія: **MIT**.
