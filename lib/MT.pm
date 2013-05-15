# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT;

use strict;
use base qw( MT::ErrorHandler );
use filetest 'access';
use File::Spec;
use File::Basename;
use MT::Util qw( weaken );
use MT::I18N qw( const );

our ( $VERSION, $SCHEMA_VERSION );
our (
    $PRODUCT_NAME, $PRODUCT_CODE,   $PRODUCT_VERSION,
    $VERSION_ID,   $RELEASE_NUMBER, $PORTAL_URL
);
our ( $MT_DIR, $APP_DIR, $CFG_DIR, $CFG_FILE, $SCRIPT_SUFFIX );
our (
    $plugin_sig, $plugin_envelope, $plugin_registry,
    %Plugins,    @Components,      %Components,
    $DebugMode,  $mt_inst,         %mt_inst
);
my %Text_filters;

# For state determination in MT::Object
our $plugins_installed;

BEGIN {
    $plugins_installed = 0;

    ( $VERSION, $SCHEMA_VERSION ) = ( '5.2', '5.0036' );
    (   $PRODUCT_NAME, $PRODUCT_CODE,   $PRODUCT_VERSION,
        $VERSION_ID,   $RELEASE_NUMBER, $PORTAL_URL,
        )
        = (
        '__PRODUCT_NAME__',   'MT',
        '5.2.5',              '__PRODUCT_VERSION_ID__',
        '__RELEASE_NUMBER__', '__PORTAL_URL__'
        );

  # To allow MT to run straight from svn, if no build process (pre-processing)
  # is run, then default to MTOS
    if ( $PRODUCT_NAME eq '__PRODUCT' . '_NAME__' ) {
        $PRODUCT_NAME = 'Movable Type';
    }
    if ( $PORTAL_URL eq '__PORTAL' . '_URL__' ) {
        $PORTAL_URL = 'http://www.movabletype.org/';
    }
    if ( $VERSION_ID eq '__PRODUCT_VERSION' . '_ID__' ) {
        $VERSION_ID = $PRODUCT_VERSION;
    }

    if ( $RELEASE_NUMBER eq '__RELEASE' . '_NUMBER__' ) {
        $RELEASE_NUMBER = 5;
    }

    $DebugMode = 0;

    # Alias lowercase to uppercase package; note: this is an equivalence
    # as opposed to having @mt::ISA set to 'MT'. so @mt::Plugins would
    # resolve as well as @MT::Plugins.
    *{mt::} = *{MT::};

    # Alias these; Components is the preferred array for MT 4
    *Plugins = \@Components;
}

# On-demand loading of compatibility module, if a plugin asks for it, using
#     use MT 3;
# or even specific to minor version (but this just loads MT::Compat::v3)
#     use MT 3.3;
sub VERSION {
    my $v = $_[1];
    if ( defined $v && ( $v =~ m/^(\d+)/ ) ) {
        my $compat = "MT::Compat::v" . $1;
        if ( ( $1 > 2 ) && ( $1 < int($VERSION) ) ) {
            no strict 'refs';
            unless ( defined *{ $compat . '::' } ) {
                eval "# line " . __LINE__ . " " . __FILE__
                    . "\nrequire $compat;";
            }
        }
    }
    return UNIVERSAL::VERSION(@_);
}

sub version_number  {$VERSION}
sub version_id      {$VERSION_ID}
sub product_code    {$PRODUCT_CODE}
sub product_name    {$PRODUCT_NAME}
sub product_version {$PRODUCT_VERSION}
sub schema_version  {$SCHEMA_VERSION}
sub release_number  {$RELEASE_NUMBER}

sub portal_url {
    if ( my $url = const('PORTAL_URL') ) {
        return $url;
    }
    return $PORTAL_URL;
}

# Default id method turns MT::App::CMS => cms; Foo::Bar => foo/bar
sub id {
    my $pkg = shift;
    my $id = ref($pkg) || $pkg;

    # ignore the MT::App prefix as part of the identifier
    $id =~ s/^MT::App:://;
    $id =~ s!::!/!g;
    return lc $id;
}

sub version_slug {
    return MT->translate_templatized(<<"SLUG");
<__trans phrase="Powered by [_1]" params="$PRODUCT_NAME">
<__trans phrase="Version [_1]" params="$VERSION_ID">
<__trans phrase="http://www.movabletype.com/">
SLUG
}

sub build_id {
    my $build_id = '__BUILD_ID__';
    $build_id = '' if $build_id eq '__BUILD_' . 'ID__';
    return $build_id;
}

sub import {
    my $pkg = shift;
    return unless @_;

    my (%param) = @_;
    my $app_pkg;
    if ( $app_pkg = $param{app} || $param{App} || $ENV{MT_APP} ) {
        if ( $app_pkg !~ m/::/ ) {
            my $apps = $pkg->registry('applications');
            $app_pkg = $apps->fetch($app_pkg);
            if ( ref $app_pkg ) {

                # pick first one??
                $app_pkg = $app_pkg->[0];

                # pick last one??
                # $app_pkg = pop @$app_pkg;
            }
        }
    }
    elsif ( $param{run} || $param{Run} ) {

        # my $script = File::Spec->rel2abs($0);
        my ( $filename, $path, $suffix ) = fileparse( $0, qr{\..+$} );
        $SCRIPT_SUFFIX = $suffix;
        my $script = lc $filename;
        $script =~ s/^mt-//;
        my $apps = $pkg->registry('applications');
        $app_pkg = $apps->fetch( lc $script );
        unless ($app_pkg) {
            die "cannot determine application for script $0, stopped at";
        }
    }
    $pkg->run_app( $app_pkg, \%param )
        if $app_pkg;
}

sub run_app {
    my $pkg = shift;
    my ( $class, $param ) = @_;

    # When running under FastCGI, the initial invocation of the
    # script has a bare environment. We can use this to test
    # for FastCGI.
    my $not_fast_cgi = 0;
    $not_fast_cgi ||= exists $ENV{$_}
        for qw(HTTP_HOST GATEWAY_INTERFACE SCRIPT_FILENAME SCRIPT_URL);
    my $fast_cgi
        = defined $param->{FastCGI}
        ? $param->{FastCGI}
        : ( not $not_fast_cgi );
    if ($fast_cgi) {
        eval { require CGI::Fast; };
        $fast_cgi = 0 if $@;
    }

    # ready to run now... run inside an eval block so we can gracefully
    # die if something bad happens
    my $app;
    eval {
        eval "require $class; 1;" or die $@;
        if ($fast_cgi) {
            my ( $max_requests, $max_time, $cfg );
            while ( my $cgi = new CGI::Fast ) {
                $app = $class->new( %$param, CGIObject => $cgi )
                    or die $class->errstr;

                $app->{fcgi_startup_time} ||= time;
                $app->{fcgi_request_count}
                    = ( $app->{fcgi_request_count} || 0 ) + 1;

                unless ($cfg) {
                    $cfg          = $app->config;
                    $max_requests = $cfg->FastCGIMaxRequests;
                    $max_time     = $cfg->FastCGIMaxTime;
                }

                local $SIG{__WARN__} = sub { $app->trace( $_[0] ) };
                $pkg->set_instance($app);
                $app->init_request( CGIObject => $cgi );
                $app->run;

                # Check for timeout for this process
                if ( $max_time
                    && ( time - $app->{fcgi_startup_time} >= $max_time ) )
                {
                    last;
                }

                # Check for max executions for this process
                if ( $max_requests
                    && ( $app->{fcgi_request_count} >= $max_requests ) )
                {
                    last;
                }
            }
        }
        else {
            $app = $class->new(%$param) or die $class->errstr;
            local $SIG{__WARN__} = sub { $app->trace( $_[0] ) };
            $app->run;
        }
    };
    if ( my $err = $@ ) {
        my $charset = 'utf-8';
        eval {
            $app ||= MT->instance;
            my $cfg = $app->config;
            my $c   = $app->find_config;
            $cfg->read_config($c);
            $charset = $cfg->PublishCharset;
        };
        if ( $app && UNIVERSAL::isa( $app, 'MT::App' ) ) {
            eval {
                my %param = ( error => $err );
                if ( $err =~ m/Bad ObjectDriver/ ) {
                    $param{error_database_connection} = 1;
                }
                elsif ( $err =~ m/Bad CGIPath/ ) {
                    $param{error_cgi_path} = 1;
                }
                elsif ( $err =~ m/Missing configuration file/ ) {
                    $param{error_config_file} = 1;
                }
                my $page = $app->build_page( 'error.tmpl', \%param )
                    or die $app->errstr;
                print "Content-Type: text/html; charset=$charset\n\n";
                print $page;
            };
            if ( my $err = $@ ) {
                print "Content-Type: text/plain; charset=$charset\n\n";
                print $app
                    ? $app->translate( "Got an error: [_1]", $err )
                    : "Got an error: $err";
            }
        }
        else {
            if ( $err =~ m/Missing configuration file/ ) {
                my $host = $ENV{SERVER_NAME} || $ENV{HTTP_HOST};
                $host =~ s/:\d+//;
                my $port = $ENV{SERVER_PORT};
                my $uri = $ENV{REQUEST_URI} || $ENV{PATH_INFO};
                $uri =~ s/mt(\Q$SCRIPT_SUFFIX\E)?.*$//;
                my $cgipath = '';
                $cgipath = $port == 443 ? 'https' : 'http';
                $cgipath .= '://' . $host;
                $cgipath
                    .= ( $port == 443 || $port == 80 ) ? '' : ':' . $port;
                $cgipath .= $uri;

                print "Status: 302 Moved\n";
                print "Location: " . $cgipath . "mt-wizard.cgi\n\n";
            }
            else {
                print "Content-Type: text/plain; charset=$charset\n\n";
                print $app
                    ? $app->translate( "Got an error: [_1]", $err )
                    : "Got an error: $err\n";
            }
        }
    }
}

sub instance {
    my $class = shift;
    $mt_inst ||= $mt_inst{$class} ||= $class->construct(@_);
}
*app = \&instance;

sub set_instance {
    my $class = shift;
    $mt_inst = shift;
}

sub new {
    my $mt = &instance_of;
    $mt_inst ||= $mt;
    $mt;
}

sub instance_of {
    my $class = shift;
    $mt_inst{$class} ||= $class->construct(@_);
}

sub construct {
    my $class = shift;
    my $mt = bless {}, $class;
    local $mt_inst = $mt;
    $mt->init(@_)
        or die $mt->errstr;
    $mt;
}

{
    my %object_types;

    sub model {
        my $pkg = shift;
        my ($k) = @_;

        $object_types{$k} = $_[1] if scalar @_ > 1;
        return $object_types{$k} if exists $object_types{$k};

        if ( $k =~ m/^(.+):(meta|summary)$/ ) {
            my $ppkg = $pkg->model($1);
            my $mpkg = $ppkg->meta_pkg($2);
            return $mpkg ? $object_types{$k} = $mpkg : undef;
        }

        if ( $k =~ m/^(.+):revision$/ ) {
            my $ppkg = $pkg->model($1);
            my $rpkg = $ppkg->revision_pkg;
            return $rpkg ? $object_types{$k} = $rpkg : undef;
        }

        my $model = $pkg->registry( 'object_types', $k );
        if ( ref($model) eq 'ARRAY' ) {

           # First element of an array *should* be a scalar; in case it isn't,
           # return undef.
            $model = $model->[0];
            return undef if ref $model;
        }
        elsif ( ref($model) eq 'HASH' ) {

            # If all we have is a hash, this doesn't tell us the package for
            # this object type, so it's undefined.
            return undef;
        }
        return undef unless $model;

        # Element in object type hash is scalar, so return it
        no strict 'refs';
        unless ( defined *{ $model . '::__properties' } ) {
            use strict 'refs';
            eval "# line " . __LINE__ . " " . __FILE__ . "\nrequire $model;";
            if ( $@ && ( $k =~ m/^(.+)\./ ) ) {

                # x.foo can't be found, so try loading x
                if ( my $ppkg = $pkg->model($1) ) {

                    # well now see if $model is defined
                    no strict 'refs';
                    unless ( defined *{ $model . '::__properties' } ) {

                        # if not, use parent package instead
                        $model = $ppkg;
                    }
                }
            }
        }
        return $object_types{$k} = $model;
    }

    sub models {
        my $pkg = shift;
        my ($k) = @_;

        my @matches;
        my $model = $pkg->registry('object_types');
        foreach my $m ( keys %$model ) {
            if ( $m =~ m/^\Q$k\E\.?/ ) {
                push @matches, $m;
            }
        }
        return @matches;
    }
}

sub all_models {
    my $pkg = shift;
    map { $pkg->model($_) } keys %{ $pkg->registry('object_types') };
}

sub registry {
    my $pkg = shift;

    require MT::Component;
    my $regs = MT::Component->registry(@_);
    my $r;
    if ($regs) {
        foreach my $cr (@$regs) {

            # in the event that our registry request returns something
            # other than an array of hashes, return it as is instead of
            # merging it together.
            return $regs unless ref($cr) eq 'HASH';

            delete $cr->{plugin} if exists $cr->{plugin};
            __merge_hash( $r ||= {}, $cr );
        }
    }
    return $r;
}

# merges contents of two hashes, giving preference to the right side
# if $replace is true; otherwise it will always append to the left side.
sub __merge_hash {
    my ( $h1, $h2, $replace ) = @_;
    for my $k ( keys(%$h2) ) {
        if ( exists( $h1->{$k} ) && ( !$replace ) ) {
            if ( ref $h1->{$k} eq 'HASH' ) {
                __merge_hash( $h1->{$k}, $h2->{$k}, ( $replace || 0 ) + 1 );
            }
            elsif ( ref $h1->{$k} eq 'ARRAY' ) {
                if ( ref $h2->{$k} eq 'ARRAY' ) {
                    push @{ $h1->{$k} }, @{ $h2->{$k} };
                }
                else {
                    push @{ $h1->{$k} }, $h2->{$k};
                }
            }
            else {
                $h1->{$k} = [ $h1->{$k}, $h2->{$k} ];
            }
        }
        else {
            $h1->{$k} = $h2->{$k};
        }
    }
}

# The above functions can all be used to make MT objects (and subobjects).
# The difference between them is characterized by these assertions:
#
#  $mt = MT::App::Search->new();
#  assert($mt->isa('MT::App::Search'))
#
#  $mt1 = MT->instance
#  $mt2 = MT->instance
#  assert($mt1 == $mt2);
#
#  $mt1 = MT::App::CMS->construct()
#  $mt2 = MT::App::CMS->construct()
#  assert($mt1 != $mt2);
#
# TBD: make a test script for these.

# obsolete; do not use
sub unplug {
}

sub config {
    my $mt = shift;
    ref $mt or $mt = MT->instance;
    unless ( $mt->{cfg} ) {
        require MT::ConfigMgr;
        weaken( $mt->{cfg} = MT::ConfigMgr->instance );
    }
    if (@_) {
        my $setting = shift;
        @_ ? $mt->{cfg}->set( $setting, @_ ) : $mt->{cfg}->get($setting);
    }
    else {
        $mt->{cfg};
    }
}

sub request {
    my $pkg = shift;
    my $inst = ref($pkg) ? $pkg : $pkg->instance;
    unless ( $inst->{request} ) {
        require MT::Request;
        $inst->{request} = MT::Request->instance;
    }
    if (@_) {
        $inst->{request}->stash(@_);
    }
    else {
        $inst->{request};
    }
}

sub log {
    my ( $mt, $msg );
    if ( @_ == 1 ) {

        # single parameter to log, so it must be the message
        $msg = shift;
        $mt  = MT->instance;
    }
    else {

        # multiple parameters to log; second one is message
        ( $mt, $msg ) = @_;
    }
    unless ($plugins_installed) {

        # finish init_schema here since we have to log something
        # to the database.
        $mt->init_schema();
    }
    my $log_class = $mt->model('log');
    my $log       = $log_class->new();
    if ( ref $msg eq 'HASH' ) {
        $log->set_values($msg);
    }
    elsif ( ( ref $msg ) && ( UNIVERSAL::isa( $msg, 'MT::Log' ) ) ) {
        $log = $msg;
    }
    else {
        $log->message($msg);
    }
    $log->level( MT::Log::INFO() )
        unless defined $log->level;
    $log->class('system')
        unless defined $log->class;
    $log->save();
    print STDERR Encode::encode_utf8(
        MT->translate( "Message: [_1]", $log->message ) . "\n" )
        if $MT::DebugMode && ( $^O ne "MSWin32" );
}

