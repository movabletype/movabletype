# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::Wizard;

use strict;
use base qw( MT::App );

use MT::Util qw( trim browser_language );

sub id {'wizard'}

sub init {
    my $app   = shift;
    my %param = @_;
    $app->init_core();
    my $cfg = $app->config;
    $cfg->define( $app->component('core')->registry('config_settings') );
    $app->init_core_registry();
    $cfg->UsePlugins(0);
    $app->SUPER::init(@_);
    $app->{mt_dir} ||= $ENV{MT_HOME} || $param{Directory};
    $app->{is_admin}             = 1;
    $app->{plugin_template_path} = '';
    $app->add_methods(
        pre_start => \&pre_start,
        run_step  => \&run_step,
    );
    $app->{template_dir} = 'wizard';
    $app->config->set( 'StaticWebPath', $app->static_path );
    return $app;
}

sub init_request {
    my $app = shift;

    $app->{default_mode} = 'pre_start';

    # prevents init_request from trying to process the configuration file.
    $app->SUPER::init_request(@_);
    $app->set_no_cache;
    $app->{requires_login} = 0;

    my $default_lang = $app->param('default_language') || browser_language();
    $app->set_language($default_lang);
    $app->init_lang_defaults();

    my $mode = $app->mode;
    return
           unless $mode eq 'previous_step'
        || $mode eq 'next_step'
        || $mode eq 'retry'
        || $mode eq 'test';

    my $step = $app->param('step') || '';

    my $prev_step = 'pre_start';
    my $new_step  = '';

    if ( $mode eq 'retry' ) {
        $new_step = $step;
        $app->delete_param('test') if $app->param('test');
    }
    elsif ( $mode eq 'test' ) {
        $new_step = $step;
    }
    else {
        my $steps = $app->wizard_steps;
        foreach my $s (@$steps) {
            if ( $mode eq 'next_step' ) {
                if ( $prev_step eq $step ) {
                    $new_step = $s->{key};
                    $app->param( 'save', 1 )
                        if $app->request_method eq 'POST';
                    last;
                }
            }
            elsif ( $mode eq 'previous_step' ) {
                if ( $s->{key} eq $step ) {
                    $new_step = $prev_step if $prev_step;
                    last;
                }
            }
            $prev_step = $s->{key};
        }
        $app->delete_param('test') if $app->param('test');
    }

    # If mt-check.cgi exists, redirect to errro screen
    my $cfg_exists = $app->is_config_exists();
    if ( $cfg_exists && lc $step ne 'seed' && lc $mode ne 'retry' ) {
        my %param;
        $param{cfg_exists} = 1;
        $app->mode('pre_start');
        return $app->build_page( "start.tmpl", \%param );
    }

    $app->param( 'next_step', $new_step );
    $app->mode('run_step');
}

