FROM golang AS builder

RUN git clone -b v1.64.0 --depth=1 --single-branch https://github.com/rclone/rclone.git /go/src/github.com/rclone/rclone/
WORKDIR /go/src/github.com/rclone/rclone/

RUN \
  CGO_ENABLED=0 \
  make
RUN ./rclone version

# Begin final image
FROM chrislusf/seaweedfs:3.58

RUN apk --no-cache add ca-certificates fuse3 tzdata && \
  echo "user_allow_other" >> /etc/fuse.conf

COPY --from=builder /go/src/github.com/rclone/rclone/rclone /usr/local/bin/
ENV XDG_CONFIG_HOME=/config
