FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    pkg-config \
    libmysqlclient-dev \
    mysql-client \
    zlib1g-dev \
    libpcre3-dev \
    libssl-dev \
    libyaml-dev \
    nano

WORKDIR /opt

RUN git config --global core.autocrlf false

RUN git clone https://github.com/rathena/rathena.git

WORKDIR /opt/rathena

RUN git fetch --all

RUN git reset --hard && git clean -fd && git checkout $(git rev-list -n 1 --before="2016-06-01" master)

RUN ./configure --enable-sql
RUN make server

COPY docker/rathena/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6900 6121 5121

CMD ["/start.sh"]