sub init_core_registry {
    my $app  = shift;
    my $core = $app->component("core");
    $core->{registry}{applications}{wizard} = {
        wizard_steps => {
            start => {
                order   => 0,
                handler => \&start,
                params  => [
                    qw(set_static_uri_to set_static_file_to default_language)
                ],
            },
            configure => {
                order   => 100,
                handler => \&configure,
                params  => [
                    qw(dbpath dbname dbport dbserver dbsocket
                        dbtype dbuser dbpass odbcdriver publish_charset)
                ]
            },
            optional => {
                order   => 200,
                handler => \&optional,
                params  => [
                    qw(mail_transfer sendmail_path smtp_server
                        test_mail_address email_address_main
                        smtp_port smtp_auth smtp_auth_username
                        smtp_auth_password smtp_ssl )
                ],
            },
            cfg_dir => {
                order     => 300,
                handler   => \&cfg_dir,
                params    => ['temp_dir'],
                condition => \&cfg_dir_conditions,
            },
            seed => {
                order   => 10000,
                handler => \&seed,
            },
        },
        optional_packages => {
            'Digest::SHA' => {
                link => 'http://search.cpan.org/dist/Digest-SHA/',
                label =>
                    'Digest::SHA is required in order to provide enhanced protection of user passwords.',
            },
            'Plack' => {
                link => 'http://search.cpan.org/dist/Plack/',
                label =>
                    'This module and its dependencies are required to run Movable Type under psgi.',
            },
            'CGI::PSGI' => {
                link => 'http://search.cpan.org/dist/CGI-PSGI/',
                label =>
                    'This module and its dependencies are required to run Movable Type under psgi.',
            },
            'CGI::Parse::PSGI' => {
                link => 'http://search.cpan.org/dist/CGI-Emulate-PSGI/',
                label =>
                    'This module and its dependencies are required to run Movable Type under psgi.',
            },
            'XMLRPC::Transport::HTTP::Plack' => {
                link =>
                    'http://search.cpan.org/dist/SOAP-Transport-HTTP-Plack/',
                label =>
                    'This module and its dependencies are required to run Movable Type under psgi.',
            },
            'Net::SMTP' => {
                link => 'http://search.cpan.org/dist/libnet/',
                label =>
                    'Net::SMTP is required in order to send mail using an SMTP server.',
            },
            'Authen::SASL' => {
                link => 'http://search.cpan.org/dist/Authen-SASL/',
                label =>
                    'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.',
            },
            'Net::SMTP::SSL' => {
                link => 'http://search.cpan.org/dist/Net-SMTP-SSL/',
                label =>
                    'Net::SMTP::SSL is required to use SMTP Auth over an SSL connection.',
            },
            'Net::SMTP::TLS' => {
                link => 'http://search.cpan.org/dist/Net-SMTP-TLS/',
                label =>
                    'Net::SMTP::TLS is required to use SMTP Auth with STARTTLS command.',
            },
            'IO::Socket::SSL' => {
                link => 'http://search.cpan.org/dist/IO-Socket-SSL/',
                label =>
                    'IO::Socket::SSL is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command. Also, this module is required for site statistics of Google Analytics.',
            },
            'Net::SSLeay' => {
                link => 'http://search.cpan.org/dist/Net-SSLeay/',
                label =>
                    'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.',
            },
            'HTML::Entities' => {
                link => 'http://search.cpan.org/dist/HTML-Entities',
                label =>
                    'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.',
            },
            'HTML::Parser' => {
                link => 'http://search.cpan.org/dist/HTML-Parser',
                label =>
                    'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.',
            },
            'SOAP::Lite' => {
                link    => 'http://search.cpan.org/dist/SOAP-Lite',
                version => 0.50,
                label =>
                    'This module is needed if you want to use the MT XML-RPC server implementation.',
            },
            'File::Temp' => {
                link => 'http://search.cpan.org/dist/File-Temp',
                label =>
                    'This module is needed if you would like to be able to overwrite existing files when you upload.',
            },
            'List::Util' => {
                link => 'http://search.cpan.org/dist/Scalar-List-Utils',
                label =>
                    'List::Util is optional; It is needed if you want to use the Publish Queue feature.',
            },
            'Scalar::Util' => {
                link => 'http://search.cpan.org/dist/Scalar-List-Utils',
                label =>
                    'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.',
            },
            'Image::Magick' => {
                link => 'http://www.imagemagick.org/script/perl-magick.php',
                label =>
                    'This module is needed if you would like to be able to create thumbnails of uploaded images.',
            },
            'GD' => {
                link => 'http://search.cpan.org/dist/GD',
                label =>
                    'This module is needed if you would like to be able to create thumbnails of uploaded images.',
            },
            'Imager' => {
                link => 'http://search.cpan.org/dist/Imager',
                label =>
                    'This module is needed if you would like to be able to create thumbnails of uploaded images.',
            },
            'IPC::Run' => {
                link => 'http://search.cpan.org/dist/IPC-Run',
                label =>
                    'This module is needed if you would like to be able to use NetPBM as the image driver for MT.',
            },
            'Storable' => {
                link => 'http://search.cpan.org/dist/Storable',
                label =>
                    'This module is required by certain MT plugins available from third parties.',
            },
            'Crypt::DSA' => {
                link => 'http://search.cpan.org/dist/Crypt-DSA',
                label =>
                    'This module accelerates comment registration sign-ins.',
            },
            'Crypt::SSLeay' => {
                link => 'http://search.cpan.org/dist/Crypt-SSLeay',
                label =>
                    'This module and its dependencies are required to permit commenters to authenticate via OpenID providers such as AOL and Yahoo! that require SSL support. Also this module is required for site statistics of Google Analytics.',
            },
            'Cache::File' => {
                link => 'http://search.cpan.org/dist/Cache/lib/Cache/File.pm',
                label =>
                    'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.',
            },
            'MIME::Base64' => {
                link => 'http://search.cpan.org/dist/MIME-Base64',
                label =>
                    'This module is needed to enable comment registration. Also, required in order to send mail via an SMTP Server.',
            },
            'XML::Atom' => {
                link  => 'http://search.cpan.org/dist/XML-Atom',
                label => 'This module enables the use of the Atom API.',
            },
            'Cache::Memcached' => {
                link => 'http://search.cpan.org/dist/Cache-Memcached',
                label =>
                    'This module is required in order to use memcached as caching mechanism used by Movable Type.',
            },
            'Archive::Tar' => {
                link => 'http://search.cpan.org/dist/Archive-Tar',
                label =>
                    'This module is required in order to archive files in backup/restore operation.',
            },
            'IO::Compress::Gzip' => {
                link => 'http://search.cpan.org/dist/IO-Compress-Zlib',
                label =>
                    'This module is required in order to compress files in backup/restore operation.',
            },
            'IO::Uncompress::Gunzip' => {
                link => 'http://search.cpan.org/dist/IO-Compress-Zlib',
                label =>
                    'This module is required in order to decompress files in backup/restore operation.',
            },
            'Archive::Zip' => {
                link => 'http://search.cpan.org/dist/Archive-Zip',
                label =>
                    'This module is required in order to archive files in backup/restore operation.',
            },
            'XML::SAX' => {
                link => 'http://search.cpan.org/dist/XML-SAX',
                label =>
                    'This module and its dependencies are required in order to restore from a backup.',
            },
            'Digest::SHA1' => {
                link => 'http://search.cpan.org/dist/Digest-SHA1',
                label =>
                    'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.',
            },
            'Safe' => {
                link => 'http://search.cpan.org/dist/Safe',
                label =>
                    'This module is used in a test attribute for the MTIf conditional tag.',
            },
            'Digest::MD5' => {
                link  => 'http://search.cpan.org/dist/Digest-MD5',
                label => 'This module is used by the Markdown text filter.',
            },
            'Text::Balanced' => {
                link => 'http://search.cpan.org/dist/Text-Balanced',
                label =>
                    'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.',
            },
            'XML::Parser' => {
                link  => 'http://search.cpan.org/dist/XML-Parser',
                label => 'This module required for action streams.',
            },
            'XML::SAX::ExpatXS' => {
                link    => 'http://search.cpan.org/dist/XML-SAX-ExpatXS',
                label   => 'XML::SAX::ExpatXS is optional; It is one of the modules is required to restore a backup created in a backup/restore operation.',
                version => 1.30,
            },
            'XML::SAX::Expat' => {
                link    => 'http://search.cpan.org/dist/XML-SAX-Expat',
                label   => 'XML::SAX::Expat is optional; It is one of the modules is required to restore a backup created in a backup/restore operation.',
                version => 0.37,
            },
            'XML::LibXML::SAX' => {
                link    => 'http://search.cpan.org/dist/XML-LibXML-SAX',
                label   => 'XML::LibXML::SAX is optional; It is one of the modules is required to restore a backup created in a backup/restore operation.',
                version => 1.70,
            },
            'Time::HiRes' => {
                link => 'http://search.cpan.org/dist/Time-HiRes/',
                label =>
                    'This module is required for executing run-periodic-tasks.',
            },
            'Mozilla::CA' => {
                link => 'http://search.cpan.org/dist/Mozilla-CA/',
                label =>
                    'This module is required for site statistics of Google Analytics.',
            },
        },
        required_packages => {
            'Image::Size' => {
                link => 'http://search.cpan.org/dist/Image-Size',
                label =>
                    'This module is required for file uploads (to determine the size of uploaded images in many different formats).',
            },
            'CGI::Cookie' => {
                link =>
                    'http://search.cpan.org/search?query=cgi-cookie&mode=module',
                label => 'This module is required for cookie authentication.',
            },
            'DBI' => {
                link => 'http://search.cpan.org/dist/DBI',
                label =>
                    'DBI is required to work with most supported databases.',
                version => 1.21,
            },
            'CGI' => {
                link => 'http://search.cpan.org/dist/CGI.pm',
                label =>
                    'CGI is required for all Movable Type application functionality.',
            },
            'File::Spec' => {
                link    => 'http://search.cpan.org/dist/File-Spec',
                version => 0.8,
                label =>
                    'File::Spec is required to work with file system path information on all supported operating systems.',
            },
            'LWP::UserAgent' => {
                link => 'http://search.cpan.org/dist/libwww-perl/',
                label =>
                    'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.',
            },
        },
        database_options => {
            'mysql' => {
                options          => { login_required => 1, },
                default_database => 'test',
                list_sql         => 'SHOW DATABASES;'
            },
            'postgres' => {
                options          => { login_required => 1, },
                default_database => 'template1',
                list_sql =>
                    'SELECT datname FROM pg_database ORDER BY datname;'
            },
            'sqlite'  => { options => { path_required => 1, }, },
            'sqlite2' => { options => { path_required => 1, }, },
        },
        image_drivers => {
            magick => {
                order  => 100,
                driver => 'ImageMagick',
            },
            gd => {
                order  => 200,
                driver => 'GD',
            },
            netpbm => {
                order  => 300,
                driver => 'NetPBM',
            },
            imager => {
                order  => 400,
                driver => 'Imager',
            },
        },
    };
}

