FROM alpine:3.6

RUN apk add --no-cache --update \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    python3

ADD . /moto/
ENV PYTHONUNBUFFERED 1

WORKDIR /moto/
RUN  python3 -m ensurepip && \
     rm -r /usr/lib/python*/ensurepip && \
     pip3 --no-cache-dir install --upgrade pip setuptools && \
     pip3 --no-cache-dir install ".[server]"

RUN sed -i 's/0[.]001/0.01/' /usr/lib/python3.6/site-packages/moto/sqs/models.py

ENTRYPOINT ["/usr/bin/moto_server", "-H", "0.0.0.0"]

EXPOSE 5000
