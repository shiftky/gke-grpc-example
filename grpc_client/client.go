package main

import (
	"context"
	"fmt"
	"io"
	"log"

	pb "github.com/shiftky/gke-grpc-example/message"

	"google.golang.org/grpc"
)

type client struct{}

func main() {
	conn, err := grpc.Dial("127.0.0.1:8080", grpc.WithInsecure())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	cli := pb.NewMessageServiceClient(conn)

	stream, err := cli.GetNewMessage(context.Background(), new(pb.Request))
	if err != nil {
		log.Fatal(err)
	}
	for {
		msg, err := stream.Recv()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println(msg)
	}
}
