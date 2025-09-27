# Gruvdark colorscheme for Kakoune
# Based on provided palette

# Palette options
declare-option str fg 'rgb:d6cfc4'
declare-option str fg_light 'rgb:e6e3de'
declare-option str blue 'rgb:579dd4'
declare-option str blue_dark 'rgb:2a404f'
declare-option str red 'rgb:e16464'
declare-option str red_dark 'rgb:b55353'
declare-option str green 'rgb:72ba62'
declare-option str green_dark 'rgb:4d8a4d'
declare-option str pink 'rgb:d159b6'
declare-option str purple 'rgb:9266da'
declare-option str aqua 'rgb:00a596'
declare-option str orange 'rgb:d19f66'
declare-option str orange_dark 'rgb:a9743a'
declare-option str grey 'rgb:575757'
declare-option str grey_light 'rgb:9d9a94'

# Background ramp
declare-option str bg0 'rgb:191919' # Darkest bg for menus only
declare-option str bg1 'rgb:1e1e1e' # Primary bg
declare-option str bg2 'rgb:232323'
declare-option str bg3 'rgb:252525'
declare-option str bg4 'rgb:303030'
declare-option str bg5 'rgb:323232'
declare-option str bg6 'rgb:373737'
declare-option str bg7 'rgb:3c3c3c'

# Extras
declare-option str line_nr 'rgb:545454'
declare-option str cursor_line 'rgb:232323'
declare-option str diff_add 'rgb:31392b'
declare-option str diff_delete 'rgb:382b2c'
declare-option str diff_change 'rgb:1c3448'
declare-option str diff_text 'rgb:2c5372'
declare-option str cursor_line_normal 'rgba:579dd41c'
declare-option str cursor_line_insert 'rgba:72ba621c'
declare-option str cursor_line_prompt 'rgba:d19f661c'

# Builtin faces
set-face global Default            "%opt{fg},%opt{bg1}"
set-face global PrimarySelection   ",%opt{blue_dark}"
set-face global SecondarySelection ",%opt{blue_dark}"
set-face global PrimaryCursor      "%opt{bg1},%opt{blue}"
set-face global SecondaryCursor    "%opt{bg1},%opt{blue_dark}"
set-face global PrimaryCursorEol   "%opt{bg1},%opt{blue}"
set-face global SecondaryCursorEol "%opt{bg1},%opt{blue_dark}"
set-face global LineNumbers        "%opt{line_nr},%opt{bg1}"
set-face global LineNumberCursor   "%opt{blue},%opt{bg1}+b"
set-face global LineNumbersWrapped "%opt{bg5},%opt{bg1}+i"
set-face global StatusLine         "%opt{fg_light},%opt{bg4}"
set-face global StatusLineMode     "%opt{bg1},%opt{blue}"
set-face global StatusLineInfo     "%opt{fg_light},%opt{bg4}"
set-face global StatusLineValue    "%opt{fg_light},%opt{bg4}"
set-face global StatusCursor       "%opt{bg1},%opt{blue}"
set-face global Prompt             "%opt{fg_light},%opt{bg4}"
set-face global Error              "%opt{red},%opt{bg1}"
set-face global MatchingChar       "%opt{blue},%opt{bg1}"
set-face global Whitespace         "%opt{grey_light},%opt{bg1}+f"
set-face global WrapMarker         Whitespace
set-face global BufferPadding      "%opt{bg1},%opt{bg1}"
set-face global MenuForeground     "%opt{fg_light},%opt{blue_dark}+b"
set-face global MenuBackground     "%opt{fg_light},%opt{bg0}"
set-face global Information        "%opt{fg_light},%opt{bg3}"

# Code faces
set-face global value      "%opt{fg_light}"
set-face global type       "%opt{blue}"
set-face global variable   "%opt{fg}"
set-face global keyword    "%opt{purple}"
set-face global module     "%opt{orange}"
set-face global function   "%opt{blue}"
set-face global string     "%opt{green}"
set-face global builtin    "%opt{red}"
set-face global constant   "%opt{pink}"
set-face global comment    "%opt{grey_light}"
set-face global documentation comment
set-face global meta       "%opt{orange}"
set-face global operator   "%opt{aqua}"
set-face global attribute  "%opt{green}"
set-face global comma      "%opt{fg}"
set-face global bracket    "%opt{grey}"

