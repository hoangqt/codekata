GO=go build

all: build

build: ## build S=file_wo_ext
	$(GO) -o ${S} ${S}.go

clean: ## clean
	rm -f ${S}

run: ## execute program
	./${S} ../c/${S}.c

# https://www.client9.com/self-documenting-makefiles/
help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\
		printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST)

.DEFAULT_GOAL=help
