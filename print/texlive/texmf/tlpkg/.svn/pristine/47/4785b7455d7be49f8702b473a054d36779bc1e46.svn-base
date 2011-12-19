CFLAGS = -Wall -I.
SO = dylib

all: libtlp.$(SO)

libtlp.$(SO): tlp-src.o tlp-config.o tlp-utils.o
	$(CC) $^ -dynamiclib -o $@
