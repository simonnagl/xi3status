CC = gcc
PKG-CONFIG = pkg-config

PROG = xi3status
# Find out last version from git and store it into LAST_VERSION
PWD = $(shell pwd)
VERSION_FILE_PATH := $(PWD)/LAST_VERSION
GIT_VERSION := $(subst release/,,$(shell git describe --tags))
CACHED_VERSION := $(shell [ -r $(VERSION_FILE_PATH) ] && cat $(VERSION_FILE_PATH))
ifneq ($(GIT_VERSION),$(CACHED_VERSION))
$(shell echo -n $(GIT_VERSION) > $(VERSION_FILE_PATH))
endif

SOURCES   := $(wildcard src/*.c)
HEADERS   := $(wildcard include/*.h)
OBJECTS   := $(SOURCES:.c=.o)
LIBRARIES  = glib-2.0

INCLUDEDIR = include

FLAGS = -Wall -I$(INCLUDEDIR)

CFLAGS = $(FLAGS)
CFLAGS += `$(PKG-CONFIG) --cflags $(LIBRARIES)`
CFLAGS += -DG_LOG_DOMAIN=\"$(PROG)\"
CFLAGS += -DG_MESSAGE_DEBUG=\"xi3status\"
CFLAGS += -DVERSION=\"$(GIT_VERSION)\"

LDFLAGS = $(FLAGS)
LDFLAGS += `$(PKG-CONFIG) --libs $(LIBRARIES)`

all: $(PROG)

%.o: %.c
	@echo "[$(PROG)] $(CC) $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

$(PROG): $(OBJECTS)
	@$(CC) $(LDFLAGS) -o $@ $^
	@echo "[$(PROG)] Link $ $@"

.PHONEY: clean
clean: 
	@echo "[$(PROG)] clean"
	@rm $(OBJECTS) $(PROG)
