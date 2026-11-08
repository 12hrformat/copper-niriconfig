#!/bin/sh
# One chip per niri workspace, for waybar's custom/workspaces module.
#
# niri only lists workspaces that exist, so a short list is normal. When niri
# is not running, or the reply is not an array, nothing is printed and waybar
# hides the module rather than showing a broken chip.
#
# Markup is emitted as Pango because the module runs with escape=false; the
# focused workspace is the blue one, urgent ones are red.

set -u

msg=$(niri msg --json workspaces 2>/dev/null) || exit 1
[ -n "$msg" ] || exit 1

printf '%s\n' "$msg" | jq -r '
    if type != "array" or length == 0 then empty
    else
      sort_by(.idx)
      | map(
          if .is_urgent then
            "<span foreground=\"#f7768e\" weight=\"bold\"> \(.idx) </span>"
          elif .is_focused then
            "<span foreground=\"#7aa2f7\" weight=\"bold\"> \(.idx) </span>"
          elif .is_active then
            "<span foreground=\"#a9b1d6\"> \(.idx) </span>"
          else
            "<span foreground=\"#565f89\"> \(.idx) </span>"
          end
        )
      | join("")
    end'