sub run_tasks {
    my $mt = shift;
    require MT::TaskMgr;
    MT::TaskMgr->run_tasks(@_);
}

our %CallbackAlias;
our $CallbacksEnabled = 1;
my %CallbacksEnabled;
my @Callbacks;

sub add_callback {
    my $class = shift;
    my ( $meth, $priority, $plugin, $code ) = @_;
    if ( $meth =~ m/^(.+::)?([^\.]+)(\..+)?$/ ) {

        # Remap (whatever)::(name).(something)
        if ( exists $CallbackAlias{$2} ) {
            $meth = $CallbackAlias{$2};
            $meth = $1 . $meth if $1;
            $meth = $meth . $3 if $3;
        }
    }
    $meth = $CallbackAlias{$meth} if exists $CallbackAlias{$meth};
    my $internal = 0;
    if ( ref $plugin ) {
        if ( ( defined $mt_inst ) && ( $plugin == $mt_inst ) ) {
            $plugin   = undef;
            $internal = 1;
        }
        elsif ( !UNIVERSAL::isa( $plugin, "MT::Component" ) ) {
            return $class->trans_error(
                "If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin"
            );
        }
    }
    if ( ( ref $code ) ne 'CODE' ) {
        if ( ref $code ) {
            return $class->trans_error(
                'Fourth argument to add_callback must be a CODE reference.');
        }
        else {

            # Defer until callback is used
            # if ($plugin) {
            #     $code = MT->handler_to_coderef($code);
            # }
        }
    }

    # 0 and 11 are exclusive.
    if ( $priority == 0 || $priority == 11 ) {
        if ( $Callbacks[$priority]->{$meth} ) {
            return $class->trans_error("Two plugins are in conflict");
        }
    }
    return $class->trans_error( "Invalid priority level [_1] at add_callback",
        $priority )
        if ( ( $priority < 0 ) || ( $priority > 11 ) );
    require MT::Callback;
    $CallbacksEnabled{$meth} = 1;
    ## push @{$Plugins{$plugin_sig}{callbacks}}, "$meth Callback" if $plugin_sig;
    my $cb = MT::Callback->new(
        plugin   => $plugin,
        code     => $code,
        priority => $priority,
        internal => $internal,
        method   => $meth
    );
    push @{ $Callbacks[$priority]->{$meth} }, $cb;
    $cb;
}

sub remove_callback {
    my $class    = shift;
    my ($cb)     = @_;
    my $priority = $cb->{priority};
    my $method   = $cb->{method};
    my $list     = $Callbacks[$priority];
    return unless $list;
    my $cbarr = $list->{$method};
    return unless $cbarr;
    @$cbarr = grep { $_ != $cb } @$cbarr;
}

# For use by MT internal code
sub _register_core_callbacks {
    my $class = shift;
    my ($callback_table) = @_;
    foreach my $name ( keys %$callback_table ) {
        $class->add_callback( $name, 5, $mt_inst, $callback_table->{$name} )
            || return;
    }
    1;
}

sub register_callbacks {
    my $class = shift;
    my ($callback_list) = @_;
    foreach my $cb (@$callback_list) {
        $class->add_callback( $cb->{name}, $cb->{priority}, $cb->{plugin},
            $cb->{code} )
            || return;
    }
    1;
}

{
    my $CB_ERR;
    sub callback_error { $CB_ERR = $_[0]; }
    sub callback_errstr {$CB_ERR}
}

sub run_callback {
    my $class = shift;
    my ( $cb, @args ) = @_;

    $cb->error();    # reset the error string
    my $result = eval { $cb->invoke(@args); };
    if ( my $err = $@ ) {
        $cb->error($err);
        my $plugin = $cb->{plugin};
        my $name;
        if ( $cb->{internal} ) {
            $name = MT->translate("Internal callback");
        }
        elsif ( UNIVERSAL::isa( $plugin, 'MT::Plugin' ) ) {
            $name = $plugin->name() || MT->translate("Unnamed plugin");
        }
        else {
            $name = MT->translate("Unnamed plugin");
        }
        require MT::Log;
        MT->log(
            {   message =>
                    MT->translate( "[_1] died with: [_2]", $name, $err ),
                class    => 'system',
                category => 'callback',
                level    => MT::Log::ERROR(),
            }
        );
        return 0;
    }
    if ( $cb->errstr() ) {
        return 0;
    }
    return $result;
}

# A callback should return a true/false value. The result of
# run_callbacks is the logical AND of all the callback's return
# values. Some hookpoints will ignore the return value: e.g. object
# callbacks don't use it. By convention, those that use it have Filter
# at the end of their names (CommentPostFilter, CommentThrottleFilter,
# etc.)
# Note: this composition is not short-circuiting. All callbacks are
# executed even if one has already returned false.
# ALSO NOTE: failure (dying or setting $cb->errstr) does not force a
# "false" return.
# THINK: are there cases where a true value should override all false values?
# that is, where logical OR is the right way to compose multiple callbacks?
sub run_callbacks {
    my $class = shift;
    my ( $meth, @args ) = @_;
    return 1 unless $CallbacksEnabled && %CallbacksEnabled;
    $meth = $CallbackAlias{$meth} if exists $CallbackAlias{$meth};
    my @methods;

    # execution:
    #   Full::Name.<variant>
    #   *::Name.<variant> OR Name.<variant>
    #   Full::Name
    #   *::Name OR Name
    push @methods, $meth if $CallbacksEnabled{$meth};    # bleh::blah variant
    if ( $meth =~ /::/ ) {    # presence of :: implies it's an obj. cb
        my $name = $meth;
        $name =~ s/^.*::([^:]*)$/$1/;
        $name = $CallbackAlias{ '*::' . $name }
            if exists $CallbackAlias{ '*::' . $name };
        push @methods, '*::' . $name
            if $CallbacksEnabled{ '*::' . $name };    # *::blah variant
        push @methods, $name if $CallbacksEnabled{$name};    # blah variant
    }
    if ( $meth =~ /\./ ) {  # presence of ' ' implies it is a variant callback
        my ($name) = split /\./, $meth, 2;
        $name = $CallbackAlias{$name} if exists $CallbackAlias{$name};
        push @methods, $name if $CallbacksEnabled{$name};    # bleh::blah
        if ( $name =~ m/::/ ) {
            my $name2 = $name;
            $name2 =~ s/^.*::([^:]*)$/$1/;
            $name2 = $CallbackAlias{ '*::' . $name2 }
                if exists $CallbackAlias{ '*::' . $name2 };
            push @methods, '*::' . $name2
                if $CallbacksEnabled{ '*::' . $name2 };      # *::blah
            push @methods, $name2 if $CallbacksEnabled{$name2};    # blah
        }
    }
    return 1 unless @methods;

    $CallbacksEnabled{$_} = 0 for @methods;
    my @errors;
    my $filter_value = 1;
    my $first_error;

    foreach my $callback_sheaf (@Callbacks) {
        for my $meth (@methods) {
            if ( my $set = $callback_sheaf->{$meth} ) {
                for my $cb (@$set) {
                    my $result = $class->run_callback( $cb, @args );
                    $filter_value &&= $result;
                    if ( !$result ) {
                        if ( $cb->errstr() ) {
                            push @errors, $cb->errstr();
                        }
                        if ( $class->errstr() ) {
                            push @errors, $class->errstr();
                        }
                        if ( !defined($first_error) ) {
                            $first_error = $cb->errstr() || $class->errstr();
                        }
                    }
                }
            }
        }
    }

    callback_error( join( '', @errors ) );

    $CallbacksEnabled{$_} = 1 for @methods;
    if ( !$filter_value ) {
        return $class->error($first_error);
    }
    else {
        return $filter_value;
    }
}

sub user_class {
    shift->{user_class};
}

sub find_config {
    my $mt = shift;
    my ($param) = @_;

    $param->{Config}    ||= $ENV{MT_CONFIG};
    $param->{Directory} ||= $ENV{MT_HOME};
    if ( !$param->{Directory} ) {
        if ( $param->{Config} ) {
            $param->{Directory} = dirname( $param->{Config} );
        }
        else {
            $param->{Directory} = dirname($0) || $ENV{PWD} || '.';
        }
    }

    # the directory is the more important parameter between it and
    # the config parameter. if config is unreadable, then scan for
    # a config file using the directory as a base.  we support
    # either mt.cfg or mt-config.cgi for the config file name. the
    # latter being a more secure choice since it is unreadable from
    # a browser.
    for my $cfg_file ( $param->{Config},
        File::Spec->catfile( $param->{Directory}, 'mt-config.cgi' ),
        'mt-config.cgi' )
    {
        return $cfg_file if $cfg_file && -r $cfg_file && -f $cfg_file;
    }
    return undef;
}

sub init_schema {
    require MT::Object;
    MT::Object->install_pre_init_properties();
}

sub init_permissions {
    require MT::Permission;
    MT::Permission->init_permissions;
}

sub init_config {
    my $mt = shift;
    my ($param) = @_;

    unless ( $mt->{cfg_file} ) {
        my $cfg_file = $mt->find_config($param);

        return $mt->error(
            "Missing configuration file. Did you forgot to move mt-config.cgi-original to mt-config.cgi?"
        ) unless $cfg_file;
        $cfg_file = File::Spec->rel2abs($cfg_file);
        $mt->{cfg_file} = $cfg_file;
    }

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

    # also make note of the active application path; this is derived by
    # checking the PWD environment variable, the dirname of $0,
    # the directory of SCRIPT_FILENAME and lastly, falls back to mt_dir
    unless ( $mt->{app_dir} ) {
        $mt->{app_dir} = $ENV{PWD} || "";
        $mt->{app_dir} = dirname($0)
            if !$mt->{app_dir}
                || !File::Spec->file_name_is_absolute( $mt->{app_dir} );
        $mt->{app_dir} = dirname( $ENV{SCRIPT_FILENAME} )
            if $ENV{SCRIPT_FILENAME}
                && ( !$mt->{app_dir}
                    || (!File::Spec->file_name_is_absolute( $mt->{app_dir} ) )
                );
        $mt->{app_dir} ||= $mt->{mt_dir};
        $mt->{app_dir} = File::Spec->rel2abs( $mt->{app_dir} );
    }

    my $cfg = $mt->config;
    $cfg->define( $mt->registry('config_settings') );
    $cfg->read_config( $mt->{cfg_file} ) or return $mt->error( $cfg->errstr );

    my @mt_paths = $cfg->paths;
    for my $meth (@mt_paths) {
        my $path = $cfg->get( $meth, undef );
        my $type = $cfg->type($meth);
        if ( defined $path ) {
            if ( $type eq 'ARRAY' ) {
                my @paths = $cfg->get($meth);
                local $_;
                foreach (@paths) {
                    next if File::Spec->file_name_is_absolute($_);
                    $_ = File::Spec->catfile( $config_dir, $_ );
                }
                $cfg->$meth( \@paths );
            }
            else {
                next if ref($path);    # unexpected referene, ignore
                if ( !File::Spec->file_name_is_absolute($path) ) {
                    $path = File::Spec->catfile( $config_dir, $path );
                    $cfg->$meth($path);
                }
            }
        }
        else {
            next if $type eq 'ARRAY';
            my $path = $cfg->default($meth);
            if ( defined $path ) {
                $cfg->$meth( File::Spec->catfile( $config_dir, $path ) );
            }
        }
    }

    if ( my $local_lib = $cfg->LocalLib ) {
        $local_lib = [$local_lib] if !ref $local_lib;
        eval "use local::lib qw( @{$local_lib} )";
        return $mt->trans_error( 'Bad LocalLib config ([_1]): ',
            join( ', ', @$local_lib ), $@, )
            if $@;
    }

    return $mt->trans_error("Bad ObjectDriver config")
        unless $cfg->ObjectDriver;

    if ( $cfg->PerformanceLogging && $cfg->ProcessMemoryCommand ) {
        $mt->log_times();
    }

    $mt->set_language( $cfg->DefaultLanguage );

    my $cgi_path = $cfg->CGIPath;
    if ( !$cgi_path || $cgi_path =~ m!http://www\.example\.com/! ) {
        return $mt->trans_error("Bad CGIPath config");
    }

    $mt->{cfg} = $cfg;

    1;
}

{
    my ($memory_start);

    sub log_times {
        my $pkg = shift;

        my $timer = $pkg->get_timer;
        return unless $timer;

        my $memory;
        my $cmd = $pkg->config->ProcessMemoryCommand;
        if ($cmd) {
            my $re;
            if ( ref($cmd) eq 'HASH' ) {
                $re  = $cmd->{regex};
                $cmd = $cmd->{command};
            }
            $cmd =~ s/\$\$/$$/g;
            $memory = `$cmd`;
            if ($re) {
                if ( $memory =~ m/$re/ ) {
                    $memory = $1;
                    $memory =~ s/\D//g;
                }
            }
            else {
                $memory =~ s/\s+//gs;
            }
        }

        # Called at the start of the process; so we're only recording
        # the memory usage at the start of the app right now.
        unless ( $timer->{elapsed} ) {
            $memory_start = $memory;
            return;
        }

        require File::Spec;
        my $dir = MT->config('PerformanceLoggingPath') or return;

        my @time = localtime(time);
        my $file = sprintf(
            "pl-%04d%02d%02d.log",
            $time[5] + 1900,
            $time[4] + 1,
            $time[3]
        );
        my $log_file = File::Spec->catfile( $dir, $file );

        my $first_write = !-f $log_file;

        open my $PERFLOG, ">>", $log_file
            or ( warn("Failed to open preflog $log_file"), return );
        require Fcntl;
        flock( $PERFLOG, Fcntl::LOCK_EX() );

        if ($first_write) {
            require Config;
            my ( $osname, $osvers )
                = ( $Config::Config{osname}, $Config::Config{osvers} );
            print $PERFLOG "# Operating System: $osname/$osvers\n";
            print $PERFLOG "# Platform: $^O\n";
            my $ver
                = ref($^V) eq 'version'
                ? $^V->normal
                : ( $^V ? join( '.', unpack 'C*', $^V ) : $] );
            print $PERFLOG "# Perl Version: $ver\n";
            print $PERFLOG "# Web Server: $ENV{SERVER_SOFTWARE}\n";
            require MT::Object;
            my $driver = MT::Object->driver;

            if ($driver) {
                my $dbh = $driver->r_handle;
                if ($dbh) {
                    my $dbname = $dbh->get_info(17);    # SQL_DBMS_NAME
                    my $dbver  = $dbh->get_info(18);    # SQL_DBMS_VER
                    if ( $dbname && $dbver ) {
                        print $PERFLOG "# Database: $dbname/$dbver\n";
                    }
                }
            }
            my ( $drname, $drh ) = each %DBI::installed_drh;
            print $PERFLOG "# Database Library: DBI/"
                . $DBI::VERSION
                . "; DBD/"
                . $drh->{Version} . "\n";
            if ( $ENV{MOD_PERL} ) {
                print $PERFLOG "# App Mode: mod_perl\n";
            }
            elsif ( $ENV{FAST_CGI} ) {
                print $PERFLOG "# App Mode: FastCGI\n";
            }
            else {
                print $PERFLOG "# App Mode: CGI\n";
            }
        }

        if ($memory) {
            print $PERFLOG $timer->dump_line( "mem_start=$memory_start",
                "mem_end=$memory" );
        }
        else {
            print $PERFLOG $timer->dump_line();
        }

        close $PERFLOG;
    }
}

sub get_timer {
    my $mt = shift;
    $mt = MT->instance unless ref $mt;
    my $timer = $mt->request('timer');
    unless ( defined $timer ) {
        if ( MT->config('PerformanceLogging') ) {
            my $uri;
            if ( $mt->isa('MT::App') ) {
                $uri = $mt->uri( args => { $mt->param_hash } );
            }
            require MT::Util::ReqTimer;
            $timer = MT::Util::ReqTimer->new($uri);
        }
        else {
            $timer = 0;
        }
        $mt->request( 'timer', $timer );
    }
    return $timer;
}

