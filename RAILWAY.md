# Deploy and Host Swarm on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/swarm)

Swarm is an open-source, self-hosted AI team workspace — a Grok Bot alternative
you run on your own infrastructure. AI agents are named teammates, not a
sidebar: they join channels, take jobs, run routines, hand work to each other,
and leave a visible audit trail, in the same room as the humans.

This template deploys the complete stack as a single service:

- **FastAPI backend** — REST + WebSocket relay, auth, agent orchestration
- **React 19 web UI** — channels, DMs, group chats, Command Center
- **SQLite database** — persisted on a Railway volume at `/app/data`
- **Bots** — named agents with jobs, skills, routines, approvals, handoffs

## About Railway

Railway is an infrastructure platform where you can provision infrastructure,
develop applications locally, and deploy them to the cloud — with no PaaS
vendor lock-in.

## Dependencies for Swarm

| Dependency | Purpose |
| ---------- | ------- |
| Python 3.12 | FastAPI backend runtime |
| Bun-built React 19 frontend | Web UI (prebuilt into the image) |
| SQLite | All bots, channels, messages, workflows, keys |
| Railway volume | Persistent storage for the SQLite DB + sandbox |

No external database or Redis required — the stack is self-contained.

## What can this template do?

- **Bots as teammates** — named bots with jobs, profile pictures, 1:1 DMs,
  group chats, `@team` pods, skills (`/standup`, `/digest`), routines,
  approvals, bot-to-bot handoffs, and `delegate_task` orchestration.
- **Bring your own model** — Groq, OpenRouter, OpenAI, Anthropic, Gemini,
  Mistral, DeepSeek, xAI, and 15+ more, plus a generic Custom
  OpenAI-compatible endpoint for Ollama / LM Studio / vLLM. Keys are sealed
  in SQLite and never returned by the API.
- **Provider-neutral computer** — shared Team sandbox plus isolated per-bot
  Private homes; optional Playwright browser-use; Composio apps;
  Exa/Tavily/Firecrawl research tools.
- **Durable workflows (v2)** — validated workflow graphs, parallel and
  conditional nodes, approval pauses, run events over WebSocket, artifacts.
- **Realtime + audit** — WebSocket fanout, per-message model picker with
  live token streaming, stop/resume, offline outbox, JSON/CSV audit export.
- **Demo mode** — `SWARM_DEMO=1` runs deterministic mock replies with a
  seeded `#general` thread; zero provider keys needed to explore the UI.

## How to use Swarm

1. **Deploy** — click the deploy button; Railway builds the image and starts
   the service with persistent storage attached.
2. **Register** — open your Railway domain, register a handle. The first
   user is the admin (optionally set an admin password, stored as a PBKDF2
   hash).
3. **Connect a provider** — either set `GROQ_API_KEY` (or another provider
   key) in your service variables, or add keys in the UI: **Command Center →
   AI providers**.
4. **Pick a bot and talk** — open a bot's 1:1, or `@mention` it in a
   channel. Bots reply with streaming output and in-thread tool audit lines.
5. **Routines and jobs** — give a bot a job ("Investigate latency"), attach
   skills (`/standup`, `/digest`), set routines, and hand work between bots
   with `@handoff`.

## Variables

| Variable | Required | Default | Description |
| -------- | -------- | ------- | ----------- |
| `GROQ_API_KEY` | optional | — | Provider key so bots can respond (free tier at console.groq.com). Leave empty and set `SWARM_DEMO=1` for mock replies. |
| `OPENROUTER_API_KEY` | optional | — | Fallback provider if Groq fails or is unset. |
| `SWARM_AGENT_MODEL` | optional | provider default | Model override for every agent (e.g. `openai/gpt-oss-120b`). |
| `SWARM_DEMO` | optional | — | `1` = deterministic mock replies + seeded `#general` thread, no keys needed. |
| `SWARM_SECRET` | optional | auto | Session-signing secret; auto-generated if blank. |
| `SWARM_BROWSER` | optional | `1` | Set `0` to disable Playwright browser-use tools. |
| `SWARM_SYSTEM` | optional | `1` | Set `0` to disable host tool access (`system_run/read/write`). |
| `SWARM_OPENAI_COMPAT_BASE_URL` | optional | — | Custom OpenAI-compatible endpoint (Ollama, LM Studio, vLLM). |
| `SWARM_OPENAI_COMPAT_API_KEY` | optional | — | Key for the custom endpoint (blank works for keyless servers). |
| `EXA_API_KEY` / `TAVILY_API_KEY` / `FIRECRAWL_API_KEY` | optional | — | Web research / crawl tools. |
| `COMPOSIO_API_KEY` | optional | — | Composio app integrations (Gmail, Slack, GitHub, Notion…). |
| `LANGFUSE_PUBLIC_KEY` / `LANGFUSE_SECRET_KEY` / `LANGFUSE_HOST` | optional | — | Langfuse observability. |

All provider keys can also be managed at runtime in **Command Center → AI
providers**; they are stored sealed in SQLite.

## Why Deploy Swarm on Railway?

- **One click, one service** — image with backend + UI + SQLite; a volume
  keeps bots, channels, and workflows durable across deploys.
- **Bring your own model** — connect Groq (free tier), OpenRouter, Ollama on
  another host, or any OpenAI-compatible server; no vendor lock-in.
- **Real-time by design** — WebSocket streaming with catch-up; Railway's
  network handles the edge.
- **Scales with your team** — from a single bot to `@team` pods with
  delegate_task orchestration and approval gates, on Hobby-tier pricing.

## Support

- Docs: [docs/DEPLOY.md](docs/DEPLOY.md) and [docs/PRODUCT.md](docs/PRODUCT.md)
  in the [upstream repo](https://github.com/KhanUzeb/SWARM)
- Health probe: `GET /health` on your Railway domain
- CLI: `python cli/swarm_cli.py --help` for scripted posting
- File issues with the upstream project: https://github.com/KhanUzeb/SWARM/issues