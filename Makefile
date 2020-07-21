# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

all: generate

revendor:
	@env GO111MODULE=on go mod vendor -v
	@env GO111MODULE=on go mod tidy -v

update-dependencies:
	@env GO111MODULE=on go get -u
	@make revendor

# Run go fmt against code
fmt:
	go fmt ./...

# Run go vet against code
vet:
	go vet ./...

# Generate code
generate:
	@./vendor/github.com/gardener/gardener/hack/generate.sh ./charts/...