sub time_this {
    my $mt = shift;
    my ( $str, $code ) = @_;
    my $timer = $mt->get_timer();
    my $ret;
    if ($timer) {
        $timer->pause_partial();
        $ret = $code->();
        $timer->mark($str);
    }
    else {
        $ret = $code->();
    }
    return $ret;
}

sub init_config_from_db {
    my $mt      = shift;
    my ($param) = @_;
    my $cfg     = $mt->config;

    # Tell any instantiated drivers to reconfigure themselves as necessary
    require MT::ObjectDriverFactory;
    if ( MT->config('ObjectDriver') ) {
        my $driver = MT::ObjectDriverFactory->instance;
        $driver->configure if $driver;
    }
    else {
        MT::ObjectDriverFactory->configure();
    }

    $cfg->read_config_db();

    1;
}

sub bootstrap {
    my $pkg = shift;
    $pkg->init_paths() or return;
    $pkg->init_core()  or return;
}

sub init_paths {
    my $mt = shift;
    my ($param) = @_;

    # determine MT directory
    my ($orig_dir);
    require File::Spec;
    if ( !( $MT_DIR = $ENV{MT_HOME} ) ) {
        if ( $0 =~ m!(.*([/\\]))! ) {
            $orig_dir = $MT_DIR = $1;
            my $slash = $2;
            $MT_DIR =~ s!(?:[/\\]|^)(?:plugins[/\\].*|tools[/\\])$!$slash!;
            $MT_DIR = '' if ( $MT_DIR =~ m!^\.?[\\/]$! );
        }
        else {

            # MT_DIR/lib/MT.pm -> MT_DIR/lib -> MT_DIR
            $MT_DIR = dirname( dirname( File::Spec->rel2abs(__FILE__) ) );
        }
        unless ($MT_DIR) {
            $orig_dir = $MT_DIR = $ENV{PWD} || '.';
            $MT_DIR =~ s!(?:[/\\]|^)(?:plugins[/\\].*|tools[/\\]?)$!!;
        }
        $ENV{MT_HOME} = $MT_DIR;
    }
    unshift @INC, File::Spec->catdir( $MT_DIR,   'extlib' );
    unshift @INC, File::Spec->catdir( $orig_dir, 'lib' )
        if $orig_dir && ( $orig_dir ne $MT_DIR );

    $mt->set_language('en_US');

    if ( my $cfg_file = $mt->find_config($param) ) {
        $cfg_file = File::Spec->rel2abs($cfg_file);
        $CFG_FILE = $cfg_file;
    }
    else {
        return $mt->trans_error(
            "Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?"
        ) if ref($mt);
    }

    # store the mt_dir (home) as an absolute path; fallback to the config
    # directory if it isn't set.
    $MT_DIR ||=
        $param->{directory}
        ? File::Spec->rel2abs( $param->{directory} )
        : $CFG_DIR;
    $MT_DIR ||= dirname($0);

    # also make note of the active application path; this is derived by
    # checking the PWD environment variable, the dirname of $0,
    # the directory of SCRIPT_FILENAME and lastly, falls back to mt_dir
    $APP_DIR = $ENV{PWD} || "";
    $APP_DIR = dirname($0)
        if !$APP_DIR || !File::Spec->file_name_is_absolute($APP_DIR);
    $APP_DIR = dirname( $ENV{SCRIPT_FILENAME} )
        if $ENV{SCRIPT_FILENAME}
            && ( !$APP_DIR
                || ( !File::Spec->file_name_is_absolute($APP_DIR) ) );
    $APP_DIR ||= $MT_DIR;
    $APP_DIR = File::Spec->rel2abs($APP_DIR);

    return 1;
}

sub init_core {
    my $mt = shift;
    return if exists $Components{'core'};
    require MT::Core;
    my $c = MT::Core->new( { id => 'core', path => $MT_DIR } )
        or die MT::Core->errstr;
    $Components{'core'} = $c;

    push @Components, $c;
    return 1;
}

sub i18n_default_settings {
    my %settings = (
        'NewsboxURL'         => 'NEWSBOX_URL',
        'SupportURL'         => 'SUPPORT_URL',
        'NewsURL'            => 'NEWS_URL',
        'DefaultTimezone'    => 'DEFAULT_TIMEZONE',
        'TimeOffset'         => 'DEFAULT_TIMEZONE',
        'MailEncoding'       => 'MAIL_ENCODING',
        'ExportEncoding'     => 'EXPORT_ENCODING',
        'LogExportEncoding'  => 'LOG_EXPORT_ENCODING',
        'CategoryNameNodash' => 'CATEGORY_NAME_NODASH',
        'PublishCharset'     => 'PUBLISH_CHARSET',
        'FeedbackURL'        => 'FEEDBACK_URL',
    );

    foreach my $key ( keys %settings ) {
        $settings{$key} = const( $settings{$key} );
    }

    \%settings;
}

sub init_lang_defaults {
    my $mt  = shift;
    my $cfg = $mt->config;
    $cfg->DefaultLanguage('en_US') unless $cfg->DefaultLanguage;

    my $settings = $mt->i18n_default_settings;
    foreach my $key ( keys %$settings ) {
        $cfg->default( $key, $settings->{$key} );
    }

    return 1;
}

sub init {
    my $mt    = shift;
    my %param = @_;

    $mt->bootstrap() unless $MT_DIR;
    $mt->{mt_dir}     = $MT_DIR;
    $mt->{config_dir} = $CFG_DIR;
    $mt->{app_dir}    = $APP_DIR;

    $mt->init_callbacks();

    ## Initialize the language to the default in case any errors occur in
    ## the rest of the initialization process.
    $mt->init_config( \%param ) or return;
    $mt->init_lang_defaults(@_) or return;
    require MT::Plugin;
    $mt->init_addons(@_) or return;
    $mt->init_config_from_db( \%param ) or return;
    $mt->init_debug_mode;
    $mt->init_plugins(@_) or return;
    $plugins_installed = 1;
    $mt->init_schema();
    $mt->init_permissions();

    # Load MT::Log so constants are available
    require MT::Log;

    $mt->run_callbacks( 'post_init', $mt, \%param );
    return $mt;
}

sub init_debug_mode {
    my $mt  = shift;
    my $cfg = $mt->config;

    # init the debug mode
    if ( $MT::DebugMode = $cfg->DebugMode ) {
        require Data::Dumper;
        $Data::Dumper::Terse    = 1;
        $Data::Dumper::Maxdepth = 4;
        $Data::Dumper::Sortkeys = 1;
        $Data::Dumper::Indent   = 1;
    }
}

{
    my $callbacks_added;

    sub init_callbacks {
        my $mt = shift;
        return if $callbacks_added;
        MT->_register_core_callbacks(
            {   'build_file_filter' =>
                    sub { MT->publisher->queue_build_file_filter(@_) },
                'cms_upload_file' => \&core_upload_file_to_sync,
                'api_upload_file' => \&core_upload_file_to_sync,
                'post_init' =>
                    '$Core::MT::Summary::Triggers::post_init_add_triggers',
            }
        );
        $callbacks_added = 1;
    }
}

sub core_upload_file_to_sync {
    my ( $cb, %args ) = @_;
    MT->upload_file_to_sync(%args);
}

sub upload_file_to_sync {
    my $class = shift;
    my (%args) = @_;

    # no need to do this unless we're syncing stuff.
    return unless MT->config('SyncTarget');

    my $url  = $args{url};
    my $file = $args{file};
    return unless -f $file;

    my $blog    = $args{blog};
    my $blog_id = $blog->id;
    return unless $blog->publish_queue;

    require MT::FileInfo;
    my $base_url = $url;
    $base_url =~ s!^https?://[^/]+!!;
    my $fi = MT::FileInfo->load( { blog_id => $blog_id, url => $base_url } );
    if ( !$fi ) {
        $fi = MT::FileInfo->new();
        $fi->blog_id($blog_id);
        $fi->url($base_url);
    }
    $fi->file_path($file);
    $fi->save;

    require MT::TheSchwartz;
    require TheSchwartz::Job;
    my $job = TheSchwartz::Job->new();
    $job->funcname('MT::Worker::Sync');
    $job->uniqkey( $fi->id );
    $job->coalesce(
        ( $fi->blog_id || 0 ) . ':' . $$ . ':' . ( time - ( time % 10 ) ) );
    MT::TheSchwartz->insert($job);
}

sub init_addons {
    my $mt  = shift;
    my $cfg = $mt->config;
    my @PluginPaths;

    unshift @PluginPaths, File::Spec->catdir( $MT_DIR, 'addons' );
    return $mt->_init_plugins_core( {}, 1, \@PluginPaths );
}

sub init_plugins {
    my $mt = shift;

    # Load compatibility module for prior version
    # This should always be MT::Compat::v(MAJOR_RELEASE_VERSION - 1).
    if ( MT->config('RequiredCompatibility') < 4.0 ) {
        require MT::Compat::v3;
    }

    my $cfg          = $mt->config;
    my $use_plugins  = $cfg->UsePlugins;
    my @PluginPaths  = $cfg->PluginPath;
    my $PluginSwitch = $cfg->PluginSwitch || {};
    return $mt->_init_plugins_core( $PluginSwitch, $use_plugins,
        \@PluginPaths );
}

{
    my $plugin_full_path;

    sub add_plugin {
        my $class = shift;
        my ($plugin) = @_;
        if ( ref $plugin eq 'HASH' ) {
            require MT::Plugin;
            $plugin = MT::Plugin->new($plugin);
        }
        $plugin->{name} ||= $plugin_sig;
        $plugin->{plugin_sig} = $plugin_sig;

        my $id = $plugin->id;
        unless ($plugin_envelope) {
            warn
                "MT->add_plugin improperly called outside of MT plugin load loop.";
            return;
        }
        $plugin->envelope($plugin_envelope);
        Carp::confess(
            "You cannot register multiple plugin objects from a single script. $plugin_sig"
            )
            if exists( $Plugins{$plugin_sig} )
                && ( exists $Plugins{$plugin_sig}{object} );

        $Components{ lc $id } = $plugin if $id;
        $Plugins{$plugin_sig}{object} = $plugin;
        $plugin->{full_path} = $plugin_full_path;
        $plugin->path($plugin_full_path);
        unless ( $plugin->{registry} && ( %{ $plugin->{registry} } ) ) {
            $plugin->{registry} = $plugin_registry;
        }
        if ( $plugin->{registry} ) {
            if ( my $settings = $plugin->{registry}{config_settings} ) {
                $settings = $plugin->{registry}{config_settings}
                    = $settings->()
                    if ref($settings) eq 'CODE';
                $class->config->define($settings) if $settings;
            }
        }
        push @Components, $plugin;
        1;
    }

    sub __load_plugin {
        my ( $mt, $timer, $PluginSwitch, $use_plugins, $plugin, $sig ) = @_;
        die "Bad plugin filename '$plugin'"
            if ( $plugin !~ /^([-\\\/\@\:\w\.\s~]+)$/ );
        local $plugin_sig      = $sig;
        local $plugin_registry = {};
        if (!$use_plugins
            || ( exists $PluginSwitch->{$plugin_sig}
                && !$PluginSwitch->{$plugin_sig} )
            )
        {
            $Plugins{$plugin_sig}{full_path} = $plugin_full_path;
            $Plugins{$plugin_sig}{enabled}   = 0;
            return 0;
        }
        return 0 if exists $Plugins{$plugin_sig};
        $Plugins{$plugin_sig}{full_path} = $plugin_full_path;
        $timer->pause_partial if $timer;
        eval "# line " . __LINE__ . " " . __FILE__ . "\nrequire '$plugin';";
        $timer->mark( "Loaded plugin " . $sig ) if $timer;
        if ($@) {
            $Plugins{$plugin_sig}{error} = $@;

            # Issue MT log within another eval block in the
            # event that the plugin error is happening before
            # the database has been initialized...
            eval {
                require MT::Log;
                $mt->log(
                    {   message => $mt->translate(
                            "Plugin error: [_1] [_2]", $plugin,
                            $Plugins{$plugin_sig}{error}
                        ),
                        class    => 'system',
                        category => 'plugin',
                        level    => MT::Log::ERROR()
                    }
                );
            };
            return 0;
        }
        else {
            if ( my $obj = $Plugins{$plugin_sig}{object} ) {
                $obj->init_callbacks();
            }
            else {

                # A plugin did not register itself, so
                # create a dummy plugin object which will
                # cause it to show up in the plugin listing
                # by it's filename.
                MT->add_plugin( {} );
            }
        }
        $Plugins{$plugin_sig}{enabled} = 1;
        return 1;
    }

    sub __load_plugin_with_yaml {
        my ( $use_plugins, $PluginSwitch, $plugin_dir ) = @_;
        my $pclass
            = $plugin_dir =~ m/\.pack$/
            ? 'MT::Component'
            : 'MT::Plugin';

        # Don't process disabled plugin config.yaml files.
        if ($pclass eq 'MT::Plugin'
            && (!$use_plugins
                || ( exists $PluginSwitch->{$plugin_dir}
                    && !$PluginSwitch->{$plugin_dir} )
            )
            )
        {
            $Plugins{$plugin_dir}{full_path} = $plugin_full_path;
            $Plugins{$plugin_dir}{enabled}   = 0;
            return;
        }
        return if exists $Plugins{$plugin_dir};
        my $id = lc $plugin_dir;
        $id =~ s/\.\w+$//;
        my $p = $pclass->new(
            {   id       => $id,
                path     => $plugin_full_path,
                envelope => $plugin_envelope
            }
        );

        # rebless? based on config?
        local $plugin_sig = $plugin_dir;
        MT->add_plugin($p);
        $p->init_callbacks();
    }

    sub _init_plugins_core {
        my $mt = shift;
        my ( $PluginSwitch, $use_plugins, $PluginPaths ) = @_;

        my $timer;
        if ( $mt->config->PerformanceLogging ) {
            $timer = $mt->get_timer();
        }

        foreach my $PluginPath (@$PluginPaths) {
            my $plugin_lastdir = $PluginPath;
            $plugin_lastdir =~ s![\\/]$!!;
            $plugin_lastdir =~ s!^.*[\\/]!!;

            if ( opendir my $DH, $PluginPath ) {
                my @p = readdir $DH;
                closedir $DH;
                for my $plugin (@p) {
                    next if ( $plugin =~ /^\.\.?$/ || $plugin =~ /~$/ );

                    $plugin_full_path
                        = File::Spec->catfile( $PluginPath, $plugin );
                    if ( -f $plugin_full_path ) {
                        $plugin_envelope = $plugin_lastdir;
                        __load_plugin( $mt, $timer, $PluginSwitch,
                            $use_plugins, $plugin_full_path, $plugin )
                            if $plugin_full_path =~ /\.pl$/;
                        next;
                    }

                    my $plugin_dir = $plugin;
                    $plugin_envelope = "$plugin_lastdir/" . $plugin;

                    foreach my $lib (qw(lib extlib)) {
                        my $plib
                            = File::Spec->catdir( $plugin_full_path, $lib );
                        unshift @INC, $plib if -d $plib;
                    }

                    # handle config.yaml
                    my $yaml = File::Spec->catdir( $plugin_full_path,
                        'config.yaml' );

                    if ( -f $yaml ) {
                        __load_plugin_with_yaml( $use_plugins, $PluginSwitch,
                            $plugin_dir );
                        next;
                    }

                    my @plugins;
                    if ( opendir my $subdir, $plugin_full_path ) {
                        @plugins = readdir $subdir;
                        closedir $subdir;
                    }
                    else {
                        warn "Can not read directory: $plugin_full_path";
                    }
                    for my $plugin (@plugins) {
                        next if $plugin !~ /\.pl$/;
                        my $plugin_file
                            = File::Spec->catfile( $plugin_full_path,
                            $plugin );
                        if ( -f $plugin_file ) {
                            __load_plugin( $mt, $timer, $PluginSwitch,
                                $use_plugins, $plugin_file,
                                $plugin_dir . '/' . $plugin );
                        }
                    }
                }
            }
        }

        # Reset the Text_filters hash in case it was preloaded by plugins by
        # calling all_text_filters (Markdown in particular does this).
        # Upon calling all_text_filters again, it will be properly loaded by
        # querying the registry.
        %Text_filters = ();

        1;
    }

}

