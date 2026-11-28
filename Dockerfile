# syntax=docker/dockerfile:1

FROM node:22-alpine

ENV NODE_ENV=production

WORKDIR /app

COPY --chown=node:node app/server.js ./server.js
COPY --chown=node:node web/public ./public

RUN mkdir -p /data && chown node:node /data

VOLUME ["/data"]

USER node

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "fetch('http://127.0.0.1:8080/health').then(r => { if (!r.ok) process.exit(1); }).catch(() => process.exit(1))"

STOPSIGNAL SIGTERM

CMD ["node", "server.js"]
