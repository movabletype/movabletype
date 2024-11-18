package MT::Test::PHP;

use strict;
use warnings;
use Test::Requires 'IPC::Run3';
use Encode;
use File::Temp 'tempfile';
use Test::More ();

my $PHPVersion;

sub php_version {
    return if $ENV{MT_TEST_SKIP_PHP};
    return $PHPVersion if defined $PHPVersion;
    my $php_version_string = `php --version 2>&1` or return $PHPVersion = 0;
    ($PHPVersion) = $php_version_string =~ /^PHP (\d+\.\d+)/im;
    return $PHPVersion = 0 unless $PHPVersion and $PHPVersion >= 5;
    if (MT->config->ObjectDriver =~ /u?mssqlserver/i) {
        my $phpinfo = `php -i 2>&1` or return $PHPVersion = 0;
        return $PHPVersion = 0 if $phpinfo =~ /\-\-without\-(?:pdo\-)?mssql/;
    }
    my $smarty_major_version = _find_smarty_version();
    if ($smarty_major_version > 3) {
        return $PHPVersion = 0 if $PHPVersion < 7.1;
    }
    if ($PHPVersion < 7.2) {
        Test::More::diag "PHP $PHPVersion is not supported";
        return $PHPVersion = 0;
    }
    $PHPVersion;
}

sub _find_smarty_version {
    open my $fh, '<', "$ENV{MT_HOME}/php/vendor/smarty/smarty/libs/Smarty.class.php";
    read($fh, my $buf, 8192) or return;
    my ($smarty_version) = $buf =~ /SMARTY_VERSION\s*=\s*'([0-9.]+)';/;
    my ($major, $minor, $patch) = split /\./, $smarty_version;
    return wantarray ? ($major, $minor, $patch) : $major;
}

sub run {
    my ( $class, $script, $stderr ) = @_;
    my $command = _make_php_command();
    IPC::Run3::run3 $command, \$script, \my $result, $stderr, { binmode_stdin => 1 } or die $?;
    $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
    Encode::decode_utf8($result);

    return $result;
}

sub supports_gd {
    my $result = shift->run('<?php phpinfo(); ?>');
    $result =~ /GD Support\s*=>\s*enabled/ ? 1 : 0;
}

sub supports_memcached {
    my $result = shift->run('<?php phpinfo(); ?>');
    $result =~ /memcache support\s*=>\s*enabled/ ? 1 : 0;
}

my ($INI_FILE, $command);

sub _make_php_command {
    return $command if $command;

    my $dir = $ENV{MT_TEST_ROOT} || '.';
    ( my $fh, $INI_FILE ) = tempfile(
        DIR    => $dir,
        SUFFIX => '.ini',
    );
    print $fh <<'INI';
date.timezone = Asia/Tokyo;
error_reporting = E_ALL;
display_startup_errors = On;
display_errors = On;
log_errors = On;
INI

    if ($ENV{MT_TEST_PHP_OPCACHE}) {
    print $fh <<'INI';
opcache.jit = On;
opcache.jit_buffer_size = 100M;
opcache.enable_cli = 1;
INI
    }

    close $fh;

    my $ini_setting = `php --ini`;
    if ($ini_setting =~ /Scan for additional .ini files in: \(none\)/) {
        $ENV{PHP_INI_SCAN_DIR} = $dir;
        $command = ['php'];
    }
    else {
        $command = ['php', '--php-ini', $INI_FILE];
    }
    return $command;
}

1;
