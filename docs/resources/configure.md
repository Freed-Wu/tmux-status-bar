# makeure

See customization in
<https://make-language-server.readthedocs.io/en/latest/api/make-language-server.html#make_language_server.server.get_document>.

## (Neo)[Vim](https://www.vim.org)

### [coc.nvim](https://github.com/neoclide/coc.nvim)

```json
{
  "languageserver": {
    "make": {
      "command": "make-language-server",
      "filetypes": [
        "make",
        "automake"
      ],
      "initializationOptions": {
        "method": "builtin"
      }
    }
  }
}
```

### [vim-lsp](https://github.com/prabirshrestha/vim-lsp)

```vim
if executable('make-language-server')
  augroup lsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'make',
          \ 'cmd': {server_info->['make-language-server']},
          \ 'whitelist': ['make', 'automake'],
          \ 'initialization_options': {
          \   'method': 'builtin',
          \ },
          \ })
  augroup END
endif
```

## [Neovim](https://neovim.io)

```lua
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "Makefile", "Makefile.*", "*.mk" },
  callback = function()
    vim.lsp.start({
      name = "make",
      cmd = { "make-language-server" }
    })
  end,
})
```

## [Emacs](https://www.gnu.org/software/emacs)

```elisp
(make-lsp-client :new-connection
(lsp-stdio-connection
  `(,(executable-find "make-language-server")))
  :activation-fn (lsp-activate-on "Makefile" "Makefile.*" "*.mk")
  :server-id "make")))
```

## [Sublime](https://www.sublimetext.com)

```json
{
  "clients": {
    "make": {
      "command": [
        "make-language-server"
      ],
      "enabled": true,
      "selector": "source.make"
    }
  }
}
```