# Tree-sitter highlighters
set-face global ts_attribute                    "%opt{green}"
set-face global ts_comment                      "%opt{grey_light}+i"
set-face global ts_comment_unused               "%opt{grey_light}+is"
set-face global ts_conceal                      "%opt{red}+i"
set-face global ts_constant                     "%opt{pink}"
set-face global ts_constant_builtin_boolean     "%opt{blue}"
set-face global ts_constant_character           "%opt{green}+b"
set-face global ts_constant_macro               "%opt{blue}"
set-face global ts_constructor                  "%opt{fg_light}"
set-face global ts_diff_plus                    "%opt{grey}"
set-face global ts_diff_minus                   "%opt{red}"
set-face global ts_diff_delta                   "%opt{orange}"
set-face global ts_diff_delta_moved             ts_diff_delta
set-face global ts_error                        "%opt{red}"
set-face global ts_function                     "%opt{blue}+b"
set-face global ts_function_builtin             "%opt{blue}+bi"
set-face global ts_function_macro               "%opt{red}"
set-face global ts_hint                         "%opt{grey_light}"
set-face global ts_info                         "%opt{fg_light}"
set-face global ts_keyword                      "%opt{purple}"
set-face global ts_keyword_conditional          "%opt{purple}"
set-face global ts_keyword_control_conditional  "%opt{purple}"
set-face global ts_keyword_control_directive    "%opt{purple}+i"
set-face global ts_keyword_control_import       "%opt{purple}"
set-face global ts_keyword_directive            "%opt{purple}+i"
set-face global ts_keyword_storage              "%opt{purple}"
set-face global ts_keyword_storage_modifier     "%opt{purple}+i"
set-face global ts_keyword_storage_modifier_mut "%opt{purple}+i"
set-face global ts_keyword_storage_modifier_ref "%opt{purple}+i"
set-face global ts_label                        "%opt{purple}"
set-face global ts_markup_bold                  "+b"
set-face global ts_markup_heading               "%opt{orange}+b"
set-face global ts_markup_italic                "+i"
set-face global ts_markup_list_checked          "%opt{green}"
set-face global ts_markup_list_numbered         "%opt{green}"
set-face global ts_markup_list_unchecked        "%opt{green}"
set-face global ts_markup_list_unnumbered       "%opt{green}"
set-face global ts_markup_link_label            "%opt{red}"
set-face global ts_markup_link_url              "%opt{aqua}+iu"
set-face global ts_markup_link_uri              "%opt{aqua}+iu"
set-face global ts_markup_link_text             "%opt{aqua}"
set-face global ts_markup_quote                 "+i"
set-face global ts_markup_raw_block             "%opt{fg_light}"
set-face global ts_markup_raw_inline            "%opt{green},%opt{bg1}"
set-face global ts_markup_strikethrough         "+s"
set-face global ts_namespace                    "%opt{orange}+b"
set-face global ts_operator                     "%opt{aqua}"
set-face global ts_property                     "%opt{fg_light}"
set-face global ts_punctuation                  "%opt{fg}"
set-face global ts_punctuation_special          "%opt{orange}"
set-face global ts_special                      "%opt{orange}"
set-face global ts_spell                        ",,%opt{grey}+c"
set-face global ts_string                       "%opt{green}"
set-face global ts_string_regex                 "%opt{orange}"
set-face global ts_string_regexp                "%opt{orange}"
set-face global ts_string_escape                "%opt{fg_light}"
set-face global ts_string_special               "%opt{fg_light}"
set-face global ts_string_special_path          "%opt{green}+b"
set-face global ts_string_special_symbol        "%opt{orange}"
set-face global ts_string_symbol                "%opt{orange}"
set-face global ts_tag                          "%opt{orange}+i"
set-face global ts_tag_error                    "%opt{red}+i"
set-face global ts_text                         "%opt{fg}"
set-face global ts_text_title                   "%opt{orange}+b"
set-face global ts_type                         "%opt{blue}"
set-face global ts_type_enum_variant            "%opt{orange}"
set-face global ts_type_enum_variant_builtin    "%opt{orange}"
set-face global ts_variable                     "%opt{fg}"
set-face global ts_variable_builtin             "%opt{blue}"
set-face global ts_variable_other_member        "%opt{fg_light}"
set-face global ts_variable_parameter           "%opt{fg_light}+i"
set-face global ts_warning                      "%opt{orange}"

