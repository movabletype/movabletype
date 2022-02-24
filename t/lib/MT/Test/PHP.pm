package MT::Test::PHP;

use strict;
use warnings;
use Test::Requires 'IPC::Run3';
use Encode;
use File::Temp 'tempfile';

sub run {
    my ( $class, $script, $stderr ) = @_;

    my $dir = $ENV{MT_TEST_ROOT} || '.';

    my ( $fh, $ini_file ) = tempfile(
        DIR    => $dir,
        SUFFIX => '.ini',
    );
    print $fh <<'INI';
date.timezone = Asia/Tokyo;
error_reporting = E_ALL;
display_startup_errors = On;
display_errors = On;
log_errors = On;
opcache.jit = On;
opcache.jit_buffer_size = 100M;
INI
    close $fh;

    my @args;
    my $ini_setting = `php --ini`;
    if ($ini_setting =~ /Scan for additional .ini files in: \(none\)/) {
        $ENV{PHP_INI_SCAN_DIR} = $dir;
        @args = ();
    }
    else {
        @args = ( '--php-ini', $ini_file );
    }


    IPC::Run3::run3 [ 'php', @args ], \$script, \my $result, $stderr, { binmode_stdin => 1 } or die $?;
    $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
    Encode::decode_utf8($result);

    unlink $ini_file;

    return $result;
}

1;
