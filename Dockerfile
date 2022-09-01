FROM python:3.9-slim as builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# Install poetry
ENV POETRY_HOME="/opt/poetry"
ENV PATH "${POETRY_HOME}/bin/:$PATH"

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        # deps for installing poetry
        curl \
        # deps for building python deps
        build-essential \
        git-all

RUN curl -sSL https://install.python-poetry.org |  python3 -

# RUN poetry config virtualenvs.create false

WORKDIR /app
COPY poetry.lock pyproject.toml ./
RUN poetry install --without dev

FROM python:3.9-slim as runner

EXPOSE 5000

ENV VENV_PATH='/app/.venv'

COPY --from=builder $VENV_PATH $VENV_PATH

ENV PATH "${VENV_PATH}/bin/:$PATH"

WORKDIR /app
COPY . /app

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "mlops_api.app:app"] 