my %addons;

sub find_addons {
    my $mt = shift;
    my ($type) = @_;

    unless (%addons) {
        my $addon_path = File::Spec->catdir( $MT_DIR, 'addons' );
        if ( opendir my $DH, $addon_path ) {
            my @p = readdir $DH;
            closedir $DH;
            foreach my $p (@p) {
                next if $p eq '.' || $p eq '..';
                my $full_path = File::Spec->catdir( $addon_path, $p );
                if ( -d $full_path ) {
                    if ( $p =~ m/^(.+)\.(\w+)$/ ) {
                        my $label = $1;
                        my $id    = lc $1;
                        my $type  = $2;
                        if ( $type eq 'pack' ) {
                            $label .= ' Pack';
                        }
                        elsif ( $type eq 'theme' ) {
                            $label .= ' Theme';
                        }
                        elsif ( $type eq 'plugin' ) {
                            $label .= ' Plugin';
                        }
                        push @{ $addons{$type} },
                            {
                            label    => $label,
                            id       => $id,
                            envelope => 'addons/' . $p . '/',
                            path     => $full_path,
                            };
                    }
                }
            }
        }
    }
    if ($type) {
        my $addons = $addons{$type} ||= [];
        return $addons;
    }
    return 1;
}

*mt_dir = \&server_path;
sub server_path { $_[0]->{mt_dir} }
sub app_dir     { $_[0]->{app_dir} }
sub config_dir  { $_[0]->{config_dir} }

sub component {
    my $mt = shift;
    my ($id) = @_;
    return $Components{ lc $id };
}

sub publisher {
    my $mt = shift;
    $mt = $mt->instance unless ref $mt;
    require MT::WeblogPublisher;
    $mt->request('WeblogPublisher')
        || $mt->request( 'WeblogPublisher', new MT::WeblogPublisher() );
}

sub rebuild {
    my $mt = shift;
    $mt->publisher->rebuild(@_)
        or return $mt->error( $mt->publisher->errstr );
}

sub rebuild_entry {
    my $mt = shift;
    $mt->publisher->rebuild_entry(@_)
        or return $mt->error( $mt->publisher->errstr );
}

sub rebuild_indexes {
    my $mt = shift;
    $mt->publisher->rebuild_indexes(@_)
        or return $mt->error( $mt->publisher->errstr );
}

sub rebuild_archives {
    my $mt = shift;
    $mt->publisher->rebuild_archives(@_)
        or return $mt->error( $mt->publisher->errstr );
}

sub ping {
    my $mt    = shift;
    my %param = @_;
    my $blog;
    require MT::Entry;
    require MT::Util;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
            or return $mt->trans_error( "Loading of blog '[_1]' failed: [_2]",
            $blog_id, MT::Blog->errstr );
    }

    my (@res);

    my $send_updates = 1;
    if ( exists $param{OldStatus} ) {
        ## If this is a new entry (!$old_status) OR the status was previously
        ## set to draft, and is now set to publish, send the update pings.
        my $old_status = $param{OldStatus};
        if ( $old_status && $old_status eq MT::Entry::RELEASE() ) {
            $send_updates = 0;
        }
    }

    if ( $send_updates && !( MT->config->DisableNotificationPings ) ) {
        ## Send update pings.
        my @updates = $mt->update_ping_list($blog);
        for my $url (@updates) {
            require MT::XMLRPC;
            if (MT::XMLRPC->ping_update( 'weblogUpdates.ping', $blog, $url ) )
            {
                push @res, { good => 1, url => $url, type => "update" };
            }
            else {
                my $err = MT::XMLRPC->errstr;
                $err = Encode::decode_utf8($err)
                    if ( $err && !Encode::is_utf8($err) );
                push @res,
                    {
                    good  => 0,
                    url   => $url,
                    type  => "update",
                    error => $err,
                    };
            }
        }
        if ( $blog->mt_update_key ) {
            require MT::XMLRPC;
            if ( MT::XMLRPC->mt_ping($blog) ) {
                push @res,
                    {
                    good => 1,
                    url  => $mt->{cfg}->MTPingURL,
                    type => "update"
                    };
            }
            else {
                my $err = MT::XMLRPC->errstr;
                $err = Encode::decode_utf8($err)
                    if ( $err && !Encode::is_utf8($err) );
                push @res,
                    {
                    good  => 0,
                    url   => $mt->{cfg}->MTPingURL,
                    type  => "update",
                    error => $err,
                    };
            }
        }
    }

    my $cfg     = $mt->{cfg};
    my $send_tb = $cfg->OutboundTrackbackLimit;
    return \@res if $send_tb eq 'off';

    my @tb_domains;
    if ( $send_tb eq 'selected' ) {
        @tb_domains = $cfg->OutboundTrackbackDomains;
    }
    elsif ( $send_tb eq 'local' ) {
        my $iter = MT::Blog->load_iter();
        while ( my $b = $iter->() ) {
            next if $b->id == $blog->id;
            push @tb_domains, MT::Util::extract_domains( $b->site_url );
        }
    }
    my $tb_domains = join '|', map { lc quotemeta $_ } @tb_domains;
    $tb_domains = qr/(?:^|\.)$tb_domains$/ if $tb_domains;

    ## Send TrackBack pings.
    if ( my $entry = $param{Entry} ) {
        my $pings = $entry->to_ping_url_list;

        my %pinged = map { $_ => 1 } @{ $entry->pinged_url_list };
        my $cats = $entry->categories;
        for my $cat (@$cats) {
            push @$pings, grep !$pinged{$_}, @{ $cat->ping_url_list };
        }

        my $ua = MT->new_ua;

        ## Build query string to be sent on each ping.
        my @qs;
        push @qs, 'title=' . MT::Util::encode_url( $entry->title );
        push @qs, 'url=' . MT::Util::encode_url( $entry->permalink );
        push @qs, 'excerpt=' . MT::Util::encode_url( $entry->get_excerpt );
        push @qs, 'blog_name=' . MT::Util::encode_url( $blog->name );
        my $qs = join '&', @qs;

        ## Character encoding--best guess.
        my $enc = $mt->{cfg}->PublishCharset;

        for my $url (@$pings) {
            $url =~ s/^\s*//;
            $url =~ s/\s*$//;
            my $url_domain;
            ($url_domain) = MT::Util::extract_domains($url);
            next if $tb_domains && ( lc($url_domain) !~ $tb_domains );

            my $req = HTTP::Request->new( POST => $url );
            $req->content_type(
                "application/x-www-form-urlencoded; charset=$enc");
            $req->content($qs);
            my $res = $ua->request($req);
            if ( substr( $res->code, 0, 1 ) eq '2' ) {
                my $c = $res->content;
                $c = Encode::decode_utf8($c) if !Encode::is_utf8($c);
                my ( $error, $msg )
                    = $c =~ m!<error>(\d+).*<message>(.+?)</message>!s;
                if ($error) {
                    push @res,
                        {
                        good  => 0,
                        url   => $url,
                        type  => 'trackback',
                        error => $msg,
                        };
                }
                else {
                    push @res,
                        { good => 1, url => $url, type => 'trackback' };
                }
            }
            else {
                push @res,
                    {
                    good  => 0,
                    url   => $url,
                    type  => 'trackback',
                    error => "HTTP error: " . $res->status_line
                    };
            }
        }
    }
    \@res;
}

sub ping_and_save {
    my $mt    = shift;
    my %param = @_;
    if ( my $entry = $param{Entry} ) {
        my $results = MT::ping( $mt, @_ ) or return;
        my %still_ping;
        my $pinged = $entry->pinged_url_list;
        for my $res (@$results) {
            next if $res->{type} ne 'trackback';
            if ( !$res->{good} ) {
                $still_ping{ $res->{url} } = 1;
            }
            push @$pinged, $res->{url}
                . (
                $res->{good}
                ? ''
                : ' ' . $res->{error}
                );
        }
        $entry->pinged_urls( join "\n", @$pinged );
        $entry->to_ping_urls( join "\n", keys %still_ping );
        $entry->save or return $mt->error( $entry->errstr );
        return $results;
    }
    1;
}

sub needs_ping {
    my $mt    = shift;
    my %param = @_;
    my $blog  = $param{Blog};
    my $entry = $param{Entry};
    require MT::Entry;
    return unless $entry->status == MT::Entry::RELEASE();
    my $old_status = $param{OldStatus};
    my %list;
    ## If this is a new entry (!$old_status) OR the status was previously
    ## set to draft, and is now set to publish, send the update pings.
    if ( ( !$old_status || $old_status ne MT::Entry::RELEASE() )
        && !( MT->config->DisableNotificationPings ) )
    {
        my @updates = $mt->update_ping_list($blog);
        @list{@updates} = (1) x @updates;
        $list{ $mt->{cfg}->MTPingURL } = 1 if $blog && $blog->mt_update_key;
    }
    if ($entry) {
        @list{ @{ $entry->to_ping_url_list } } = ();
        my %pinged = map { $_ => 1 } @{ $entry->pinged_url_list };
        my $cats = $entry->categories;
        for my $cat (@$cats) {
            @list{ grep !$pinged{$_}, @{ $cat->ping_url_list } } = ();
        }
    }
    my @list = keys %list;
    return unless @list;
    \@list;
}

sub update_ping_list {
    my $mt = shift;
    my ($blog) = @_;

    my @updates;
    if ( my $pings = MT->registry('ping_servers') ) {
        my $up = $blog->update_pings;
        if ($up) {
            foreach ( split ',', $up ) {
                next unless exists $pings->{$_};
                push @updates, $pings->{$_}->{url};
            }
        }
    }
    if ( my $others = $blog->ping_others ) {
        push @updates, split /\r?\n/, $others;
    }
    my %updates;
    for my $url (@updates) {
        for ($url) {
            s/^\s*//;
            s/\s*$//;
        }
        next unless $url =~ /\S/;
        $updates{$url}++;
    }
    keys %updates;
}

