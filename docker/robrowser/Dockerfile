FROM alpine:3.19

WORKDIR /opt

RUN apk add --no-cache \
    git \
    nodejs \
    npm \
    bash \
    curl \
    nano

RUN npm install -g wsproxy http-server

RUN git clone https://github.com/MrAntares/roBrowserLegacy

WORKDIR /opt/roBrowserLegacy

RUN npm install
RUN npm run build -- -O -T -H
RUN cp -r dist/Web/* .

# copiar template
COPY docker/robrowser/index.template.html /opt/index.template.html

EXPOSE 8080 5999

CMD sh -c '
envsubst < /opt/index.template.html > /opt/roBrowserLegacy/index.html &&
wsproxy -a ragnarok-server:6900 &
http-server -p 8080 -a 0.0.0.0
'
