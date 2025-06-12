LOCAL_BIN:=$(CURDIR)/bin

install-deps:
	GOBIN=$(LOCAL_BIN) go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.1.6

check-lint-config:
	$(LOCAL_BIN)/golangci-lint config verify --config .golangci.pipeline.yaml

lint:
	$(LOCAL_BIN)/golangci-lint run ./... --config .golangci.pipeline.yaml

test:
	go clean -testcache
	go test ./... -covermode count -coverpkg=github.com/igorezka/auth/internal/service/...,github.comgithub.com/igorezka/auth/internal/api/... -count 5

test-coverage:
	go clean -testcache
	go test ./... -coverprofile=coverage.tmp.out -covermode count -coverpkg=github.com/igorezka/auth/internal/service/...,github.com/igorezka/auth/internal/api/... -count 5
	grep -v 'mocks\|config' coverage.tmp.out  > coverage.out
	rm coverage.tmp.out
	go tool cover -html=coverage.out -o=coverage.html;
	go tool cover -func=./coverage.out | grep "total";