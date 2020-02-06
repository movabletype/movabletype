package MT::Test::PHP;

use strict;
use warnings;
use Test::Requires 'IPC::Run3';
use Encode;
use File::Temp 'tempfile';

sub run {
    my ( $class, $script ) = @_;

    my ( $fh, $ini_file ) = tempfile(
        DIR    => $ENV{MT_TEST_ROOT} || '.',
        SUFFIX => '.ini',
    );
    print $fh <<'INI';
date.timezone = Asia/Tokyo;
error_reporting = E_ALL;
display_startup_errors = On;
display_errors = On;
log_errors = On;
INI
    close $fh;

    IPC::Run3::run3 [ 'php', '--php-ini', $ini_file ],
        \$script, \my $result, undef,
        { binmode_stdin => 1 } or die $?;
    $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
    Encode::decode_utf8($result);

    unlink $ini_file;

    return $result;
}

1;
