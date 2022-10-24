#build
FROM node:14.17.3 as builder
WORKDIR /usr/src/app
COPY . .
RUN npm ci --cache .npm --prefer-offline && npm run build
#release
FROM nginx:latest
WORKDIR /app
COPY --from=builder /usr/src/app/dist/ /usr/share/nginx/html/
EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
