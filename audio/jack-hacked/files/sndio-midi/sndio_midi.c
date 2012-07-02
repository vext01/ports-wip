/*
 * SNDIO MIO < - > JACK MIDI bridge
 *
 * Copyright (c) 2012 Edd Barrett
 * Copyright (c) 2006,2007 Dmitry S. Baikov
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 */

/* Required for clock_nanosleep(). Thanks, Nedko */
#define _GNU_SOURCE

#include "sndio_midi.h"
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>
#include <time.h>
#include <limits.h>
#include <ctype.h>
#include <sndio.h>
#include <jack/thread.h>
#include <jack/ringbuffer.h>
#include <jack/midiport.h>
//#include "midi_pack.h"
//#include "midi_unpack.h"


#ifdef STANDALONE
#define MESSAGE(...) fprintf(stderr, __VA_ARGS__)
#else
#include <jack/messagebuffer.h>
#endif

#define info_log(...)  MESSAGE(__VA_ARGS__)
#define error_log(...) MESSAGE(__VA_ARGS__)

#ifdef JACK_MIDI_DEBUG
#define debug_log(...) MESSAGE(__VA_ARGS__)
#else
#define debug_log(...)
#endif


#if 0
struct sndio_midi_t {
	sndio_midi_t parent;
	jack_client_t *client;

	// May or may not need these XXX
	//midi_stream_t in;
	//midi_stream_t out;
};
#endif


sndio_midi_t *sndio_midi_new(jack_client_t *jack)
{
	printf("NEW MIDI_T!!!\n");

	sndio_midi_t *midi = calloc(1, sizeof(sndio_midi_t));
	if (!midi)
		return NULL;

	/* XXX stream setup */

	midi->client = jack;

	return &midi->parent;
}

void sndio_midi_delete(sndio_midi_t *m)
{
	printf("MIDI_DELETE!!!\n");
	sndio_midi_t *midi = (sndio_midi_t*)m;

	sndio_midi_detach(m);
	
	/* XXX mio_close() */

	free(midi);
}

int sndio_midi_attach(sndio_midi_t *m)
{
	printf("MIDI_ATTACH!!!\n");
	return 0;
}

int sndio_midi_detach(sndio_midi_t *m)
{
	printf("MIDI_DETACH!!!\n");

	sndio_midi_t *midi = (sndio_midi_t*)m;

	sndio_midi_stop(m);

	return 0;
}

int sndio_midi_start(sndio_midi_t *m)
{
	printf("MIDI_START!!!\n");

	sndio_midi_t *midi = (sndio_midi_t*)m;
	return 0;
}

int sndio_midi_stop(sndio_midi_t *m)
{
	printf("MIDI_STOP!!!\n");
	sndio_midi_t *midi = (sndio_midi_t*)m;

	return 0;
}

void sndio_midi_read(sndio_midi_t *m, jack_nframes_t nframes)
{
	printf("MIDI_READ!!!\n");
	sndio_midi_t *midi = (sndio_midi_t*)m;
	//jack_process(&midi->in, nframes);
}

void sndio_midi_write(sndio_midi_t *m, jack_nframes_t nframes)
{
	printf("MIDI_WRITE!!!\n");
	sndio_midi_t *midi = (sndio_midi_t*)m;
	//jack_process(&midi->out, nframes);
}

/*
static
inline int midi_port_open_jack(const alsa_midi_t *midi, midi_port_t *port, int type, const char *name)
{
	port->jack = jack_port_register(midi->client, name, JACK_DEFAULT_MIDI_TYPE,
		type | JackPortIsPhysical|JackPortIsTerminal, 0);
	return port->jack == NULL;
}
*/

#if 0
static
int midi_port_open(const alsa_midi_t *midi, midi_port_t *port)
{
	int err;
	int type;
	char name[64];
	snd_midi_t **in = NULL;
	snd_midi_t **out = NULL;

	if (port->id.id[2] == 0) {
		in = &port->midi;
		type = JackPortIsOutput;
	} else {
		out = &port->midi;
		type = JackPortIsInput;
	}
	
	if ((err = snd_midi_open(in, out, port->dev, SND_RAWMIDI_NONBLOCK))<0)
		return err;

	/* Some devices (emu10k1) have subdevs with the same name,
	 * and we need to generate unique port name for jack */
	snprintf(name, sizeof(name), "%s", port->name);
	if (midi_port_open_jack(midi, port, type, name)) {
		int num;
		num = port->id.id[3] ? port->id.id[3] : port->id.id[1];
		snprintf(name, sizeof(name), "%s %d", port->name, num);
		if (midi_port_open_jack(midi, port, type, name))
			return 2;
	}
	if ((port->event_ring = jack_ringbuffer_create(MAX_EVENTS*sizeof(event_head_t)))==NULL)
		return 3;
	if ((port->data_ring = jack_ringbuffer_create(MAX_DATA))==NULL)
		return 4;

	return 0;
}
#endif
