/*
 * Copyright (c) 2009 Jacob Meuser <jakemsr@sdf.lonestar.org>
 * Copyright (c) 2012 Edd Barrett  <edd@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef __JACK_SNDIO_DRIVER_H__
#define __JACK_SNDIO_DRIVER_H__

#include <sys/types.h>
#include <pthread.h>
#include <semaphore.h>

#include <jack/types.h>
#include <jack/jslist.h>
#include <jack/driver.h>
#include <jack/jack.h>
#include <jack/ringbuffer.h>

#define SNDIO_DRIVER_DEF_DEV		"default"
#define SNDIO_DRIVER_DEF_FS		44100
#define SNDIO_DRIVER_DEF_BLKSIZE	1024
#define SNDIO_DRIVER_DEF_NPERIODS	2
#define SNDIO_DRIVER_DEF_BITS		16
#define SNDIO_DRIVER_DEF_INS		2
#define SNDIO_DRIVER_DEF_OUTS		2

typedef jack_default_audio_sample_t jack_sample_t;

#define MAX_MIDI_DEVS		8
#define MAX_MIDI_DEV_NAME	16
#define MAX_MIDI_PORT_NAME	32
#define MAX_MIDI_BUFFER		1024
#define MIO_NONBLOCK		1

/* midi ports and their correposponding mio_* handles (if opened) */
typedef struct _sndio_midi_dev
{
	char			device_name[MAX_MIDI_DEV_NAME];
	struct mio_hdl		*mio_rw_handle;
	jack_port_t		*in_port;
	jack_port_t		*out_port;
	jack_ringbuffer_t	*event_ring;
	jack_ringbuffer_t	*data_ring;
} sndio_midi_dev_t;

typedef struct _sndio_driver
{
	JACK_DRIVER_NT_DECL

	jack_nframes_t sample_rate;
	jack_nframes_t period_size;
	jack_nframes_t orig_period_size;
	unsigned int nperiods;
	int bits;
	unsigned int capture_channels;
	unsigned int playback_channels;
	jack_nframes_t sys_cap_latency;
	jack_nframes_t sys_play_latency;
	int ignorehwbuf;

	struct sio_hdl *hdl;
	char *dev;

	void *capbuf;
	size_t capbufsize;
	void *playbuf;
	size_t playbufsize;
	JSList *capture_ports;
	JSList *playback_ports;

	int sample_bytes;
	size_t pprime;

	int poll_timeout;
	jack_time_t poll_next;

	jack_client_t *client;

	/* midi */
	sndio_midi_dev_t	*midi_devs[MAX_MIDI_DEVS];
	int num_mio_devs;

} sndio_driver_t;

/* sndio_midi.c */
void	sndio_midi_add_dev(sndio_driver_t *driver, char *devname);
void	sndio_midi_write(sndio_driver_t *driver, jack_nframes_t nframes);
void	sndio_midi_read(sndio_driver_t *driver, jack_nframes_t nframes);
void	sndio_midi_create_ports(sndio_driver_t *driver);

#endif
