# syntax=docker/dockerfile:1

FROM python:3.12-slim AS base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# System deps: build tools for native wheels, libpq for PostgreSQL, audio libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first for better layer caching
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application code
COPY . .

# Collect static (no-op if not configured; safe to keep)
RUN python manage.py collectstatic --noinput || true

EXPOSE 8000 8001

# Default command runs the Django/DRF API via Gunicorn.
# Override in docker-compose for the realtime service, worker, and beat.
CMD ["gunicorn", "hab.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
