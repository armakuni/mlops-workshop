FROM python:3.9-slim

EXPOSE 5000

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 

# Install poetry
ENV POETRY_HOME="/opt/poetry"
ENV PATH "/opt/poetry/bin/:$PATH"

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        # deps for installing poetry
        curl \
        # deps for building python deps
        build-essential \
        git-all

RUN curl -sSL https://install.python-poetry.org |  python3 -

RUN poetry config virtualenvs.create false

COPY poetry.lock pyproject.toml ./
RUN poetry install

WORKDIR /app
COPY . /app

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "mlops_api.app:app"] 
