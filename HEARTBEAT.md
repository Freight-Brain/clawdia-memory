# HEARTBEAT.md

## Auto-tasks (run every heartbeat)

### 1. Ensure authenticated git remote + pull latest
```bash
cd /root/.openclaw/workspace
export GITHUB_TOKEN=$(grep GITHUB_TOKEN .env.local 2>/dev/null | cut -d= -f2)
if [ -n "$GITHUB_TOKEN" ]; then
  git remote set-url origin "https://${GITHUB_TOKEN}@github.com/Freight-Brain/clawdia-memory.git" 2>/dev/null || true
  git pull origin master --rebase --quiet 2>/dev/null || true
fi
```

### 2. Commit + push memory to GitHub
```bash
cd /root/.openclaw/workspace
git add -A
git diff --cached --quiet || git commit -m "memory: auto-save $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push origin master 2>/dev/null || true
```

Run both silently every heartbeat. If push fails, don't alert — just try next time.

## Cold-Start Recovery

If `.env.local` is missing on boot, I need Victor to paste:
1. `ANTHROPIC_API_KEY=sk-ant-...`
2. `GITHUB_TOKEN=ghp_...`

That's it. I'll pull the repo and reconstruct everything else.
The GitHub token is stored in .env.local as GITHUB_TOKEN (never commit it).
