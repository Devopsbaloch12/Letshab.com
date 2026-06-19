<div align="center">

# Let's HAB — AI Revenue Automation Platform

**AI voice & chat receptionists that answer every call, qualify leads, and book appointments 24/7 for home-service businesses and contractors.**

[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Django](https://img.shields.io/badge/Django-5.x-092E20?logo=django&logoColor=white)](https://www.djangoproject.com/)
[![DRF](https://img.shields.io/badge/DRF-3.15-A30000?logo=django&logoColor=white)](https://www.django-rest-framework.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-realtime-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Celery](https://img.shields.io/badge/Celery-async-37814A?logo=celery&logoColor=white)](https://docs.celeryq.dev/)
[![LangGraph](https://img.shields.io/badge/LangGraph-agents-1C3C3C)](https://langchain-ai.github.io/langgraph/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-Proprietary-red)](./LICENSE)

[Website](https://www.letshab.com) · [App](https://app.letshab.com) · [Solutions](https://www.letshab.com/solutions) · [Pricing](https://www.letshab.com/pricing)

</div>

---

## Overview

Home-service businesses miss a large share of inbound calls, and every missed call is lost revenue. **HAB** closes that gap with two connected products backed by a single shared-memory agent core:

- **HAB Voice** — an AI voicebot that picks up after a few rings, holds a natural conversation, qualifies the caller, books the job into the calendar, and logs the lead in the CRM. Works 24/7/365 and handles multiple concurrent calls.
- **HAB Chat** — an AI chatbot that engages website visitors, answers questions, captures qualified leads, and pushes them into the CRM.

Both channels share conversation memory, lead context, and the same CRM/calendar integrations, so a caller and a website visitor are treated as one lead across the system.

This repository contains the **backend platform**: the REST API, the realtime voice service, the agent orchestration layer, the integration adapters, and the async workers.

## Key Features

- **Realtime voice pipeline** — streaming speech-to-text, agent reasoning, and text-to-speech with low end-to-end latency over telephony.
- **LangGraph agent core** — stateful conversation graph with tool calling for lead qualification, spam filtering, appointment booking, and CRM writes.
- **Shared memory across channels** — voice and chat read/write the same lead and conversation state.
- **Appointment booking** — conversation-to-calendar flow with availability lookup and confirmation.
- **CRM & calendar sync** — pluggable adapters for HAB CRM, Salesforce, HubSpot, Zoho, ServiceTitan, Jobber, Housecall Pro, and GoHighLevel.
- **Lead qualification & spam filtering** — classify, score, and route inbound contacts before they hit the calendar.
- **Per-business bot training** — each tenant configures tone, scripts, services, and routing so the bot "works like they do."
- **Multi-tenant isolation** — tenant-scoped data, usage metering (voice minutes), and per-plan limits.
- **Usage metering & billing hooks** — track AI voice minutes and conversations against plan quotas.

## Architecture

```
                         ┌──────────────────────────────┐
   Inbound call ───────► │   Telephony (Twilio)          │
                         └──────────────┬───────────────┘
                                        │ media stream (WebSocket)
                         ┌──────────────▼───────────────┐
   Website visitor ────► │   FastAPI Realtime Service     │
   (HAB Chat WS)         │   STT (Deepgram) ─► Agent ─►   │
                         │   TTS (Cartesia)               │
                         └──────────────┬───────────────┘
                                        │ invokes
                         ┌──────────────▼───────────────┐
                         │   LangGraph Agent Core         │
                         │   - qualify / spam-filter      │
                         │   - book appointment (tool)    │
                         │   - CRM write (tool)           │
                         │   - shared conversation memory │
                         └──────┬─────────────────┬──────┘
                                │                 │
              ┌─────────────────▼───┐   ┌─────────▼──────────────┐
              │  Django + DRF API    │   │  Integration Adapters   │
              │  - tenants / auth    │   │  - CRMs (HubSpot, ...)  │
              │  - leads / calls     │   │  - Calendars            │
              │  - bots / config     │   │  - Webhooks             │
              │  - billing / usage   │   └─────────┬──────────────┘
              └──────┬───────────────┘             │
                     │                              │
        ┌────────────▼────────────┐    ┌────────────▼───────────┐
        │  PostgreSQL (multi-      │    │  Celery + Redis         │
        │  tenant, indexed)        │    │  - CRM sync jobs        │
        │                          │    │  - follow-ups / retries │
        │  Redis (cache + state)   │    │  - webhook processing   │
        └──────────────────────────┘    └─────────────────────────┘
```

**Why two app layers?** Django/DRF owns business logic, persistence, admin, auth, and billing — where its batteries-included model shines. FastAPI handles the realtime voice/chat WebSocket path, where async streaming and low latency matter most. The LangGraph core is shared by both.

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Python 3.12 |
| Web / API | Django, Django REST Framework |
| Realtime | FastAPI, WebSockets, asyncio |
| Agents | LangGraph, LangChain |
| Speech-to-text | Deepgram |
| Text-to-speech | Cartesia |
| Telephony | Twilio |
| Database | PostgreSQL |
| Cache / state / broker | Redis |
| Async workers | Celery |
| Auth | JWT (httpOnly cookies), OAuth 2.0 / SSO, RBAC |
| Frontend (separate repo) | Next.js |

## Getting Started

### Prerequisites

- Python 3.12+
- PostgreSQL 16+
- Redis 7+
- API credentials for Twilio, Deepgram, Cartesia, and at least one CRM

### Local setup

```bash
# 1. Clone
git clone https://github.com/<your-org>/hab-backend.git
cd hab-backend

# 2. Create and activate a virtualenv
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Configure environment
cp .env.example .env             # then fill in the values

# 5. Run migrations
python manage.py migrate

# 6. Create an admin user
python manage.py createsuperuser

# 7. Start the services (in separate terminals)
python manage.py runserver                       # Django/DRF API
uvicorn realtime.main:app --reload --port 8001    # FastAPI realtime service
celery -A hab worker -l info                      # Celery worker
celery -A hab beat -l info                        # Celery scheduler
```

### Run with Docker

```bash
cp .env.example .env             # fill in values
docker compose up --build
```

This brings up the API, realtime service, Celery worker/beat, PostgreSQL, and Redis.

## Project Structure

```
hab-backend/
├── hab/                    # Django project (settings, celery app, urls)
├── apps/
│   ├── tenants/            # Multi-tenant accounts, plans, usage metering
│   ├── accounts/           # Auth, users, RBAC
│   ├── leads/              # Leads, contacts, qualification, scoring
│   ├── calls/              # Call records, transcripts, recordings
│   ├── bots/               # Per-tenant bot config, scripts, training
│   ├── appointments/       # Calendar, availability, bookings
│   ├── integrations/       # CRM + calendar adapters, webhooks
│   └── billing/            # Plans, quotas, voice-minute accounting
├── agent/                  # LangGraph agent core (graph, nodes, tools, memory)
├── realtime/              # FastAPI service: telephony + chat WebSockets, STT/TTS
├── tests/                  # pytest suite
├── requirements.txt
├── docker-compose.yml
├── Dockerfile
└── .env.example
```

## API

The REST API follows the OpenAPI 3.0 spec. With the server running, browse:

- Swagger UI: `http://localhost:8000/api/docs/`
- OpenAPI schema: `http://localhost:8000/api/schema/`

High-level resource groups: `tenants`, `auth`, `leads`, `calls`, `bots`, `appointments`, `integrations`, `billing`.

## Integrations

CRM and calendar connectors live in `apps/integrations/` behind a common adapter interface, so adding a provider means implementing one adapter — not touching the agent core.

Currently supported: **HAB CRM, Salesforce, HubSpot, Zoho, ServiceTitan, Jobber, Housecall Pro, GoHighLevel.**

## Testing

```bash
pytest                      # full suite
pytest --cov=apps --cov=agent --cov=realtime   # with coverage
```

## Plans

The platform meters usage against the published plans (HAB Chat, HAB Voice & Chat, Enterprise). Voice minutes and conversation counts are tracked per tenant and enforced at the API and realtime layers. See [pricing](https://www.letshab.com/pricing) for current tiers.

## License

Proprietary. © 2026 HAB. All rights reserved. See [LICENSE](./LICENSE).

## Contact

- Website: https://www.letshab.com
- Maintainer: Arbaz Baloch · baloucharbaz134@gmail.com
