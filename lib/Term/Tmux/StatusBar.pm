package Term::Tmux::StatusBar;
use strict;
use warnings;
use base 'Term::Tmux';
use Exporter qw(import);
our @EXPORT = qw( main window_status_current_format_left
  window_status_current_format_right status_left status_right );

my $default_left_sep  = '';
my $default_right_sep = '';
my $default_format    = ' %s ';

sub change_format_sep {
    my $i = shift;
    if ( $i =~ /%s/ ) {
        $_[0] = $i;
    }
    else {
        $_[1] = $i;
    }
    return @_;
}

sub get_tokens {
    my @tokens = split( ':', $_[0] );
    $tokens[2] = sprintf $_[1], $tokens[2];
    return @tokens;
}

sub left {
    my $last_bg = shift;
    my $out     = '';
    my $sep     = $default_left_sep;
    my $format  = $default_format;
    my $fg      = '';
    my $bg      = '';
    my $text    = '';
    foreach my $i (@_) {
        if ( $i !~ /:/ ) {
            ( $format, $sep ) = change_format_sep( $i, $format, $sep );
            next;
        }
        ( $fg, $bg, $text ) = get_tokens( $i, $format );
        if ( $last_bg eq '' ) {
            $out .= "#[fg=$fg,bg=$bg]$text";
        }
        else {
            $out .= "#[fg=$last_bg,bg=$bg]$sep#[fg=$fg]$text";
        }
        $last_bg = $bg;
    }
    $out .= "#[fg=$bg,bg=#{\@background_color}]$sep";
    return $out;
}

sub window_status_current_format_left {
    return left( '#{@background_color}', @_ );
}

sub status_left {
    return left( '', @_ );
}

sub right {
    my $out    = '';
    my $sep    = $default_right_sep;
    my $format = $default_format;
    my $fg     = '';
    my $bg     = '';
    my $text   = '';
    foreach my $i (@_) {
        if ( $i !~ /:/ ) {
            ( $format, $sep ) = change_format_sep( $i, $format, $sep );
            next;
        }
        ( $fg, $bg, $text ) = get_tokens( $i, $format );
        $out = "#{?$text,#[fg=$bg]$sep#[fg=$fg,bg=$bg]$text,}";
    }
    return ( $out, $sep );
}

sub window_status_current_format_right {
    my ( $out, $sep ) = right($_);
    $out .= "#[fg=#{\@background_color}]$sep";
    return $out;
}

sub status_right {
    my ( $out, $sep ) = right($_);
    return $out;
}

sub do_interpolation {
    $_[0] =~ s/#\{status-left:(.*)\}/status_left(split(',', $1))/ge;
    $_[0] =~ s/#\{status-right:(.*)\}/status_right(split(',', $1))/ge;
    $_[0] =~
s/#\{window-status-current-format-left:(.*)\}/window_status_current_format_left(split(',', $1))/ge;
    return $_[0];
}

sub main {
    my @array =
      ( 'status-left', 'status-right', 'window-status-current-format', );
    foreach my $option (@array) {
        my $value = `tmux show-option -gqv '$option'`;
        if ($value ne '') {
            $value = do_interpolation($value);
            `tmux set-option -gq '$option' '$value'`;
        }
    }
    my $value = `tmux show -gqv \@background_color`;
    if ($value eq '') {
        `tmux set-option -gq \@background_color '#{TMUX_PEACOCK_SESSION_COLOUR}'`;
    }
}

1;

__END__

=head1 NAME

Tmux::StatusBar - change tmux status bar.

=head1 DESCRIPTION
