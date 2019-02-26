.PHONY: bootstrap
bootstrap: export GO111MODULE=on
bootstrap:
	go mod download
	go mod vendor

.PHONY: build
build: bootstrap
build: export GO111MODULE=on
build: export CGO_ENABLED=0
build:
	go build -mod=vendor -v -o bin/moopo cmd/moopo/main.go

.PHONY: tree
tree:
	@tree -I vendor

.PHONY: clean
clean:
	@git status --ignored --short | grep '^!! ' | sed 's/!! //' | xargs rm -rf