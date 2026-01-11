# first part: use a GraalVM image, add Maven and build the native service
#-------------------------------------------------------------------------
FROM ghcr.io/graalvm/native-image-community:21 as build

SHELL ["/bin/bash", "-c"]

# add maven
RUN microdnf install maven zip

# set the working directory to /build and copy the source code into the image 
VOLUME /build
WORKDIR /build

# launch maven, create the native service
#RUN mvn clean package -Pnative

ENTRYPOINT [ "bash" ]
