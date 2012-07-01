MAINTAINERCLEANFILES=Makefile.in

AM_CFLAGS = $(JACK_CFLAGS)

plugindir = $(ADDON_DIR)

plugin_LTLIBRARIES = jack_sndio_midi.la

jack_sndio_midi_la_LDFLAGS = -module -avoid-version
jack_sndio_midi_la_SOURCES = sndio_midi_driver.c

noinst_HEADERS = sndio_midi.h

jack_sndio_midi_la_LIBADD = $(SNDIO_LIBS) 