sub run_step {
    my $app       = shift;
    my $steps     = $app->registry("wizard_steps");
    my $next_step = $app->param('next_step');
    my $curr_step = $app->param('step');
    my $h         = $steps->{$curr_step}{handler};

    my %param = $app->unserialize_config;
    my $keys  = $app->config_keys;
    if ($curr_step) {
        foreach ( @{ $keys->{$curr_step} } ) {
            if ( defined $app->param($_) ) {
                $param{$_} = $app->param($_);
            }
            else {
                delete $param{$_}
                    if exists $param{$_};
            }
        }

        if ( $app->param('save') ) {
            $app->param( 'config', $app->serialize_config(%param) );
        }
    }

    $h = $steps->{$next_step}{handler};

    if ( !$h ) {
        return $app->pre_start();
    }

    $h = $app->handler_to_coderef($h)
        unless ref($h) eq 'CODE';

    $app->param( 'step', $next_step );
    return $h->( $app, %param );
}

sub config_keys {
    my $app   = shift;
    my $steps = $app->registry("wizard_steps");
    my $keys  = {};
    foreach my $key ( keys %$steps ) {
        my $p = $steps->{$key}{params};
        $keys->{$key} = $p if $p;
    }
    return $keys;
}

sub init_config {
    return 1;
}

sub pre_start {
    my $app = shift;
    my %param;

    eval { use File::Spec; };
    my ($static_file_path);
    if ( !$@ ) {
        $static_file_path = File::Spec->catfile( $app->static_file_path );
    }

    $param{cfg_exists}        = $app->is_config_exists;
    $param{valid_static_path} = 1
        if $app->is_valid_static_path( $app->static_path );
    $param{mt_static_exists} = $app->mt_static_exists;
    $param{static_file_path} = $static_file_path;

    $param{languages}
        = MT::I18N::languages_list( $app, $app->current_language );

    return $app->build_page( "start.tmpl", \%param );
}

sub wizard_steps {
    my $app = shift;
    my @steps;
    my $steps       = $app->registry("wizard_steps");
    my $active_step = $app->param('step') || 'start';
    my %param       = $app->unserialize_config;
    foreach my $key ( keys %$steps ) {
        if ( my $cond = $steps->{$key}{condition} ) {
            if ( !ref($cond) ) {
                $cond = $app->handler_to_coderef($cond);
            }
            next unless ref($cond) eq 'CODE';
            next unless $cond->( $app, \%param );
        }
        push @steps,
            {
            key    => $key,
            active => $active_step eq $key,
            %{ $steps->{$key} },
            };
    }
    @steps = sort { $a->{order} <=> $b->{order} } @steps;
    return \@steps;
}

sub build_page {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    $param ||= {};
    my $steps = $app->wizard_steps;
    $param->{'wizard_steps'} = $steps;
    $param->{'step'}         = $app->param('step');
    $param->{'default_language'} ||= $app->param('default_language');

    return $app->SUPER::build_page( $tmpl, $param );
}

