/* tlp-config.c - module exporting configuration stuff
 *
 * Copyright 2007 Jjgod Jiang
 * Derived from the Perl implementation by Norbert Preining
 *
 * This file is licensed under the GNU General Public License version 2
 * or any later version. */

#include <tlp-utils.h>
#include <stdlib.h>

#define TLP_META_CATEGORIES     "Collection", "Scheme"
#define TLP_NORMAL_CATEGORIES   "Package", "TLCore", "Documentation"
#define TLP_DEFAULT_CATEGORY    "Package"

const char *_tlp_meta_categories[] = {
    TLP_META_CATEGORIES, 
};

const char *_tlp_normal_categories[] = {
    TLP_NORMAL_CATEGORIES,
};

const char *_tlp_categories[] = {
    TLP_META_CATEGORIES, 
    TLP_NORMAL_CATEGORIES,
};

tlp_str_list *tlp_meta_categories;
tlp_str_list *tlp_normal_categories;
tlp_str_list *tlp_categories;
tlp_str       tlp_default_category;

#define ARR_SIZE(arr)       (sizeof(arr) / sizeof(arr[0]))

/* TODO: we might have more complicated implementation later. */
tlp_result tlp_config_init()
{
    tlp_meta_categories = tlp_str_list_from_array(_tlp_meta_categories);
    if (tlp_meta_categories == NULL)
        goto failed1;

    tlp_normal_categories = tlp_str_list_from_array(_tlp_normal_categories);  
    if (tlp_normal_categories == NULL)
        goto failed2;

    tlp_categories = tlp_str_list_from_array(_tlp_categories);
    if (tlp_categories == NULL)
        goto failed3;

    tlp_default_category = tlp_str_from_bytes(TLP_DEFAULT_CATEGORY);
    if (tlp_default_category == NULL)
        goto failed4;

    return TLP_OK;

failed4:
    tlp_str_list_free(tlp_categories);
failed3:
    tlp_str_list_free(tlp_normal_categories);
failed2:
    tlp_str_list_free(tlp_meta_categories);
failed1: 
    return TLP_FAILED;
}

void tlp_config_free()
{
    tlp_str_list_free(tlp_meta_categories);
    tlp_str_list_free(tlp_normal_categories);
    tlp_str_list_free(tlp_categories);

    tlp_str_free(tlp_default_category);
}

