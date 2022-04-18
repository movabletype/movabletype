package MT::Test::Memcached;

use strict;
use warnings;
use Test::More;
use Test::Memcached;

BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
}

sub new {
    my ( $class, $memcached_options ) = @_;

    $memcached_options //= {};
    $memcached_options->{user} //= 'root';

    my $memd = Test::Memcached->new(options => $memcached_options);
    $memd->start;

    bless { server => $memd }, $class;
}

sub address {
    my $self = shift;
    return '127.0.0.1:'. $self->{server}->option('tcp_port');
}

sub stop {
    my $self = shift;
    $self->{server}->stop;
    1
}

1;
