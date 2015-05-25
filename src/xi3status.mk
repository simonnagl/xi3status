CC = gcc

SOURCES   := $(wildcard src/*.c)
HEADERS   := $(wildcard include/*.h)
OBJECTS   := $(SOURCES:.c=.o)
LIBRARIES  = glib-2.0

INCLUDEDIR = include

FLAGS = -Wall -I$(INCLUDEDIR)

CFLAGS = $(FLAGS)
CFLAGS += `$(PKG-CONFIG) --cflags $(LIBRARIES)`
# For glib-2.0
CFLAGS += -DG_LOG_DOMAIN=\"$(PROG)\"
CFLAGS += -DG_MESSAGE_DEBUG=\"xi3status\"
# For version output
CFLAGS += -DVERSION=\"$(GIT_VERSION)\"

LDFLAGS = $(FLAGS)
LDFLAGS += `$(PKG-CONFIG) --libs $(LIBRARIES)`

%.o: %.c
	@echo "[$(PROG)] $(CC) $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

$(PROG): $(OBJECTS)
	@echo "[$(PROG)] Link $ $@"
	@$(CC) $(LDFLAGS) -o $@ $^
	
.PHONEY: clean-$(PROG)
clean-$(PROG): 
	@echo "[$(PROG)] clean"
	@rm $(OBJECTS) $(PROG)
