PROG = xi3status

PKG-CONFIG = pkg-config

# Find out last version from git and store it into LAST_VERSION
PWD = $(shell pwd)
VERSION_FILE_PATH := $(PWD)/LAST_VERSION
GIT_VERSION := $(subst release/,,$(shell git describe --tags))
CACHED_VERSION := $(shell [ -r $(VERSION_FILE_PATH) ] && cat $(VERSION_FILE_PATH))
ifneq ($(GIT_VERSION),$(CACHED_VERSION))
$(shell echo -n $(GIT_VERSION) > $(VERSION_FILE_PATH))
endif

all: $(PROG)

clean: clean-$(PROG)
	
include $(PWD)/src/xi3status.mk
include $(PWD)/man/man.mk
