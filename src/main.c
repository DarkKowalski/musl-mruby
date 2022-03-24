#include <mruby.h>
#include <mruby/array.h>
#include <mruby/compile.h>
#include <stdlib.h>
#include <string.h>

#include "args.h"

int main(int argc, char **argv)
{
    /* Parse cmdline arguments */
    option_t opt;
    parse_arg(argc, argv, &opt);
    if (!opt.execute)
    {
        return 0;
    }

    /* Initialize Ruby runtime */
    mrb_state *mrb = mrb_open();
    if (!mrb)
    {
        fprintf(stderr, "Could not initialize Musl MRuby runtime. Abort.\n");
        exit(-1);
    }

    /* Define ARGV */
    mrb_value ARGV = mrb_ary_new_capa(mrb, argc);
    for (int i = 2; i < argc; i++)
    {
        mrb_ary_push(mrb, ARGV, mrb_str_new(mrb, argv[i], strlen(argv[i])));
    }
    mrb_define_global_const(mrb, "ARGV", ARGV);

    /* Load script file */
    FILE *fp =
        fopen(argv[1], "r+"); /* read & update fails on opening directories */
    if (!fp)
    {
        fprintf(stderr, "Failed to open file %s. Abort.\n", argv[1]);
        mrb_close(mrb);
        exit(-1);
    }
    mrb_load_file(mrb, fp);
    fclose(fp);

    /* Runtime error */
    if (mrb->exc)
    {
        mrb_print_error(mrb);
        mrb_close(mrb);
        exit(-1);
    }

    /* Clean up */
    mrb_close(mrb);

    return 0;
}
