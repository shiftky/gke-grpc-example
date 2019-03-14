package main

import (
	"context"
	"flag"
	"fmt"
	"io"
	"log"

	pb "github.com/shiftky/gke-grpc-example/message"

	"google.golang.org/grpc"
)

type client struct{}

func main() {
	host := flag.String("host", "127.0.0.1:8080", "gRPC server host (host:port)")
	flag.Parse()

	conn, err := grpc.Dial(*host, grpc.WithInsecure())
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
