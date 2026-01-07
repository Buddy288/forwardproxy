FROM caddy:2-builder AS builder

RUN xcaddy build \
    --with github.com/caddyserver/forwardproxy@caddy2

FROM caddy:2-alpine

# Copy binary
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Fix permissions (THIS IS THE KEY)
RUN chmod +x /usr/bin/caddy

# Copy config
COPY Caddyfile /etc/caddy/Caddyfile

# Run using shell (Render-safe)
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
