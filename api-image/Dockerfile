FROM python:3.7.6-buster

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN \
  apt-get update -qqy && \
  apt-get -qqy install pipenv git && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
  git clone https://github.com/shacker/gtd.git /app && \
  pipenv install --system --deploy --dev

COPY local.py /app/project
COPY wait-for-it.sh /app/

# TODO: Add non root user

#CMD ["python", "manage.py", "migrate"]
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
