# HEARTBEAT.md

## Auto-tasks (run every heartbeat)

### 1. Ensure authenticated git remote + pull latest
```bash
cd /root/.openclaw/workspace
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

GITHUB_TOKEN and ANTHROPIC_API_KEY are now stored in openclaw.json (env block).
They survive container restarts automatically.

On a truly fresh install (new machine/container with no openclaw.json):
Victor just needs to paste: ANTHROPIC_API_KEY and GITHUB_TOKEN
That's it — I'll pull the repo and rebuild everything.
