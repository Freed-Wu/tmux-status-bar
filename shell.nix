{ pkgs ? import <nixpkgs> { } }:

with pkgs;
mkShell {
  name = "tmux-powerline-compiler";
  buildInputs = [
    flex
    bison
    xmake
  ];
}
