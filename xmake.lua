add_rules("mode.debug", "mode.release")

target("tmux-powerline-compiler")
do
    set_kind("binary")
    add_rules("lex", "yacc")
    add_files("src/*.l", "src/*.y", "src/*.c")
    add_includedirs("src")
end
