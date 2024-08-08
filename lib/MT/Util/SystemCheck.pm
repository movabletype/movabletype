# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::SystemCheck;

use strict;
use warnings;

sub check_all {
    my ($class, $param) = @_;

    $class->check_mt($param);
    $class->check_perl($param);
    $class->check_memcached($param);
    $class->check_server_model($param);
    $class->check_dependencies($param);

    $param;
}

sub check_mt {
    my ($class, $param) = @_;
    require MT;
    $param->{version}                   = MT->version_id;
    $param->{mt_home}                   = $ENV{MT_HOME};
    $param->{os}                        = $^O;
    $param->{current_working_directory} = _mt_getcwd();

    $param;
}

sub _mt_getcwd {
    require Cwd;
    my $cwd = '';
    my ($bad);
    local $SIG{__WARN__} = sub { $bad++ };
    eval { $cwd = Cwd::getcwd() };
    if ($bad || $@) {
        eval { $cwd = Cwd::cwd() };
        my $permitted_error = 'Insecure ' . $ENV{PATH};
        if ($@ && $@ !~ /$permitted_error/) {
            die $@;
        }
    }
    $cwd;
}

sub check_perl {
    my ($class, $param) = @_;
    $param->{perl_is_too_old} = 1 if $] < 5.016003;
    $param->{perl_version}    = sprintf('%vd', $^V);

    my %seen;
    $param->{perl_include_path} = [grep { !$seen{$_}++ } @INC];

    $param;
}

sub check_memcached {
    my ($class, $param) = @_;
    require MT::Memcached;
    if (MT::Memcached->is_available) {
        $param->{memcached_enabled} = 1;
        my $inst = MT::Memcached->instance;
        my $key  = 'syscheck-' . $$;
        $inst->add($key, $$);
        if ($inst->get($key) == $$) {
            $inst->delete($key);
            $param->{memcached_active} = 1;
        }
    }
    $param;
}

sub check_server_model {
    my ($class, $param) = @_;

    $param->{server_model} =
          $ENV{'psgi.version'} ? 'PSGI'
        : $ENV{FAST_CGI}       ? 'FastCGI'
        : $ENV{MOD_PERL}       ? 'mod_perl'
        :                        'CGI';

    $param->{web_server} = $ENV{SERVER_SOFTWARE};

    if ($param->{server_model} ne 'PSGI') {
        ## Try to create a new file in the current working directory. This
        ## isn't a perfect test for running under cgiwrap/suexec, but it
        ## is a pretty good test.
        my $tmp = "test$$.tmp";
        if (open(my $fh, ">", $tmp)) {
            close $fh;
            unlink($tmp);
            $param->{is_cgiwrap_or_suexec} = 1;
        }
    }

    $param;
}

sub check_dependencies {
    my ($class, $param) = @_;

    my @keys = qw(req data opt);
    my %deps = map { $_ => [] } @keys;

    my $wizard = MT->instance->registry->{applications}{wizard} || {};
    my $req    = $wizard->{required_packages}         || {};
    my $dbi;
    for my $module (keys %$req) {
        next if $module eq 'plugin';
        my $conf = $req->{$module};
        if ($module eq 'DBI') {
            $dbi = [$module, $conf->{version} || 0, 1, $conf->{label}];
        } else {
            push @{ $deps{req} }, [$module, $conf->{version} || 0, 1, $conf->{label}];
        }
    }
    my $drivers = MT->registry('object_drivers') || {};
    for my $key (keys %$drivers) {
        my $driver = $drivers->{$key};
        my $label  = $driver->{label};
        push @{ $deps{data} }, [
            $driver->{dbd_package},
            $driver->{dbd_version} || 0,
            0,
            MT->translate("The [_1] database driver is required to use [_2].", $driver->{dbd_package}, $label),
        ];
    }
    unshift @{ $deps{data} }, $dbi;
    my $opt = $wizard->{optional_packages} || {};
    for my $module (keys %$opt) {
        next if $module eq 'plugin';
        my $conf = $opt->{$module};
        push @{ $deps{opt} }, [$module, $conf->{version} || 0, 0, $conf->{label}];
    }

    require MT::Util::Dependencies;
    my %core_deps;
    @core_deps{@keys} = MT::Util::Dependencies->requirements_for_check(MT->instance);

    my $i = 0;
    for my $key (@keys) {
        my @merged = grep defined, (@{ $deps{$key} }, @{ $core_deps{$key} });

        my %seen;
        my @sorted = grep { !$seen{ $_->[0] }++ } sort { $a->[0] cmp $b->[0] or $b->[1] <=> $a->[1] } @merged;

        if ($key eq 'data') {
            my @tmp;
            for my $list (@sorted) {
                if ($list->[0] eq 'DBI') {
                    unshift @tmp, $list;
                } else {
                    push @tmp, $list;
                }
            }
            @sorted = @tmp;
        }

        my %imglib = MT::Util::Dependencies->check_imglib();

        my (@modified, @missing);
        for my $list (@sorted) {
            my %hash = (
                id          => $i++,
                module      => $list->[0],
                version     => $list->[1],
                required    => $list->[2],
                description => $list->[3],
            );
            my $module = $hash{module};
            eval("use $module" . ($hash{version} ? " $hash{version} ();" : "();"));
            if ($@) {
                $hash{exception} = $@;
                push @missing, \%hash;
            } else {
                $hash{installed_version} = $module->VERSION || MT->translate('unknown');
                if ($module eq 'DBI') {
                    $param->{dbi_is_okay} = 1;
                } elsif ($key eq 'data' && !$param->{dbi_is_okay}) {
                    $hash{warning} = MT->translate("The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.", $module);
                } elsif ($module eq 'DBD::mysql') {
                    if ($hash{installed_version} == 3.0000) {
                        $hash{warning} = MT->translate("The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.");
                    }
                } elsif ($module eq 'Image::Magick') {
                    my $formats = join ", ", map { $imglib{$_} ? "<strong>$_</strong>" : $_ } sort Image::Magick->QueryFormat;
                    $hash{extra_html} = MT->translate("Supported format: [_1]", $formats);
                } elsif ($module eq 'Graphics::Magick') {
                    my $formats = join ", ", map { $imglib{$_} ? "<strong>$_</strong>" : $_ } sort Graphics::Magick->QueryFormat;
                    $hash{extra_html} = MT->translate("Supported format: [_1]", $formats);
                } elsif ($module eq 'Imager') {
                    eval { require Imager::File::WEBP; };
                    my $formats = join ", ", map { $imglib{$_} ? "<strong>$_</strong>" : $_ } sort Imager->read_types;
                    $hash{extra_html} = MT->translate("Supported format: [_1]", $formats);
                }
                push @modified, \%hash;
            }
        }

        $param->{$key} = \@modified;
        $param->{"missing_$key"} = \@missing;
    }
    $param->{lacks_core_modules} = MT::Util::Dependencies->lacks_core_modules;

    $param;
}

1;
