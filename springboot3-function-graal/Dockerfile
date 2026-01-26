FROM ghcr.io/graalvm/native-image-community:21 as build
RUN microdnf install maven zip

VOLUME /build
WORKDIR /build
SHELL ["/bin/bash", "-c"]
ENTRYPOINT [ "bash" ]