sub start {
    my $app   = shift;
    my %param = @_;

    $param{languages}
        = MT::I18N::languages_list( $app, $app->current_language );

    my $static_path = $app->param('set_static_uri_to');
    my $static_file_path
        = defined $param{set_static_file_to}
        ? $param{set_static_file_to}
        : $app->param('set_static_file_to');
    $param{set_static_file_to} = $static_file_path;

    # test for static_path
    unless ( $app->param('set_static_uri_to') ) {
        $param{uri_invalid} = 1;
        return $app->build_page( "start.tmpl", \%param );
    }

    $static_path = $app->cgipath . $static_path
        unless $static_path =~ m#^(https?:/)?/#;
    $static_path =~ s#(^\s+|\s+$)##;
    $static_path .= '/' unless $static_path =~ m!/$!;

    unless ( $app->param('uri_valid')
        || $app->is_valid_static_path($static_path) )
    {
        $param{uri_invalid}       = 1;
        $param{set_static_uri_to} = $app->param('set_static_uri_to');
        return $app->build_page( "start.tmpl", \%param );
    }

    $app->config->set( 'StaticWebPath', $static_path );

    # test for static_file_path
    unless ($static_file_path) {
        $param{file_invalid} = 1;
        return $app->build_page( "start.tmpl", \%param );
    }

    if (   !( -d $static_file_path )
        || !( -f File::Spec->catfile( $static_file_path, "mt.js" ) ) )
    {
        $param{file_invalid}      = 1;
        $param{set_static_uri_to} = $app->param('set_static_uri_to');
        return $app->build_page( "start.tmpl", \%param );
    }
    $param{default_language} = $app->param('default_language');
    $param{config}           = $app->serialize_config(%param);
    $param{static_file}      = $static_file_path;

    # test for required packages...
    my $req = $app->registry("required_packages");
    my @REQ;
    foreach my $key ( keys %$req ) {
        my $pkg = $req->{$key};
        push @REQ,
            [
            $key, $pkg->{version} || 0, 1, $pkg->{label},
            $key, $pkg->{link}
            ];
    }

# bugid: 111277
# Performance improvement of 'Requirements Check' screen on Windows environment.
    if ( $^O eq 'MSWin32' ) {
        eval {
            require Net::SSLeay;
            no warnings;
            *Net::SSLeay::RAND_poll = sub () {1};
        };
    }

    my ($needed) = $app->module_check( \@REQ );
    if (@$needed) {
        $param{package_loop} = $needed;
        $param{required}     = 1;
        return $app->build_page( "packages.tmpl", \%param );
    }

    my @DATA;
    my $drivers = $app->object_drivers;
    foreach my $key ( keys %$drivers ) {
        my $driver = $drivers->{$key};
        my $label  = $driver->{label};
        my $link   = 'http://search.cpan.org/dist/' . $driver->{dbd_package};
        $link =~ s/::/-/g;
        push @DATA,
            [
            $driver->{dbd_package},
            $driver->{dbd_version},
            0,
            $app->translate(
                "The [_1] database driver is required to use [_2].",
                $driver->{dbd_package}, $label
            ),
            $label, $link
            ];
    }
    my ($db_missing) = $app->module_check( \@DATA );
    if ( ( scalar @$db_missing ) == ( scalar @DATA ) ) {
        $param{package_loop}           = $db_missing;
        $param{missing_db_or_optional} = 1;
        $param{missing_db}             = 1;
        return $app->build_page( "packages.tmpl", \%param );
    }

    my $opt = $app->registry("optional_packages");
    my @OPT;
    foreach my $key ( keys %$opt ) {
        my $pkg = $opt->{$key};
        push @OPT,
            [
            $key, $pkg->{version} || 0, 0, $pkg->{label},
            $key, $pkg->{link}
            ];
    }
    my ($opt_missing) = $app->module_check( \@OPT );
    push @$opt_missing, @$db_missing;
    if (@$opt_missing) {
        $param{package_loop}           = $opt_missing;
        $param{missing_db_or_optional} = 1;
        $param{optional}               = 1;
        return $app->build_page( "packages.tmpl", \%param );
    }

    $param{success} = 1;
    return $app->build_page( "packages.tmpl", \%param );
}

sub object_drivers {
    my $app = shift;
    my $drivers = $app->registry("object_drivers") || {};
    return $drivers;
}

