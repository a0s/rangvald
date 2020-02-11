FROM python:3.7.6-alpine

ARG PUID=65535
ARG PGID=65535
WORKDIR /app
COPY local.py wait-for-it.sh /tmp/

RUN \
  apk update && \
  apk upgrade && \
  apk add --no-cache bash libpq && \
  apk add --no-cache --virtual build-dependencies build-base gcc git postgresql-dev && \
  git clone https://github.com/shacker/gtd.git /app && \
  pip install pipenv && \
  pipenv install --system --deploy --dev && \
  apk del build-dependencies && \
  addgroup -g ${PGID} django && \
  adduser -H -D -u ${PUID} -G django django && \
  cp /tmp/local.py /app/project && \
  cp /tmp/wait-for-it.sh /app && \
  chown -R django:django /app

USER django

#CMD ["python", "manage.py", "migrate"]
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
