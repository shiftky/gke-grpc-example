GO111MODULE=on

SERVER_BINARY=server
CLIENT_BINARY=client

REGISTRY ?= yukirii
VERSION ?= $(shell git describe --exact-match 2> /dev/null || \
					 git describe --match=$(git rev-parse --short=8 HEAD) --always --dirty --abbrev=8)

all: proto build-server build-client

proto: proto_clean
	protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		message/*.proto

proto_clean:
	rm -f message/*.pb.go

build-server:
	go build -o $(SERVER_BINARY) grpc_server/*.go

build-client:
	go build -o $(CLIENT_BINARY) grpc_client/*.go

clean:
	rm -f $(SERVER_BINARY)
	rm -f $(CLIENT_BINARY)

docker-build:
	docker build -t $(REGISTRY)/grpc-example:$(VERSION) .

docker-push:
	docker login -u="$(DOCKER_USERNAME)" -p="$(DOCKER_PASSWORD)"
	docker push $(REGISTRY)/grpc-example:$(VERSION)
