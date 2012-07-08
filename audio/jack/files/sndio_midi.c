#include <stdio.h>
#include <string.h>

#include <jack/types.h>
#include <jack/internal.h>
#include <jack/engine.h>
#include <jack/thread.h>

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
			/* XXX clean up */
			fprintf(stderr, "%s: could not malloc\n", __func__);
			continue;
		}

		midi_dev->mio_rw_handle = hdl;

		if ((midi_dev->device_name = strdup(devname)) == NULL) {
			/* XXX clean up */
			fprintf(stderr, "%s: could not strdup\n", __func__);
			continue;
		}

		/* make port names */
		if ((snprintf(portname_in, MAX_MIDI_PORT_NAME, "%s_in", devname)) < 0) {
			/* XXX clean up */
			fprintf(stderr, "%s: could not malloc\n", __func__);
			continue;
		}

		if ((snprintf(portname_out, MAX_MIDI_PORT_NAME, "%s_out", devname)) < 0) {
			/* XXX clean up */
			fprintf(stderr, "%s: could not malloc\n", __func__);
			continue;
		}

		midi_dev->in_port = jack_port_register(
		    driver->client,
		    portname_out,
		    JACK_DEFAULT_MIDI_TYPE,
		    JackPortIsInput | JackPortIsPhysical,
		    SNDIO_MIDI_BUFSZ
		    );

		midi_dev->out_port = jack_port_register(
		    driver->client,
		    portname_in,
		    JACK_DEFAULT_MIDI_TYPE,
		    JackPortIsOutput | JackPortIsPhysical,
		    SNDIO_MIDI_BUFSZ
		    );

		if ((midi_dev->in_port == NULL) || (midi_dev->out_port == NULL)) {
			/* XXX clean up */
			fprintf(stderr, "%s: could not make jack ports for %s\n", __func__, devname);
			continue;
		}

		jack_slist_append(driver->midi_devs, midi_dev->in_port);
		jack_slist_append(driver->midi_devs, midi_dev->out_port);
	} // next device

	return (0);
}
