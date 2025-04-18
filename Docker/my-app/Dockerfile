FROM python:3.12-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir Flask pytest

EXPOSE 5000

CMD ["python", "app.py"]

