FROM tvoll/ragnadocker

RUN apt-get update && apt-get install -y \
    git \
    zsh \
    nano \
    vim \
    curl \
    sudo \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

RUN echo 'alias rathena-up="cd / && sh launch-athena.sh"' >> /root/.zshrc
RUN echo 'alias rathena-down="cd /usr/bin/rathena && sh ./athena-start stop"' >> /root/.zshrc
RUN echo 'alias rathena-update="cd /usr/bin/rathena && git pull"' >> /root/.zshrc

# Corrigir IPs para Docker networking
RUN sed -i 's/127.0.0.1/ragnarok-server/g' /datastoresetup/usr-bin-rathena/conf/*.conf

# Garantir que os campos estejam ativos
RUN sed -i 's|//login_ip|login_ip|g' /datastoresetup/usr-bin-rathena/conf/char_athena.conf
RUN sed -i 's|//char_ip|char_ip|g' /datastoresetup/usr-bin-rathena/conf/map_athena.conf
RUN sed -i 's|//map_ip|map_ip|g' /datastoresetup/usr-bin-rathena/conf/map_athena.conf

COPY docker/rathena/start.sh /start.sh
RUN chmod +x /start.sh


CMD ["/start.sh"]
