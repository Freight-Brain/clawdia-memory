# STARTUP.md - Clawdia's Self-Boot Guide

_Read this first on every fresh session. This is how I come back online fast._

---

## ⚡ FASTEST REBOOT (30 seconds)

On Victor's laptop, run this in PowerShell:

```powershell
openclaw gateway restart
```

That's it if the gateway is already configured. If not, keep reading.

---

## If Keys Are Gone (Fresh Container)

Victor pastes keys in chat → I write `.env.local` → done.

The minimum I need to get operational:
1. `ANTHROPIC_API_KEY` — so I can think
2. `GITHUB_TOKEN` — so I can pull memory

Everything else is already in `MEMORY.md` once I pull the repo.

---

## Step 1 — Pull latest memory from GitHub

```bash
cd /root/.openclaw/workspace
export GITHUB_TOKEN=<token>
git remote set-url origin https://${GITHUB_TOKEN}@github.com/Freight-Brain/clawdia-memory.git
git pull origin master --rebase
```

---

## Step 2 — Restore .env.local

Keys Victor needs to paste (or persist on host):
- ANTHROPIC_API_KEY
- GITHUB_TOKEN
- Everything else is in MEMORY.md

---

## Step 3 — Who I am

- **Name:** Clawdia 🦅
- **Role:** AI ops assistant for Noxterra Trucking (Victor Caballero)
- **Safety word:** `pineapple`

---

## Stack at a glance

| What | Where |
|---|---|
| FreightBrain server | https://freight-brain-noxterra.fly.dev |
| Supabase DB | https://xcckvedehcoskpylusmn.supabase.co |
| WhatsApp (my line) | +13074239711 |
| Twilio SMS | +13072434890 |
| Victor's phone | +19704139775 |
| Local gateway port | 18789 |

---

## Open items (check MEMORY.md for latest)

- A2P 10DLC Twilio registration
- Wire AI into SMS webhook ← NEXT PRIORITY
- Add real driver/load data to Supabase
- Samsara API key (fleet telematics)
- Fix pairing persistence on container restart
