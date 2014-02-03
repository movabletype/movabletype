# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::Minimal;

use strict;
use warnings;
use utf8;

use MT::Util qw(weaken);
use File::Basename qw(dirname);
use base qw( MT );

sub init {
    my $mt    = shift;
    my %param = @_;

    $mt->init_paths();
    $mt->init_config( \%param ) or return;
    $mt->init_query() or return;

    1;
}

sub init_query {
    my $mt = shift;

    use CGI;
    my $q = CGI->new;
    $mt->{query} = $q;

    1;
}

sub init_db {
    require MT::ObjectDriverFactory;
    if ( MT->config('ObjectDriver') ) {
        my $driver = MT::ObjectDriverFactory->instance;
        $driver->configure if $driver;
    }
    else {
        MT::ObjectDriverFactory->configure();
    }
}

sub init_config {
    my $mt = shift;
    my ($param) = @_;

    $mt->init_cfg_file(@_) or return $mt->error( $mt->errstr );

    # translate the config file's location to an absolute path, so we
    # can use that directory as a basis for calculating other relative
    # paths found in the config file.
    my $config_dir = $mt->{config_dir} = dirname( $mt->{cfg_file} );

    # store the mt_dir (home) as an absolute path; fallback to the config
    # directory if it isn't set.
    $mt->{mt_dir}
        = $param->{Directory}
        ? File::Spec->rel2abs( $param->{Directory} )
        : $mt->{config_dir};
    $mt->{mt_dir} ||= dirname($0);

    require MT::Core::Config;
    my $cfg = $mt->config;
    $cfg->define(
        {   %$MT::Core::Config::common,     %$MT::Core::Config::database,
            %$MT::Core::Config::middleware, %$MT::Core::Config::data_api,
        }
    );
    $cfg->read_config( $mt->{cfg_file} ) or return $mt->error( $cfg->errstr );

    1;
}

sub init_paths {
    my $mt = shift;
    my ($param) = @_;

    # determine MT directory
    my ($orig_dir);
    require File::Spec;
    if ( !( $MT::MT_DIR = $ENV{MT_HOME} ) ) {
        if ( $0 =~ m!(.*([/\\]))! ) {
            $orig_dir = $MT::MT_DIR = $1;
            my $slash = $2;
            $MT::MT_DIR =~ s!(?:[/\\]|^)(?:plugins[/\\].*|tools[/\\])$!$slash!;
            $MT::MT_DIR = '' if ( $MT::MT_DIR =~ m!^\.?[\\/]$! );
        }
        else {

            # MT::MT_DIR/lib/MT.pm -> MT::MT_DIR/lib -> MT::MT_DIR
            $MT::MT_DIR = dirname( dirname( File::Spec->rel2abs(__FILE__) ) );
        }
        unless ($MT::MT_DIR) {
            $orig_dir = $MT::MT_DIR = $ENV{PWD} || '.';
            $MT::MT_DIR =~ s!(?:[/\\]|^)(?:plugins[/\\].*|tools[/\\]?)$!!;
        }
        $ENV{MT_HOME} = $MT::MT_DIR;
    }
    unshift @INC, File::Spec->catdir( $MT::MT_DIR,   'extlib' );
    unshift @INC, File::Spec->catdir( $orig_dir, 'lib' )
        if $orig_dir && ( $orig_dir ne $MT::MT_DIR );

    if ( my $cfg_file = $mt->find_config($param) ) {
        $cfg_file = File::Spec->rel2abs($cfg_file);
        $MT::CFG_FILE = $cfg_file;
    }
    else {
        return $mt->trans_error(
            "Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?"
        ) if ref($mt);
    }

    # store the mt_dir (home) as an absolute path; fallback to the config
    # directory if it isn't set.
    $MT::MT_DIR ||=
        $param->{directory}
        ? File::Spec->rel2abs( $param->{directory} )
        : $MT::CFG_DIR;
    $MT::MT_DIR ||= dirname($0);

    # also make note of the active application path; this is derived by
    # checking the PWD environment variable, the dirname of $0,
    # the directory of SCRIPT_FILENAME and lastly, falls back to mt_dir
    $MT::APP_DIR = $ENV{PWD} || "";
    $MT::APP_DIR = dirname($0)
        if !$MT::APP_DIR || !File::Spec->file_name_is_absolute($MT::APP_DIR);
    $MT::APP_DIR = dirname( $ENV{SCRIPT_FILENAME} )
        if $ENV{SCRIPT_FILENAME}
        && ( !$MT::APP_DIR
        || ( !File::Spec->file_name_is_absolute($MT::APP_DIR) ) );
    $MT::APP_DIR ||= $MT::MT_DIR;
    $MT::APP_DIR = File::Spec->rel2abs($MT::APP_DIR);

    return 1;
}

sub path_info {
    shift->{query}->path_info(@_);
}

sub param {
    shift->{query}->param(@_);
}

sub get_header {
    my $app = shift;
    my ($key) = @_;
    if ( $ENV{MOD_PERL} ) {
        return $app->{apache}->header_in($key);
    }
    else {
        ( $key = uc($key) ) =~ tr/-/_/;
        return $ENV{ 'HTTP_' . $key };
    }
}

1;
__END__

=head1 NAME

MT::App::Minimal

=head1 SYNOPSIS

The I<MT::App::Minimal> module is the minimal application module fore
Movable Type.
This module has these features.

=over 4

=item * Never load any plugins.

=item * Never load any modules which are not indispensable.

=item * Load a few core config values from mt-config.cgi.

=item * Implement a few method that related CGI object.

=back

=cut