sub configure {
    my $app   = shift;
    my %param = @_;

    $param{set_static_uri_to} = $app->param('set_static_uri_to');

    # set static web path
    $app->config->set( 'StaticWebPath', $param{set_static_uri_to} );
    delete $param{publish_charset};
    my $db_options = $app->registry('database_options');
    if ( my $dbtype = $param{dbtype} ) {
        $param{"dbtype_$dbtype"} = 1;
        foreach ( keys %{ $db_options->{$dbtype}->{options} } ) {
            $param{$_} = $db_options->{$dbtype}->{options}->{$_};
        }
        if ( $dbtype eq 'mssqlserver' ) {
            $param{publish_charset} = $app->param('publish_charset')
                || (
                $app->param('default_language') eq 'ja'
                ? 'Shift_JIS'
                : 'ISO-8859-1'
                );
        }
    }

    my $form_data = $app->registry('db_form_data');
    my @fields;
    my @advanced;
    $app->set_form_fields( $form_data, \@fields, \@advanced );

    my @DATA;
    my @show;
    my $drivers = $app->object_drivers;
    foreach my $key ( keys %$drivers ) {
        my $driver  = $drivers->{$key};
        my $label   = $driver->{label};
        my $display = $driver->{display};
        my @ids;
        foreach my $id (@$display) {
            push @ids, "'" . $id . "'";
        }
        my $link = 'http://search.cpan.org/dist/' . $driver->{dbd_package};
        $link =~ s/::/-/g;
        push @DATA,
            [
            $driver->{dbd_package},
            $driver->{dbd_version},
            0,
            $app->translate(
                "The [_1] driver is required to use [_2].",
                $driver->{dbd_package}, $label
            ),
            $label, $link,
            join( ',', @ids ),
            ];
        my $form_data = $driver->{db_form_data};
        $app->set_form_fields( $form_data, \@fields, \@advanced );
    }
    my ( $missing, $dbmod ) = $app->module_check( \@DATA );
    if ( scalar(@$dbmod) == 0 ) {
        $param{missing_db_or_optional} = 1;
        $param{missing_db}             = 1;
        $param{package_loop}           = $missing;
        return $app->build_page( "packages.tmpl", \%param );
    }
    foreach (@$dbmod) {
        if ( $_->{module} eq 'DBD::mysql' ) {
            $_->{id} = 'mysql';
        }
        elsif ( $_->{module} eq 'DBD::Pg' ) {
            $_->{id} = 'postgres';
        }
        elsif ( $_->{module} eq 'DBD::Oracle' ) {
            $_->{id} = 'oracle';
        }
        elsif ( $_->{module} eq 'DBD::ODBC1.13' ) {
            $_->{id} = 'mssqlserver';
        }
        elsif ( $_->{module} eq 'DBD::ODBC1.14' ) {
            $_->{id} = 'umssqlserver';
        }
        elsif ( $_->{module} eq 'DBD::SQLite' ) {
            $_->{id} = 'sqlite';
        }
        elsif ( $_->{module} eq 'DBD::SQLite2' ) {
            $_->{id} = 'sqlite2';
        }
        if ( $param{dbtype} && ( $param{dbtype} eq $_->{id} ) ) {
            $_->{selected} = 1;
        }
    }
    @fields = sort { $a->{order} <=> $b->{order} } @fields;
    $param{field_loop} = \@fields;
    @advanced = sort { $a->{order} <=> $b->{order} } @advanced;
    $param{advanced_loop} = \@advanced;

    $param{db_loop} = $dbmod;
    $param{one_db}  = $#$dbmod == 0;    # db module is only one or not
    $param{config} = $app->serialize_config(%param);

    my $ok = 1;
    my ( $err_msg, $err_more );
    if ( $app->param('test') ) {

        # if check successfully and push continue then goto next step
        $ok = 0;
        my $dbtype = $param{dbtype};
        my $driver = $drivers->{$dbtype}{config_package}
            if exists $drivers->{$dbtype};
        $param{dbserver_null} = 1 unless $param{dbserver};

        if ($driver) {
            my $cfg = $app->config;
            $cfg->ObjectDriver($driver);

            my $exec_show_db = '';
            if ( !$param{dbname} ) {

                # set default database
                if ( $db_options->{$dbtype}->{default_database} ) {
                    $cfg->Database(
                        $db_options->{$dbtype}->{default_database} );
                    $exec_show_db = $db_options->{$dbtype}->{list_sql};
                }
            }
            else {
                $cfg->Database( $param{dbname} );
            }
            $cfg->DBUser( $param{dbuser} )         if $param{dbuser};
            $cfg->DBPassword( $param{dbpass} )     if $param{dbpass};
            $cfg->DBPort( $param{dbport} )         if $param{dbport};
            $cfg->DBSocket( $param{dbsocket} )     if $param{dbsocket};
            $cfg->ODBCDriver( $param{odbcdriver} ) if $param{odbcdriver};
            $cfg->DBHost( $param{dbserver} )
                if $param{dbserver} && ( $param{dbtype} ne 'oracle' );
            my $current_charset = $cfg->PublishCharset;
            $cfg->PublishCharset( $param{publish_charset} )
                if $param{publish_charset};

            if ( $dbtype eq 'sqlite' || $dbtype eq 'sqlite2' ) {
                require File::Spec;
                my $db_file = $param{dbpath};
                if ( !File::Spec->file_name_is_absolute($db_file) ) {
                    $db_file
                        = File::Spec->catfile( $app->{mt_dir}, $db_file );
                }
                $cfg->Database($db_file) if $db_file;
                $param{dbpath} = $db_file if $db_file;
                if ( $dbtype eq 'sqlite2' ) {
                    $cfg->UseSQLite2(1);
                }
            }

            # test loading of object driver with these parameters...
            require MT::ObjectDriverFactory;
            my $od = MT::ObjectDriverFactory->new($driver);
            $cfg->PublishCharset($current_charset);

            # to test connection
            my @dbs;
            eval {
                my $handle = $od->rw_handle;
                if ($exec_show_db) {
                    my $sth = $handle->prepare($exec_show_db)
                        or die $handle->errstr;
                    $sth->execute
                        or die $handle->errstr;
                    while ( my @row = $sth->fetchrow ) {
                        push @dbs, { name => @row };
                    }
                }
            };

            if ( my $err = $@ ) {
                $err_msg
                    = $app->translate(
                    'An error occurred while trying to connect to the database.  Check the settings and try again.'
                    );
                my $enc;
                if (   exists( $param{publish_charset} )
                    && $param{publish_charset}
                    && ( $param{publish_charset} ne $current_charset ) )
                {
                    $enc = $param{publish_charset};
                }
                if ( $dbtype =~ m/u?mssqlserver/i ) {
                    $enc = 'utf8';
                }
                if ($enc) {
                    require Encode;
                    $err = Encode::decode( $enc, $err );
                }
                $err_more = $err;
            }
            else {
                if (@dbs) {
                    my @f;
                    foreach my $field ( @{ $param{field_loop} } ) {
                        if ( $field->{id} eq 'dbname' ) {
                            $field->{element} = 'select';
                            my @options;
                            foreach my $db (@dbs) {
                                my $select = {};
                                $select->{value} = $db->{name};
                                $select->{label} = $db->{name};
                                push @options, $select;
                            }
                            $field->{option_loop} = \@options;
                        }
                        push @f, $field;
                    }
                    $param{field_loop}   = \@f;
                    $param{one_database} = @dbs == 0;
                    $err_msg
                        = $app->translate(
                        'Please select a database from the list of available databases and try again.'
                        );
                }
                else {
                    $ok = 1;
                }
            }
        }
        if ($ok) {
            $param{success} = 1;
            return $app->build_page( "configure.tmpl", \%param );
        }
        $param{connect_error} = 1;
        $param{error}         = $err_msg;
        $param{error_more}    = $err_more;
    }

    $app->build_page( "configure.tmpl", \%param );
}

sub cfg_dir_conditions {
    my $app = shift;
    my ($param) = @_;
    if ( $^O ne 'MSWin32' ) {

        # check for writable temp directory
        if ( -w "/tmp" ) {
            return 0;
        }
    }
    return 1;
}

