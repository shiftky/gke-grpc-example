package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"time"

	pb "github.com/shiftky/gke-grpc-example/message"

	"google.golang.org/grpc"
)

type server struct{}

func (s *server) GetNewMessage(req *pb.Request, stream pb.MessageService_GetNewMessageServer) error {
	h, err := os.Hostname()
	if err != nil {
		log.Fatal(err)
	}

	for i := 1; i <= 10; i++ {
		resp := &pb.Reply{
			Message: fmt.Sprintf("reply - %d from %s", i, h),
		}
		if err := stream.Send(resp); err != nil {
			return err
		}
		time.Sleep(1 * time.Second)
	}
	return nil
}

func main() {
	lis, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatal(err)
	}

	s := grpc.NewServer()
	pb.RegisterMessageServiceServer(s, new(server))

	if err = s.Serve(lis); err != nil {
		log.Fatal(err)
	}
}
