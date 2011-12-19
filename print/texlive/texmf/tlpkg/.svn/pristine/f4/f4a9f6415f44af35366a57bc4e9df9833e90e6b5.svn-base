/* tlp-utils.h - module for general tlp utilities
 *
 * Copyright 2007 Jjgod Jiang
 * Derived from the Perl implementation by Norbert Preining
 *
 * This file is licensed under the GNU General Public License version 2
 * or any later version. */

#include <tlp-utils.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

tlp_str tlp_str_from_bytes(const char *bytes)
{
    return (tlp_str) strdup(bytes);
}

tlp_str tlp_str_copy(tlp_str str)
{
    if (str == NULL)
        return NULL;

    return strdup(str);
}

void tlp_str_free(tlp_str str)
{
    free(str);
}

tlp_str_list *tlp_str_list_new()
{
    tlp_str_list *list = tlp_new(tlp_str_list);
    if (list == NULL)
        return NULL;

    list->head = list->tail = NULL;
    return list;
}

tlp_str_list *tlp_str_list_from_array(const char *array[])
{
    tlp_str_list *list = tlp_str_list_new();
    int i, size;

    if (list == NULL)
        return NULL;

    size = sizeof(array) / sizeof(array[0]);
    for (i = 0; i < size; i++)
        if (tlp_str_list_append_bytes(list, array[i]) != TLP_OK)
        {
            tlp_str_list_free(list);
            return NULL;
        }

    return list;
}

tlp_result tlp_str_list_append(tlp_str_list *list, tlp_str str)
{
    tlp_str_list_node *node = tlp_new(tlp_str_list_node);

    if (node == NULL)
        return TLP_FAILED;

    node->str = str;
    node->next = NULL;

    if (list->head == NULL)
        list->head = node;

    if (list->tail == NULL)
        list->tail = node;

    else
    {
        list->tail->next = node;
        list->tail = node;
    }

    return TLP_OK;
}

tlp_result tlp_str_list_append_bytes(tlp_str_list *list, const char *bytes)
{
    tlp_str str = tlp_str_from_bytes(bytes);
    if (str == NULL)
        return TLP_FAILED;

    return tlp_str_list_append(list, str);
}

void tlp_str_list_free(tlp_str_list *list)
{
    tlp_str_list_node *node = list->head, *temp;

    while (node != NULL)
    {
        temp = node->next;
        
        tlp_str_free(node->str);
        free(node);

        node = temp;
    }

    free(list);
    list = NULL;
}

tlp_str tlp_fgets(tlp_str s, int n, FILE *fp)
{
    return (tlp_str) fgets((char *) s, n, fp);
}

void tlp_str_output(FILE *fp, tlp_str str)
{
    fprintf(stderr, "%s", (char *) str);
}

size_t tlp_str_len(tlp_str str)
{
    return strlen((const char *) str);
}

int tlp_str_start_with(tlp_str str, tlp_str prefix)
{
    int len = tlp_str_len(prefix);

    if (tlp_str_len(str) < len)
        return 0;

    return strncmp((const char *) str, 
                   (const char *) prefix, len);
}

int tlp_str_start_with_bytes(tlp_str str, const char *prefix)
{
    tlp_str prefix_str;
    int ret;

    prefix_str = tlp_str_from_bytes(prefix);
    if (prefix_str == NULL)
        return 0;

    ret = tlp_str_start_with(str, prefix_str);

    tlp_str_free(prefix_str);
    return ret;
}

int tlp_char_is_space(tlp_char ch)
{
    return isspace((int) ch);
}

int tlp_char_is_eol(tlp_char ch)
{
    return (ch == '\r' || ch == '\n');
}

int tlp_char_in_word(tlp_char ch)
{
    return (isalnum(ch) || ch == '_');
}

void tlp_error_msg(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
}

void tlp_error_str(tlp_str str)
{
    tlp_str_output(stderr, str);
}

