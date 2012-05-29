AVR-Utils: Makefile template, testing, debugging, configuring
=============================================================
Often I find my self refactoring some of my project-specific AVR code to make it more generic, and then
the code becomes **so generic** that it does not belong to that project anymore. That is - however - a
good thing, because then this generic code, useful to possibly a LOT of AVR-related project, is dropped
here.

As of now this repository consists of:


A Makefile template
-------------------
During the development of several AVR projects, I was collecting tips and ideas
from all over the web, cooking and mixing them with my own spices... The result of all this is a pretty
generic Makefile template for AVR projects, in which you only have to redefine a few variables and then
use all the nice targets:

* The standard "all" target: compiles the project  and produces ELF images or static libs (.a files).
* The "install" target: compiles a static library and installs it in a user-defined PREFIX.
* The standard "clean" target
* The "writeflash" target: program your AVR board using avrdude.
* The "stats" target: shows executable image size and other stats about ELF sections.
* The "disasm" target: disassembles the project's executable image into a .s file.

This Makefile template is split in files "Makefile.tpl" and "Makefile.targets.tpl" ("tpl" stands for
template). To use it, you just have to remove the ".tpl" extension from both files and edit the file that
*after the renaming* is named "Makefile" :)  Makefile.targets has only definitions that remain constant
among projects, therefore you should **only edit Makefile**. That's why I separated the contents into
these two files in the first place.


Helper functions to facilitate unit-testing AVR code
----------------------------------------------------
In the last few months, I repeated some 3 times the process of coding "ad-hoc" unit-testing for my AVR
projects, and it was predictable and tiresome. So, last time, I chose to implement some assertion helpers
the way they **should be** and gathered them in assert\_helpers.{c,h}.


Helper functions to facilitate "printf-powered debugging"
--------------------------------------------------------
Yes, even if debuggers are awesome these days, sometimes a printf in the middle of that code is
Good Enough. The functions in sim\_debug.{c,h} use the address of input/output SimulAVR
*virtual registers* to make your AVR print to the console where SimulAVR is running! Yay!

The variables SIM\_WRITE\_ADDR and SIM\_READ\_ADDR are defined in the Makefile template, and the values of
these variables are the addresses of the "virtual registers". Then you can easily open a "virtual device"
for I/O in you AVR C code (using avr-libc), like this:

``` c
    #include <stdio.h>
    #include <avr-utils/sim_debug.h>
    stdout = stdin = fdevopen(debug_putc, debug_getc);
```

After opening, you can just use "printf" as you *always have been comfortable with* :)

``` c
    printf("Yippie, debugging!\n");
```

Helper functions to facilitate configuring AVR on-chip peripherals
------------------------------------------------------------------
Most AVR microcontrollers have some very common and straightforward on-chip peripherals. Some examples:

 * Timers: 8-bit timers, 16-bit timers, etc.
 * Analog-to-digital converters.
 * Analog Comparators.

And for each of these peripheral, a huge amount of pulls and levers are available to help users setup the
peripherals the way they want. The way this configuration is done is by reading and writing to IO registers
with cryptic names, and using cryptic bit flags in the process. Wouldn't it be a bit nicer if we could have at
least SOME functions to help achieve configurations which are VERY commom?

That's what, for example, the functions in timers-atmega168{,p}.{c,h} provide. They have helper functions (for
example `getTimer0PrescaleBits\_atmega168`) so that you don't have to always keep an eye on your code and
other on the datasheet...

