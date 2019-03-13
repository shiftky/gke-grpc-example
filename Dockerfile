FROM golang:1.11 as build

ENV REPODIR /go/src/github.com/shiftky/gke-grpc-example

RUN apt-get update -y && apt-get install -y build-essential wget unzip curl
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.7.0/protoc-3.7.0-linux-x86_64.zip && \
    unzip protoc-3.7.0-linux-x86_64.zip -d protoc3 && \
    mv protoc3/bin/* /usr/local/bin/ && \
    mv protoc3/include/* /usr/local/include/
RUN go get -u github.com/golang/protobuf/protoc-gen-go \
    google.golang.org/grpc

RUN mkdir -p ${REPODIR}
ADD . ${REPODIR}
WORKDIR ${REPODIR}

RUN make


FROM debian:7.11

ENV REPODIR /go/src/github.com/shiftky/gke-grpc-example

COPY --from=build ${REPODIR}/server /
COPY --from=build ${REPODIR}/client /

EXPOSE 8080
