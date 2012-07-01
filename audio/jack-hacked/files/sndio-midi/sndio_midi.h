/*
 * Copyright (c) 2012 Edd Barrett
 * Copyright (c) 2006 Dmitry S. Baikov
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

#ifndef __jack_sndio_midi_h__
#define __jack_sndio_midi_h__

#include <jack/jack.h>
#include <jack/driver.h>

typedef struct sndio_midi_t sndio_midi_t;

struct sndio_midi_t {
	void (*destroy)(sndio_midi_t *amidi);
	int (*attach)(sndio_midi_t *amidi);
	int (*detach)(sndio_midi_t *amidi);
	int (*start)(sndio_midi_t *amidi);
	int (*stop)(sndio_midi_t *amidi);
	void (*read)(sndio_midi_t *amidi, jack_nframes_t nframes);
	void (*write)(sndio_midi_t *amidi, jack_nframes_t nframes);
};

typedef struct _sndio_midi_driver {

    JACK_DRIVER_DECL;

    sndio_midi_t *midi;
    jack_client_t *client;

} sndio_midi_driver_t;

/* from sndio_midi.c */
extern sndio_midi_t *sndio_midi_new(jack_client_t *jack);
extern void sndio_midi_delete(sndio_midi_t *m);
extern int sndio_midi_attach(sndio_midi_t *m);
extern int sndio_midi_detach(sndio_midi_t *m);
extern int sndio_midi_start(sndio_midi_t *m);
extern int sndio_midi_stop(sndio_midi_t *m);
extern void sndio_midi_read(sndio_midi_t *m, jack_nframes_t nframes);
extern void sndio_midi_write(sndio_midi_t *m, jack_nframes_t nframes);

#endif
