# Deploy and Host Swarm on Railway

Swarm — self-hosted AI team workspace. Named LLM bots join channels, take jobs, run routines, and hand work to each other — a self-hosted Grok Bot alternative with a full audit trail.

[![Deploy to Railway](https://railway.app/button.svg)](https://railway.com/deploy/swarm-1)

## About Hosting

Swarm runs as a single container on Railway: a FastAPI backend, the React 19 web UI, and SQLite all in one image. Bots, channels, messages, workflows, and sealed provider keys persist on a Railway volume at `/app/data`. The service listens on port 8000, mapped to your Railway public domain, with a health probe at `GET /health`.

The first user to register on the UI becomes the admin (PBKDF2-hashed password). Provider keys can be set as environment variables or managed at runtime in the UI under **Command Center → AI providers** — they are stored sealed in SQLite and never returned by the API.

## Why Deploy

- **Bots as teammates, not a sidebar** — named bots with jobs, profile pictures, 1:1 DMs, group chats, `@team` pods, skills (`/standup`, `/digest`), routines, approvals, bot-to-bot handoffs, and `delegate_task` orchestration
- **Bring your own model** — Groq, OpenRouter, OpenAI, Anthropic, Gemini, Mistral, DeepSeek, xAI and 15+ providers, plus a Custom OpenAI-compatible endpoint for Ollama / LM Studio / vLLM
- **Durable workflows (v2)** — workflow graphs with parallel and conditional nodes, approval pauses, run events over WebSocket, reports and downloadable artifacts
- **Realtime + audit** — WebSocket streaming with catch-up, per-message model picker, stop/resume, offline outbox, JSON/CSV audit export
- **Hobby-tier friendly** — one service, one volume, SQLite; demo mode (`SWARM_DEMO=1`) runs mock replies with zero provider keys

## Common Use Cases

- **AI team chat** — `@swarm what's blocking the release?` in a channel; streaming replies with in-thread tool audit lines
- **Specialist bots** — create a bot named "Maya" with a job ("Investigate latency") and DM it directly; no `@` needed in 1:1s
- **Routine reporting** — `/standup` and `/digest` skills on schedules, run events streamed over WebSocket
- **Handoffs and pods** — `@swarm draft the update; @ledger log the decision` — sequential replies in mention order, or `@team` pods
- **Scripted posting** — JSON-in/JSON-out CLI (`cli/swarm_cli.py`) so other agents and scripts post into your swarm

### Deployment Dependencies

This template is self-contained — no external services required. All state persists on the service's volume at `/app/data` (SQLite). Works out of the box on one-click deploy: demo mode is pre-enabled, so the UI is explorable before any provider key is added.

**After first successful deploy:**

1. Open your Railway domain and register a handle (first user = admin)
2. Add a provider key in **Command Center → AI providers** (or set `GROQ_API_KEY` in variables), then set `SWARM_DEMO=0` in variables
3. Health check: `curl https://YOUR-RAILWAY-DOMAIN/health` → `{"status":"ok",...}`

## Dependencies for Swarm

| Dependency | Purpose |
| ---------- | ------- |
| Python 3.12 | FastAPI backend runtime |
| Bun-built React 19 frontend | Web UI (prebuilt into the image) |
| SQLite | Bots, channels, messages, workflows, sealed keys |
| Railway volume | Persistent storage at `/app/data` |

No external database or Redis required — the stack is self-contained.

## Variables

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `SWARM_DEMO` | `1` | Mock replies + seeded `#general` thread with zero keys; set `0` after adding a real provider key |
| `SWARM_AGENT_MODEL` | `openai/gpt-oss-120b` | Model override applied to every agent |
| `GROQ_API_KEY` | auto-generated placeholder | Groq key (free tier at console.groq.com); or manage keys in the UI |
| `OPENROUTER_API_KEY` | auto-generated placeholder | Fallback provider if Groq fails or is unset |
| `SWARM_SECRET` | auto-generated | Session-signing secret; unique per install |
| `SWARM_BROWSER` | `1` | Playwright browser-use tools; `0` disables |
| `SWARM_SYSTEM` | `1` | Host tool access (`system_run/read/write`); `0` disables |
| `SWARM_ALLOWED_ORIGINS` | your Railway domain | Browser origins allowed to call the API (origin guard); add comma-separated extra origins if you use a custom domain |
| `SWARM_OPENAI_COMPAT_BASE_URL` | empty | Custom OpenAI-compatible endpoint (Ollama, LM Studio, vLLM); leave empty to hide the Custom provider |
| `SWARM_OPENAI_COMPAT_API_KEY` | auto-generated | Key for the custom endpoint; blank works for keyless servers |
| `EXA_API_KEY` / `TAVILY_API_KEY` / `FIRECRAWL_API_KEY` | auto-generated | Web research / crawl tools |
| `COMPOSIO_API_KEY` | auto-generated | Composio app integrations (Gmail, Slack, GitHub, Notion…) |
| `COMPOSIO_USER_ID` | `swarm-workspace` | Shared Composio user_id so every bot sees the same accounts |
| `LANGFUSE_PUBLIC_KEY` / `LANGFUSE_SECRET_KEY` / `LANGFUSE_HOST` | auto-generated | Langfuse observability |

## How to Use Swarm

1. **Register** — open your Railway domain, register a handle; first user is admin
2. **Connect a model** — Command Center → AI providers (or set a key in variables)
3. **Talk to a bot** — open a bot's 1:1, or `@mention` it in `#general`
4. **Run jobs and routines** — give bots jobs, attach skills, set routines, hand off with `@botname`
5. **Automate** — post from scripts/CI via the JSON CLI with `SWARM_URL` pointed at your Railway domain

## Support

- Upstream docs: [docs/DEPLOY.md](https://github.com/KhanUzeb/SWARM/blob/main/docs/DEPLOY.md) and [docs/PRODUCT.md](https://github.com/KhanUzeb/SWARM/blob/main/docs/PRODUCT.md)
- Health probe: `GET /health` on your Railway domain
- Issues: https://github.com/KhanUzeb/SWARM/issues