{
    my $LH;

    sub set_language {
        my $pkg = shift;
        require MT::L10N;
        $LH = MT::L10N->get_handle(@_);

        # Clear any l10n_handles in request
        $pkg->request( 'l10n_handle', {} );
        return $LH;
    }

    sub translate {
        my $this = shift;
        my $app = ref($this) ? $this : $this->app;
        if ( $app->{component} ) {
            if ( my $c = $app->component( $app->{component} ) ) {
                local $app->{component} = undef;
                return $c->translate(@_);
            }
        }
        my ( $format, @args ) = @_;
        foreach (@args) {
            $_ = $_->() if ref($_) eq 'CODE';
        }
        my $text = $LH->maketext( $format, @args );
        return $text;
    }

    sub translate_templatized {
        my $mt = shift;
        my $app = ref($mt) ? $mt : $mt->app;
        if ( $app->{component} ) {
            if ( my $c = $app->component( $app->{component} ) ) {
                local $app->{component} = undef;
                return $c->translate_templatized(@_);
            }
        }
        my @cstack;
        my ($text) = @_;

        # Here, the text must be handled as binary ( non utf-8 ) data,
        # because regexp for utf-8 string is too heavy.
        # things we have to do is
        #  * encode $text before parse
        #  * decode the strings captured by regexp
        #  * encode the translated string from translate()
        #  * decode again for return
        $text = Encode::encode( 'utf8', $text )
            if Encode::is_utf8($text);
        while (1) {
            return '' unless $text;
            $text
                =~ s!(<(/)?(?:_|MT)_TRANS(_SECTION)?(?:(?:\s+((?:\w+)\s*=\s*(["'])(?:(<(?:[^"'>]|"[^"]*"|'[^']*')+)?>|[^\5]+?)*?\5))+?\s*/?)?>)!
            my($msg, $close, $section, %args) = ($1, $2, $3);
            while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<(?:[^"'>]|"[^"]*"|'[^']*')+?>|[^\2])*?)?\2/g) {  #"
                $args{$1} = Encode::decode_utf8($3);
            }
            if ($section) {
                if ($close) {
                    $mt = pop @cstack;
                } else {
                    if ($args{component}) {
                        push @cstack, $mt;
                        $mt = MT->component($args{component})
                            or die "Bad translation component: $args{component}";
                    }
                    else {
                        die "__trans_section without a component argument";
                    }
                }
                '';
            }
            else {
                $args{params} = '' unless defined $args{params};
                my @p = map MT::Util::decode_html($_),
                        split /\s*%%\s*/, $args{params}, -1;
                @p = ('') unless @p;
                my $phrase = $args{phrase};
                $phrase = Encode::decode('utf8', $phrase)
                    unless Encode::is_utf8($phrase);
                my $translation = $mt->translate($phrase, @p);
                if (exists $args{escape}) {
                    if (lc($args{escape}) eq 'html') {
                        $translation = MT::Util::encode_html($translation);
                    } elsif (lc($args{escape}) eq 'url') {
                        $translation = MT::Util::encode_url($translation);
                    } else {
                        # fallback for js/javascript/singlequotes
                        $translation = MT::Util::encode_js($translation);
                    }
                }
                $translation = Encode::encode('utf8', $translation)
                    if Encode::is_utf8($translation);
                $translation;
            }
            !igem or last;
        }
        $text = Encode::decode_utf8($text)
            unless Encode::is_utf8($text);
        return $text;
    }

    sub current_language { $LH->language_tag }
    sub language_handle  {$LH}

    sub charset {
        my $mt = shift;
        $mt->{charset} = shift if @_;
        return $mt->{charset} if $mt->{charset};
        $mt->{charset} = $mt->config->PublishCharset
            || $mt->language_handle->encoding;
    }
}

sub supported_languages {
    my $mt = shift;
    require MT::L10N;
    require File::Basename;
    ## Determine full path to lib/MT/L10N directory...
    my $lib
        = File::Spec->catdir( File::Basename::dirname( $INC{'MT/L10N.pm'} ),
        'L10N' );
    ## ... From that, determine full path to extlib/MT/L10N.
    ## To do that, we look for the last instance of the string 'lib'
    ## in $lib and replace it with 'extlib'. reverse is a nice tricky
    ## way of doing that.
    ( my $extlib = reverse $lib ) =~ s!bil!biltxe!;
    $extlib = reverse $extlib;
    my @dirs = ( $lib, $extlib );
    my %langs;
    for my $dir (@dirs) {
        opendir my $DH, $dir or next;
        for my $f ( readdir $DH ) {
            my ($tag) = $f =~ /^(\w+)\.pm$/;
            next unless $tag;
            my $lh = MT::L10N->get_handle($tag);
            $langs{ $lh->language_tag } = $lh->language_name;
        }
        closedir $DH;
    }
    \%langs;
}

# For your convenience
sub trans_error {
    my $app = shift;
    $app->error( $app->translate(@_) );
}

sub all_text_filters {
    unless (%Text_filters) {
        if ( my $filters = MT->registry('text_filters') ) {
            %Text_filters = %$filters if ref($filters) eq 'HASH';
        }
    }
    if ( my $enabled_filters = MT->config('AllowedTextFilters') ) {
        my %enabled = map { $_ => 1 } split /\s*,\s*/, $enabled_filters;
        %Text_filters = map { $_ => $Text_filters{$_} }
            grep { exists $enabled{$_} }
            keys %Text_filters;
    }
    return \%Text_filters;
}

sub apply_text_filters {
    my $mt = shift;
    my ( $str, $filters, @extra ) = @_;
    my $all_filters = $mt->all_text_filters;
    for my $filter (@$filters) {
        my $f = $all_filters->{$filter} or next;
        my $code = $f->{code} || $f->{handler};
        unless ( ref($code) eq 'CODE' ) {
            $code = $mt->handler_to_coderef($code);
            $f->{code} = $code;
        }
        if ( !$code ) {
            warn "Bad text filter: $filter";
            next;
        }
        $str = $code->( $str, @extra );
    }
    $str = Encode::decode_utf8($str)
        if !Encode::is_utf8($str);
    return $str;
}

sub static_path {
    my $app   = shift;
    my $spath = $app->config->StaticWebPath;
    if ( !$spath ) {
        $spath = $app->config->CGIPath;
        $spath .= '/' unless $spath =~ m!/$!;
        $spath .= 'mt-static/';
    }
    else {
        $spath .= '/' unless $spath =~ m!/$!;
    }
    $spath;
}

sub static_file_path {
    my $app = shift;
    return $app->{__static_file_path}
        if exists $app->{__static_file_path};

    my $path = $app->config('StaticFilePath');
    return $app->{__static_file_path} = $path if defined $path;

    # Attempt to derive StaticFilePath based on environment
    my $web_path = $app->config->StaticWebPath || 'mt-static';
    $web_path =~ s!^https?://[^/]+/!!;
    if ( $app->can('document_root') ) {
        my $doc_static_path
            = File::Spec->catdir( $app->document_root(), $web_path );
        return $app->{__static_file_path} = $doc_static_path
            if -d $doc_static_path;
    }
    my $mtdir_static_path = File::Spec->catdir( $app->mt_dir, 'mt-static' );
    return $app->{__static_file_path} = $mtdir_static_path
        if -d $mtdir_static_path;
    return;
}

sub support_directory_url {
    my $app = shift;
    my $url = $app->config->SupportDirectoryURL;
    if ( !$url ) {
        my $spath = $app->static_path;
        $spath .= '/' unless $spath =~ m!/$!;
        $url = $spath . 'support/';
    }
    else {
        $url .= '/' unless $url =~ m!/$!;
    }
    $url;
}

sub support_directory_path {
    my $app  = shift;
    my $path = $app->config('SupportDirectoryPath');
    if ($path) {
        if ( $path !~ m{^/|^[a-zA-Z]:\\|^\\\\[a-zA-Z0-9\.]+} ) {
            return File::Spec->catdir( $app->path, $path );
        }
        return $path;
    }
    else {
        return File::Spec->catdir( $app->static_file_path, 'support' );
    }
}

sub template_paths {
    my $mt = shift;
    my @paths;
    if ( $mt->{plugin_template_path} ) {
        if (File::Spec->file_name_is_absolute( $mt->{plugin_template_path} ) )
        {
            push @paths, $mt->{plugin_template_path}
                if -d $mt->{plugin_template_path};
        }
        else {
            my $dir = File::Spec->catdir( $mt->app_dir,
                $mt->{plugin_template_path} );
            if ( -d $dir ) {
                push @paths, $dir;
            }
            else {
                $dir = File::Spec->catdir( $mt->mt_dir,
                    $mt->{plugin_template_path} );
                push @paths, $dir if -d $dir;
            }
        }
    }
    my @alt_paths = $mt->config('AltTemplatePath');
    foreach my $alt_path (@alt_paths) {
        if ( -d $alt_path ) {    # AltTemplatePath is absolute
            push @paths, File::Spec->catdir( $alt_path, $mt->{template_dir} )
                if $mt->{template_dir};
            push @paths, $alt_path;
        }
    }

    for my $addon ( @{ $mt->find_addons('pack') } ) {
        push @paths,
            File::Spec->catdir( $addon->{path}, 'tmpl', $mt->{template_dir} )
            if $mt->{template_dir};
        push @paths, File::Spec->catdir( $addon->{path}, 'tmpl' );
    }

    my $path = $mt->config->TemplatePath;
    push @paths, File::Spec->catdir( $path, $mt->{template_dir} )
        if $mt->{template_dir};
    push @paths, $path;

    return @paths;
}

sub find_file {
    my $mt = shift;
    my ( $paths, $file ) = @_;
    my $filename;
    foreach my $p (@$paths) {
        my $filepath
            = File::Spec->canonpath( File::Spec->catfile( $p, $file ) );
        $filename = File::Spec->canonpath($filepath);
        return $filename if -f $filename;
    }
    undef;
}

sub load_global_tmpl {
    my $app = shift;
    my ( $arg, $blog_id ) = @_;
    $blog_id
        = $blog_id ? [ $blog_id, 0 ]
        : MT->app->blog ? [ MT->app->blog->id, 0 ]
        :                 0;

    my $terms = {};
    if ( 'HASH' eq ref($arg) ) {
        $terms = { %$arg, blog_id => $blog_id };
    }
    else {
        $terms = {
            type    => $arg,
            blog_id => $blog_id,
        };
    }
    my $args;
    if ( ref $blog_id eq 'ARRAY' ) {
        $args->{sort}      = 'blog_id';
        $args->{direction} = 'descend';
        $args->{limit}     = 1;
    }
    require MT::Template;
    my $tmpl = MT::Template->load( $terms, $args );
    $app->set_default_tmpl_params($tmpl) if $tmpl;
    $tmpl;
}

sub load_tmpl {
    my $mt = shift;
    if ( exists( $mt->{component} ) && ( lc( $mt->{component} ) ne 'core' ) )
    {
        if ( my $c = $mt->component( $mt->{component} ) ) {
            return $c->load_tmpl(@_);
        }
    }

    my ( $file, @p ) = @_;
    my $param;
    if ( @p && ( ref( $p[$#p] ) eq 'HASH' ) ) {
        $param = pop @p;
    }
    my $cfg = $mt->config;
    require MT::Template;
    my $tmpl;
    my @paths = $mt->template_paths;

    my $type
        = { 'SCALAR' => 'scalarref', 'ARRAY' => 'arrayref' }->{ ref $file }
        || 'filename';
    $tmpl = MT::Template->new(
        type   => $type,
        source => $file,
        path   => \@paths,
        filter => sub {
            my ( $str, $fname ) = @_;
            if ($fname) {
                $fname = File::Basename::basename($fname);
                $fname =~ s/\.tmpl$//;
                $mt->run_callbacks( "template_source.$fname", $mt, @_ );
            }
            else {
                $mt->run_callbacks( "template_source", $mt, @_ );
            }
            return $str;
        },
        @p
    );
    return $mt->error(
        $mt->translate( "Loading template '[_1]' failed.", $file ) )
        unless $tmpl;
    $mt->set_default_tmpl_params($tmpl);
    $tmpl->param($param) if $param;
    $tmpl;
}

sub _svn_revision {
    my $mt      = shift;
    my $wc_base = $mt->mt_dir;
    return unless -d File::Spec->catdir( $wc_base, '.git' );

    # Currently, we are on the Github.
    return
        unless ( -e $wc_base && open my $fh, '-|', "git status" );

    my $revision = '';
    if ( -e $wc_base && open my $fh,
        '-|', "git log --pretty=format:'' | wc -l" )
    {
        $revision = do { local $/ = undef; <$fh> };
        chomp $revision;
        $revision =~ s/\s*(.*)/r$1/;
        close $fh;
    }

    my $hash = '';
    if ( -e $wc_base && open my $fh, '-|', "git log -1 | grep commit" ) {
        $hash = do { local $/ = undef; <$fh> };
        chomp $hash;
        if ( $hash =~ s/commit (.*)/$1/ ) {
            $hash = substr( $hash, 0, 8 );
        }
        close $fh;
    }

    my $branch = '';
    if ( -e $wc_base && open my $fh, '-|', "git branch" ) {
        $branch = do { local $/ = undef; <$fh> };
        chomp $branch;
        if ( $branch =~ m/\*\s(.*)/ ) {
            $branch = $1;
        }
        close $fh;
    }

    return { revision => "$revision-$hash", branch => $branch };
}

sub set_default_tmpl_params {
    my $mt     = shift;
    my ($tmpl) = @_;
    my $param  = {};
    $param->{mt_debug} = $MT::DebugMode;
    if ( $param->{mt_debug} && $mt->isa('MT::App') ) {
        $param->{mt_svn_revision} = $mt->_svn_revision();
        if ( $ENV{MOD_PERL} && exists( $mt->{apache} ) ) {
            $param->{mt_headers} = $mt->{apache}->headers_in();
        }
        else {
            $param->{mt_headers} = \%ENV;
        }
        unless ( $mt->{cookies} ) {
            if ( $ENV{MOD_PERL} ) {
                eval { require Apache::Cookie };
                $mt->{cookies} = Apache::Cookie->fetch;
            }
            else {
                eval { require CGI::Cookie };
                $mt->{cookies} = CGI::Cookie->fetch;
            }
        }
        if ( $mt->{cookies} ) {
            $param->{mt_cookies} = $mt->{cookies};
        }
        my %params = $mt->param_hash;
        $param->{mt_queries} = \%params;
        if ( $param->{mt_debug} & 4 ) {
            if ( my $profiler = Data::ObjectDriver->profiler ) {
                my $stats = $profiler->statistics;
                $param->{mt_sql_profile}{statistics} = $stats;
                $param->{mt_sql_profile}{total_queries}
                    = $stats->{'DBI:total_queries'};

                my $freq = $profiler->query_frequency;
                my @cache_types;
                foreach ( keys %$freq ) {
                    my ( $cache_type, $memcache, $method )
                        = $_ =~ /^(.+)CACHE(D?)_(.+)\s\?/;
                    next unless $cache_type;
                    push @cache_types,
                        $cache_type . ':query_' . lc($method),
                        delete $freq->{$_};
                }
                $param->{mt_sql_profile}{query_frequency} = $freq;
                $param->{mt_cache_profile} = [];
                while ( my $k = shift(@cache_types) ) {
                    push @{ $param->{mt_cache_profile} }, $k,
                        shift(@cache_types);
                }
            }
        }
    }
    $param->{mt_beta}         = 1 if MT->version_id =~ m/^\d+\.\d+(?:a|b|rc)/;
    $param->{static_uri}      = $mt->static_path;
    $param->{mt_version}      = MT->version_number;
    $param->{mt_version_id}   = MT->version_id;
    $param->{mt_product_code} = MT->product_code;
    $param->{mt_product_name} = $mt->translate( MT->product_name );
    $param->{language_tag}    = substr( $mt->current_language, 0, 2 );
    $param->{language_encoding} = $mt->charset;
    $param->{optimize_ui} = $mt->build_id && !$MT::DebugMode;

    if ( $mt->isa('MT::App') ) {
        if ( my $author = $mt->user ) {
            $param->{author_id}   = $author->id;
            $param->{author_name} = $author->name;
        }
        ## We do this in load_tmpl because show_error and login don't call
        ## build_page; so we need to set these variables here.
        require MT::Auth;
        $param->{can_logout}      = MT::Auth->can_logout;
        $param->{script_url}      = $mt->uri;
        $param->{mt_url}          = $mt->mt_uri;
        $param->{script_path}     = $mt->path;
        $param->{script_full_url} = $mt->base . $mt->uri;
        $param->{agent_mozilla} = ( $ENV{HTTP_USER_AGENT} || '' ) =~ /gecko/i;
        $param->{agent_ie} = ( $ENV{HTTP_USER_AGENT} || '' ) =~ /\bMSIE\b/;
    }
    if ( !$tmpl->param('template_filename') ) {
        if ( my $fname = $tmpl->{__file} ) {
            $fname =~ s!\\!/!g;
            $fname =~ s/\.tmpl$//;
            $param->{template_filename} = $fname;
        }
    }
    $tmpl->param($param);
}

sub process_mt_template {
    my $mt = shift;
    use bytes;
    my ($body) = @_;
    $body =~ s@<(?:_|MT)_ACTION\s+mode="([^"]+)"(?:\s+([^>]*))?>@
        my $mode = $1; my %args;
        %args = $2 =~ m/\s*(\w+)="([^"]*?)"\s*/g if defined $2; # "
        MT::Util::encode_html($mt->uri(mode => $mode, args => \%args));
    @geis;

    # Strip out placeholder wrappers to facilitate tmpl_* callbacks
    $body =~ s/<\/?MT_\w+:\w+>//g;
    $body;
}

sub build_page {
    my $mt = shift;
    my ( $file, $param ) = @_;
    my $tmpl;
    my $mode = $mt->mode;
    $param->{'app_page_template'} = 1;
    $param->{"mode_$mode"} ||= 1;
    $param->{breadcrumbs} = $mt->{breadcrumbs};
    if ( $param->{breadcrumbs}[-1] ) {
        $param->{breadcrumbs}[-1]{is_last} = 1;
        $param->{page_titles} = [ reverse @{ $mt->{breadcrumbs} } ];
    }
    pop @{ $param->{page_titles} };
    if ( my $lang_id = $mt->current_language ) {
        $param->{local_lang_id} ||= lc $lang_id;
    }
    $param->{magic_token} = $mt->current_magic if $mt->user;

    # List of installed packs in the application footer
    my @packs_installed;
    my $packs = $mt->find_addons('pack');
    if ($packs) {
        foreach my $pack (@$packs) {
            my $c = $mt->component( lc $pack->{id} );
            if ($c) {
                my $label = $c->label || $pack->{label};
                $label = $label->() if ref($label) eq 'CODE';

                # if the component did not declare a label,
                # it isn't wanting to be visible on the app footer.
                next if $label eq $c->{plugin_sig};

                my $pack_link
                    = $c->pack_link   ? $c->pack_link
                    : $c->author_link ? $c->author_link
                    :                   '';

                push @packs_installed,
                    {
                    label   => $label,
                    version => $c->version,
                    id      => $c->id,
                    link    => $pack_link,
                    };
            }
        }
    }
    @packs_installed = sort { $a->{label} cmp $b->{label} } @packs_installed;
    $param->{packs_installed} = \@packs_installed;

    $param->{portal_url} = &portal_url;

    for my $config_field ( keys %{ MT::ConfigMgr->instance->{__var} || {} } )
    {
        $param->{ $config_field . '_readonly' } = 1;
    }

    my $tmpl_file = '';
    if ( UNIVERSAL::isa( $file, 'MT::Template' ) ) {
        $tmpl = $file;
        $tmpl_file = ( exists $file->{__file} ) ? $file->{__file} : '';
    }
    else {
        $tmpl = $mt->load_tmpl($file) or return;
        $tmpl_file = $file unless ref($file);
    }

    if (( $mode && ( $mode !~ m/delete/ ) )
        && ( $mt->{login_again}
            || ( $mt->{requires_login} && !$mt->user ) )
        )
    {
        ## If it's a login screen, direct the user to where they were going
        ## (query params including mode and all) unless they were logging in,
        ## logging out, or deleting something.
        my $q = $mt->{query};
        if ($mode) {
            my @query;
            my @query_keys = grep {
                       ( $_ ne 'username' )
                    && ( $_ ne 'password' )
                    && ( $_ ne 'submit' )
                    && ( $mode eq 'logout' ? ( $_ ne '__mode' ) : 1 )
            } $q->param;
            for my $query_key (@query_keys) {
                my @vals = $q->param($query_key);
                for my $val (@vals) {
                    push @query, { name => $query_key, value => $val };
                }
            }
            $param->{query_params} = \@query;
        }
        $param->{login_again} = $mt->{login_again};
    }

    my $blog = $mt->blog;
    $tmpl->context()->stash( 'blog', $blog ) if $blog;

    $tmpl->param($param) if $param;

    if ($tmpl_file) {
        $tmpl_file = File::Basename::basename($tmpl_file);
        $tmpl_file =~ s/\.tmpl$//;
        $tmpl_file = '.' . $tmpl_file;
    }
    $mt->run_callbacks( 'template_param' . $tmpl_file,
        $mt, $tmpl->param, $tmpl );

    my $output = $mt->build_page_in_mem($tmpl);
    return unless defined $output;

    $mt->run_callbacks( 'template_output' . $tmpl_file,
        $mt, \$output, $tmpl->param, $tmpl );
    return $output;
}

sub build_page_in_mem {
    my $mt = shift;
    my ( $tmpl, $param ) = @_;
    $tmpl->param($param) if $param;
    my $out = $tmpl->output;
    return $mt->error( $tmpl->errstr ) unless defined $out;
    return $mt->translate_templatized( $mt->process_mt_template($out) );
}

