package main

import (
	"log"
	"net"

	pb "github.com/shiftky/gke-grpc-example/message"

	"google.golang.org/grpc"
)

type server struct{}

func (s *server) GetNewMessage(req *pb.Request, stream pb.MessageService_GetNewMessageServer) error {
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
