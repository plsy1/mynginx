FROM nginx:latest AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3-dev \
    zlib1g-dev \
    wget

RUN mkdir -p /tmp/nginx && \
    cd /tmp/nginx && \
    wget https://nginx.org/download/nginx-1.26.2.tar.gz && \
    tar -xvzf nginx-1.26.2.tar.gz && \
    cd nginx-1.26.2 && \
    ./configure --with-compat --with-stream=dynamic && \
    make modules

FROM nginx:latest

COPY --from=builder /tmp/nginx/nginx-1.26.2/objs/ngx_stream_module.so /usr/lib/nginx/modules/
