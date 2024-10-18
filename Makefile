OS_NAME=$(shell go env GOOS)
OS_ARCH=$(shell go env GOARCH)

DEP_ROOT_NAME=.dep
DEP_ROOT=$(PWD)/$(DEP_ROOT_NAME)

PATH:= $(DEP_ROOT):$(PATH)

AQUA_BIN_NAME=aqua
AQUA_BIN_VERSION=latest
AQUA_BIN_NATIVE=$(AQUA_BIN_NAME)_bin_$(OS_NAME)_$(OS_ARCH)

GH_BIN_NAME=gh
GH_BIN_VERSION=latest
GH_BIN_NATIVE=$(GH_BIN_NAME)_bin_$(OS_NAME)_$(OS_ARCH)

TASK_BIN_NAME=task
TASK_BIN_VERSION=latest
TASK_BIN_NATIVE=$(TASK_BIN_NAME)_bin_$(OS_NAME)_$(OS_ARCH)



print:

all: dep

dep:
	mkdir -p $(DEP_ROOT)

	# todo: cross compile to all OS and ARCH we use.

	go install github.com/aquaproj/aqua/v2/cmd/aqua@$(AQUA_BIN_VERSION)
	mv $(GOPATH)/bin/aqua $(DEP_ROOT)/$(AQUA_BIN_NATIVE)

	go install github.com/cli/cli/v2/cmd/gh@$(GH_BIN_VERSION)
	mv $(GOPATH)/bin/gh $(DEP_ROOT)/$(GH_BIN_NATIVE)

	go install github.com/go-task/task/v3/cmd/task@latest
	mv $(GOPATH)/bin/task $(DEP_ROOT)/$(TASK_BIN_NATIVE)
	


### test 

AQUA_PATH=$(shell $(AQUA_BIN_NATIVE) root-dir)

export PATH:=$(AQUA_PATH):$(PATH)


aqua-run-print:
	@echo "AQUA_PATH:   $(AQUA_PATH)"
aqua-run-h:
	$(AQUA_BIN_NATIVE) -h
aqua-run-config:
	ls -al $(AQUA_PATH)
	tree -h $(AQUA_PATH)

aqua-run-init:
	# cretas a aqua.yaml locally
	$(AQUA_BIN_NATIVE) init
aqua-run-init-del:
	rm -rf $(AQUA_PATH)


aqua-run-install:
	$(AQUA_BIN_NATIVE) install --test
	$(AQUA_BIN_NATIVE) install aquaproj/registry-tool
	$(AQUA_BIN_NATIVE) install gohugoio/hugo
	
aqua-run-install-del:
	$(AQUA_BIN_NATIVE) rm --all
aqua-run-list:
	$(AQUA_BIN_NATIVE) list -installed
aqua-run-update:
	$(AQUA_BIN_NATIVE) update
aqua-run-update:
	$(AQUA_BIN_NATIVE) update gh@v2.30.0 

aqua-run-which:
	# works
	$(AQUA_BIN_NATIVE) which hugo


task-run-h:
	$(TASK_BIN_NATIVE) -h
task-run:
	$(TASK_BIN_NATIVE) --list-all
	


### release 
GH_TAG=1.0.0

gh-release-h:
	$(GH_BIN_NAME) release create -h
gh-release:
	# runs locally and in CI, so we get solid binaries to use.
	$(GH_BIN_NAME) release create $(GH_TAG) --generate-notes 
	$(GH_BIN_NAME) release upload $(GH_TAG) $(DEP_ROOT)/$(AQUA_BIN_NATIVE) --clobber
gh-release-del:
	$(GH_BIN_NAME) release delete $(GH_TAG) --yes





