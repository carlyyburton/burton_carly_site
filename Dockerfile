FROM node:16-alpine AS development
ENV NODE_ENV development
WORKDIR /burton_carly_site
COPY package.json .
COPY yarn.lock .
RUN yarn install
COPY . .
EXPOSE 3000
CMD ["yarn", "start"]

FROM node:16-alpine AS builder
ENV NODE_ENV production
WORKDIR /burton_carly_site
COPY package.json .
COPY yarn.lock .
RUN yarn install --production
COPY . .
RUN yarn build

FROM nginx:1.21.0-alpine AS production
COPY --from=builder /burton_carly_site/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
