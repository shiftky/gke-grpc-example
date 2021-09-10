# grpc-example

## build

```bash
docker build -t ${REGISTRY}/grpc-example:${VERSION} .
docker login
docker push ${REGISTRY}/grpc-example:${VERSION}

or

make docker-build
make docker-push
```