sub new_ua {
    my $class = shift;
    my ($opt) = @_;
    $opt ||= {};
    my $lwp_class = 'LWP::UserAgent';
    if ( $opt->{paranoid} ) {
        eval { require LWPx::ParanoidAgent; };
        $lwp_class = 'LWPx::ParanoidAgent' unless $@;
    }
    eval "require $lwp_class;";
    return undef if $@;
    my $cfg = $class->config;
    my $max_size = exists $opt->{max_size} ? $opt->{max_size} : 100_000;
    my $timeout = exists $opt->{timeout} ? $opt->{timeout} : $cfg->HTTPTimeout
        || $cfg->PingTimeout;
    my $proxy = exists $opt->{proxy} ? $opt->{proxy} : $cfg->HTTPProxy
        || $cfg->PingProxy;
    my $sec_proxy
        = exists $opt->{sec_proxy} ? $opt->{sec_proxy} : $cfg->HTTPSProxy;
    my $no_proxy
        = exists $opt->{no_proxy} ? $opt->{no_proxy} : $cfg->HTTPNoProxy
        || $cfg->PingNoProxy;
    my $agent = $opt->{agent} || $MT::PRODUCT_NAME . '/' . $MT::VERSION;
    my $interface
        = exists $opt->{interface} ? $opt->{interface} : $cfg->HTTPInterface
        || $cfg->PingInterface;

    if ( my $localaddr = $interface ) {
        @LWP::Protocol::http::EXTRA_SOCK_OPTS = (
            LocalAddr => $localaddr,
            Reuse     => 1
        );
    }

    my $ua = $lwp_class->new;
    $ua->max_size($max_size) if ( defined $max_size ) && $ua->can('max_size');
    $ua->agent($agent);
    $ua->timeout($timeout) if defined $timeout;
    eval { require HTML::HeadParser; };
    $ua->parse_head(0) if $@;
    if ( defined $proxy ) {
        $ua->proxy( http => $proxy );
        my @domains = split( /,\s*/, $no_proxy ) if $no_proxy;
        $ua->no_proxy(@domains) if @domains;
    }
    if ( defined $sec_proxy ) {
        $ua->proxy( https => $sec_proxy );
    }
    return $ua;
}

sub build_email {
    my $class = shift;
    my ( $file, $param ) = @_;
    my $mt = $class->instance;

    # basically, try to load from database
    my $blog = $param->{blog} || undef;
    my $id = $file;
    $id =~ s/(\.tmpl|\.mtml)$//;

    require MT::Template;
    my @tmpl = MT::Template->load(
        {   ( $blog ? ( blog_id => [ $blog->id, 0 ] ) : ( blog_id => 0 ) ),
            identifier => $id,
            type       => 'email',
        }
    );
    my $tmpl
        = @tmpl
        ? (
        scalar @tmpl > 1
        ? ( $tmpl[0]->blog_id ? $tmpl[0] : $tmpl[1] )
        : $tmpl[0]
        )
        : undef;

    # try to load from file
    unless ($tmpl) {
        local $mt->{template_dir} = 'email';
        $tmpl = $mt->load_tmpl($file);
    }
    return unless $tmpl;

    my $ctx = $tmpl->context;
    $ctx->stash( 'blog_id', $blog->id ) if $blog;
    foreach my $name (qw{blog entry author commenter comment category ping}) {
        $ctx->stash( $name, delete $param->{$name} ) if $param->{$name};
    }

    my $out = $mt->build_page_in_mem( $tmpl, $param );

    require MT::Log;
    $mt->log(
        {   message => $mt->translate(
                "Error while creating email: [_1]",
                $mt->errstr
            ),
            class    => 'system',
            category => 'email',
            level    => MT::Log::ERROR(),
        }
    ) unless defined $out;

    $out;
}

sub get_next_sched_post_for_user {
    my ( $author_id, @further_blog_ids ) = @_;
    require MT::Permission;
    my @perms = MT::Permission->load( { author_id => $author_id }, {} );
    my @blogs = @further_blog_ids;
    for my $perm (@perms) {
        next unless $perm->can_do('load_next_scheduled_entry');
        push @blogs, $perm->blog_id;
    }
    my $next_sched_utc = undef;
    require MT::Entry;
    for my $blog_id (@blogs) {
        my $blog = MT::Blog->load($blog_id)
            or next;
        my $earliest_entry = MT::Entry->load(
            {   status  => MT::Entry::FUTURE(),
                blog_id => $blog_id
            },
            { 'sort' => 'created_on' }
        );
        if ($earliest_entry) {
            my $entry_utc
                = MT::Util::ts2iso( $blog, $earliest_entry->created_on );
            if ( $entry_utc < $next_sched_utc || !defined($next_sched_utc) ) {
                $next_sched_utc = $entry_utc;
            }
        }
    }
    return $next_sched_utc;
}

our $Commenter_Auth;

sub init_commenter_authenticators {
    my $self = shift;
    my $auths = $self->registry("commenter_authenticators") || {};
    $Commenter_Auth = {%$auths};
    my $app = $self->app;
    my $blog = $app->blog if $app->isa('MT::App');
    foreach my $auth ( keys %$auths ) {
        if ( my $c = $auths->{$auth}->{condition} ) {
            $c = $self->handler_to_coderef($c);
            if ($c) {
                delete $Commenter_Auth->{$auth} unless $c->($blog);
            }
        }
    }
    $Commenter_Auth->{$_}{key} ||= $_ for keys %$Commenter_Auth;
}

sub commenter_authenticator {
    my $self = shift;
    my ( $key, %param ) = @_;
    $Commenter_Auth or $self->init_commenter_authenticators();

    return
        if ( !exists $Commenter_Auth->{$key}
        || ( $Commenter_Auth->{$key}->{disable} && !$param{force} ) );
    return $Commenter_Auth->{$key};
}

sub commenter_authenticators {
    my $self = shift;
    my (%param) = @_;
    $Commenter_Auth or $self->init_commenter_authenticators();
    my %auths = %$Commenter_Auth;
    if ( !$param{force} ) {
        foreach my $auth ( keys %auths ) {
            delete $auths{$auth} if $auths{$auth}->{disable};
        }
    }

    return values %auths;
}

sub _commenter_auth_params {
    my ( $key, $blog_id, $entry_id, $static ) = @_;
    my $params = {
        blog_id => $blog_id,
        static  => $static,
    };
    $params->{entry_id} = $entry_id if defined $entry_id;
    return $params;
}

sub _openid_commenter_condition {
    my ( $blog, $reason ) = @_;
    eval { require Digest::SHA1; };
    return 1 unless $@;
    $$reason
        = MT->translate(
        'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.'
        );
    return 0;
}

sub core_commenter_authenticators {
    return {
        'OpenID' => {
            class             => 'MT::Auth::OpenID',
            label             => 'OpenID',
            login_form        => 'comment/auth_openid.tmpl',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/signin_openid.png',
            logo_small        => 'images/comment/openid_logo.png',
            order             => 10,
        },
        'LiveJournal' => {
            class             => 'MT::Auth::LiveJournal',
            label             => 'LiveJournal',
            login_form        => 'comment/auth_livejournal.tmpl',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/signin_livejournal.png',
            logo_small        => 'images/comment/livejournal_logo.png',
            order             => 11,
        },
        'Vox' => {
            class             => 'MT::Auth::Vox',
            label             => 'Vox',
            login_form        => 'comment/auth_vox.tmpl',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/signin_vox.png',
            logo_small        => 'images/comment/vox_logo.png',
            order             => 12,
            disable           => 1,
        },
        'Google' => {
            label      => 'Google',
            class      => 'MT::Auth::GoogleOpenId',
            login_form => 'comment/auth_googleopenid.tmpl',
            condition  => sub {
                my ( $blog, $reason ) = @_;
                my @missing;
                eval { require Digest::SHA1; };
                push @missing, 'Digest::SHA1' if $@;
                eval { require Crypt::SSLeay; };
                push @missing, 'Crypt::SSLeay' if $@;
                return 1 unless @missing;
                $$reason
                    = MT->translate( 'missing required Perl modules: [_1]',
                    join( ',', @missing ) );
                return 0;
            },
            login_form_params => \&_commenter_auth_params,
            logo              => 'images/comment/google.png',
            logo_small        => 'images/comment/google_logo.png',
            order             => 13,
        },
        'Yahoo' => {
            class             => 'MT::Auth::Yahoo',
            label             => 'Yahoo!',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/yahoo.png',
            logo_small        => 'images/comment/favicon_yahoo.png',
            login_form        => 'comment/auth_yahoo.tmpl',
            order             => 14,
        },
        AIM => {
            class             => 'MT::Auth::AIM',
            label             => 'AIM',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/aim.png',
            logo_small        => 'images/comment/aim_logo.png',
            login_form        => 'comment/auth_aim.tmpl',
            order             => 15,
        },
        'WordPress' => {
            class             => 'MT::Auth::WordPress',
            label             => 'WordPress.com',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/wordpress.png',
            logo_small        => 'images/comment/wordpress_logo.png',
            login_form        => 'comment/auth_wordpress.tmpl',
            order             => 16,
        },
        'TypeKey' => {
            class             => 'MT::Auth::TypeKey',
            label             => 'TypePad',
            login_form        => 'comment/auth_typepad.tmpl',
            login_form_params => sub {
                my ( $key, $blog_id, $entry_id, $static ) = @_;
                my $entry = MT::Entry->load($entry_id) if $entry_id;

                ## TypeKey URL
                require MT::Template::Context;
                my $ctx = MT::Template::Context->new;
                $ctx->stash( 'blog_id', $blog_id );
                my $blog = MT::Blog->load($blog_id);
                $ctx->stash( 'blog',  $blog );
                $ctx->stash( 'entry', $entry );
                my $params = {};
                require MT::Template::Tags::Comment;
                $params->{tk_signin_url}
                    = MT::Template::Tags::Comment::_hdlr_remote_sign_in_link(
                    $ctx, { static => $static } );
                return $params;
            },
            logo       => 'images/comment/signin_typepad.png',
            logo_small => 'images/comment/typepad_logo.png',
            condition  => sub {
                my ($blog) = @_;
                return 1 unless $blog;
                return $blog->remote_auth_token ? 1 : 0;
            },
            order => 17,
        },
        'YahooJP' => {
            class             => 'MT::Auth::Yahoo',
            label             => 'Yahoo! JAPAN',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/yahoo.png',
            logo_small        => 'images/comment/favicon_yahoo.png',
            login_form        => 'comment/auth_yahoojapan.tmpl',
            order             => 18,
        },
        'livedoor' => {
            class             => 'MT::Auth::OpenID',
            label             => 'livedoor',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/signin_livedoor.png',
            logo_small        => 'images/comment/livedoor_logo.png',
            login_form        => 'comment/auth_livedoor.tmpl',
            order             => 20,
        },
        'Hatena' => {
            class             => 'MT::Auth::Hatena',
            label             => 'Hatena',
            login_form        => 'comment/auth_hatena.tmpl',
            login_form_params => \&_commenter_auth_params,
            condition         => \&_openid_commenter_condition,
            logo              => 'images/comment/signin_hatena.png',
            logo_small        => 'images/comment/hatena_logo.png',
            order             => 21,
        },
    };
}

our %Captcha_Providers;

sub captcha_provider {
    my $self = shift;
    my ($key) = @_;
    $self->init_captcha_providers() unless %Captcha_Providers;
    return $Captcha_Providers{$key};
}

sub captcha_providers {
    my $self = shift;
    $self->init_captcha_providers() unless %Captcha_Providers;
    my $def  = delete $Captcha_Providers{'mt_default'};
    my @vals = values %Captcha_Providers;
    if ( defined($def) && $def->{condition}->() ) {
        unshift @vals, $def;
    }
    @vals;
}

sub core_captcha_providers {
    return {
        'mt_default' => {
            label     => 'Movable Type default',
            class     => 'MT::Util::Captcha',
            condition => sub {
                require MT::Util::Captcha;
                if ( my $error = MT::Util::Captcha->check_availability ) {
                    return 0;
                }
                1;
            },
        }
    };
}

sub init_captcha_providers {
    my $self = shift;
    my $providers = $self->registry("captcha_providers") || {};
    foreach my $provider ( keys %$providers ) {
        delete $providers->{$provider}
            if exists( $providers->{$provider}->{condition} )
                && !( $providers->{$provider}->{condition}->() );
    }
    %Captcha_Providers = %$providers;
    $Captcha_Providers{$_}{key} ||= $_ for keys %Captcha_Providers;
}

sub effective_captcha_provider {
    my $class = shift;
    my ($key) = @_;
    return undef unless $key;
    my $cp = $class->captcha_provider($key) or return;
    if ( exists $cp->{condition} ) {
        return undef unless $cp->{condition}->();
    }
    my $pkg = $cp->{class};
    $pkg =~ s/;//g;
    eval "require $pkg" or return;
    return $cp->{class};
}

sub handler_to_coderef {
    my $pkg = shift;
    my ( $name, $delayed ) = @_;

    return $name if ref($name) eq 'CODE';
    return undef unless defined $name && $name ne '';

    my $code;
    if ( $name !~ m/->/ ) {

        # check for Package::Routine first; if defined, return coderef
        no strict 'refs';
        $code = \&$name if defined &$name;
        return $code if $code;
    }

    my $component;
    if ( $name =~ m!^\$! ) {
        if ( $name =~ s/^\$(\w+)::// ) {
            $component = $1;
        }
    }
    if ( $name =~ m/^\s*sub\s*\{/s ) {
        $code = eval $name or die $@;

        if ($component) {
            return sub {
                my $mt_inst = MT->instance;
                local $mt_inst->{component} = $component;
                $code->(@_);
            };
        }
        else {
            return $code;
        }
    }

    my $hdlr_pkg = $name;
    my $method;

    # strip routine name
    if ( $hdlr_pkg =~ s/->(\w+)$// ) {
        $method = $1;
    }
    else {
        $hdlr_pkg =~ s/::[^:]+$//;
    }
    if ( !defined(&$name) && !$pkg->can('AUTOLOAD') ) {

        # The delayed option will return a coderef that delays the loading
        # of the package holding the handler routine.
        if ($delayed) {
            if ($method) {
                return sub {
                    eval "# line " 
                        . __LINE__ . " " 
                        . __FILE__
                        . "\nrequire $hdlr_pkg;"
                        or Carp::confess(
                        "failed loading package $hdlr_pkg for routine $name: $@"
                        );
                    my $mt_inst = MT->instance;
                    local $mt_inst->{component} = $component
                        if $component;
                    return $hdlr_pkg->$method(@_);
                };
            }
            else {
                return sub {
                    eval "# line " 
                        . __LINE__ . " " 
                        . __FILE__
                        . "\nrequire $hdlr_pkg;"
                        or Carp::confess(
                        "failed loading package $hdlr_pkg for routine $name: $@"
                        );
                    my $mt_inst = MT->instance;
                    local $mt_inst->{component} = $component
                        if $component;
                    no strict 'refs';
                    my $hdlr = \&$name;
                    use strict 'refs';
                    return $hdlr->(@_);
                };
            }
        }
        else {
            eval "# line " 
                . __LINE__ . " " 
                . __FILE__
                . "\nrequire $hdlr_pkg;"
                or Carp::confess(
                "failed loading package $hdlr_pkg for routine $name: $@");
        }
    }
    if ($method) {
        $code = sub {
            my $mt_inst = MT->instance;
            local $mt_inst->{component} = $component
                if $component;
            return $hdlr_pkg->$method(@_);
        };
    }
    else {
        if ($component) {
            $code = sub {
                no strict 'refs';
                my $hdlr = (
                    defined &$name ? \&$name
                    : ( $pkg->can('AUTOLOAD') ? \&$name
                        : undef
                    )
                );
                use strict 'refs';
                if ($hdlr) {
                    my $mt_inst = MT->instance;
                    local $mt_inst->{component} = $component
                        if $component;
                    return $hdlr->(@_);
                }
                return undef;
                }
        }
        else {
            no strict 'refs';
            $code = (
                defined &$name
                ? \&$name
                : ( $hdlr_pkg->can('AUTOLOAD') ? \&$name : undef )
            );
        }
    }
    return $code;
}

sub help_url {
    my $pkg = shift;
    my ($append) = @_;

    my $url = $pkg->config->HelpURL;
    return $url if defined $url;
    $url = $pkg->translate('http://www.movabletype.org/documentation/');
    if ($append) {
        $url .= $append;
    }
    $url;
}

sub register_refresh_cache_event {
    my $pkg = shift;
    my ($callback) = @_;
    return unless $callback;

    MT->_register_core_callbacks( { "$callback" => \&refresh_cache, } );
}

sub refresh_cache {
    my ( $cb, %args ) = @_;

    require MT::Cache::Negotiate;
    my $cache_driver = MT::Cache::Negotiate->new();
    return unless $cache_driver;

    $cache_driver->flush_all();
}

sub DESTROY { }

1;

__END__

=head1 NAME

MT - Movable Type

=head1 SYNOPSIS

    use MT;
    my $mt = MT->new;
    $mt->rebuild(BlogID => 1)
        or die $mt->errstr;

=head1 DESCRIPTION

The I<MT> class is the main high-level rebuilding/pinging interface in the
Movable Type library. It handles all rebuilding operations. It does B<not>
handle any of the application functionality--for that, look to I<MT::App> and
I<MT::App::CMS>, both of which subclass I<MT> to handle application requests.

=head1 PLUGIN APPLICATIONS

At any given time, the user of the Movable Type platform is
interacting with either the core Movable Type application, or a plugin
application (or "sub-application").

A plugin application is a plugin with a user interface that inherits
functionality from Movable Type, and appears to the user as a
component of Movable Type. A plugin application typically has its own
templates displaying its own special features; but it inherits some
templates from Movable Type, such as the navigation chrome and error
pages.

=head2 The MT Root and the Application Root

To locate assets of the core Movable Type application and any plugin
applications, the platform uses two directory paths, C<mt_dir> and
C<app_dir>. These paths are returned by the MT class methods with the
same names, and some other methods return derivatives of these paths.

Conceptually, mt_dir is the root of the Movable Type installation, and
app_dir is the root of the "currently running application", which
might be Movable Type or a plugin application. It is important to
understand the distinction between these two values and what each is
used for.

The I<mt_dir> is the absolute path to the directory where MT itself is
located. Most importantly, the MT configuration file and the CGI scripts that
bootstrap an MT request are found here. This directory is also the
default base path under which MT's core templates are found (but this
can be overridden using the I<TemplatePath> configuration setting).

