/* tlp-utils.h - header for general tlp definitions
 *
 * Copyright 2007 Jjgod Jiang
 * Derived from the Perl implementation by Norbert Preining
 *
 * This file is licensed under the GNU General Public License version 2
 * or any later version. */

#ifndef __TLP_UTILS__
#define __TLP_UTILS__

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

typedef char      tlp_char;
typedef tlp_char *tlp_str;

#define TLP_CHAR(x)         ((tlp_char) x)

enum tlp_special_chars {
    TLP_CHAR_COMMENT = TLP_CHAR('#'),
    TLP_CHAR_END     = TLP_CHAR('\0'),
};

typedef struct tlp_str_list_node {
    tlp_str str;
    struct tlp_str_list_node *next;
} tlp_str_list_node;

typedef struct tlp_str_list {
    struct tlp_str_list_node *head;
    struct tlp_str_list_node *tail;
} tlp_str_list;

typedef tlp_str_list tlp_execute;
typedef tlp_str_list tlp_depend;

#define tlp_executes_free(x) tlp_str_list_free(x)
#define tlp_depends_free(x)  tlp_str_list_free(x)

typedef enum tlp_result {
    TLP_FAILED = 0, TLP_OK = 1
} tlp_result;

#define tlp_new(x)           ((x *) malloc(sizeof(x)))

tlp_str tlp_str_from_bytes(const char *bytes);
tlp_str tlp_str_copy(tlp_str str);
void    tlp_str_free(tlp_str str);


tlp_str_list *tlp_str_list_new();
tlp_str_list *tlp_str_list_from_array(const char *array[]);
tlp_result    tlp_str_list_append(tlp_str_list *list, tlp_str str);
tlp_result    tlp_str_list_append_bytes(tlp_str_list *list, const char *bytes);
void          tlp_str_list_free(tlp_str_list *list);

tlp_str tlp_fgets(tlp_str s, int n, FILE *fp);
size_t  tlp_str_len(tlp_str str);
void    tlp_str_output(FILE *fp, tlp_str str);
int     tlp_str_start_with(tlp_str str, tlp_str prefix);
int     tlp_str_start_with_bytes(tlp_str str, const char *prefix);

int     tlp_char_is_space(tlp_char ch);
int     tlp_char_is_eol(tlp_char ch);
int     tlp_char_in_word(tlp_char ch);

void    tlp_error_msg(const char *fmt, ...);
void    tlp_error_str(tlp_str str);

#endif

