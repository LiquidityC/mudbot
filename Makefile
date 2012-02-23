# Variables

OS	= $(shell uname)
ifeq ($(OS),Linux)
GTK_CFLAGS	= -DUSE_GTK `pkg-config --cflags gtk+-3.0`
GTK_LFLAGS	= `pkg-config --libs gtk+-3.0`
else
GTK_CFLAGS	=
GTK_LFLAGS	=
endif

# Compiler
CC 			= gcc
SOCFLAGS	= -fPIC $(GTK_CFLAGS)
CFLAGS		= -c -Wall $(GTK_CFLAGS)
ifeq ($(BUILD),dist)
CFLAGS 		+= -O3 
SOCFLAGS 	+= -O3
else
CFLAGS 		+= -g
SOCFLAGS 	+= -Wall -g
endif
LDFLAGS 	= -L./deps/ $(GTK_LFLAGS) -lz -ldl
MFLAGS		= -shared

SOURCES 	= main.c
ifeq ($(OS),Linux)
SOURCES 	+= gtkmain.c
endif
OBJECTS 	= $(SOURCES:.c=.o)
EXECUTABLE 	= mudbot

SO_SOURCES 	= i_mapper.c
SO_OBJECTS 	= $(SO_SOURCES:.c=.o)
SO_FILES 	= $(SO_SOURCES:.c=.so)

all: $(OBJECTS) $(EXECUTABLE) $(SO_FILES)
	ctags *.c *.h

install: all
	cp mudbot ~/bin/mudbot
	cp i_mapper.so ~/bin/i_mapper.so

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@

%.so: %.c
	$(CC) $(SOCFLAGS) -o $@ $(MFLAGS) $<

clean:
	rm -f *.so *.o mudbot
