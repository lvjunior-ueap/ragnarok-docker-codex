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

CMD ["/bin/bash"]
