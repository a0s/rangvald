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

# TODO another user

#ENTRYPOINT ["python", "manage.py"]