Likewise, the I<app_dir> is the directory where the "current"
application's assets are rooted. The platform will search for
application templates underneath the I<app_dir>, but this search also
searches underneath the I<mt_dir>, allowing the application to make
use of core headers, footers, error pages, and possibly other
templates.

In order for this to be useful, the plugin's templates and
code should all be located underneath the same directory. The relative
path from the I<app_dir> to the application's templates is
configurable. For details on how to indicate the location of your
plugin's templates, see L<MT::App>.

=head2 Finding the Root Paths

When a plugin application initializes its own application class (a
subclass of MT::App), the I<mt_dir> should be discovered and passed
constructor. This comes either from the C<Directory> parameter or the
C<Config> parameter.

Since plugins are loaded from a descendent of the MT root directory,
the plugin bootstrap code can discover the MT configuration file (and thus
the MT root directory) by traversing the filesystem; the absolute path
to that file can be passed as the C<Config> parameter to
MT::App::new. Working code to do this can be found in the
examples/plugins/mirror/mt-mirror.cgi file.

The I<app_dir>, on the other hand, always derives from the location of
the currently-running program, so it typically does not need to be
specified.

=head1 USAGE

I<MT> has the following interface. On failure, all methods return C<undef>
and set the I<errstr> for the object or class (depending on whether the
method is an object or class method, respectively); look below at the section
L<ERROR HANDLING> for more information.

=head2 MT->new( %args )

Returns a I<MT> singleton instance. Returns C<undef> on failure. 
If no active instance exists, will set that object as active instance.

