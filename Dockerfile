FROM python:3.7.4-slim-stretch as Python

COPY requirements.txt .

# install deps
RUN set -ex; \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    python-dev \
    gcc \
    make \
    libffi-dev \
    libsasl2-dev \
    libxml2-dev \
    libxslt-dev \
    # pillow
    libtiff5-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    tcl8.5-dev \
    tk8.5-dev \
  \
  && pip install -r requirements.txt

FROM python:3.7.4-slim-stretch

COPY --from=Python /root/.cache /root/.cache
COPY --from=Python requirements.txt .

RUN set -ex; \
  apt-get update \
  && apt-get install -y --no-install-recommends \
      bzip2 \
      ca-certificates \
      libgdbm3 \
      libssl1.0.2 \
      libyaml-0-2 \
      procps \
      libpq5 \
      libffi6 \
      libsasl2-2 \
      libxml2 \
      libxslt1.1 \
      libtiff5 \
      libjpeg62-turbo \
      zlib1g \
      libfreetype6 \
      liblcms2-2 \
      libwebp6 \
      tcl8.5 \
      tk8.5 \
    \
  && pip install -r requirements.txt \
  && rm -rf /root/.cache \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir app
WORKDIR app

COPY ./ /app/

CMD python manage.py runserver 0.0.0.0:8000
