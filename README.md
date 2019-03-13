# gke-grpc-example

## build

```bash
docker build -t ${REGISTRY}/gke-grpc-example:${VERSION} .
docker login
docker push ${REGISTRY}/gke-grpc-example:${VERSION}

or

make docker-build
make docker-push
```

