/* tlp-src.c - module for using tlpsrc files
 *
 * Copyright 2007 Jjgod Jiang
 * Derived from the Perl implementation by Norbert Preining
 *
 * This file is licensed under the GNU General Public License version 2
 * or any later version. */

#include <tlp-src.h>
#include <stdio.h>

/* internal function prototypes {{{ */

tlp_result tlp_src_process_line(tlp_src *src, tlp_str line, 
                                int *started, int *finished, 
                                const char *file);

tlp_result tlp_str_get_word(tlp_str str, tlp_str word, int max);

tlp_result tlp_src_get_name(tlp_str     line, 
                            tlp_src    *src, 
                            int        *started, 
                            const char *file);

tlp_result tlp_src_get_category(tlp_str     line, 
                                tlp_src    *src, 
                                int        *started, 
                                const char *file);

/* }}} */

/* internal data structures {{{ */

struct tlp_src_field {
    const char  *key;
    tlp_result (*func)(tlp_str     line, 
                       tlp_src    *src, 
                       int        *started, 
                       const char *file);
};

/* for lines start with "name", we use function tlp_src_get_name() to 
 * process it, and feed it with the current tlp_src instance. */

struct tlp_src_field tlp_src_fields[] = {
    { "name",          tlp_src_get_name        }, 
    { "category",      tlp_src_get_category    }, /*
    { "shortdesc",     tlp_src_get_shortdesc   }, 
    { "longdesc",      tlp_src_get_longdesc    },
    { "catalogue",     tlp_src_get_catalogue   },

    { "runpatterns",   tlp_src_get_runpatterns },
    { "srcpatterns",   tlp_src_get_srcpatterns },
    { "docpatterns",   tlp_src_get_docpatterns },
    { "binpatterns",   tlp_src_get_binpatterns },

    { "execute",       tlp_src_get_execute     },
    { "depend",        tlp_src_get_depend      },  */
};

#define TLP_SRC_TOTAL_FIELDS    (sizeof(tlp_src_fields) / sizeof(tlp_src_fields[0]))

/* }}} */

/* tlp_src related {{{ */

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
                     tlp_depend  *depends)
{
    tlp_src *src = tlp_new(tlp_src);
    if (! src)
        return NULL;

    src->name      = tlp_str_copy(name);
    src->category  = tlp_str_copy(category);
    src->shortdesc = tlp_str_copy(shortdesc);
    src->longdesc  = tlp_str_copy(longdesc);
    src->catalogue = tlp_str_copy(catalogue);

    src->runpatterns = runpatterns;
    src->srcpatterns = srcpatterns;
    src->docpatterns = docpatterns;
    src->binpatterns = binpatterns;

    src->executes = executes;
    src->depends  = depends;

    return src;
}

void tlp_src_free(tlp_src *src)
{
    if (! src)
        return;

    tlp_str_free(src->name);
    tlp_str_free(src->category);
    tlp_str_free(src->shortdesc);
    tlp_str_free(src->longdesc);
    tlp_str_free(src->catalogue);

    tlp_patterns_free(src->runpatterns);
    tlp_patterns_free(src->srcpatterns);
    tlp_patterns_free(src->docpatterns);
    tlp_patterns_free(src->binpatterns);

    tlp_executes_free(src->executes);
    tlp_depends_free(src->depends);

    free(src);
    src = NULL;
}

tlp_src *tlp_src_from_file(char *file)
{
    FILE    *fp;
    tlp_src *src;
    tlp_char line[TLP_SRC_LINE_MAX];
    int      started, finished;

    fp = fopen(file, "r");
    if (! fp)
        return NULL;

    src = tlp_new(tlp_src);

    /* TODO: if the argument is not readable as is, try looking 
     * for it in the hierarchy where we are.*/
    if (! src)
        return NULL;

    started = finished = 0;

    while (tlp_fgets(line, TLP_SRC_LINE_MAX, fp))
    {
        if (tlp_src_process_line(src, line, 
                                 &started, 
                                 &finished, 
                                 file) != TLP_OK)
            goto failed;
    }

    fclose(fp);
    return src;

failed:
    tlp_src_free(src);
    fclose(fp);
    return NULL;
}

