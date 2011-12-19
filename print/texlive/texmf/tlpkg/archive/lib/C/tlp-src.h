/* tlp-src.h - header for using tlpsrc files
 *
 * Copyright 2007 Jjgod Jiang
 * Derived from the Perl implementation by Norbert Preining
 *
 * This file is licensed under the GNU General Public License version 2
 * or any later version. */

#ifndef __TLP_SRC__
#define __TLP_SRC__

#include <tlp-utils.h>

enum tlp_src_limits {
    TLP_SRC_LINE_MAX = 1024, 
    TLP_SRC_NAME_MAX = 256,
};

enum tlp_pattern_type {
    TLP_PATTERN_T, TLP_PATTERN_F, 
    TLP_PATTERN_D, TLP_PATTERN_R
};

typedef struct tlp_pattern {
    enum tlp_pattern_type type;

    union {
        tlp_str_list *t;
        tlp_str f;
        tlp_str d;
        tlp_str r;
    } u;

    struct tlp_pattern *next;
} tlp_pattern;

typedef struct tlp_src {
    /* name of the package */
    tlp_str      name;
    /* Collection Scheme TLCore Package Documentation */
    tlp_str      category;
    /* short one line desc */
    tlp_str      shortdesc;
    /* longer multiline dscription */
    tlp_str      longdesc;
    /* name of the respective Catalogue entry */
    tlp_str      catalogue;

    tlp_pattern *runpatterns;
    tlp_pattern *srcpatterns;
    tlp_pattern *docpatterns;
    tlp_pattern *binpatterns;

    tlp_execute *executes;
    tlp_depend  *depends;
} tlp_src;

tlp_src *tlp_src_new(tlp_str name, 
                     tlp_str category, 
                     tlp_str shortdesc, 
                     tlp_str longdesc, 
                     tlp_str catalogue, 
                     tlp_pattern *runpatterns, 
                     tlp_pattern *srcpatterns, 
                     tlp_pattern *docpatterns,
                     tlp_pattern *binpatterns,
                     tlp_execute *executes, 
                     tlp_depend  *depends);

void tlp_src_free(tlp_src *src);
void tlp_patterns_free(tlp_pattern *pat);
void tlp_pattern_free(tlp_pattern *pat);

#endif

