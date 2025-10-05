define-command -override kamp-connect -params 1.. -command-completion %{
    %arg{1} sh -c %{
        export KAKOUNE_SESSION="$1"
        export KAKOUNE_CLIENT="$2"
        shift 3

        [ $# -eq 0 ] && set "$SHELL"

        "$@"
    } -- %val{session} %val{client} %arg{@}
} -docstring 'run Kakoune command in connected context'

define-command -hidden -override kamp-init %{
    declare-option -hidden str kamp_grep_query
    declare-option -hidden str kamp_out
    declare-option -hidden str kamp_err
    evaluate-commands %sh{
        kamp_out="${TMPDIR:-/tmp}/kamp-${kak_session}.out"
        kamp_err="${TMPDIR:-/tmp}/kamp-${kak_session}.err"
        mkfifo "$kamp_out" "$kamp_err"
        printf 'set global kamp_%s %s\n' out "$kamp_out" err "$kamp_err"
    }
}

define-command -hidden -override kamp-end %{
    nop %sh{ rm -f "$kak_opt_kamp_out" "$kak_opt_kamp_err" }
}