sub cfg_dir {
    my $app   = shift;
    my %param = @_;

    $param{set_static_uri_to} = $app->param('set_static_uri_to');

    # set static web path
    $app->config->set( 'StaticWebPath', $param{set_static_uri_to} );

    $param{config} = $app->serialize_config(%param);

    my $temp_dir;
    if ( $app->param('test') ) {
        $param{changed} = 1;
        if ( $param{temp_dir} ) {
            $temp_dir = $param{temp_dir};
        }
        else {
            $param{invalid_error} = 1;
        }
    }
    else {
        if ( $param{temp_dir} ) {
            $temp_dir = $param{temp_dir};
            $param{changed} = 1;
        }
        else {
            $temp_dir = $app->config->TempDir;
            if ( !-d $temp_dir ) {
                if ( $^O eq 'MSWin32' ) {
                    $temp_dir = 'C:\Windows\Temp';
                }
            }
            $param{temp_dir} = $temp_dir;
        }
    }

    # check temp dir
    if ($temp_dir) {
        if ( !-d $temp_dir ) {
            $param{not_found_error} = 1;
        }
        elsif ( !-w $temp_dir ) {
            $param{not_write_error} = 1;
        }
        else {
            $param{success} = 1;
        }
    }

    $app->build_page( "cfg_dir.tmpl", \%param );
}

my @Sendmail
    = qw( /usr/lib/sendmail /usr/sbin/sendmail /usr/ucblib/sendmail );

sub optional {
    my $app   = shift;
    my %param = @_;

    $param{set_static_uri_to} = $app->param('set_static_uri_to');

    # set static web path
    $app->config->set( 'StaticWebPath', $param{set_static_uri_to} );

    # discover sendmail
    my $mgr = $app->config;
    my $sm_loc;
    for my $loc ( $param{sendmail_path}, @Sendmail ) {
        next unless $loc;
        $sm_loc = $loc, last if -x $loc && !-d $loc;
    }
    $param{sendmail_path} = $sm_loc || '';
    $param{smtp_server} = $mgr->default('SMTPServer')
        unless $param{smtp_server};
    $param{smtp_port} = 25
        unless $param{smtp_port};

    my $transfer;
    push @$transfer, { id => 'smtp', name => $app->translate('SMTP Server') };
    push @$transfer,
        { id => 'sendmail', name => $app->translate('Sendmail') };

    foreach (@$transfer) {
        if ( $_->{id} eq $param{mail_transfer} ) {
            $_->{selected} = 1;
        }
    }

    $param{ 'use_' . $param{mail_transfer} } = 1;
    $param{mail_loop}                        = $transfer;
    $param{config}                           = $app->serialize_config(%param);

    # bugid:111277
    # Performance improvement of sending test mail on Windows environment.
    if ( $^O eq 'MSWin32' ) {
        eval {
            require Net::SSLeay;
            Net::SSLeay::RAND_poll();
            no warnings 'redefine';
            *Net::SSLeay::RAND_poll = sub () {1};
        };
    }

    require MT::Mail;
    $param{has_net_smtp}      = MT::Mail->can_use_smtp         ? 1 : 0;
    $param{has_net_smtp_auth} = MT::Mail->can_use_smtpauth     ? 1 : 0;
    $param{has_net_smtp_ssl}  = MT::Mail->can_use_smtpauth_ssl ? 1 : 0;
    $param{has_net_smtp_ssl_msg} = MT::Mail->errstr;
    $param{has_net_smtp_tls}     = MT::Mail->can_use_smtpauth_tls ? 1 : 0;
    $param{has_net_smtp_tls_msg} = MT::Mail->errstr;
    $param{can_use_ssl}          = $param{has_net_smtp_ssl}
        || $param{has_net_smtp_tls};

    my $ok = 1;
    my $err_msg;
    if ( $app->param('test') ) {
        $ok = 0;
        if ( $param{test_mail_address} ) {
            my $cfg = $app->config;
            $cfg->MailTransfer( $param{mail_transfer} )
                if $param{mail_transfer};
            $cfg->SendMailPath( $param{sendmail_path} )
                if $param{mail_transfer}
                && ( $param{mail_transfer} eq 'sendmail' )
                && $param{sendmail_path};
            $cfg->EmailAddressMain( $param{email_address_main} )
                if $param{email_address_main};

            if ( $param{mail_transfer} && $param{mail_transfer} eq 'smtp' ) {
                $cfg->SMTPServer( $param{smtp_server} )
                    if $param{smtp_server};
                $cfg->SMTPPort( $param{smtp_port} )
                    if $param{smtp_port};
                $cfg->SMTPAuth(1)
                    if $param{smtp_auth};
                if ( $cfg->SMTPAuth ) {
                    $cfg->SMTPUser( $param{smtp_auth_username} )
                        if $param{smtp_auth_username};
                    $cfg->SMTPpassword( $param{smtp_auth_password} )
                        if $param{smtp_auth_password};
                    $cfg->SMTPAuth('ssl')
                        if $param{smtp_ssl} eq 'ssl';
                    $cfg->SMTPAuth('starttls')
                        if $param{smtp_ssl} eq 'tls';
                }
            }

            my %head = (
                id => 'wizard_test',
                To => $param{test_mail_address},
                From => $cfg->EmailAddressMain || $param{test_mail_address},
                Subject => $app->translate(
                    "Test email from Movable Type Configuration Wizard")
            );
            my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
            $head{'Content-Type'} = qq(text/plain; charset="$charset");

            my $body
                = $app->translate(
                "This is the test email sent by your new installation of Movable Type."
                );

            require MT::Mail;
            $ok = MT::Mail->send( \%head, $body );

            if ($ok) {
                $param{success} = 1;
                return $app->build_page( "optional.tmpl", \%param );
            }
            else {
                $err_msg = MT::Mail->errstr;
            }
        }

        $param{send_error} = 1;
        $param{error}      = $err_msg;
    }
    $app->build_page( "optional.tmpl", \%param );
}

