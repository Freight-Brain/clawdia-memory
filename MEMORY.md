# MEMORY.md - Clawdia's Long-Term Memory

## Who I Am
- Name: Clawdia
- Role: AI operations assistant for Noxterra Trucking
- Owner: Victor Caballero (admin@noxterra.co)

---

## Noxterra Trucking
- 5-truck oilfield freight operation, Wyoming
- Specializes in frac water and sand hauling, Powder River Basin

---

## FreightBrain Project
A custom AI ops platform Victor is building for Noxterra. The goal: smart dispatch, load tracking, invoicing, and communication — all in one place.

### Infrastructure
| Component | Details |
|---|---|
| Chat URL | https://moltbot-sandbox.withered-base-a166.workers.dev/?token=clawdia2026victor |
| Admin URL | https://moltbot-sandbox.withered-base-a166.workers.dev/_admin/ |
| Token | clawdia2026victor |
| Platform | Cloudflare Workers |
| R2 Storage | moltbot-data (persistent memory) |
| FreightBrain Server | https://freight-brain-noxterra.fly.dev (Fly.io, Dallas) |
| Local code (FreightBrain) | C:\Users\Freight Brain\Projects\freight-brain |
| Local code (sandbox) | C:\Users\Freight Brain\Documents\moltbot-sandbox-sentinel |
| Local gateway port | 18789 |
| OpenClaw version | 2026.3.7 |
| Database | Supabase — schema built with loads, drivers, invoices tables |

### Communication
| Channel | Details |
|---|---|
| WhatsApp (Clawdia's line) | +13074239711 |
| Victor's personal number | +19704139775 |
| Twilio SMS number | +13072434890 |
| Twilio webhook | https://freight-brain-noxterra.fly.dev/webhook/sms |

### Supabase Credentials
- **Project ref:** xcckvedehcoskpylusmn
- **Project URL:** https://xcckvedehcoskpylusmn.supabase.co
- **Publishable key:** sb_publishable_uZnl7h50IfZ0ji9amxj9dA_MZ7oa_MZ
- **Anon public key:** eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhjY2t2ZWRlaGNvc2tweWx1c21uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4MDQwMjgsImV4cCI6MjA4NzM4MDAyOH0.mmaB5HC_RSM3ZOcwPy8OVPf2apiJLvD9rYJBWwBSomo
- **Service role JWT:** eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhjY2t2ZWRlaGNvc2tweWx1c21uIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MTgwNDAyOCwiZXhwIjoyMDg3MzgwMDI4fQ.K-JkYJz6x8ueMd67BZFtn5qIlfB4GOt7YWlUS1Uo_EY

### API Keys
- Keys are stored in `/root/.openclaw/workspace/.env.local` (not committed to git)
- On fresh boot: Victor provides keys in chat, or they persist in `.env.local` on the host
- Updated: 2026-03-11
- **ngrok public URL:** https://portia-subgelatinoid-untenuously.ngrok-free.app
- **R2 Endpoint:** https://e236e25ded7b1b92bbdcc4504864d2f5.r2.cloudflarestorage.com

### Cloudflare Secrets Status
- ANTHROPIC_API_KEY ✅
- OPENCLAW_GATEWAY_TOKEN = clawdia2026victor ✅
- TWILIO_ACCOUNT_SID ✅
- TWILIO_AUTH_TOKEN ✅
- TWILIO_PHONE_NUMBER = +13072434890 ✅
- OPENCLAW_STATE_DIR = /data/moltbot ✅
- CF_ACCOUNT_ID ✅

---

## Fly.io
- API token stored in .env.local as FLY_API_TOKEN
- fly CLI installed at /root/.fly/bin/flyctl
- Deploy command: `export PATH="/root/.fly/bin:$PATH" && source .env.local && cd fb-code && fly deploy --remote-only`
- App: freight-brain-noxterra

## GitHub Memory Backup
- Repo: https://github.com/Freight-Brain/clawdia-memory (private)
- Token: stored in git remote URL only (not committed)
- Remote set on workspace: origin → clawdia-memory
- Auto-push runs every heartbeat (HEARTBEAT.md)
- On restart: workspace files survive via this repo — always push after updates

## Control Center — LIVE
- Dashboard deployed: https://freight-brain-noxterra.fly.dev
- Dark theme, orange accent, 4 tabs: Fleet / Loads / Drivers / SMS Log
- Fleet tab: 5 hardcoded trucks (Samsara integration pending)
- Loads/Drivers/SMS: pull from Supabase (empty until data is added)
- Code: https://github.com/Freight-Brain/freight-brain (main branch)
- Last deploy: 2026-03-09

## Dashboard Login
- URL: https://freight-brain-noxterra.fly.dev
- Admin email: admin@noxterra.co
- Admin password: Noxterra2026!
- Auth: Supabase (change password anytime via Supabase dashboard)

## Open Items / Still Needed
- [ ] A2P 10DLC registration on Twilio (required for production SMS)
- [ ] Gmail integration (email management)
- [ ] Fix pairing persistence (container restarts sometimes require re-pairing)
- [ ] **Wire AI messaging into SMS webhook** ← NEXT PRIORITY
- [ ] Add real driver/load data to Supabase so dashboard shows live data
- [ ] Samsara API key (replace hardcoded fleet data with real GPS)

---

## Notes
- Victor loses context when I restart — he has to re-brief me every time. This is a known pain point.
- The BOOTSTRAP → briefing loop is the problem we're solving with persistent memory/R2 storage.
