FROM golang:alpine as build
WORKDIR /app
ENV GOPROXY=https://mirrors.aliyun.com/goproxy/
RUN apk update && apk add wget unzip build-base git bzr mercurial gcc 
RUN git clone https://github.com/moriyoshi/s3-sftp-proxy.git
RUN cd s3-sftp-proxy && go mod init && go mod tidy && go build 

FROM alpine:latest
LABEL EMAIL="1141519465@qq.com"
LABEL AUTHOR="dalongrong"
WORKDIR /app
ENV BIND=:10022
ENV CONFIG=/app/s3-sftp-proxy.example.toml
EXPOSE 10022
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENV PATH=$PATH:/usr/local/bin
COPY s3-sftp-proxy.example.toml /app/s3-sftp-proxy.example.toml
COPY --from=build /app/s3-sftp-proxy/s3-sftp-proxy /usr/local/bin/s3-sftp-proxy
ENTRYPOINT ["./entrypoint.sh"]