sub seed {
    my $app   = shift;
    my %param = @_;

    # input data unserialize to config
    unless ( keys(%param) ) {
        $param{config} = $app->param('config');
    }
    else {
        $param{config} = $app->serialize_config(%param);
    }

    $param{static_file_path} = $param{set_static_file_to};

    require URI;
    my $uri = URI->new( $app->cgipath );
    $param{cgi_path} = $uri->path;
    $uri = URI->new( $app->param->param('set_static_uri_to') );
    $param{static_web_path} = $uri->path;
    $param{static_uri}      = $uri->path;
    my $drivers = $app->object_drivers;

    my $r_uri = $ENV{REQUEST_URI} || $ENV{SCRIPT_NAME};
    if ( $ENV{MOD_PERL}
        || ( ( $r_uri =~ m/\/mt-wizard\.(\w+)(\?.*)?$/ ) && ( $1 ne 'cgi' ) )
        )
    {
        my $new = '';
        if ( $ENV{MOD_PERL} ) {
            $param{mod_perl} = 1;
        }
        else {
            $new = '.' . $1;
        }
        my @scripts;
        my $cfg = $app->config;
        my @cfg_keys = grep {/Script$/} keys %{ $cfg->{__settings} };
        $param{mt_script} = $app->config->AdminScript;
        foreach my $key (@cfg_keys) {
            my $path = $cfg->get($key);
            $path =~ s/\.cgi$/$new/;
            if ( -e File::Spec->catfile( $app->{mt_dir}, $path ) ) {
                $param{mt_script} = $path if $key eq 'AdminScript';
                push @scripts, { name => $key, path => $path };
            }
        }
        if (@scripts) {
            $param{script_loop} = \@scripts if @scripts;
            $param{non_cgi_suffix} = 1;
        }
    }
    else {
        $param{mt_script} = $app->config->AdminScript;
    }

    # unserialize database configuration
    if ( my $dbtype = $param{dbtype} ) {
        if ( $dbtype eq 'sqlite' ) {
            $param{use_dbms}      = 1;
            $param{object_driver} = 'DBI::sqlite';
            $param{database_name} = $param{dbpath};
        }
        elsif ( $dbtype eq 'sqlite2' ) {
            $param{use_dbms}      = 1;
            $param{use_sqlite2}   = 1;
            $param{object_driver} = 'DBI::sqlite';
            $param{database_name} = $param{dbpath};
        }
        else {
            my %param_name = (
                dbname          => 'database_name',
                dbuser          => 'database_username',
                dbpass          => 'database_password',
                dbserver        => 'database_host',
                dbport          => 'database_port',
                dbsocket        => 'database_socket',
                odbcdriver      => 'database_odbcdriver',
                setnames        => 'use_setnames',
                publish_charset => 'publish_charset',
            );

            $param{use_dbms}      = 1;
            $param{object_driver} = $drivers->{$dbtype}{config_package};
            my $disp = $drivers->{$dbtype}->{display};
            foreach my $id (@$disp) {
                next unless exists $param{$id};
                next unless exists $param_name{$id};

                my $key = $param_name{$id};
                $param{$key} = $param{$id}
                    if $param{$id};
            }
        }
    }

    # look for image driver
    my $image_drivers = $app->registry('image_drivers') || {};
    eval { require MT::Image };
    if ( !$@ ) {
        my @image_drivers = map { $_->{driver} }
            sort { $a->{order} <=> $b->{order} } values %$image_drivers;
    IMAGEDRIVER:
        for my $driver (@image_drivers) {
            my $driver_class = 'MT::Image::' . $driver;
            eval "require $driver_class";
            next IMAGEDRIVER if $@;
            if ( $driver_class->load_driver ) {
                $param{image_driver} = "$driver";
                last IMAGEDRIVER;
            }
        }
    }

    if ( $param{temp_dir} eq $app->config->TempDir ) {
        $param{temp_dir} = '';
    }

    # authentication configuration
    $param{help_url} = $app->help_url();

    my $tmpls = $app->registry("wizard_template") || [];

    my @tmpl_loop;
    require MT::Template;
    foreach my $code (@$tmpls) {
        if ( $code = $app->handler_to_coderef($code) ) {
            push @tmpl_loop, { tmpl_code => $code };
        }
    }

    $param{tmpl_loop} = \@tmpl_loop;

    # If TLS is enabled, SMTPAuth should be 'starttls'
    $param{smtp_auth} = 'starttls'
        if ( $param{mail_transfer} && $param{mail_transfer} eq 'smtp' )
        && $param{smtp_auth}
        && $param{smtp_ssl} eq 'tls';

    # If SSL is enabled, SMTPAuth should be 'ssl'
    $param{smtp_auth} = 'ssl'
        if ( $param{mail_transfer} && $param{mail_transfer} eq 'smtp' )
        && $param{smtp_auth}
        && $param{smtp_ssl} eq 'ssl';

    my $data = $app->build_page( "mt-config.tmpl", \%param );

    my $cfg_file = File::Spec->catfile( $app->{mt_dir}, 'mt-config.cgi' );
    if ( !-f $cfg_file ) {

        # write!
        if ( open OUT, ">$cfg_file" ) {
            print OUT $data;
            close OUT;
        }
        $param{config_created} = 1 if -f $cfg_file;
        if ( ( !-f $cfg_file ) && $app->param->param('manually') ) {
            $param{file_not_found} = 1;
            $param{manually}       = 1;
        }
    }
    elsif ( $app->param->param('manually') ) {
        $param{config_created} = 1 if -f $cfg_file;
    }

    # back to the complete screen
    return $app->build_page( "complete.tmpl", \%param );
}

