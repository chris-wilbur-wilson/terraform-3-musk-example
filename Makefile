# Use some sensible default shell settings
SHELL := /bin/bash
.ONESHELL:
.SILENT:

RED = '\033[1;31m'
CYAN = '\033[0;36m'
NC = '\033[0m'

# assumption here is that OS is only defined in windows, so set uid and gid to 0 (root)
ifdef OS
    export USER_ID=0
    export GROUP_ID=0
else
    export USER_ID=$(shell id -u)
    export GROUP_ID=$(shell id -g)
endif

.PHONY: all
all: app__all infra__all

app__%:
	"${MAKE}" --directory app -f make.mk $*

infra__%:
	"${MAKE}" --directory infra -f make.mk $*