# Helix capture groups
set-face global ts_punctuation_delimiter        "%opt{orange}"
set-face global ts_punctuation_bracket          "%opt{grey}"
set-face global ts_type_builtin                 "%opt{blue}"
set-face global ts_type_parameter               "%opt{orange}"
set-face global ts_constant_builtin             "%opt{blue}"
set-face global ts_constant_character_escape    "%opt{fg_light}"
set-face global ts_constant_numeric             "%opt{blue}"
set-face global ts_string_special_url           "%opt{aqua}+b"
set-face global ts_comment_block_documentation  "%opt{grey_light}+i"
set-face global ts_keyword_operator             "%opt{aqua}"
set-face global ts_markup_list                  "%opt{green}"

# Kak-lsp highlighters
set-face global InlayHint                       "%opt{grey_light},%opt{bg1}+i"
set-face global parameter                       "@ts_variable_parameter"
set-face global enum                            "@ts_type_enum_variant"
set-face global InlayDiagnosticError            Error
set-face global InlayDiagnosticWarning          "%opt{orange}"
set-face global InlayDiagnosticInfo             "%opt{fg_light}"
set-face global InlayDiagnosticHint             "%opt{grey_light}"
set-face global LineFlagError                   "%opt{red}"
set-face global LineFlagWarning                 "%opt{orange}"
set-face global LineFlagInfo                    "%opt{fg_light}"
set-face global LineFlagHint                    "%opt{grey_light}"
set-face global DiagnosticError                 ",,%opt{red}+c"
set-face global DiagnosticWarning               ",,%opt{orange}+c"
set-face global DiagnosticInfo                  ",,%opt{fg_light}+c"
set-face global DiagnosticHint                  ",,%opt{grey_light}+c"

# Additional UI faces
set-face global InlineInformation               "%opt{grey_light}+i"
set-face global InfoDefault                     Information
set-face global InfoBlock                       block
set-face global InfoBlockQuote                  block
set-face global InfoBullet                      bullet
set-face global InfoHeader                      header
set-face global InfoLink                        link
set-face global InfoLinkMono                    header
set-face global InfoMono                        mono
set-face global InfoRule                        comment
set-face global InfoDiagnosticError             InlayDiagnosticError
set-face global InfoDiagnosticHint              InlayDiagnosticHint
set-face global InfoDiagnosticInformation       InlayDiagnosticInfo
set-face global InfoDiagnosticWarning           InlayDiagnosticWarning

# Markup faces
set-face global title      "%opt{orange}"
set-face global header     "%opt{fg_light}"
set-face global bold       "%opt{fg_light}+b"
set-face global italic     "%opt{fg_light}+i"
set-face global mono       "%opt{green}"
set-face global block      "%opt{blue}"
set-face global link       "%opt{aqua}"
set-face global bullet     "%opt{green}"
set-face global list       "%opt{fg}"

# Diff faces
set-face global DiffAdded      "%opt{green},%opt{diff_add}"
set-face global DiffRemoved    "%opt{red},%opt{diff_delete}"
set-face global DiffChanged    "%opt{blue},%opt{diff_change}"
set-face global DiffModified   "%opt{fg},%opt{diff_text}"

# Search highlighting
set-face global Search       "%opt{bg1},%opt{orange}"
set-face global IncSearch    "%opt{bg1},%opt{blue}"