I<new> will also read your MT configuration file (provided that it can find it--if
you find that it can't, take a look at the I<Config> directive, below). It
will also initialize the chosen object driver; the default is the C<DBM>
object driver.

I<%args> can contain:

=over 4

=item * Config

Path to the MT configuration file.

If you do not specify a path, I<MT> will try to find your MT configuration file
in the current working directory.

=item * Directory

Path to the MT home directory.

If you do not specify a path, I<MT> will try to find the MT directory using
the discovered path of the MT configuration file.

=back

=head2 MT->instance( %args )

If exists an active instance, will return it. otherwise will return
the asked class's singleton, making it the active instance.

%args are similar to C<new>

=head2 MT->app( %args )

An alias for the 'instance' method.

=head2 $class->instance_of( %args )

Similar to C<new>, but does not set the active instance

=head2 $mt->init(%params)

Initializes the Movable Type instance, including registration of basic
resources and callbacks. This method also invokes the C<init_config>
and C<init_plugins> methods.

=head2 $mt->init_core()

A method that the base MT class uses to initialize all the 'core'
functionality of Movable Type. If you want to subclass MT and extensively
modify it's core behavior, this method can be overridden to do that.
The L<MT::Core> module is a L<MT::Component> that defines the core
features of MT, and this method loads that component. Non-core components
are loaded by the L<init_addons> method.

=head2 $mt->init_paths()

Establishes some key file paths for the MT environment. Assigns
C<$MT_DIR>, C<$APP_DIR> and C<$CFG_FILE> package variables.

=head2 $mt->init_permissions()

Loads the L<MT::Permission> class and runs the
MT::Permission->init_permissions method to establish system permissions.

=head2 $mt->init_schema()

Completes the initialization of the Movable Type schema following the
loading of plugins. After this method runs, any MT object class may
safely be used.

=head2 $class->construct

Constructs a new instance of the MT subclass identified by C<$class>.

=head2 MT->set_instance

Assigns the active MT instance object. This value is returned when
C<MT-E<gt>instance> is invoked.

=head2 MT->run_app( $pkg, $params )

Instantiates and runs a MT application (identified by C<$pkg>), passing
the C<$params> hashref as the parameters to the constructor method. This
method is a self-contained version found in L<MT::Bootstrap> and will
eventually be the manner in which MT applications are run (eliminating
the need for the bootstrap module). The MT::import function calls this
method when the MT module is used with an 'App' parameter. So, you can
write a mt.cgi script that looks like this:

    #!/usr/bin/perl
    use strict;
    use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
    use MT App => 'MT::App::CMS';

=head2 $mt->find_config($params)

Handles the discovery of the MT configuration file. The path and filename
for the configuration file is returned as the result. The C<$params>
parameter is a reference to the hash of settings passed to the MT
constructor.

=head2 $mt->init_config($params)

Reads the MT configuration settingss from the MT configuration file.

The C<$params> parameter is a reference to the hash of settings passed to
the MT constructor.

=head2 $mt->init_config_from_db($param)

Reads any MT configuration settings from the MT database (L<MT::Config>).

The C<$params> parameter is a reference to the hash of settings passed to
the MT constructor.

=head2 $mt->init_addons(%param)

Loads any discoverable addons that are available. This is called from
the C<init> method, after C<init_config> method has loaded the
configuration settings, but prior to making a database connection.

=head2 $mt->init_plugins(%param)

Loads any discoverable plugins that are available. This is called from
the C<init> method, after the C<init_config> method has loaded the
configuration settings.

=head2 $mt->init_callbacks()

Installs any MT callbacks. This is called from the C<init> method very,
early; prior to loading any addons or plugins.

=head2 MT->run_tasks

Invokes the task system through L<MT::TaskMgr> to run any registered tasks 
that are pending execution. See L<MT::TaskMgr> for further documentation.

=head2 MT->find_addons( $type )

Returns an array of all 'addons' that are found within the MT 'addons'
directory of the given C<$type>. What is returned is an array reference
of hash data. Each hash will contain these elements: 'label' (the name
of the addon), 'id' (the unique identifier of the addon), 'envelope'
(the subpath of the addon, relative to the MT home directory), and 'path'
(the full path to the addon subdirectory).

=head2 MT::log( $message ) or $mt->log( $message )

Adds an entry to the application's log table. Also writes message to
STDERR which is typically routed to the web server's error log.
Examples:

    $mt->log('I would like you to know');
    $mt->log( { message => 'that this is important', level => MT::Log::ERROR() } );
    # can also use metadata, category, blog_id, author_id and ip

=head2 $mt->server_path, $mt->mt_dir

Both of these methods return the physical file path to the directory
that is the home of the MT installation. This would be the value of
the 'Directory' parameter given in the MT constructor, or would be
determined based on the path of the configuration file.

=head2 $mt->app_dir

Returns the physical file path to the active application directory. This
is determined by the directory of the active script.

=head2 $mt->config_dir

Returns the path to the MT configuration file.

=head2 $mt->config([$setting[, $value]])

This method is used to get and set configuration settings. When called
without any parameters, it returns the active MT::ConfigMgr instance
used by the application.

Specifying the C<$setting> parameter will return the value for that setting.
When passing the C<$value> parameter, this will update the config object,
assigning that value for the named C<$setting>.

=head2 $mt->user_class

Returns the package name for the class used for user authentication.
This is typically L<MT::Author>.

=head2 $mt->request([$element[,$data]])

The request method provides a request-scoped storage object. It is an
access interface for the L<MT::Request> package. Calling without any
parameters will return the L<MT::Request> instance.

When called with the C<$element> parameter, the data stored for that
element is returned (or undef, if it didn't exist). When called with
the C<$data> parameter, it will store the data into the specified
element in the request object.

All values placed in the request object are lost at the end of the
request. If the running application is not a web-based application,
the request object exists for the lifetime of the process and is
released when the process ends.

See the L<MT::Request> package for more information.

=head2 MT->new_ua

Returns a new L<LWP::UserAgent> instance that is configured according to the
Movable Type configuration settings (specifically C<HTTPInterface>, C<HTTPTimeout>, C<HTTPProxy> and C<HTTPNoProxy>). The agent string is set
to "MovableType/(version)" and is also limited to receiving a response of
100,000 bytes by default (you can override this by using the 'max_size'
method on the returned instance). Using this method is recommended for
any HTTP requests issued by Movable Type since it uses the MT configuration
settings to prepare the UserAgent object.

=head2 $mt->ping( %args )

Sends all configured XML-RPC pings as a way of notifying other community
sites that your blog has been updated.

I<%args> can contain:

=over 4

=item * Blog

An I<MT::Blog> object corresponding to the blog for which you would like to
send the pings.

Either this or C<BlogID> is required.

=item * BlogID

The ID of the blog for which you would like to send the pings.

Either this or C<Blog> is required.

=item * OldStatus

Optional, can contain the previous status of the entry. if the entry
was already released, don't send update to all the blogs that track
this blog, only to trackbacks register on this entry.

=item * Entry

An I<MT::Entry> object corresponding to the entry that was updated.

=head2 $mt->ping_and_save( %args )

Handles the task of issuing any pending ping operations for a given
entry and then saving that entry back to the database.

The I<%args> hash should contain an element named C<Entry> that is a
reference to a L<MT::Entry> object, and other elements as needed by the
ping function.

=head2 $mt->needs_ping(%param)

Returns a list of URLs that have not been pinged for a given entry. Named
parameters for this method are:

=over 4

=item Entry

The L<MT::Entry> object to examine.

=item Blog

The L<MT::Blog> object that is the parent of the entry given.

=back

The return value is an array reference of URLs that have not been pinged
for the given entry.

An empty list is returned for entries that have a non 'RELEASE' status.

=head2 $mt->update_ping_list($blog)

Returns a list of URLs for ping services that have been configured to
be notified when posting new entries.

=head2 $mt->set_language($tag)

Loads the localization plugin for the language specified by I<$tag>, which
should be a valid and supported language tag--see I<supported_languages> to
obtain a list of supported languages.

The language is set on a global level, and affects error messages and all
text in the administration system.

This method can be called as either a class method or an object method; in
other words,

    MT->set_language($tag)

will also work. However, the setting will still be global--it will not be
specified to the I<$mt> object.

The default setting--set when I<MT::new> is called--is U.S. English. If a
I<DefaultLanguage> is set in the MT configuration file, the default is then
set to that language.

=head2 MT->translate($str[, $param, ...])

Translates I<$str> into the currently-set language (set by I<set_language>),
and returns the translated string. Any parameters following I<$str> are
passed through to the C<maketext> method of the active localization module.

=head2 MT->translate_templatized($str)

Translates a string that has embedded E<lt>__transE<gt> tags. These
tags identify the portions of the string that require localization.
Each tag is processed separately and passed through the MT->translate
method. Examples (used in your application's HTML::Template templates):

    <p><__trans phrase="Hello, world"></p>

and

    <p><__trans phrase="Hello, [_1]" params="<TMPL_VAR NAME=NAME>"></p>

=head2 $mt->trans_error( $str[, $arg1, $arg2] )

Translates I<$str> into the currently-set language (set by I<set_language>),
and assigns it as the active error for the MT instance. It returns undef,
which is the usual return value upon generating an error in the application.
So when an error occurs, the typical return result would be:

    if ($@) {
        return $app->trans_error("An error occurred: [_1]", $@);
    }

The optional I<$arg1> (and so forth) parameters are passed as parameters to
any parameterized error message.

=head2 $mt->current_language

Returns the language tag for the currently-set language.

=head2 MT->supported_languages

Returns a reference to an associative array mapping language tags to their
proper names. For example:

    use MT;
    my $langs = MT->supported_languages;
    print map { $_ . " => " . $langs->{$_} . "\n" } keys %$langs;

=head2 MT->language_handle

Returns the active MT::L10N language instance for the active language.

=head2 MT->add_plugin($plugin)

Adds the plugin described by $plugin to the list of plugins displayed
on the welcome page. The argument should be an object of the
I<MT::Plugin> class.

This function can be used only while MT is loading addons/plugins,
to instruct MT to load sub-addons/plugins.

=head2 MT->all_text_filters

Returns a reference to a hash containing the registry of text filters.

=head2 MT->apply_text_filters($str, \@filters)

Applies the set of filters I<\@filters> to the string I<$str> and returns
the result (the filtered string).

I<\@filters> should be a reference to an array of filter keynames--these
are the short names passed in as the first argument to I<add_text_filter>.
I<$str> should be a scalar string to be filtered.

If one of the filters listed in I<\@filters> is not found in the list of
registered filters (that is, filters added through I<add_text_filter>),
it will be skipped silently. Filters are executed in the order in which they
appear in I<\@filters>.

As it turns out, the I<MT::Entry::text_filters> method returns a reference
to the list of text filters to be used for that entry. So, for example, to
use this method to apply filters to the main entry text for an entry
I<$entry>, you would use

    my $out = MT->apply_text_filters($entry->text, $entry->text_filters);

=head2 MT->add_callback($meth, $priority, $plugin, $code)

Registers a new callback handler for a particular registered callback.

The first parameter is the name of the callback method. 
The second parameter is a priority (a number in the range of 1-10) 
which will control the order that the handler is executed in relation 
to other handlers. (callbacks with priority 1 will be called first) If
two handlers register with the same priority, they will be executed in
the order that they registered. It is also possible to register callacks 
with priority 0 and 11, but only one of each. The third parameter is a 
C<MT::Plugin> object reference that is associated with the handler (this 
parameter is optional). The fourth parameter is a code reference that is 
invoked to handle the callback. For example:

    MT->add_callback('BuildFile', 1, undef, \&rebuild_file_hdlr);

The code reference should expect to receive an object of type
L<MT::Callback> as its first argument. This object is used to
communicate errors to the caller:

    sub rebuild_file_hdlr {
        my ($cb, ...) = @_;
        if (something bad happens) {
            return $cb->error("Something bad happened!");
        }
    }

Other parameters to the callback function depend on the callback point.

The treatment of the error string depends on the callback point.
Typically, either it is ignored or the user's action fails and the
error message is displayed.

The value returned from this method is the new L<MT::Callback> object.

=head2 MT->remove_callback($callback)

Removes a callback that was previously registered.

=head2 MT->register_callbacks([...])

Registers several callbacks simultaneously. Each element in the array
parameter given should be a hashref containing these elements: C<name>, 
C<priority>, C<plugin> and C<code>.

=head2 MT->run_callbacks($meth[, $arg1, $arg2, ...])

Invokes a particular callback, running any associated callback handlers.

The first parameter is the name of the callback to execute. This is one
of the global callback methods (see L<Callbacks> section) or can be
a class-specific method that includes the package name associated with
the callback.

The remaining arguments are passed through to any callback handlers that
are invoked.

For "Filter"-type callbacks, this routine will return a 0 if any of the
handlers return a false result. If all handlers return a true result,
a value of 1 is returned.

Example:

    MT->run_callbacks('MyClass::frobnitzes', \@whirlygigs);

Which would execute any handlers that registered in this fashion:

    MT->add_callback('MyClass::frobnitzes', 4, $plugin, \&frobnitz_hdlr);

=head2 MT->run_callback($cb[, $arg1, $arg2, ...])

An internal routine used by C<run_callbacks> to invoke a single
L<MT::Callback>.

=head2 callback_error($str)

This routine is used internally by C<MT::Callback> to set any error response
that comes from invoking a callback.

=head2 callback_errstr

This internal routine returns the error response stored using the
C<callback_error> routine.

=head2 MT->handler_to_coderef($handler[, $delayed])

Translates a registry handler signature into a Perl coderef. Handlers
are in one of the following forms:

    $<COMPONENTID>::<PERL_PACKAGE>::<SUBROUTINE>

    <PERL_PACKAGE>::<SUBROUTINE>

    <PERL_PACKAGE>-><SUBROUTINE>

    sub { ... }

When invoked with a '-E<gt>' operator, the subroutine is invoked as
a package method.

When the handler is a string that starts with 'sub {', it is eval'd
to compile it, and the resulting coderef is returned.

The coderef that is returned can be passed any parameters you wish.

When the coderef is invoked, any component that was identified in
the handler signature becomes the active component when running the
code (this affects how strings are translated, and the search paths
for templates that are loaded).

If the C<$delayed> parameter is given, a special coderef is constructed
that will delay the 'require' of the identified Perl package until
the coderef is actually invoked.

=head2 MT->registry( @path )

Queries the Movable Type registry data structure for a given resource
path. The MT registry is a collection of hash structures that contain
resources MT and/or plugins can utilize.

When this method is invoked, it actually issues a registry request
against each component registered with MT, then merges the resulting
hashes and returns them. See L<MT::Component> for further details.

=head2 MT->component( $id )

Returns a loaded L<MT::Component> based on the requested C<$id> parameter.
For example:

    # Returns the MT 'core' component
    MT->component('core');

=head2 MT->model( $id )

Returns a Perl package name for the database-backed MT object type 
identified by C<$id>. For example:

    # Assigns (by default) 'MT::Blog' to $blog_class
    my $blog_class = MT->model('blog');

It is a recommended practice to utilize the model method to derive the
implementation package name, instead of hardcoding Perl package names.

A list of names to be used with this function can be found in the 
MT::Core module, but also plugins can add more names.

=head2 MT->all_models( $id )

Returns a list of package names for all the database-backed MT object
type. For example:

    my @models = MT->all_models;
    # @models now contains ('MT::Blog', 'MT::Entry', 'MT::Asset', etc.)

=head2 MT->models( $id )

Returns a list of object types that are registered as sub-types. For
instance, the MT 'asset' object type has several sub-types associated
with it:

    my @types = MT->models('asset');
    # @types now contains ('asset', 'asset.image', 'asset.video', etc.)

=head2 MT->product_code

The product code identifying the Movable Type product that is installed.
This is either 'MTE' for Movable Type Enterprise version or 'MT' for the
community version.

=head2 MT->product_name

The name of the Movable Type product that is installed. This is either
'Movable Type Advanced' or 'Movable Type Publishing Platform'.

=head2 MT->product_version

The version number of the product. This is different from the C<version_id>
and C<version_number> methods as they report the API version information.

=head2 MT->VERSION

Returns the API version of MT. 

Used internally to load suitable API 'compatibility' module, if a plugin 
declares:

    use MT 4;

in which case will attempt to load a module named "MT::Compat::v4". 
This module would contain compatibility support for MT 4-based plugins.

=head2 MT->version_id

Returns the API version of MT (including any beta/alpha designations).

=head2 MT->version_number

Returns the numeric API version of MT (without any beta/alpha designations).
For example, if I<version_id> returned C<2.5b1>, I<version_number> would
return C<2.5>.

=head2 MT->schema_version

Returns the version of the MT database schema.

=head2 $mt->id

Provides an identifier for the application, one that relates to the
'application' paths of the MT registry. This method may be overridden
for any subclass of MT to provide the appropriate identifier. By
default, the base 'id' method will return an id taken from the
Perl package name, by stripping off any 'MT::App::' prefix, and lowercasing
the remaining string.

For example: MT::App::CMS => cms; Foo::Bar => foo/bar

=head2 MT->version_slug

Returns a string of text that is appended to emails sent through the
C<build_email> method.

=head2 $mt->publisher

Returns the L<MT::WeblogPublisher> object that is used for managing the
MT publishing process. See L<MT::WeblogPublisher> for more information.

=head2 $mt->rebuild

An alias to L<MT::WeblogPublisher::rebuild>. See L<MT::WeblogPublisher>
for documentation of this method.

=head2 $mt->rebuild_entry

An alias to L<MT::WeblogPublisher::rebuild_entry>. See L<MT::WeblogPublisher>
for documentation of this method.

=head2 $mt->rebuild_indexes

An alias to L<MT::WeblogPublisher::rebuild_indexes>. See
L<MT::WeblogPublisher> for documentation of this method.

=head2 $mt->rebuild_archives

An alias to L<MT::WeblogPublisher::rebuild_archives>. See
L<MT::WeblogPublisher> for documentation of this method.

=head2 $app->template_paths

Returns an array of directory paths where application templates exist.

=head2 $app->find_file(\@paths, $filename)

Returns the path and filename for a file found in any of the given paths.
If the file cannot be found, it returns undef.

=head2 $app->load_tmpl($tmpl_source[, @params][, $hashref])

Loads a L<MT::Template> template using the either a filename as tmpl_source, 
or a reference to a string. See the documentation for the C<build_page> 
method to learn about how templates are located. The optional C<@params> 
are passed to the L<MT::Template> constructor. The optional C<$hashref> is added 
to the template's context.

=head2 $app->load_global_tmpl($args[, $blog_id])

Loads a L<MT::Template> from the database. is $args is hashref, it is used
as filtering terms. otherwise, it is used as template type.

template is searched for the supplied blog_id and the global templates.
if $blog_id is not supplied, it will try to retrive it from the application.

=head2 $app->set_default_tmpl_params($tmpl)

Assigns standard parameters to the given L<MT::Template> C<$tmpl> object.
Refer to the L<STANDARD APPLICATION TEMPLATE PARAMETERS> section for a
complete list of these parameters.

=head2 $app->charset( [$charset] )

Gets or sets the application's character set based on the "PublishCharset"
configuration setting or the encoding of the active language
(C<$app-E<gt>current_language>).

=head2 $app->build_page($tmpl_name, \%param)

Builds an application page to be sent to the client; the page name is specified
in C<$tmpl_name>, which should be the name of a template containing valid
L<MT::Template> markup. C<\%param> is a hash ref whose keys and values will
be passed to L<MT::Template::param> for use in the template.

On success, returns a scalar containing the page to be sent to the client. On
failure, returns C<undef>, and the error message can be obtained from
C<$app-E<gt>errstr>.

=head3 How does build_page find a template?

The C<build_page> function looks in several places for an app
template. Two configuration directives can modify these search paths,
and application and plugin code can also affect them.

The I<TemplatePath> config directive is an absolute path to the directory
where MT's core application templates live. It defaults to the I<mt_dir>
plus an additional path segment of 'tmpl'.

The optional I<AltTemplatePath> config directive is a path (absolute
or relative) to a directory where some 'override templates' may
live. An override template takes the place of one of MT's core
application templates, and is used interchangeably with the core
template. This allows power users to customize the look and feel of
the MT application. If I<AltTemplatePath> is relative, its base path
is the value of the Movable Type configuration file.

Next, any application built on the C<MT::App> foundation can define
its own I<template_dir> parameter, which identifies a subdirectory of
TemplatePath (or AltTemplatePath) where that application's templates
can be found. I<template_dir> defaults to C<cms>. Most templates will
be found in this directory, but sometimes the template search will
fall through to the parent directory, where a default error template
is found, for example. I<template_dir> should rightly have been named
I<application_template_dir>, since it is application-specific.

Finally, a plugin can specify its I<plugin_template_path>, which
locates a directory where the templates for that plugin's own
interface are found. If the I<plugin_template_path> is relative, it
may be relative to either the I<app_dir>, or the I<mt_dir>; the former
takes precedence if it exists. (for a definition of I<app_dir> and
I<mt_dir>, see L<MT>)

Given these values, the order of search is as follows:

=over 4

=item * I<plugin_template_path>

=item * I<AltTemplatePath>

=item * I<AltTemplatePath>F</>I<template_dir>

=item * I<TemplatePath>/I<template_dir>

=item * I<TemplatePath>

=back

If a template with the given name is not found in any of these
locations, an ugly error is thrown to the user.

=head2 $app->build_page_in_mem($tmpl, \%param)

Used internally by the L<build_page> method to render the output
of a L<MT::Template> object (the first parameter) using the parameter
data (the second parameter). It additionally calls the L<process_mt_template>
method (to process any E<lt>__actionE<gt> tags)
and then L<translate_templatized> (to process any E<lt>__transE<gt> tags).

=head2 $app->process_mt_template($str)

Processes the E<lt>__action<gt> tags that are present in C<$str>. These tags
are in the following format:

    <__action mode="mode_name" parameter="value">

The mode parameter is required (and must be the first attribute). The
following attributes are appended as regular query parameters.

The MT_ACTION tag is a preferred way to specify application links rather
than using this syntax:

    <mt:var name="script_url">?__mode=mode_name&parameter=value

C<process_mt_templates> also strips the C<$str> variable of any tags in
the format of C<E<lt>MT_\w+:\w+E<gt>>. These are 'marker' tags that are
used to identify specific portions of the template page and used in
conjunction with the transformer callback helper methods C<tmpl_prepend>,
C<tmpl_append>, C<tmpl_replace>, C<tmpl_select>.

=head2 $mt->build_email($file, $param)

Loads a template from the application's 'email' template directory and
processes it as a MT::Template. The C<$param> argument is a hash reference
of parameter data for the template. The return value is the output of the
template.

=head2 MT::get_next_sched_post_for_user($author_id, @blog_ids)

This is an internal routine used by L<MT::XMLRPCServer> and the
getNextScheduled XMLRPC method to determine the timestamp for the next
entry that is scheduled for publishing. The return value is the timestamp
in UTC time in the format "YYYY-MM-DDTHH:MM:SSZ".

=head2 $mt->commenter_authenticator($id)

Returns a specific comment authenication option using the identifier
C<$id> parameter.

=head2 $mt->commenter_authenticators()

Returns the available comment authentication identifiers that are
installed in the MT registry.

=head2 $mt->core_commenter_authenticators()

A method that returns the MT-supplied comment authentication registry
data.

=head2 $mt->init_commenter_authenticators()

Initializes the list of installed MT comment authentication options,
drawing from the MT registry.

=head2 $mt->captcha_provider($id)

Returns a specific CAPTCHA provider configuration using the identifier
C<$id> parameter. This is a convenience method that accesses the CAPTCHA
providers installed into the MT registry.

=head2 $mt->captcha_providers()

Returns the available CAPTCHA providers. This is a convenience method
that accesses the MT registry for available CAPTCHA providers (it also
invokes the 'condition' key for each provider to filter the list).

=head2 $mt->core_captcha_providers()

A method that returns the MT-supplied CAPTCHA provider registry data.

=head2 $mt->init_captcha_providers()

Initializes the list of installed CAPTCHA providers, drawing from
the MT registry.

=head2 $mt->effective_captcha_provider($id)

Returns the Perl package name for the specified CAPTCHA provider.
The condition for this provider is checked and the Perl package is loaded.
On problem with this provider, returns undef.

=head2 $app->static_path()

Returns the application's static web path.

=head2 $app->static_file_path()

Returns the application's static file path.

=head2 MT::core_upload_file_to_sync

A MT callback handler routine that forwards to the L<upload_file_to_sync>
method.

=head2 MT->upload_file_to_sync(%param)

A routine that will make record of a file that is to be transmitted
to one or more servers (typically via rsync). This method runs when
the C<SyncTarget> MT configuration setting is configured. Normally
published files are automatically processed for syncing operations,
but this routine is used for files that are created through other
means, such as uploading an asset.

=head2 MT->help_url( [ $suffix ] )

Returns a help URL for the application. This method is used to construct
the URL directing users to online documentation. If called without any
parameters, it returns the base URL for providing help. If a parameter is
given, the URL is appended with the given subpath. The base URL by default
is 'http://www.movabletype.org/documentation/'. This string is passed
through MT's localization modules, so it can be changed on a per-language
basis. The C<$suffix> parameter, however, is always appended to this base URL.

=head2 MT->portal_url

Returns the home page of this MT installation.

=head2 $app->support_directory_url

Returns the support page of this MT application. configurable using the
SupportDirectoryURL configuration directive, otherwise default to
static_file_url/support/

=head2 $app->support_directory_path

Returns the location of the support directory for this app on the file
system. configurable using the SupportDirectoryPath configuration directive,
otherwise default to static_file_path/support/

=head2 MT->get_timer

Returns an instance of L<MT::Util::ReqTimer> for use in timing MT's
operations.

=head2 MT->log_times

Used as part of Movable Type's performance logging framework. This method
is called internally, once at the startup of Movable Type, and once as it
is shutting down.

=head2 MT->time_this($string, $code)

Utility method to time a particular routine. This will log the execution
time of the C<$code> coderef with the identifying phrase C<$string> using
MT's performance logging framework.

=head2 MT::refresh_cache($cb)

A callback handler that invalidates the cache of MT's caching driver.
See L<MT::Cache::Negotiate>.

=head2 MT->register_refresh_cache_event($callback)

Registers a callback that will cause the MT cache to invalidate itself.
See L<MT::Cache::Negotiate>.

=head1 ERROR HANDLING

On an error, all of the above methods return C<undef>, and the error message
can be obtained by calling the method I<errstr> on the class or the object
(depending on whether the method called was a class method or an instance
method).

For example, called on a class name:

    my $mt = MT->new or die MT->errstr;

Or, called on an object:

    $mt->rebuild(BlogID => $blog_id)
        or die $mt->errstr;

=head1 DEBUGGING

MT has a package variable C<$MT::DebugMode> which is assigned through
your MT configuration file (DebugMode setting). If this is set to
any non-zero value, MT applications will display any C<warn>'d
statements to a panel that is displayed within the app.

The DebugMode is a bit-wise setting and offers the following options:

    1 - Display debug messages
    2 - Display a stack trace for messages captured
    4 - Lists queries issued by Data::ObjectDriver
    8 - Reports on MT templates that take more than 1/4 second to build*
    128 - Outputs app-level request/response information to STDERR.

These can be combined, so if you want to display queries and debug messages,
use a DebugMode of 5 for instance.

You may also use the local statement to temporarily apply a particular bit,
if you want to scope the debug messages you receive to a block of code:

    local $MT::DebugMode |= 4;  # show me the queries for the following
    my $obj = MT::Entry->load({....});

*DebugMode bit 8 actually outputs it's messages to STDERR (which typically
is sent to your web server's error log).

=head1 CALLBACKS

Movable Type has a variety of hook points at which a plugin can attach
a callback.

In each case, the first parameter is an L<MT::Callback> object which
can be used to pass error information back to the caller.

The app-level callbacks related to rebuilding are documented
in L<MT::WeblogPublisher>. The specific apps document the callbacks
which they invoke.

=head2 NewUserProvisioning($cb, $user)

This callback is invoked when a user is being added to Movable Type.
Movable Type itself registers for this callback (with a priority of 5)
to provision the user with a new weblog if the system has been configured
to do so.

=head2 post_init($cb, \%param)

This callback is invoked when MT is initialized and ready to run.
This callback is invoked after MT initialized addons, plugins, schema
and permissions.  The arguments passed to initialize MT is passed
through to the callback.

=head1 LICENSE

The license that applies is the one you agreed to when downloading
Movable Type.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, MT is Copyright 2001-2013 Six Apart.
All rights reserved.

=cut
