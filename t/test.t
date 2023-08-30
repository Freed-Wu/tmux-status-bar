use Test::More;
use Term::Tmux::StatusBar;

ok( status_right('>', 'black:white:a', ')', 'white:blue:b', ']') eq '', 'status_right' );
ok( status_right('>', 'black:white:a', ')', 'white:blue:b', ']') eq '', 'status_right' );

done_testing();
