package MT::Test::Fluentd;

use strict;
use warnings;
use File::Temp;
use Test::More ();
use Test::TCP;
use Path::Tiny;

BEGIN {
    Test::More::plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
    eval { require Fluent::Logger; 1 }
        or Test::More::plan skip_all => "requires Fluent::Logger";
}

my @Candidates = qw(
    /usr/sbin/fluentd
    /usr/local/bin/fluentd
);

sub run {
    my $class = shift;

    my $fluentd = _find_fluentd() or Test::More::plan skip_all => "fluentd not found";

    my $root = File::Spec->catdir($ENV{MT_TEST_ROOT}, '.fluentd');
    mkdir $root unless -d $root;

    my $guard = Test::TCP->new(
        code => sub {
            my $port = shift;
            _exec_fluentd($fluentd, $port, $root);
            die "Can't execute $fluentd: $!";
        },
    );

    my $server_port = $guard->port;
    my $config_file = path($ENV{MT_CONFIG});
    my $config      = $config_file->slurp;
    $config .= "\nFluentLoggerOption host=127.0.0.1\n";
    $config .= "\nFluentLoggerOption port=$server_port\n";
    $config .= "\nFluentLoggerOption ack=1\n";
    $config_file->spew($config);

    MT->config(
        FluentLoggerOption => {
            host => '127.0.0.1',
            port => $server_port,
            ack  => 1,
        },
    );

    bless {
        guard => $guard,
        root  => $root,
        port  => $server_port,
    }, $class;
}

sub _find_fluentd {
    for my $candidate (@Candidates) {
        return $candidate if -e $candidate && -x _;
    }
}

sub _exec_fluentd {
    my ($fluentd, $port, $root) = @_;
    my $conf = _write_fluentd_config($port, $root);
    exec $fluentd, '-c', $conf, '--suppress-config-dump', ($ENV{TEST_VERBOSE} ? () : '-q');
}

sub _write_fluentd_config {
    my ($port, $root) = @_;

    my %conf = (
        'match mt.**' => {
            '@type'  => 'file',
            'path'   => $root,
            'append' => 'true',
        },
        source => {
            '@type' => 'forward',
            'port'  => $port,
        },
    );

    my $tmpfile = File::Temp->new(TMPDIR => 1, UNLINK => 1);
    __write_structured_conf($tmpfile, \%conf, 0);
    return $tmpfile;
}

sub __write_structured_conf {
    my ($fh, $conf, $indent_level) = @_;
    my $indent = "  " x ($indent_level);
    for my $key (sort keys %$conf) {
        if (ref $conf->{$key} eq 'HASH') {
            my $open  = $key;
            my $close = $key;
            $close =~ s/ .+$//;
            print $fh "\n$indent<$open>\n\n";
            __write_structured_conf($fh, $conf->{$key}, $indent_level + 1);
            print $fh "$indent</$close>\n\n";
        } else {
            print $fh "$indent$key $conf->{$key}\n";
        }
    }
}

sub logfiles {
    my $self   = shift;
    my $logdir = $self->{root};
    glob "$logdir/*";
}

sub slurp_logfiles {
    my $self   = shift;
    my $output = '';
    for my $file ($self->logfiles) {
        open my $fh, '<', $file or die "$file: $!";
        local $/;
        $output .= "$file: \n";
        $output .= <$fh> // '';
        $output .= "\n";
    }
    $output;
}

1;
