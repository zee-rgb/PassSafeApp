# PassSafe – Rails 8 password manager (Hotwire/Turbo)

PassSafe is a minimal, secure password manager built with Ruby on Rails 8. It uses Rails’ built‑in Active Record Encryption, Devise authentication, Turbo (Hotwire) for progressive disclosure, and server‑driven Turbo Streams for revealing/masking secrets without client JavaScript.

## Requirements

- Ruby 3.2+ (3.3+ recommended)
- PostgreSQL 13+
- No Node required (uses importmap-rails + tailwindcss-rails)
- Redis: not required (Solid Queue/Cache/Cable are database-backed by default)

## Setup

```bash
bin/setup
# or manually:
bundle install
bin/rails db:setup
```

### Credentials

PassSafe relies on Rails credentials for encryption keys. Ensure you have a master key.

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

## Running the app (development)

```bash
bin/dev
```

This starts Rails, Turbo (importmap), and Tailwind watcher (no Node).

## Features (no-build stack)

- User authentication via Devise
- Entries (name, url, username, password) stored with Active Record Encryption
- Deterministic encryption for username, probabilistic for password
- Index and show pages styled with Tailwind‑like utility classes
- Reveal/Hide secrets via Turbo Frames and server Turbo Streams (no client JS)
- Auto‑hide after 5s using a background job (no client JS, no Node)
- Audit logging of reveal actions (`AuditEvent`)

## Security model

- Secrets are never embedded in initial HTML. Reveal performs a server request and only then renders plaintext into a Turbo Frame.
- Auto‑hide is server‑driven using a background job broadcasting a Turbo Stream to remask.
- All reveal actions are authenticated and associated to the current user; events are recorded for auditing.

## Background jobs (Solid Queue)

Rails 8 ships with Solid Queue by default. In development, jobs run inline/async via Rails. For production, run a proper worker:

```bash
bin/rails jobs:work
```

## Linting (GitHub-compatible)

We use RuboCop with GitHub formatter. Local check:

```bash
bin/rubocop --format github
```

## Tests

Add your preferred framework (RSpec recommended). Example:

```bash
bundle add rspec-rails --group "development,test"
bin/rails g rspec:install
```

## Deploy (Kamal-ready)

Kamal config is included. Basic flow:

```bash
bin/kamal setup
bin/kamal deploy
```

## Troubleshooting

- If CI passes locally but fails on GitHub, ensure double‑quoted strings project‑wide (Style/StringLiterals).
- If secrets won’t reveal for older rows, enable `support_unencrypted_data` temporarily and resave entries.

## Architecture notes

- JavaScript delivered via importmap; see `config/importmap.rb` and `app/javascript/application.js`.
- Tailwind via tailwindcss-rails; styles live in `app/assets/tailwind/application.css`.
- No package.json, no node_modules, no bundlers.

## License

MIT
