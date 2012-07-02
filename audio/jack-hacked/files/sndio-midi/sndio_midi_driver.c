
#include "sndio_midi.h"
#include <string.h>
#include <stdio.h>

static int
sndio_midi_driver_attach( sndio_midi_driver_t *driver, jack_engine_t *engine )
{
	printf("ATTACH!!!\n");
	//return driver->midi->attach(driver->midi);
	return 0;
}

static int
sndio_midi_driver_detach( sndio_midi_driver_t *driver, jack_engine_t *engine )
{
	printf("DETACH!!!\n");
	//return driver->midi->detach(driver->midi);
	return 0;
}

static int
sndio_midi_driver_read( sndio_midi_driver_t *driver, jack_nframes_t nframes )
{
	printf("READ!!!\n");
	//driver->midi->read(driver->midi, nframes);
	return 0;
}

static int
sndio_midi_driver_write( sndio_midi_driver_t *driver, jack_nframes_t nframes )
{
	printf("WRITE!!!\n");
	//driver->midi->write(driver->midi, nframes);
	return 0;
}

static int
sndio_midi_driver_start( sndio_midi_driver_t *driver )
{
	printf("START!!!\n");
	//return driver->midi->start(driver->midi);
	return 0;
}

static int
sndio_midi_driver_stop( sndio_midi_driver_t *driver )
{
	printf("STOP!!!\n");
	//return driver->midi->stop(driver->midi);
	return 0;
}

static void
sndio_midi_driver_delete( sndio_midi_driver_t *driver )
{
	printf("DELETE!!!!\n");
	//if (driver->midi)
	//	(driver->midi->destroy)(driver->midi);

	//free (driver);
}

static sndio_midi_driver_t *
sndio_midi_driver_new (jack_client_t *client, const char *name)
{
	printf("NEW!!!!!\n");
	sndio_midi_driver_t *driver;

	jack_info ("creating sndio_midi driver ..."); 

	driver = (sndio_midi_driver_t *) calloc (1, sizeof (sndio_midi_driver_t));

	jack_driver_init ((jack_driver_t *) driver);

	driver->attach = (JackDriverAttachFunction) sndio_midi_driver_attach;
	driver->detach = (JackDriverDetachFunction) sndio_midi_driver_detach;
	driver->read = (JackDriverReadFunction) sndio_midi_driver_read;
	driver->write = (JackDriverWriteFunction) sndio_midi_driver_write;
	driver->start = (JackDriverStartFunction) sndio_midi_driver_start;
	driver->stop = (JackDriverStartFunction) sndio_midi_driver_stop;

	driver->client = client;

	return driver;
}

/* DRIVER "PLUGIN" INTERFACE */

const char driver_client_name[] = "sndio_midi";

const jack_driver_desc_t *
driver_get_descriptor ()
{
	printf("GET DESCRIPTOR!!!!\n");

	jack_driver_desc_t * desc;
	jack_driver_param_desc_t * params;

	desc = calloc (1, sizeof (jack_driver_desc_t));

	strncpy (desc->name, driver_client_name, sizeof(driver_client_name));
	desc->nparams = 0;

	params = calloc (desc->nparams, sizeof (jack_driver_param_desc_t));
	desc->params = params;

	return desc;
}

jack_driver_t *
driver_initialize (jack_client_t *client, const JSList * params)
{
	printf("INIT!!!!\n");

	/* pass down parameters */
	const JSList * node;
	const jack_driver_param_t * param;

	for (node = params; node; node = jack_slist_next (node)) {
  	        param = (const jack_driver_param_t *) node->data;

		switch (param->character) {
			default:
				break;
		}
	}
			
	return sndio_midi_driver_new (client, NULL);
}

void
driver_finish (jack_driver_t *driver)
{
	printf("FINISH!!!\n");
	sndio_midi_driver_delete ((sndio_midi_driver_t *) driver);
}
