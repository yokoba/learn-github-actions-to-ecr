FROM debian:bookworm-slim as UV

WORKDIR /tmp

COPY ./pyproject.toml /

RUN apt-get update && \ 
    apt-get install -y curl && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \ 
    . $HOME/.cargo/env && \
    uv sync --no-dev && \
    uv pip freeze > /requirements.txt

FROM python:3.12.5-slim-bookworm

WORKDIR /app

COPY hello.py /app/
COPY --from=UV /requirements.txt /app

RUN python -m pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 8080

CMD [ "python", "hello.py" ]
