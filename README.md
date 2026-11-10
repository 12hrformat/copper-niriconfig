# Copper niri configuration

The niri session configuration for [Copper Linux](https://github.com/12hrformat/copperlinux).

The image build fetches this repository at a pinned commit, checks the tarball
against a sha256, and unpacks `dotfiles/` into `/usr/share/copper/niri-skel`.
`startniri` seeds that tree into a user's home the first time they start the
session, and fills in any missing file on later starts. Nothing here is called
during boot: it is data for the compositor.

## Contents

```
dotfiles/.config/niri/config.kdl          the session: input, layout, spawns, binds
dotfiles/.config/waybar/config.jsonc      the bar
dotfiles/.config/waybar/style.css         the bar's colours
dotfiles/.config/waybar/scripts/           niri IPC helpers for the bar
wallpapers/final.png                      the default wallpaper artwork
```

`wallpapers/` is outside `dotfiles/`, so the build does not unpack it into a
home. The session's `swaybg` spawn points at
`/usr/share/copper/wallpapers/copper-default.png` in the Copper Linux tree,
which carries these bytes; this copy is where the artwork itself is kept.

`workspaces.sh` and `window.sh` talk to niri over its IPC socket
(`$XDG_RUNTIME_DIR/niri.sock`). They use `niri msg --json` and `jq`, both of
which the image ships. The bar is intentionally built from `custom` modules:
noble's waybar 0.9.24 predates niri's own modules, and installing a second,
newer copy of waybar would drag in a second GTK stack.

## Editing

- **KDL, not INI.** `/‑` comments out the node that follows. `//` is a line
  comment.
- **LF only.** The image has no editor to repair CRLF, and a `\r` in a KDL file
  or a bar script is a parse error or a broken shebang. `.gitattributes` pins it.
- **The user's copy wins.** Seeding never overwrites a file that already exists.
  To ship a change to an existing home, change the file name or tell the user to
  delete theirs; editing the skeleton only affects fresh homes.

## Pinning

`iso/build.sh` in the Copper Linux repository carries three constants:
`NIRI_CFG_SHA`, `NIRI_CFG_URL`, and `NIRI_CFG_SHA256`. Bump the commit, download
the codeload tarball, and update the hash in the same change. A mismatch stops
the build rather than shipping a configuration nobody reviewed.
