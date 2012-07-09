#include <stdio.h>
#include <string.h>
#include <stdlib.h>

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
void
sndio_midi_add_dev(sndio_driver_t *driver, char *devname)
{
	struct mio_hdl		*hdl;
	sndio_midi_dev_t	*midi_dev = NULL;

	printf("Checking: %s\n", devname);

	/* sanity */
	if (driver->num_midi_devs >= MAX_MIDI_DEVS - 1) {
		jack_error("too many midi devices: %s@%i\n",
		    __FILE__, __LINE__);
		exit(1);
	}

	/*  open the mio device */
	if ((hdl = mio_open(devname, MIO_IN | MIO_OUT, 0)) == NULL) {
		jack_error("%s not usable: %s@%i\n",
		    devname, __FILE__, __LINE__);
		exit(1);
	}

	/*
	 * Stuff everything into a sndio_midi_t and append to the
	 * sndio driver's list of midi devs
	 */

	if ((midi_dev = malloc(sizeof(sndio_midi_dev_t))) < 0) {
		jack_error("could not malloc: %s@%i\n", __FILE__, __LINE__);
		free(midi_dev);
		exit(1);
	}

	midi_dev->mio_rw_handle = hdl;
	strlcpy(midi_dev->device_name, devname, MAX_MIDI_DEV_NAME);

	/* we cannot make jack ports yet until the driver is registered */

#if 0
	/* make port names */
	if ((snprintf(portname_in, MAX_MIDI_PORT_NAME, "%s_in", devname)) < 0) {
		fprintf(stderr, "%s: could not malloc\n", __func__);
		free(midi_dev);
		exit(1);
	}

	if ((snprintf(portname_out, MAX_MIDI_PORT_NAME, "%s_out", devname)) < 0) {
		fprintf(stderr, "%s: could not malloc\n", __func__);
		free(midi_dev);
		exit(1);
	}

	/* create jack ports */
	printf("making port: %s\n", portname_in);
	midi_dev->in_port = jack_port_register(
	    driver->client,
	    portname_in,
	    JACK_DEFAULT_MIDI_TYPE,
	    JackPortIsOutput | JackPortIsPhysical,
	    MAX_MIDI_BUFFER
	    );

	if (midi_dev->in_port == NULL) {
		jack_error("could not make output port for %s: %s@%i\n",
		    devname, __FILE__, __LINE__);
		free(midi_dev);
		exit(1);
	}

	printf("making port: %s\n", portname_out);
	midi_dev->out_port = jack_port_register(
	    driver->client,
	    portname_out,
	    JACK_DEFAULT_MIDI_TYPE,
	    JackPortIsInput | JackPortIsPhysical,
	    MAX_MIDI_BUFFER
	    );

	if (midi_dev->out_port == NULL) {
		jack_error("could not make input port for %s: %s@%i\n",
		    devname, __FILE__, __LINE__);
		free(midi_dev);
		exit(1);
	}
#endif

	driver->midi_devs[driver->num_midi_devs] = midi_dev;
	driver->num_midi_devs++;
}

void
sndio_midi_create_ports(sndio_driver_t *driver)
{
	sndio_midi_dev_t	*midi_dev;
	int			i;
	char			portname_in[MAX_MIDI_PORT_NAME];
	char			portname_out[MAX_MIDI_PORT_NAME];

	for (i = 0; i < driver->num_midi_devs; i++) {

		midi_dev = driver->midi_devs[i];

		/* make port names */
		if ((snprintf(portname_in, MAX_MIDI_PORT_NAME, "%s_in", midi_dev->device_name)) < 0) {
			fprintf(stderr, "%s: could not malloc\n", __func__);
			free(midi_dev);
			exit(1);
		}

		if ((snprintf(portname_out, MAX_MIDI_PORT_NAME, "%s_out", midi_dev->device_name)) < 0) {
			fprintf(stderr, "%s: could not malloc\n", __func__);
			free(midi_dev);
			exit(1);
		}

		/* create jack ports */
		printf("making port: %s\n", portname_in);
		midi_dev->in_port = jack_port_register(
		    driver->client,
		    portname_in,
		    JACK_DEFAULT_MIDI_TYPE,
		    JackPortIsOutput | JackPortIsPhysical,
		    MAX_MIDI_BUFFER
		    );

		if (midi_dev->in_port == NULL) {
			jack_error("could not make output port for %s: %s@%i\n",
			    portname_in, __FILE__, __LINE__);
			free(midi_dev);
			exit(1);
		}

		printf("making port: %s\n", portname_out);
		midi_dev->out_port = jack_port_register(
		    driver->client,
		    portname_out,
		    JACK_DEFAULT_MIDI_TYPE,
		    JackPortIsInput | JackPortIsPhysical,
		    MAX_MIDI_BUFFER
		    );

		if (midi_dev->out_port == NULL) {
			jack_error("could not make input port for %s: %s@%i\n",
			    portname_out, __FILE__, __LINE__);
			free(midi_dev);
			exit(1);
		}
	}
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
