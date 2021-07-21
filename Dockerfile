FROM traefik:1.7-alpine

ARG ARG_GUCCI_VERSION
ARG ARG_CUSTOMER_EMAIL
ARG ARG_TRAEFIK_DOMAIN

ENV CUSTOMER_EMAIL=${ARG_CUSTOMER_EMAIL}
ENV TRAEFIK_DOMAIN=${ARG_TRAEFIK_DOMAIN}}

VOLUME /mnt/acme

EXPOSE 80
EXPOSE 443

# Install gucci
RUN mkdir -p /tmp \
    && mkdir -p /usr/local/bin \
    && cd /tmp \
    && wget -q https://github.com/noqcks/gucci/releases/download/${ARG_GUCCI_VERSION}/gucci-v${ARG_GUCCI_VERSION}-linux-amd64 \
    && chmod +x gucci-v${ARG_GUCCI_VERSION}-linux-amd64 \
    && mv gucci-v${ARG_GUCCI_VERSION}-linux-amd64 /usr/local/bin/gucci

ADD traefik.tpl.toml /tmp/traefik.tpl.toml

# Generate config
RUN gucci /tmp/traefik.tpl.toml > /traefik.toml

COPY certs /certs