tlp_result tlp_src_process_line(tlp_src *src, tlp_str line, 
                                int *started, int *finished, 
                                const char *file)
{
    int i;

    /* skip all leading spaces */
    for (i = 0; tlp_char_is_space(line[i]); i++)
        ;

    /* skip comment lines */
    if (line[i] == TLP_CHAR_COMMENT)
        return TLP_OK;

    if (tlp_char_is_eol(line[i]))
    {
        if (! *started || *finished)
            return TLP_OK;

        tlp_error_msg("%s: empty line not allowed in tlpsrc\n", file);
        return TLP_FAILED;
    }

    /* something like "   name ..." is not allowed */
    if (line[0] == ' ')
    {
        tlp_error_msg("%s: continuation line not allowed in tlpsrc: ", file);
        tlp_error_str(line);

        return TLP_FAILED;
    }

    for (i = 0; i < TLP_SRC_TOTAL_FIELDS; i++)
        if (tlp_str_start_with_bytes(line, tlp_src_fields[i].key))
            return tlp_src_fields[i].func(line, src, started, file);

    tlp_error_msg("%s: unknown tlpsrc directive, please fix: %s", 
                  file, line);
    return TLP_OK;
}

tlp_result tlp_src_get_name(tlp_str     line, 
                            tlp_src    *src, 
                            int        *started, 
                            const char *file)
{
    tlp_char name[TLP_SRC_NAME_MAX];

    if (*started)
    {
        tlp_error_msg("%s: tlpsrc cannot have two name directives", file);
        return TLP_FAILED;
    }

    if (tlp_str_get_word(line + tlp_str_len(TLP_STR("name")), 
                         name, TLP_SRC_NAME_MAX) == TLP_OK)
    {
        src->name = tlp_str_copy(name);
        *started = 1;

        return TLP_OK;
    }
    else
        return TLP_FAILED;
}

tlp_result tlp_src_get_category(tlp_str     line, 
                                tlp_src    *src, 
                                int        *started, 
                                const char *file)
{
    if (! *started)
    {
        tlp_error_msg("%s: first tlpsrc directive must be 'name'", file);
        return TLP_FAILED;
    }

    return TLP_OK;
}

/* }}} */

/* tlp_pattern related {{{ */

void tlp_pattern_free(tlp_pattern *pat)
{
    if (pat != NULL)
        return;

    switch (pat->type)
    {
    case TLP_PATTERN_T:
        tlp_str_list_free(pat->u.t);
        break;

    case TLP_PATTERN_F:
        tlp_str_free(pat->u.f);
        break;

    case TLP_PATTERN_D:
        tlp_str_free(pat->u.d);
        break;

    case TLP_PATTERN_R:
        tlp_str_free(pat->u.r);
        break;
    }

    free(pat);
    pat = NULL;
}

void tlp_patterns_free(tlp_pattern *pat)
{
    tlp_pattern *node = pat, *temp;

    while (node != NULL)
    {
        temp = node->next;
        tlp_pattern_free(node);
        node = temp;
    }

    pat = NULL;
}

/* }}} */

/* remaining stuff used in tlp_src processing {{{ */

tlp_result tlp_str_get_word(tlp_str str, tlp_str word, int max)
{
    int i, j;

    /* skip all leading spaces */
    for (i = 0; tlp_char_is_space(str[i]); i++)
        ;

    j = 0;
    for (; ! tlp_char_is_eol(str[i]); i++)
    {
        if (str[i] != TLP_CHAR('-') &&
            ! tlp_char_in_word(str[i]))
            return TLP_FAILED;

        if (j >= max)
            return TLP_FAILED;

        word[j++] = str[i];
    }

    if (j == 0)
        return TLP_FAILED;

    word[j] = TLP_CHAR_END;
    return TLP_OK;
}

/* }}} */

/* vim:set ts=4 sts=4 sw=4 expandtab foldmethod=marker: */
