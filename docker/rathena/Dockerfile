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

# clone limpo do rAthena
RUN git clone https://github.com/rathena/rathena.git

WORKDIR /opt/rathena

# checkout do commit compatível com clientes antigos
RUN git checkout $(git rev-list -n 1 --before="2016-06-01" master)

RUN ./configure
RUN make server

COPY docker/rathena/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6900 6121 5121

CMD ["/start.sh"]