sub serialize_config {
    my $app   = shift;
    my %param = @_;

    require MT::Serialize;
    my $ser  = MT::Serialize->new('MT');
    my $keys = $app->config_keys();
    my %set;
    foreach my $key ( keys %$keys ) {
        foreach my $p ( @{ $keys->{$key} } ) {
            $set{$p} = $param{$p};
        }
    }
    my $set = \%set;
    unpack 'H*', $ser->serialize( \$set );
}

sub unserialize_config {
    my $app  = shift;
    my $data = $app->param('config');
    my %config;
    if ($data) {
        $data = pack 'H*', $data;
        require MT::Serialize;
        my $ser    = MT::Serialize->new('MT');
        my $thawed = $ser->unserialize($data);
        if ($thawed) {
            my $saved_cfg = $$thawed;
            if ( keys %$saved_cfg ) {
                foreach my $p ( keys %$saved_cfg ) {
                    $config{$p} = $saved_cfg->{$p};
                }
            }
        }
    }
    %config;
}

sub cgipath {
    my $app = shift;

    # these work for Apache... need to test for IIS...
    my $host = $ENV{SERVER_NAME} || $ENV{HTTP_HOST};
    $host =~ s/:\d+//;    # eliminate any port that may be present
    my $port = $ENV{SERVER_PORT};

    # REQUEST_URI for CGI-compliant servers; SCRIPT_NAME for IIS.
    my $uri = $ENV{REQUEST_URI} || $ENV{SCRIPT_NAME};
    $uri =~ s!/mt-wizard(\.f?cgi|\.f?pl)(\?.*)?$!/!;

    my $cgipath = '';
    $cgipath = $port == 443 ? 'https' : 'http';
    $cgipath .= '://' . $host;
    $cgipath .= ( $port == 443 || $port == 80 ) ? '' : ':' . $port;
    $cgipath .= $uri;

    $cgipath;
}

sub module_check {
    my $self    = shift;
    my $modules = shift;
    my ( @missing, @ok );
    foreach my $ref (@$modules) {
        my ( $mod, $ver, $req, $desc, $name, $link, $display ) = @$ref;
        if ( 'CODE' eq ref($desc) ) {
            $desc = $desc->();
        }
        else {
            $desc = $self->translate($desc);
        }
        eval( "use $mod" . ( $ver ? " $ver;" : ";" ) );
        $mod .= $ver if $mod eq 'DBD::ODBC';
        if ($@) {
            push @missing,
                {
                module      => $mod,
                version     => $ver,
                required    => $req,
                description => $desc,
                label       => $name,
                link        => $link,
                display     => $display,
                };
        }
        else {
            push @ok,
                {
                module      => $mod,
                version     => $ver,
                required    => $req,
                description => $desc,
                label       => $name,
                link        => $link,
                display     => $display,
                };
        }
    }
    ( \@missing, \@ok );
}

sub static_path {
    my $app         = shift;
    my $static_path = '';

    if ( $app->config->StaticWebPath ne '' ) {
        $static_path = $app->config->StaticWebPath;
        $static_path .= '/' unless $static_path =~ m!/$!;
        return $static_path;
    }
    return $app->mt_static_exists ? $app->cgipath . 'mt-static/' : '';
}

sub mt_static_exists {
    my $app = shift;
    return ( -f File::Spec->catfile( $app->{mt_dir}, "mt-static", "mt.js" ) )
        ? 1
        : 0;
}

sub is_valid_static_path {
    my $app = shift;
    my ($static_uri) = @_;

    my $path;
    if ( $static_uri =~ m/^http/i ) {
        $path = $static_uri . 'mt.js';
    }
    elsif ( $static_uri =~ m#^/# ) {
        my $host = $ENV{SERVER_NAME} || $ENV{HTTP_HOST};
        $host =~ s/:\d+//;    # eliminate any port that may be present
        my $port = $ENV{SERVER_PORT};
        $path = $port == 443 ? 'https' : 'http';
        $path .= '://' . $host;
        $path .= ( $port == 443 || $port == 80 ) ? '' : ':' . $port;
        $path .= $static_uri . 'mt.js';
    }
    else {
        $path = $app->cgipath . $static_uri . 'mt.js';
    }

    require LWP::UserAgent;
    my $ua       = LWP::UserAgent->new;
    my $request  = HTTP::Request->new( GET => $path );
    my $response = $ua->request($request);
    $response->is_success
        and ( $response->content_length() != 0 )
        && ( $response->content =~ m/function\s+openManual/s );
}

sub is_config_exists {
    my $app = shift;

    eval { use File::Spec; };
    my ( $cfg, $cfg_exists, $static_file_path );
    if ( !$@ ) {
        $cfg = File::Spec->catfile( $app->{mt_dir}, 'mt-config.cgi' );
        $cfg_exists |= 1 if -f $cfg;
    }
    return $cfg_exists;
}

sub set_form_fields {
    my $app = shift;
    my ( $form_data, $fields, $advanced ) = @_;

    foreach my $name ( keys %$form_data ) {
        my $data  = $form_data->{$name};
        my $field = {};
        $field->{id}            = $name;
        $field->{label}         = $data->{label};
        $field->{order}         = $data->{order};
        $field->{element}       = $data->{element};
        $field->{default}       = $data->{default};
        $field->{show_hint}     = $data->{show_hint};
        $field->{hint}          = $data->{hint};
        $field->{class}         = $data->{class};
        $field->{label_class}   = $data->{label_class};
        $field->{content_class} = $data->{content_class};

        if ( $data->{element} eq 'select' ) {
            my @options;
            my $option = $data->{option};
            foreach my $key ( keys %$option ) {
                my $select = {};
                $select->{value} = $key;
                $select->{label} = $option->{$key};
                push @options, $select;
            }
            $field->{option_loop} = \@options;
        }
        else {
            $field->{type} = $data->{type};
        }
        if ( $data->{advanced} ) {
            push @$advanced, $field;
        }
        else {
            push @$fields, $field;
        }
    }
}

1;
__END__

=head1 NAME

MT::App::Wizard

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
