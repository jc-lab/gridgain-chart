FROM alpine:3.18

RUN apk add bash curl jq

COPY ["auto-activate.sh", "/opt"]
RUN chmod +x /opt/auto-activate.sh