# Mode-aware statusline segments
declare-option str gruv_statusline_normal '{%opt{bg1},%opt{blue}+b}  NORMAL  {%opt{fg_light},%opt{bg4}} %val{cursor_line}:%val{cursor_char_column}  %val{bufname}  {%opt{fg_light},%opt{bg4}+bi}kak  '
declare-option str gruv_statusline_insert '{%opt{bg1},%opt{green}+b}  INSERT  {%opt{fg_light},%opt{bg4}} %val{cursor_line}:%val{cursor_char_column}  %val{bufname}  {%opt{fg_light},%opt{bg4}+bi}kak  '
declare-option str gruv_statusline_prompt '{%opt{bg1},%opt{orange}+b}  COMMAND  {%opt{fg_light},%opt{bg4}} %val{cursor_line}:%val{cursor_char_column}  %val{bufname}  {%opt{fg_light},%opt{bg4}+bi}kak  '

define-command -hidden gruvdark-apply-normal %{
  set-face global PrimaryCursor      "%opt{bg1},%opt{blue}"
  set-face global PrimaryCursorEol   "%opt{bg1},%opt{blue}"
  set-face global SecondaryCursor    "%opt{bg1},%opt{blue_dark}"
  set-face global SecondaryCursorEol "%opt{bg1},%opt{blue_dark}"
  set-face global StatusCursor       "%opt{bg1},%opt{blue}"
  set-face global LineNumberCursor   "%opt{blue},%opt{bg1}+b"
  set-face global crosshairs_line    "default,%opt{cursor_line_normal}"
  set-face global StatusLineMode     "%opt{bg1},%opt{blue}"
  set-face global Prompt             "%opt{fg_light},%opt{bg4}"
  set-option global modelinefmt "%opt{gruv_statusline_normal}"
}

define-command -hidden gruvdark-apply-insert %{
  set-face global PrimaryCursor      "%opt{bg1},%opt{green}"
  set-face global PrimaryCursorEol   "%opt{bg1},%opt{green}"
  set-face global SecondaryCursor    "%opt{bg1},%opt{green_dark}"
  set-face global SecondaryCursorEol "%opt{bg1},%opt{green_dark}"
  set-face global StatusCursor       "%opt{bg1},%opt{green}"
  set-face global LineNumberCursor   "%opt{green},%opt{bg1}+b"
  set-face global crosshairs_line    "default,%opt{cursor_line_insert}"
  set-face global StatusLineMode     "%opt{bg1},%opt{green}"
  set-face global Prompt             "%opt{fg_light},%opt{bg4}"
  set-option global modelinefmt "%opt{gruv_statusline_insert}"
}

define-command -hidden gruvdark-apply-prompt %{
  set-face global PrimaryCursor      "%opt{bg1},%opt{orange}"
  set-face global PrimaryCursorEol   "%opt{bg1},%opt{orange}"
  set-face global SecondaryCursor    "%opt{bg1},%opt{orange_dark}"
  set-face global SecondaryCursorEol "%opt{bg1},%opt{orange_dark}"
  set-face global StatusCursor       "%opt{bg1},%opt{orange}"
  set-face global LineNumberCursor   "%opt{orange},%opt{bg1}+b"
  set-face global crosshairs_line    "default,%opt{cursor_line_prompt}"
  set-face global StatusLineMode     "%opt{bg1},%opt{orange}"
  set-face global Prompt             "%opt{bg1},%opt{orange}+b"
  set-option global modelinefmt "%opt{gruv_statusline_prompt}"
}

remove-hooks global gruvdark-mode
hook -group gruvdark-mode global ModeChange (push|pop):.*insert %{ gruvdark-apply-insert }
hook -group gruvdark-mode global ModeChange (push|pop):insert:.* %{ gruvdark-apply-normal }
hook -group gruvdark-mode global ModeChange (push|pop):.*prompt %{ gruvdark-apply-prompt }
hook -group gruvdark-mode global ModeChange (push|pop):prompt.* %{ gruvdark-apply-normal }
hook -group gruvdark-mode global KakBegin .* %{ gruvdark-apply-normal }
