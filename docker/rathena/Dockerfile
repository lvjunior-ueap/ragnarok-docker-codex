FROM ubuntu:22.04

RUN apt update && apt install -y \
    git \
    build-essential \
    cmake \
    libmariadb-dev \
    zlib1g-dev \
    libpcre3-dev \
    mariadb-client \
    nano \
    vim

WORKDIR /opt

RUN git clone https://github.com/rathena/rathena.git

WORKDIR /opt/rathena

RUN sed -i 's/#define PACKETVER.*/#define PACKETVER 20151104/' src/config/packets.hpp

RUN ./configure && make server

EXPOSE 6900 6121 5121

CMD ["./athena-start", "start"]