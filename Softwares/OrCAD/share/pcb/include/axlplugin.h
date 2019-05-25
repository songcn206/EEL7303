#ifndef _AXLPLUGIN_H
#define _AXLPLUGIN_H

/*INDENT OFF*/
/*------------------------------------------------------------------------*/
/*-
 *	Cadence Design Systems
 * (c) 2006 Cadence Design Systems, Inc. All rights reserved.
 *
 * Axl Skill Programming interface for Plugin capability.
 *
 * See axlDllDoc for programming infomation
 */
/*------------------------------------------------------------------------*/

/*-
 */
/*INDENT ON*/

// maximum arguments supported by plugin interface
#define AXLPLUGIN_MAX		512

// version
#define AXLPLUGIN_VERS_IN	1
#define AXLPLUGIN_VERS_OUT	1

/* legal boolean values */
#define AXLPLUGIN_TRUE		1
#define AXLPLUGIN_FALSE		0

// support plugin primitive data types
//  NOTE: AP_STRING is only support for output, all others apply
//	to both in/out
typedef enum {
	AP_BOOL = 0,
	AP_LONG,
	AP_DOUBLE,
	AP_CONST_STRING,
	AP_STRING,
	AP_XY,
	AP_EOF
} AXLPluginTypes;

typedef struct {
	double x;
	double y;
} AXLXY;

typedef union {
	int b_value; 
	long l_value;
	double d_value;
	const char *cs_value;
	char *s_value;
	AXLXY xy_value;
} AXLPluginData;

typedef struct {
	AXLPluginTypes type;
	AXLPluginData data;
} AXLPluginEntry;


// Input/Output data structure passed to plugin functions
typedef struct {
	long version;		/* see AXLPLUGIN_VERS */
	long flag;		/* future use, must be 0 */
	long maxEntries;	/* AXLPLUGIN_MAX */
	long count;		/* number entries initialize in argv */
	AXLPluginEntry *argv;	/* arrary of maxEntries */
} AXLPluginArgs;


#endif /* _AXLPLUGIN_H */
