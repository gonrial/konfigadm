all: test docs integration


.PHONY: linux
linux:
	GOOS=linux go build -o dist/konfigadm -ldflags '-X main.version=built-$(shell date +%Y%m%d%M%H%M%S)' .

.PHONY: test
test:
	go test -v ./pkg/... ./cmd/... -race -coverprofile=coverage.txt -covermode=atomic

.PHONY: integration
integration: linux
	go test -v ./test -race -coverprofile=integ.txt -covermode=atomic

.PHONY: docs
docs:
	pip install mkdocs mkdocs-material pymdown-extensions Pygments
	git remote add docs "https://$(GH_TOKEN)@github.com/moshloop/konfigadm.git"
	git fetch docs && git fetch docs gh-pages:gh-pages
	mkdocs gh-deploy -v --remote-name docs

