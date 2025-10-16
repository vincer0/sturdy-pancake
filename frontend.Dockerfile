FROM node:22-alpine

USER root

ARG TZ=UTC
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN yarn global add @vue/cli -g

WORKDIR /var/www

COPY --chown=node:node frontend/package.json frontend/yarn.lock ./

RUN yarn cache clean
RUN yarn install

COPY --chown=node:node frontend/src src/
COPY --chown=node:node frontend/vite.config.ts frontend/tsconfig.json frontend/tsconfig.node.json frontend/tsconfig.app.json frontend/index.html ./

EXPOSE 3000

CMD ["yarn", "dev"]
