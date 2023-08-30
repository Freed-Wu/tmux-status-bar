# tmux-status-bar

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/Freed-Wu/tmux-status-bar/main.svg)](https://results.pre-commit.ci/latest/github/Freed-Wu/tmux-status-bar/main)

[![github/downloads](https://shields.io/github/downloads/Freed-Wu/tmux-status-bar/total)](https://github.com/Freed-Wu/tmux-status-bar/releases)
[![github/downloads/latest](https://shields.io/github/downloads/Freed-Wu/tmux-status-bar/latest/total)](https://github.com/Freed-Wu/tmux-status-bar/releases/latest)
[![github/issues](https://shields.io/github/issues/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/issues)
[![github/issues-closed](https://shields.io/github/issues-closed/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/issues?q=is%3Aissue+is%3Aclosed)
[![github/issues-pr](https://shields.io/github/issues-pr/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/pulls)
[![github/issues-pr-closed](https://shields.io/github/issues-pr-closed/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/pulls?q=is%3Apr+is%3Aclosed)
[![github/discussions](https://shields.io/github/discussions/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/discussions)
[![github/milestones](https://shields.io/github/milestones/all/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/milestones)
[![github/forks](https://shields.io/github/forks/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/network/members)
[![github/stars](https://shields.io/github/stars/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/stargazers)
[![github/watchers](https://shields.io/github/watchers/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/watchers)
[![github/contributors](https://shields.io/github/contributors/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/graphs/contributors)
[![github/commit-activity](https://shields.io/github/commit-activity/w/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/graphs/commit-activity)
[![github/last-commit](https://shields.io/github/last-commit/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/commits)
[![github/release-date](https://shields.io/github/release-date/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/releases/latest)

[![github/license](https://shields.io/github/license/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar/blob/main/LICENSE)
[![github/languages](https://shields.io/github/languages/count/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar)
[![github/languages/top](https://shields.io/github/languages/top/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar)
[![github/directory-file-count](https://shields.io/github/directory-file-count/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar)
[![github/code-size](https://shields.io/github/languages/code-size/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar)
[![github/repo-size](https://shields.io/github/repo-size/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar)
[![github/v](https://shields.io/github/v/release/Freed-Wu/tmux-status-bar)](https://github.com/Freed-Wu/tmux-status-bar)

[![cpan/v](https://img.shields.io/cpan/v/tmux-status-bar)](https://metacpan.org/pod/Tmux::StatusBar::README)

A tmux plugin to customize tmux status bar. The biggest difference between
other similar plugins is it provides some functions to
`~/.config/tmux/tmux.conf` and make it possible to cooperate with other tmux
plugin, which let users to control tmux by a more "tmux" method.

## Similar Projects

- [powerline](https://github.com/powerline/powerline): use
  `~/.config/powerline/config.json` to configure
- [tmux-powerline](https://github.com/erikw/tmux-powerline): use
  `.tmux-powerlinerc`, which is a bash script, to configure
- There are many [tmux themes](https://github.com/rothgar/awesome-tmux#themes),
  which provide some variables to allow user to customize separators, colors and
  some less attributions on `~/.config/tmux/tmux.conf` by tmux script.
- [Oh My Tmux!](https://github.com/gpakosz/.tmux): it is not a tmux plugin, it
  is a tmux configuration, which contains some variables to configure tmux status
  bar like tmux themes. It is too large and perhaps separate some functions of
  its code to many different tmux plugins can be better.

## Usage

`~/.config/tmux/tmux.conf`:

```tmux
# [XXX] can be ignored
set -g @background_color XXX
set -g status-left "#{status-left:[[format,][fg_color:bg_color:text,][sep],]...}"
set -g status-right "#{status-right:[[format,][sep,][fg_color:bg_color:text],]...}"
set -g window-status-current-format "#{window-status-current-format-left:[[format,][sep,][fg_color:bg_color:text],][sep]}"
```

## Dependencies

## Install

### [tpm](https://github.com/tmux-plugins/tpm)

```tmux
set -g @plugin Freed-Wu/tmux-status-bar
run ~/.config/tmux/plugins/tpm/tpm
```

### [CPAN]()

```sh
cpan tmux-status-bar
```

```tmux
run-shell tmux-status-bar
```
