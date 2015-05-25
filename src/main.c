#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <glib.h>


/*
 * Parse command line options and react.
 */
void parse_command_line(int *argc, char ***argv) {
	// Default values of options
	static gboolean debug = FALSE;
	static gboolean silent = FALSE;
	static gboolean print_version = FALSE;

	// Define options
	static GOptionEntry entries[] =
	{
		{ "version", 'V', G_OPTION_FLAG_NONE, G_OPTION_ARG_NONE, &print_version, "Print version information", NULL},
		{ "debug", 'd', G_OPTION_FLAG_NONE, G_OPTION_ARG_NONE, &debug, "Log debug information", NULL },
		{ "silent", 's', G_OPTION_ARG_NONE, G_OPTION_ARG_NONE, &silent, "Only log errors", NULL },
		{ NULL },
	};

	GError *error = NULL;
	GOptionContext *context;

	context = g_option_context_new("");
	g_option_context_set_ignore_unknown_options(context, FALSE);
	g_option_context_set_summary(context, "Creates a status line for i3bar\nFor more information look at the man page");
	g_option_context_add_main_entries(context, entries, NULL);
	if (!g_option_context_parse (context, argc, argv, &error))
	{
		g_error ("option parsing failed: %s\n", error->message);
	}

	// Check for option clashes
	if (debug && silent) {
		g_error("Option clash: Use either --debug or --silent");
	}

	// Print version information	
	if(print_version) {
		g_print("xi3status version: %s\n", VERSION);
		exit(0);
	}

	// Set the right log level
	// Options that stand in conflict
	if(debug) {
		if(g_setenv("G_MESSAGES_DEBUG", "xi3status", TRUE) == FALSE) {
			g_critical("G_MESSAGES_DEBUG coul not be set. Continue without debug logging");
		}
	} else if (silent) {
		// TODO enable silent logging
	}

	g_option_context_free(context);
}

int main(int argc, char **argv) {

	parse_command_line(&argc, &argv); // And set the right log level

	/*
	 * Define internal data structure
	 */

	// Write header block of the i3bar protocol
	if (puts(" { \"version\": 1 }[") == EOF) {
		g_error("Unable to write to stdout");
	}

	/* Infinite Loop which generates the output */
	while (TRUE) {
		int i;
		printf("[{ \"full_text\": \"Test %i\" }],", i++);

		// Flush the output to display the changes
		if (fflush(NULL) == EOF) {
			//TODO Print to log file
			g_critical("fflush failed");
		}
		// TODO Sleep exactly the specified interval
		sleep(1);
	}
	return 0;
}
