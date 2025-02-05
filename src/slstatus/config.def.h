/* See LICENSE file for copyright and license details. */

/* interval between updates (in ms) */
const unsigned int interval = 1000;

/* text to show if no value can be retrieved */
static const char unknown_str[] = "n/a";

/* maximum output string length */
#define MAXLEN 2048

static const struct arg args[] = {
/*  function            format       argument */
	{ ram_used,         "|  %s ",   NULL },
	{ battery_perc,     "| %s%% ",   "BAT0" },
	{ keymap,           "| %s ",     NULL },
	{ datetime,         "%s",        "| 󰃭 %a %d/%m |  %R " },
};