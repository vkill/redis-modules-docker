FROM rust:alpine as builder

RUN set -ex \
  && apk add --no-cache --virtual .builddeps \
    musl-dev \
    git \
  \
  && echo "done"

RUN set -ex \
  && cd /opt \
  && git clone https://github.com/brandur/redis-cell.git --depth 1 \
  && echo "done"

RUN set -ex \
  && cd /opt/redis-cell \
  # https://github.com/rust-lang/rust/issues/74317
  && RUSTFLAGS='-C target-feature=-crt-static' cargo build --target x86_64-unknown-linux-musl --release \
  && ldd target/x86_64-unknown-linux-musl/release/libredis_cell.so \
  && echo "done"

# 
# 
# 
FROM redis:7.0-alpine

MAINTAINER vkill <vkill.net@gmail.com>

RUN set -ex \
  \
  && apk add --no-cache --virtual .rundeps \
    # libgcc_s.so.1
    libgcc \
    # ld-linux-x86-64.so.2
    gcompat \
  \
  && echo "done"

COPY --from=builder /opt/redis-cell/target/x86_64-unknown-linux-musl/release/libredis_cell.so /etc/redis/modules/libredis_cell.so

CMD ["redis-server", "--loadmodule", "/etc/redis/modules/libredis_cell.so"]
