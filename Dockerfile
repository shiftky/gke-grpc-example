FROM golang:1.17 as build

ENV REPODIR /go/src/github.com/yukirii/grpc-example

RUN apt-get update -y && apt-get install -y build-essential wget unzip curl
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.17.3/protoc-3.17.3-linux-x86_64.zip && \
    unzip protoc-3.17.3-linux-x86_64.zip -d protoc3 && \
    mv protoc3/bin/* /usr/local/bin/ && \
    mv protoc3/include/* /usr/local/include/
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

RUN mkdir -p ${REPODIR}
ADD . ${REPODIR}
WORKDIR ${REPODIR}

RUN make


FROM debian:11-slim

ENV REPODIR /go/src/github.com/yukirii/grpc-example

COPY --from=build ${REPODIR}/server /
COPY --from=build ${REPODIR}/client /

EXPOSE 8080
