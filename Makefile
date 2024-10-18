OS_NAME=
OS_ARCH=

DEP_ROOT_NAME=.dep
DEP_ROOT=$(PWD)/$(DEP_ROOT_NAME)

AQUA_BIN_NAME=aqua
AQUA_BIN_VERSION=latest


print:

dep:
	mkdir -p $(DEP_ROOT)

	go install github.com/aquaproj/aqua/v2/cmd/aqua@$(AQUA_BIN_VERSION)
	mv $(GOPATH)/bin/aqua $(DEP_ROOT)/aqua

	