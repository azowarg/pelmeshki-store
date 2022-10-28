#Build
FROM golang:latest as builder
ENV GOCACHE=".cache"
WORKDIR /usr/src/app
COPY . .
RUN go test ./...  \
    && go build ./cmd/api
#Release
FROM alpine:3.16.2
WORKDIR /app
RUN addgroup --system gouser \
    && adduser -S -s /bin/false -G gouser gouser -D -H \
    && apk add --no-cache dumb-init==1.2.5-r1 libc6-compat
COPY --from=builder /usr/src/app/api ./pelmeshki-backend
EXPOSE 8081
USER gouser
ENTRYPOINT [ "dumb-init", "./backend-pelmeni-store" ]
