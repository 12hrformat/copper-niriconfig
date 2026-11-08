#!/bin/sh
# The focused window's title, for waybar's custom/window module.
#
# niri answers null when nothing is focused (an empty workspace, or right after
# a window closes). That is not an error: print nothing and let waybar hide the
# module instead of drawing the word "null".

set -u

msg=$(niri msg --json focused-window 2>/dev/null) || exit 1
[ -n "$msg" ] || exit 1

printf '%s\n' "$msg" | jq -r '
    if . == null then "" else (.title // .app_id // "") end'
