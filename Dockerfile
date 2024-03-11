ARG PYTHON_BASE_IMAGE='python'

FROM ${PYTHON_BASE_IMAGE}:3.11 AS rye

ENV PYTHONDONTWRITEBYTECODE=1

ENV PYTHONUNBUFFERED=1

ENV PYTHONPATH="/app/src:$PYTHONPATH"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential

ENV RYE_HOME="/opt/rye"
ENV PATH="$RYE_HOME/shims:$PATH"

RUN curl -sSf https://rye-up.com/get | RYE_NO_AUTO_INSTALL=1 RYE_INSTALL_OPTION="--yes" bash

COPY pyproject.toml requirements.lock requirements-dev.lock .python-version README.md ./

RUN rye sync --no-dev --no-lock

RUN . .venv/bin/activate

FROM rye AS dev

RUN rye sync --no-lock

FROM rye AS run

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

USER appuser

COPY src src

ENTRYPOINT ["/app/.venv/bin/uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]