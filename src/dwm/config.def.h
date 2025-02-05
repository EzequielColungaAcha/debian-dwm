/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const unsigned int gappih    = 1;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 1;       /* vert inner gap between windows */
static const unsigned int gappoh    = 1;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 1;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 1;        /* 1 means no outer gap when there is only one window */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const int focusonwheel       = 0;
static const char *fonts[]          = { "JetBrainsMonoNerdFont:size=12" };
static const char dmenufont[]       = "JetBrainsMonoNerdFont:size=12";
static char normbgcolor[]           = "#222222";
static char normbordercolor[]       = "#444444";
static char normfgcolor[]           = "#bbbbbb";
static char selfgcolor[]            = "#eeeeee";
static char selbordercolor[]        = "#005577";
static char selbgcolor[]            = "#005577";
static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
};

/* tagging */
static const char *tags[] = { "", "󰨞", "", "", "", "" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class             instance    title            tags mask  isfloating  isterminal  noswallow  monitor */
	{ "Gimp",            NULL,       NULL,            0,         1,          0,          0,         -1 },
	{ "google-chrome",   NULL,       NULL,            1 << 3,    0,          0,         -1,         -1 },
	{ "st-256color",     NULL,       NULL,            0,         0,          1,          0,         -1 },
	{ "alacritty",       NULL,       NULL,            0,         0,          1,          0,         -1 },
	{ NULL,              NULL,       "Event Tester",  0,         0,          0,          1,         -1 }, /* xev */
};

/* layout(s) */
static const float mfact     = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "HHH",      grid },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod1Mask
#define WINKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbordercolor, "-sf", selfgcolor, NULL };
static const char *allApps[] = { "rofi_all_apps", NULL };
static const char *favApps[] = { "rofi_fav_apps", NULL };
static const char *powerMenu[] = { "rofi_powermenu", NULL };
static const char *termcmd[]  = { "alacritty", NULL };
static const char *wallpaperChangePywal[] = { "wallpaperChangePywal", NULL};
static const char *actionsMenu[] = { "actionsMenu", NULL};
static const char *keyboardLayoutToggle[] = { "keyboardLayoutToggle", NULL};
static const char *flameshot[] = { "flameshot", "gui", NULL};
static const char *slock[] = { "slock", NULL};
#include <X11/XF86keysym.h>
static const char *mutevol[] 			= { "volume", "--toggle",  NULL };
static const char *mutemic[] 			= { "volume", "--toggle-mic",  NULL };
static const char *upvol[]   			= { "volume", "--inc",  	NULL };
static const char *downvol[] 			= { "volume", "--dec",    	NULL };

static const Key keys[] = {
	/* modifier                     key                         function        argument */
	{ 0, 						    XF86XK_AudioMute, 			spawn,          {.v = mutevol } },
	{ 0, 						    XF86XK_AudioMicMute, 		spawn,          {.v = mutemic } },
	{ 0, 						    XF86XK_AudioLowerVolume, 	spawn,          {.v = downvol } },
	{ 0, 						    XF86XK_AudioRaiseVolume, 	spawn,          {.v = upvol   } },
	{ 0,                            XK_Super_L,                 spawn,          {.v = favApps } },
	{ 0,                            XK_Print,                   spawn,          {.v = flameshot } },
	{ MODKEY|ShiftMask|ControlMask, XK_l,                       spawn,          {.v = slock } },
	{ MODKEY,                       XK_a,                       spawn,          {.v = allApps } },
	{ MODKEY,                       XK_p,                       spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return,                  spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask|ControlMask, XK_Return,                  spawn,          {.v = wallpaperChangePywal } },
	{ MODKEY|ShiftMask,             XK_x,                       spawn,          {.v = actionsMenu } },
	{ MODKEY|ShiftMask|ControlMask, XK_x,                       spawn,          {.v = powerMenu } },
	{ MODKEY,                       XK_space,                   spawn,          {.v = keyboardLayoutToggle } },
	{ MODKEY,                       XK_b,                       togglebar,      {0} },
	{ MODKEY,                       XK_j,                       focusstackvis,  {.i = +1 } },
	{ MODKEY,                       XK_k,                       focusstackvis,  {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,                       focusstackhid,  {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,                       focusstackhid,  {.i = -1 } },
	{ MODKEY,                       XK_i,                       incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,                       incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,                       setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,                       setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,                       setcfact,       {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_l,                       setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,                       setcfact,       {.f =  0.00} },
	{ MODKEY,                       XK_Return,                  zoom,           {0} },
	{ MODKEY|Mod4Mask,              XK_u,                       incrgaps,       {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_u,                       incrgaps,       {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_i,                       incrigaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_i,                       incrigaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_o,                       incrogaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_o,                       incrogaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_6,                       incrihgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_6,                       incrihgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_7,                       incrivgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_7,                       incrivgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_8,                       incrohgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_8,                       incrohgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_9,                       incrovgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,                       incrovgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_0,                       togglegaps,     {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,                       defaultgaps,    {0} },
	{ MODKEY,                       XK_Tab,                     view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,                       killclient,     {0} },
	{ MODKEY,                       XK_t,                       setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,                       setlayout,      {.v = &layouts[10]} },
	{ MODKEY,                       XK_m,                       setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_space,                   togglefloating, {0} },
	{ MODKEY,                       XK_0,                       view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,                       tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,                   focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,                  focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,                   tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,                  tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_F5,                      xrdb,           {.v = NULL } },
	{ MODKEY|ShiftMask,             XK_s,                       show,           {0} },
	{ MODKEY|ShiftMask|ControlMask, XK_s,                       showall,        {0} },
	{ MODKEY|ShiftMask|ControlMask, XK_h,                       hide,           {0} },
	{ MODKEY|ShiftMask,             XK_f,      togglefullscr,  {0} },
	TAGKEYS(                        XK_1,                                       0)
	TAGKEYS(                        XK_2,                                       1)
	TAGKEYS(                        XK_3,                                       2)
	TAGKEYS(                        XK_4,                                       3)
	TAGKEYS(                        XK_5,                                       4)
	TAGKEYS(                        XK_6,                                       5)
	TAGKEYS(                        XK_7,                                       6)
	TAGKEYS(                        XK_8,                                       7)
	TAGKEYS(                        XK_9,                                       8)
	{ MODKEY|ShiftMask,             XK_q,                       quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button1,        togglewin,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
