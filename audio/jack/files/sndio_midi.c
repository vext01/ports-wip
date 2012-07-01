#include <stdio.h>

#include <jack/types.h>
#include <jack/internal.h>
#include <jack/engine.h>
#include <jack/thread.h>

#include "sndio_driver.h"

int
sndio_midi_add_ports(sndio_driver_t *d)
{
	jack_port_t		*port;

	printf("ADD PORTS\n");
	
	// XXX hardcode
	// add mio_open checks
	
	jack_port_register(
	    d->client,
	    "rmidi0_out",
	    JACK_DEFAULT_MIDI_TYPE,
	    JackPortIsOutput | JackPortIsPhysical,
	    SNDIO_MIDI_BUFSZ
	    );

	return (0);
}
