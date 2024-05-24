FROM golang:alpine as builder

WORKDIR /service
COPY . .
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o main main.go

FROM alpine:latest

RUN apk add chromium


WORKDIR /root/
COPY --from=builder /service/main .
COPY --from=builder /service/conf/default.yaml /root/doctron.yaml

# Expose port 8080 to the outside world
EXPOSE 8080

#Command to run the executable
CMD ["./main", "--config", "/root/configs/doctron/doctron.yaml"]
