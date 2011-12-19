/* tlp-config.c - header exporting configuration stuff
 *
 * Copyright 2007 Jjgod Jiang
 * Derived from the Perl implementation by Norbert Preining
 *
 * This file is licensed under the GNU General Public License version 2
 * or any later version. */

#ifndef __TLP_CONFIG__
#define __TLP_CONFIG__

/* We use the following pointers to encapsulate the real config module
 * implementation: we could use static allocated arrays, or we could 
 * use dynamic allocated ones, as long as we follow the rule (put a 
 * NULL pointer at the end of it), internal implementation does not 
 * matter. */

extern tlp_str_list tlp_meta_categories;
extern tlp_str_list tlp_normal_categories;
extern tlp_str_list tlp_categories;

#endif

