#include <stdio.h>
#include <string.h>

#include <jack/types.h>
#include <jack/internal.h>
#include <jack/engine.h>
#include <jack/thread.h>
#include <jack/ringbuffer.h>
#include <jack/midiport.h>

#include <sndio.h>

#include "sndio_driver.h"

/*
 * Create jack ports for the OpenBSD rmidi* devices
 */
int
sndio_midi_add_ports(sndio_driver_t *driver)
{
	struct mio_hdl		*hdl;
	sndio_midi_dev_t	*midi_dev = NULL;
	int			n;
	char			devname[MAX_MIDI_DEV_NAME];
	char			portname_in[MAX_MIDI_PORT_NAME];
	char			portname_out[MAX_MIDI_PORT_NAME];

	for (n = 0; n < MAX_MIDI_PORTS; n++) {
		printf("Checking /dev/rmidi%d\n", n);

		if (snprintf(devname, MAX_MIDI_DEV_NAME, "rmidi/%d", n) < 0) {
			fprintf(stderr, "%s: couldn't sprintf\n", __func__);
			continue;
		}

		/*
		 * for now we just open any midi port we can and hold
		 * an open mio_hdl. This should eventually be changed so
		 * that only connected ports are held open XXX
		 */
		if ((hdl = mio_open(devname, MIO_IN | MIO_OUT, 0)) == NULL) {
			fprintf(stderr, "%s: %s not usable\n", __func__, devname);
			continue;
		}

		/*
		 * Stuff everything into a sndio_midi_t and append to the
		 * sndio driver's list of midi devs
		 */

		if ((midi_dev = malloc(sizeof(sndio_midi_dev_t))) < 0) {
			fprintf(stderr, "%s: could not malloc\n", __func__);
			free(midi_dev);
			continue;
		}

		midi_dev->mio_rw_handle = hdl;
		strlcpy(midi_dev->device_name, devname, MAX_MIDI_DEV_NAME);

		/* make port names */
		if ((snprintf(portname_in, MAX_MIDI_PORT_NAME, "%s_in", devname)) < 0) {
			fprintf(stderr, "%s: could not malloc\n", __func__);
			free(midi_dev);
			continue;
		}

		if ((snprintf(portname_out, MAX_MIDI_PORT_NAME, "%s_out", devname)) < 0) {
			fprintf(stderr, "%s: could not malloc\n", __func__);
			free(midi_dev);
			continue;
		}

		midi_dev->in_port = jack_port_register(
		    driver->client,
		    portname_in,
		    JACK_DEFAULT_MIDI_TYPE,
		    JackPortIsOutput | JackPortIsPhysical,
		    MAX_MIDI_BUFFER
		    );

		midi_dev->out_port = jack_port_register(
		    driver->client,
		    portname_out,
		    JACK_DEFAULT_MIDI_TYPE,
		    JackPortIsInput | JackPortIsPhysical,
		    MAX_MIDI_BUFFER
		    );

		if ((midi_dev->in_port == NULL) || (midi_dev->out_port == NULL)) {
			fprintf(stderr, "%s: could not make jack ports for %s\n", __func__, devname);
			free(midi_dev);
			continue;
		}

		driver->midi_devs[driver->num_midi_devs] = midi_dev;
		driver->num_midi_devs++;
	} // next device

	printf("I found %d midi devices\n", driver->num_midi_devs);

	return (0);
}

void
sndio_debug_print_midi_event(jack_midi_event_t *ev)
{
	size_t		byte;

	printf("MIDI_EVENT:\n");
	printf("\ttime: %u\n", ev->time);
	printf("\tsize: %lu\n", ev->size);

	for (byte = 0; byte < ev->size; byte++)
		printf("\tdata byte %lu: %02x %u\n",
		    byte, (unsigned int) ev->buffer[byte], ev->buffer[byte]);
}

void
sndio_midi_write(sndio_driver_t *driver, jack_nframes_t nframes)
{
	int			 m_dev_no = 0, ev_no;
	sndio_midi_dev_t	*midi_dev;
	void			*buf;
	jack_nframes_t		num_events;
	jack_midi_event_t	midi_event;

	for (m_dev_no = 0; m_dev_no < driver->num_midi_devs; m_dev_no++) {
		midi_dev = driver->midi_devs[m_dev_no];

		buf = jack_port_get_buffer(midi_dev->out_port, nframes);
		num_events = jack_midi_get_event_count(buf);

		if (num_events == 0)
			continue;

		for (ev_no = 0; ev_no < num_events; ev_no++) {
			if (jack_midi_event_get(&midi_event, buf, ev_no) != 0) {
				fprintf(stderr, "%s: no events to get, should not happen\n", __func__);
				break;
			}

			sndio_debug_print_midi_event(&midi_event);
			mio_write(midi_dev->mio_rw_handle, midi_event.buffer, midi_event.size);
		}
	}
}
