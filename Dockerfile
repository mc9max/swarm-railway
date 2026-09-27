# syntax=docker/dockerfile:1

########## Stage 1: build the web UI ##########
FROM oven/bun:1 AS web
WORKDIR /web
COPY frontend/package.json frontend/bun.lock ./
RUN bun install --frozen-lockfile
COPY frontend/ ./
RUN bun run build

########## Stage 2: Python runtime ##########
FROM python:3.12-slim AS base

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ ./backend/
COPY plugins/ ./plugins/
COPY profiles/ ./profiles/
COPY skills/ ./skills/
COPY --from=web /web/dist ./frontend/dist

# Run as root: Railway volumes mount root-owned; a non-root USER would hit
# EACCES on /app/data (SQLite + sandbox) and restart-loop.
RUN mkdir -p /app/data /tmp/swarm-sandbox

ENV SWARM_SANDBOX_DIR=/tmp/swarm-sandbox
ENV SWARM_SYSTEM=1
ENV SWARM_SYSTEM_ROOT=/app
ENV SWARM_DB_PATH=/app/data/swarm.db

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:' + __import__('os').environ.get('PORT','8000') + '/health', timeout=4)" || exit 1

CMD ["sh", "-c", "uvicorn backend.main:app --host 0.0.0.0 --port ${PORT:-8000}"]