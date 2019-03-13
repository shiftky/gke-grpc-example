GO111MODULE=on
BINARY=server

all: proto build

proto:
	protoc --go_out=plugins=grpc:. message/*.proto

proto_clean:
	rm -f message/*.pb.go

build:
	go build -o $(BINARY)

clean: proto_clean
	rm -f $(BINARY)
