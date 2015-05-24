CC = gcc
PKG-CONFIG = pkg-config

PROG = xi3status

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
