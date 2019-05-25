
This directory allows customers configure Allegro based products
(Allegro, APD and SPECCTRAQuest) or a site wide basis.

To set or override Allegro environment variables or aliases place
a "site.env" file in this directory.

Directories provided are as follows:
   Directory	 File Extensions	 Description
    assembly      .arl .rle		DFA configuration files
    configure
	prfedit   .prf			User files for environment editor
    devices       .txt			3rd party device files
    icons         .bmp			Form Bitmaps (skill programs)
    extracta      .txt			extracta command files
    forms         .form			Form files (skill programs)
    menus         .men			Menu files
    nclegend      .txt			NC Drill legend template files
    padstacks     .pad			Padstacks
    parameter     .prm			Physical option reuse files (Example
					grids, text sizes, visibility etc.)
    scripts       .scr			Allegro script files
    skill         .il .ils .cxt		Skill programs (also requires
					presence of allegro.ilinit
					to load the files)
    signal        .dat .wave .ibs .mod  Signoise models
		  .ctl 
    symbols       .psm .bsm .osm	Packages, mechanical, other
		  .ssm .fsm		shape and flash symbol files
    tech          .tech			Technology files
    views         .color		Visibility setting packages
    xtalk         .xtb			Crosstalk tables

Hints:
    1) Place your site pxlBA.txt in the extracta to specify properties
       that genfeedformat should feedback to the schematic
