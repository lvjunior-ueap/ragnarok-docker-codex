FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    build-essential \
    cmake \
    pkg-config \
    libmariadb-dev \
    libmariadb-dev-compat \
    mariadb-client \
    zlib1g-dev \
    libpcre3-dev \
    libssl-dev \
    libyaml-dev \
    patch \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# usar repo local (muito mais rápido)
COPY rathena /opt/rathena

WORKDIR /opt/rathena

# aplicar PACKETVER antigo
RUN sed -i 's/#define PACKETVER.*/#define PACKETVER 20151104/' src/config/packets.hpp || true

# copiar patches
COPY patches /patches

# aplicar todos os patches automaticamente
RUN set -eux; \
    if [ -d /patches ]; then \
        for p in /patches/*.patch; do \
            echo "Applying patch: $p"; \
            patch -p1 < "$p" || true; \
        done; \
    fi

# patches rápidos inline (automação inicial)

# remover NPC Market
RUN sed -i '/NPC_MARKET/d' src/map/clif_packetdb.hpp || true

# neutralizar structs NPC market
RUN sed -i 's/PACKET_ZC_NPC_MARKET_OPEN/PACKET_ZC_PC_PURCHASE_ITEMLIST/g' src/map/clif.cpp || true
RUN sed -i 's/PACKET_ZC_NPC_MARKET_PURCHASE_RESULT/PACKET_ZC_PC_PURCHASE_RESULT/g' src/map/clif.cpp || true

# corrigir packets de skill
RUN sed -i 's/PACKET_ZC_USESKILL_ACK/PACKET_ZC_USE_SKILL/g' src/map/clif.cpp || true
RUN sed -i 's/HEADER_ZC_USESKILL_ACK/HEADER_ZC_USE_SKILL/g' src/map/clif.cpp || true

# remover random options
RUN sed -i 's/option_data/option/g' src/map/clif.cpp || true

# configurar build
RUN ./configure

# compilar
RUN make -j$(nproc) server || true

EXPOSE 6900 6121 5121

CMD ["./athena-start", "start"]