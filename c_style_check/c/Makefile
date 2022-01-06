# Use gcc instead of default clang aka cc
CC=gcc

all: build

build: ## build S=file_wo_ext
	$(CC) -o ${S} ${S}.c -Wall -Wstrict-prototypes -ansi -pedantic -std=c99

clean: ## clean
	rm -f ${S}

run: ## run S=file_wo_ext
	./${S} ${S}.c

# https://www.client9.com/self-documenting-makefiles/
help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\
		printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST)

.DEFAULT_GOAL=help
