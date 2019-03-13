GO111MODULE=on
SERVER_BINARY=server
CLIENT_BINARY=client

all: proto build-server build-client

proto: proto_clean
	protoc --go_out=plugins=grpc:. message/*.proto

proto_clean:
	rm -f message/*.pb.go

build-server:
	go build -o $(SERVER_BINARY) grpc_server/*.go

build-client:
	go build -o $(CLIENT_BINARY) grpc_client/*.go

clean:
	rm -f $(SERVER_BINARY)
	rm -f $(CLIENT_BINARY)
