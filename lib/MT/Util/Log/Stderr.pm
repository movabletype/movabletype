# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::Log::Stderr;
use strict;
use warnings;
use MT;
use Encode qw(find_encoding);
use base qw(MT::Util::Log);

use constant HasANSIColor => eval {
    die unless $ENV{MT_UTIL_LOG_COLORED};
    require Win32::Console::ANSI if $^O eq 'MSWin32';
    require Term::ANSIColor;
    1;
};

sub new {
    my ( $self, $logger_level, $log_file ) = @_;

    return $self;
}

my $Encoding;

sub _find_encoding {
    my $enc;
    if ( eval { require Term::Encoding; 1 } ) {
        $enc = Term::Encoding::get_encoding() || 'utf8';
        if ( $^O eq 'MSWin32' and $enc eq 'cp0' ) {
            $enc = 'cp932';
        }
    }
    else {
        $enc = $^O eq 'MSWin32' ? 'cp932' : 'utf8';
    }
    find_encoding($enc);
}

sub _encode {
    my $msg = shift;
    $Encoding ||= _find_encoding();
    $Encoding->encode($msg);
}

sub maybe_colored {
    my ( $msg, $color ) = @_;
    $msg = _encode($msg);

    if (HasANSIColor) {
        return Term::ANSIColor::colored($msg, $color);
    }
    return $msg;
}

sub debug {
    my ( $class, $msg ) = @_;
    print STDERR maybe_colored("$msg\n", "blue");
}

sub info {
    my ( $class, $msg ) = @_;
    print STDERR maybe_colored("$msg\n", "green");
}

sub notice {
    my ( $class, $msg ) = @_;
    print STDERR maybe_colored("$msg\n", "green");
}

sub warn {
    my ( $class, $msg ) = @_;
    print STDERR maybe_colored("$msg\n", "yellow");
}

sub error {
    my ( $class, $msg ) = @_;
    print STDERR maybe_colored("$msg\n", "red");
}

1;
