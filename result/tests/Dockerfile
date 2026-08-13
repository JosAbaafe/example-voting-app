FROM node:18-slim

# add curl for healthcheck, and upgrade all OS packages to pick up
# security fixes (e.g. libgnutls30) not present in the base image layer
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

# update bundled npm to pick up its newer, non-vulnerable version of "tar"
# (the CVE lives in npm's own dependency tree, not in this project's deps)
RUN npm install -g npm@latest && \
    npm install -g nodemon

COPY package*.json ./

RUN npm ci && \
 npm cache clean --force && \
 mv /usr/local/app/node_modules /node_modules

COPY . .

ENV PORT=80
EXPOSE 80

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
