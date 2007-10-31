# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Component;

use strict;
use base qw( Class::Accessor::Fast MT::ErrorHandler );
use MT::Util qw(encode_js);

__PACKAGE__->mk_accessors(qw( id path envelope version schema_version ));

BEGIN {

    # my @registry_methods = qw( callbacks upgrade_functions object_types
    #     junk_filters text_filters permissions importers rebuild_options
    #     tasks );
    my @registry_methods = qw( callbacks );
    foreach my $meth (@registry_methods) {
        my $sub = sub { &_getset( shift, $meth, @_ ) };
        no strict 'refs';
        *$meth = $sub;
    }
}

# static method
sub select {
    my ( $pkg, $class ) = @_;
    if ( $class && $class !~ m/::/ ) {
        $class = $pkg . '::' . $class;
    }
    elsif ( !$class ) {
        $class = $pkg;
    }
    my @plugins;
    foreach my $p (@MT::Plugins) {
        push @plugins, $p if UNIVERSAL::isa( $p, $class );
    }
    return @plugins;
}

sub new {
    my $class = shift;
    my ($self) = ref $_[0] ? @_ : {@_};
    bless $self, $class;
    $self->init();
    $self;
}

sub init {
    my $c = shift;
    $c->init_registry() or return;

    # plugin callbacks are initialized after they finish loading.
    $c->init_callbacks() unless $c->isa('MT::Plugin');
    $c;
}

sub init_callbacks {
    my $c = shift;

    if ( $c->can('init_app') ) {
        MT->add_callback(
            'init_app',
            5, $c,
            sub {
                my $cb = shift;
                local $MT::plugin_registry = $c->{registry};
                $c->init_app(@_);
            }
        );
    }
    elsif (_getset( $c, 'init_app' )
        || _getset( $c, 'applications' )
        || $c->can('init_app') )
    {
        MT->add_callback( 'init_app', 5, $c, \&on_init_app );
    }

    if ( $c->can('init_request') ) {
        MT->add_callback(
            'init_request',
            5, $c,
            sub {
                my $cb = shift;
                local $MT::plugin_registry = $c->{registry};
                $c->init_request(@_);
            }
        );
    }
    elsif ( _getset( $c, 'init_request' ) || _getset( $c, 'applications' ) ) {
        MT->add_callback( 'init_request', 5, $c, \&on_init_request );
    }

    if ( $c->{init_tasks} ) {
        MT->add_callback( 'tasks', 5, $c, $c->{init_tasks} );
    }
    elsif ( $c->can('init_tasks') ) {
        MT->add_callback( 'tasks', 5, $c,
            sub { my $cb = shift; $c->init_tasks(@_) } );
    }

    if ( my $callbacks = $c->callbacks ) {
        if ( ref $callbacks eq 'ARRAY' ) {
            foreach my $cb (@$callbacks) {
                MT->add_callback( $_->{name}, $cb->{priority} || 5,
                    $c, $cb->{handler} || $cb->{code} );
            }
        }
        elsif ( ref $callbacks eq 'HASH' ) {
            foreach my $cbname ( keys %$callbacks ) {
                if ( ref $callbacks->{$cbname} eq 'CODE' ) {
                    MT->add_callback( $cbname, 5, $c, $callbacks->{$cbname} );
                }
                elsif ( ref $callbacks->{$cbname} eq 'HASH' ) {
                    MT->add_callback(
                        $cbname,
                        $callbacks->{$cbname}{priority} || 5,
                        $c,
                        $callbacks->{$cbname}{handler}
                          || $callbacks->{$cbname}{code}
                    );
                }
                elsif ( ref $callbacks->{$cbname} eq 'ARRAY' ) {
                    my $list = $callbacks->{$cbname};
                    MT->add_callback( $cbname, $_->{priority} || 5,
                        $c, $_->{handler} || $_->{code} )
                      foreach @$list;
                }
            }
        }
    }
}

sub load_registry {
    my $c      = shift;
    my ($file) = @_;
    my $path   = $c->path or return;
    $path = File::Spec->catfile( $c->path, $file );
    return unless -f $path;
    require YAML::Tiny;
    my $y = eval { YAML::Tiny->read($path) }
        or die "Error reading $path: " . $YAML::Tiny::errstr;
    if ( ref($y) ) {

        # skip over non-hash elements
        shift @$y while @$y && ( ref( $y->[0] ) ne 'HASH' );
        return $y->[0] if @$y;
    }
    return {};
}

sub init_registry {
    my $c = shift;
    my $r = $c->load_registry("config.yaml");
    if ( !$r ) {
        return 1;
    }

   # TBD: 'extends' support...
   # if (my $ext = $r->{extends}) {
   #     # require any other components declared here
   #     $ext = [ $ext ] unless ref($ext) eq 'ARRAY';
   #     foreach my $comp (@$ext) {
   #         MT->require_component($comp)
   #             or return $c->error("Error loading required component: $comp");
   #     }
   # }
    $c->registry($r);

    # map key registry elements into metadata
    foreach my $prop (qw(version schema_version)) {
        $c->$prop( $r->{$prop} ) if exists $r->{$prop};
    }
    $c->name( $r->{label} ) if exists $r->{label};
    return 1;
}

sub on_init_app {
    my $cb      = shift;
    my $c       = $cb->plugin;
    my ($app)   = @_;
    my $app_pkg = ref $app;
    my $init;
    if ( $init = _getset( $c, 'init_app' ) ) {
        if ( ref $init eq 'HASH' ) {
            $init = $init->{$app_pkg};
        }
    }
    else {
        $init = $c->registry( "applications", $app->id, "init" );
    }
    if ( $init && !ref($init) ) {
        $init = MT->handler_to_coderef($init);
    }
    if ( $init && ( ref $init eq 'CODE' ) ) {
        local $MT::plugin_registry = $c->{registry};
        $init->( $c, @_ );
    }
    elsif ( $c->can('init_app') ) {
        local $MT::plugin_registry = $c->{registry};
        $c->init_app(@_);
    }
}

sub on_init_request {
    my $cb      = shift;
    my $c       = $cb->plugin;
    my ($app)   = @_;
    my $app_pkg = ref $app;
    my $init;
    if ( $init = _getset( $c, 'init_request' ) ) {
        if ( ref $init eq 'HASH' ) {
            $init = $init->{$app_pkg} if exists $init->{$app_pkg};
        }
    }
    else {
        $init = $c->registry( "applications", $app->id, "init_request" );
    }
    if ( $init && !ref($init) ) {
        $init = MT->handler_to_coderef($init);
    }
    if ( ref $init eq 'CODE' ) {
        local $MT::plugin_registry = $c->{registry};
        $init->( $app, @_ );
    }
}

sub _getset {
    my $c = shift;
    my ($prop) = @_;
    if ( exists $c->{registry}{$prop} ) {
        if ( @_ > 1 ) {
            return $c->{registry}{$prop} = $_[1];
        }
        else {
            my $out = $c->{registry}{$prop};

            # Handle reference to another YAML file
            # (ie, app-cms.yaml/tags.yaml/etc.)
            if ( defined($out) && !ref($out) && ( $out =~ m/^[-\w]+\.yaml$/ ) )
            {
                my $r = $c->load_registry($out);
                if ($r) {
                    return $c->{registry}{$prop} = $r;
                }
                return undef;
            }
            return $out;
        }
    }
    return @_ > 1 ? $c->{$prop} = $_[1] : $c->{$prop};
}

sub _getset_translate {
    my $c = shift;
    my ($p) = @_;
    if ( !$p ) {
        $p = ( caller(1) )[3];
        $p =~ s/.*:://;
    }
    my $return;
    if ( exists $c->{registry}{$p} ) {
        $return = @_ > 1 ? $c->{registry}{$p} = $_[1] : $c->{registry}{$p};
    }
    else {
        $return = @_ > 1 ? $c->{$p} = $_[1] : $c->{$p};
    }
    Carp::confess( "c isn't set" . Data::Dumper::Dumper( \@MT::Plugins ) )
      if !ref($c) || ( ref($c) eq 'HASH' );
    return $c->l10n_filter( defined $return ? $return : '' );
}

sub name { &_getset_translate }

sub label {
    my $c = shift;
    return $c->_getset('label') || $c->name();
}

sub description { &_getset_translate }

sub needs_upgrade {
    my $c  = shift;
    my $sv = $c->schema_version;
    return 0 unless defined $sv;
    my $key     = 'PluginSchemaVersion';
    my $id      = $c->id;
    my $ver     = MT->config($key);
    my $cfg_ver = $ver->{$id} if $ver;
    if ( ( !defined $cfg_ver ) || ( $cfg_ver < $sv ) ) {
        return 1;
    }
    0;
}

sub template_paths {
    my $c = shift;

    my $mt   = MT->instance;
    my $path = $mt->config('TemplatePath');

    my @paths;
    my $dir = File::Spec->catdir( $c->path, 'tmpl' );
    push @paths, $dir if -d $dir;
    $dir = $c->path;
    push @paths, $dir if -d $dir;
    if ( my $alt_path = $mt->config('AltTemplatePath') ) {
        if ( -d $alt_path ) {    # AltTemplatePath is absolute
            push @paths, File::Spec->catdir( $alt_path, $mt->{template_dir} )
              if $mt->{template_dir};
            push @paths, $alt_path;
        }
    }
    push @paths, File::Spec->catdir( $path, $mt->{template_dir} )
      if $mt->{template_dir};
    push @paths, $path;
    return @paths;
}

sub load_tmpl {
    my $c = shift;
    my ($file) = @_;

    my $mt = MT->instance;

    # my $cache_dir = File::Spec->catdir($path, 'cache');
    # undef $cache_dir if (!-d $cache_dir) || (!-w $cache_dir);
    my $type = { 'SCALAR' => 'scalarref', 'ARRAY' => 'arrayref' }->{ ref $file }
      || 'filename';

    require MT::Template;
    my $tmpl = MT::Template->new(
        type   => $type,
        source => $file,
        path   => [ $c->template_paths ]
    );
    my $err = $tmpl->errstr unless defined $tmpl;
    return $c->error(
        $mt->translate( "Loading template '[_1]' failed: [_2]", $file, $err ) )
      if $err;

    ## We do this in load_tmpl because show_error and login don't call
    ## build_page; so we need to set these variables here.
    if ( $mt->isa('MT::App') ) {
        $mt->set_default_tmpl_params($tmpl);
    }
    else {
        my %param = (
            static_uri        => $mt->static_path,
            script_path       => $mt->path,
            mt_version        => MT->version_id,
            language_tag      => $mt->current_language,
            language_encoding => $mt->charset,
        );
    
        if ( my $author = $mt->user ) {
            $param{author_id}   = $author->id;
            $param{author_name} = $author->name;
            $param{can_logout} = MT::Auth->can_logout;
        }

        $tmpl->param( \%param );
    }

    return $tmpl;
}

sub l10n_class { _getset( shift, 'l10n_class', @_ ) || 'MT::L10N' }

sub translate {
    my $c       = shift;
    my $handles = MT->request('l10n_handle') || {};
    my $h       = $handles->{ $c->id };
    unless ($h) {
        my $lang = MT->current_language || MT->config->DefaultLanguage;
        eval "require " . $c->l10n_class . ";";
        if ($@) {
            $h = MT->language_handle;
        }
        else {
            $h = $c->l10n_class->get_handle($lang);
        }
        $handles->{ $c->id } = $h;
        MT->request( 'l10n_handle', $handles );
    }
    my ( $format, @args ) = @_;
    foreach (@args) {
        $_ = $_->() if ref($_) eq 'CODE';
    }
    my $enc = MT->instance->config('PublishCharset');
    my $str;
    if ($h) {
        if ( $enc =~ m/utf-?8/i ) {
            $str = $h->maketext( $format, @args );
        }
        else {
            $str = MT::I18N::encode_text(
                $h->maketext(
                    $format,
                    map { MT::I18N::encode_text( $_, $enc, 'utf-8' ) } @args
                ),
                'utf-8', $enc
            );
        }
    }
    if ( !defined $str ) {
        $str = MT->translate(@_);
    }
    $str;
}

sub translate_templatized {
    my $c = shift;
    my ($text) = @_;
    while (1) {
        $text =~
s!(<(?:_|MT)_TRANS(?:\s+((?:\w+)\s*=\s*(["'])(?:<[^>]+?>|[^\3]+?)*?\3))+?\s*/?>)!
        my($msg, %args) = ($1);
        while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<[^>]+?>|[^\2])*?)?\2/g) {  #"
            $args{$1} = $3;
        }
        $args{params} = '' unless defined $args{params};
        my @p = map MT::Util::decode_html($_),
                split /\s*%%\s*/, $args{params}, -1;
        @p = ('') unless @p;
        my $translation = $c->translate($args{phrase}, @p);
        if (exists $args{escape}) {
            if (lc($args{escape}) eq 'html') {
                $translation = encode_html($translation);
            } else {
                # fallback for js/javascript/singlequotes
                $translation = encode_js($translation);
            }
        }
        $translation;
        !igem or last;
    }
    return $text;
}

sub l10n_filter { $_[0]->translate_templatized( $_[1] ) }

# can be invoked statically or with an instance.
# if invoked statically, it queries all available plugins
#   MT::Plugin->registry("applications")
# if invoked with an instance, it only selects for that plugin's registry
#   $foo_plugin->registry("applications")

sub registry {
    my $c = shift;
    if ( ref $c ) {
        if ( !@_ ) { return $c->{registry} ||= {} }
        if ( ref $_[0] ) {
            return $c->{registry} = shift;
        }
        my @path = @_;
        my $r    = $c->{registry};
        return undef unless $r;
        my ( $last_r, $last_p );
        foreach my $p (@path) {
            if ( ref $p ) {

                # Handle the case where an assignment
                # is being made to a registry item. Ie
                # $comp->registry("foo","bar","baz", { stuff => ... })
                $last_r->{$last_p} = $p;
                $r = $last_r;
                last;
            }
            if ( exists $r->{$p} ) {
                my $v = $r->{$p};

                # check for a yaml file reference...
                if ( !ref($v) && ( $v =~ m/^[-\w]+\.yaml$/ ) ) {
                    my $f = File::Spec->catfile( $c->path, $v );
                    if ( -f $f ) {
                        require YAML::Tiny;
                        my $y = eval { YAML::Tiny->read($f) }
                            or die "Error reading $f: " . $YAML::Tiny::errstr;

                        # skip over non-hash elements
                        shift @$y while @$y && ( ref( $y->[0] ) ne 'HASH' );
                        if (@$y) {
                            $r->{$p} = $y->[0];
                        }
                    }
                }
                elsif ( ref($v) eq 'CODE' ) {
                    $r->{$p} = $v->($c);
                }
                $last_r = $r;
                $last_p = $p;
                $r      = $r->{$p};
            }
            else {
                return undef;
            }
        }

        # deepscan for any label elements since they will need translation
        if ( ref $r eq 'HASH' ) {
            __deep_localize_labels( $c, $r );
            $_->{plugin} = $c for grep { ref $_ eq 'HASH' } values %$r;
        }

        # $r should now be the element of the path requested
        return $r;
    }
    else {
        my @objs = $c->select();
        my @list;
        foreach my $o (@objs) {
            my $r = $o->registry(@_);
            push @list, $r if defined $r;
        }
        return @list ? \@list : undef;
    }
}

sub __deep_localize_labels {
    my ( $c, $hash ) = @_;
    foreach my $k ( keys %$hash ) {
        if ( ref( $hash->{$k} ) eq 'HASH' ) {
            __deep_localize_labels( $c, $hash->{$k} );
        }
        else {
            next unless $k =~ m/(?:\b|_)label\b/;
            if ( !ref( my $label = $hash->{$k} ) ) {
                $hash->{$k} = sub { $c->translate($label) };
            }
        }
    }
}

1;
__END__

=head1 NAME

MT::Component - Movable Type class that describes a component

=head1 SYNOPSIS

    package MyPlugin;

    use base 'MT::Plugin';
    use vars qw($VERSION);
    $VERSION = 1.12;

    my $plugin = new MyPlugin({
        name => 'My Plugin',
        version => $VERSION,
        author_name => 'Conan the Barbaraian',
        author_link => 'http://example.com/',
        plugin_link => 'http://example.com/mt-plugins/example/',
        description => 'Frobnazticates all Diffyhorns',
        config_link => 'myplugin.cgi',
        settings => new MT::PluginSettings([
            ['option1', { Default => 'default_setting' }],
            ['option2', { Default => 'system_default', Scope => 'system' }],
            ['option2', { Scope => 'blog' }],
        ]),
        config_template => \&config_tmpl
    });
    MT->add_plugin($plugin);

    # Alternatively, instantiating MT::Plugin itself

    my $plugin = new MT::Plugin({
        name => "Example Plugin",
        version => 1.12,
        author_name => "Conan the Barbarian",
        author_link => "http://example.com/",
        plugin_link => "http://example.com/mt-plugins/example/",
        description => "Frobnazticates all Diffyhorns",
        config_link => 'myplugin.cgi',
        doc_link => <documentation URL>,
        settings => new MT::PluginSettings([
            ['option1', { Default => 'default_setting' }],
            ['option2', { Default => 'system_default', Scope => 'system' }],
            ['option2', { Scope => 'blog' }],
        ]),
        config_template => \&config_tmpl
    });
    MT->add_plugin($plugin);

=head1 DESCRIPTION

An I<MT::Plugin> object holds data about a plugin which is used to help
users understand what the plugin does and let them configure the
plugin.

Normally, a plugin will construct an I<MT::Plugin> object and pass it
to the C<add_plugin> method of the I<MT> class:

    MT->add_plugin($plugin);

This will help populate additional information about the plugin on
the plugin listing in the MT system overview.

When adding callbacks, you will use the plugin object as well; this
object is used to help the user identify errors that arise in
executing the callback. For example, to add a callback which is
executed before the I<MT::Foo> object is saved to the database, you might
make a call like this:

   MT::Foo->add_callback("pre_save", 10, $plugin, \&callback_function);

This call will tell I<MT::Foo> to call the function
C<callback_function> just before executing any C<save> operation. The
number '10' is signalling the priority, which controls the order in
which various plugins are called. Lower number callbacks are called
first.

=head1 ARGUMENTS

=over 4

=item * key

The key is an optional, but recommended element of the plugin. This
value is used to uniquely identify the plugin and should never change
from one version to the next. The key is used when available in storing
plugin configuration data using the C<MT::PluginData> package.

=item * name (required)

A human-readable string identifying the plugin. This will be displayed
in the plugin's slug on the MT front page.

=item * version

The version number for the release of the plugin. Will be displayed
next to the plugin's name wherever listed. This information is not
required, but recommended.

=item * schema_version

If your plugin declares a list of object classes, the schema_version
is used to determine whether your classes require installation or
upgrade. MT will store your plugin's schema_version in the C<MT::Config>
table for future reference.

=item * description

A longer string giving a brief description of what the plugin does.

=item * doc_link

A URL pointing to some documentation for the plugin. This can be a
relative path, in which case it identifies documentation within the
plugin's distribution, or it can be an absolute URL, pointing at
off-site documentation.

=item * config_link

The relative path of a CGI script or some other configuration
interface for the plugin. This is relative to the "plugin
envelope"--that is, the directory underneath C<mt/plugins> where all
your plugin files live.

=item * author_name

The name of the individual or company that created the plugin.

=item * author_link

A URL pointing to the home page of the individual or company that
created the plugin.

=item * plugin_link

A URL pointing to the home page for the plugin itself.

=item * config_template

Defines a C<HTML::Template> file by name to use for plugin configuration.
This value may also be a code reference, which MT would call
passing three arguments: the plugin object instance, a hashref of
C<HTML::Template> parameter data and the scope value (either "system"
for system-wide configuration or "blog:N" where N is the active blog id).

=item * system_config_template

Defines a C<HTML::Template> file by name to use for system-wide
plugin configuration. If not defined, MT will fall back to the config_template
setting. This value may also be a code reference, which MT would call
passing three arguments: the plugin object instance, a hashref of
C<HTML::Template> parameter data and the scope value (always "system" in
this case).

=item * blog_config_template

Defines a C<HTML::Template> file by name to use for weblog-specific
plugin configuration. If not defined, MT will fall back to the config_template
setting. This value may also be a code reference, which MT would call
passing three arguments: the plugin object instance, a hashref of
C<HTML::Template> parameter data and the scope value (for weblogs, this
would be "blog:N", where N is the active blog id).

=item * settings

Identifies the plugin's configuration settings.

=item * app_methods

Used to register custom mode handlers for one or more application classes.
This parameter accepts a hashref of package names mapping to a hashref of
modes and their handlers. For example:

    app_methods => {
        'MT::MyPackage' => {
            'mode1' => \&handler1,
            'mode2' => \&handler2
        }
    }

=item * app_action_links

Used to register plugin action links that are displayed on various pages
within the MT::App::CMS application. The format for this key is:

    app_action_links => {
        'MT::App::CMS' => {   # application the action applies to
            'type' => {
                link => 'myplugin.cgi',
                link_text => 'Configure MyPlugin'
            }
        }
    }

This is an alternative to using C<MT-E<gt>add_plugin_action>.

=item * app_itemset_actions

Used to register plugin itemset action links that are displayed on various
listings within the MT::App::CMS application. The format for this key is:

    app_itemset_actions => {
        'MT::App::CMS' => {   # application the action applies to
            $type => {
                key => 'unique_action_name',
                label => 'Uppercase text',
                code => \&itemset_handler
            }
        }
    }

Where C<$type> should be an MT item such as 'entry', 'asset', 'ping',
etc.

Please see the full documentation of these C<type> options in the
L<MT::App::CMS> add_itemset_action section.

In the event that you need to register multiple actions for a single type,
you can use the alternate format:

    app_itemset_actions => {
        'MT::App::CMS' => [   # application the action applies to
            {   type => 'type',
                key => 'unique_action_name',
                label => 'Uppercase text',
                code => \&itemset_handler_upper
            },
            {   type => 'type',
                key => 'unique_action_name2',
                label => 'Lowercase text',
                code => \&itemset_handler_lower
            }
        ]
    }

This is an alternative to using C<MT::App::CMS-E<gt>add_itemset_action>.

=item * callbacks

Used to register object or application callbacks with the callback
system. This can be used in lieu of MT->add_callback. Example:

    callbacks => {
        'callback_name' => \&callback_handler,
        'another_callback' => {
            priority => 1,
            code => \&another_handler
        }
    }

=item * junk_filters

You can register one or more junk detection filters using this
key. The format is:

    junk_filters => {
        'MyJunkFilter' => \&junk_filter_handler
    }

This is an alternative to using C<MT-E<gt>register_junk_filter>.

=item * init_app

It's possible for a plugin to define code that is to be executed upon
app initialization with this parameter. It may be a simple coderef which
will be invoked for all MT::App instances:

    init_app => \&init_app_routine

Or it can be a hashref that maps MT::App package names to a coderef.

    init_app => {
        'MT::App::CMS' => \&init_cms_app_routine,
        'MT::App::Comments' => \&init_comments_app_routine,
    }

=item * init_request

A plugin can use this parameter to define a routine to execute upon
the start of each HTTP request to an application. Like 'init_app', this
parameter can either be a coderef or a hashref for app-specific routines.

=item * template_tags

This parameter is used to declare custom tag handlers for Movable Type.
It is similar in function to C<MT::Template::Context-E<gt>add_tag>.
The parameter is given as a hashref, in this format:

    template_tags => {
        'TagName' => \&tag_handler
    }

You may register one or more template tags in this way.

=item * container_tags

This parameter is used to declare custom container tags for Movable Type.
It is similar in function to C<MT::Template::Context-E<gt>add_container_tag>.
You may register one or more container tags in this way.

    container_tags => {
        'ContainerTag' => \&container_tag_handler
    }

=item * conditional_tags

This parameter is used to declare custom conditional tags for Movable Type.
This is similar in function to C<MT::Template::Context-E<gt>add_conditional_tag>.
You may register one or more conditional tags in this way.

    conditional_tags => {
        'IfCondition' => \&conditional_tag_handler
    }

=item * global_filters

This parameter is used to declare global tag attributes. It is similar in
function to C<MT::Template::Context-E<gt>add_global_filter>. You may
register 1 or more global filters in this way.

    global_filters => {
        'attribute_name' => \&attribute_handler
    }

=item * text_filters

Text formatting filters can be declared with this parameter. It is similar
in function to C<MT-E<gt>add_text_filter>. You may register 1 or more
filters in this way.

    text_filters => {
        'format_name' => { label => "My Text Format", code => \&formatter }
    }

=item * tasks

System tasks that are executed through the C<MT::TaskMgr> can be registered
with this parameter. The format for this parameter is as follows:

    tasks => {
        'task_id' => \&task_code,
        'weekly_task' => {
            name => "My Weekly Task",
            frequency => 24 * 60 * 60 * 7,   # run every 7 days
            code => \&weekly_task_code
        }
    }

The task identifier used for the key of each task registered should be
globally unique. You should use some unique prefix or suffix that only
your plugin will use.

Refer to L<MT::TaskMgr> for more details on the MT task subsystem.

=item * object_classes

Declaration of a list of MT::Object descendant classes that you want
the MT upgrade process to maintain.

    object_classes => [ 'MyPlugin::Foo', 'MyPlugin::Bar' ]

Define this in conjunction with a C<schema_version> to have MT maintain
the schema for your object packages.

=item * upgrade_functions

This defines a list of custom upgrade operations that you may require MT
to use to upgrade your schema from one version to another. For most upgrades
(simple column additions or size changes), this is unnecessary, but if you
require any kind of data manipulation or conversion, you will need to
register an upgrade function to handle it.  Please refer to the L<MT::Upgrade>
package for how to declare an upgrade function.  Here is an example:

    upgrade_functions => {
        'my_plugin_fix_field_a' => {
            version_limit => 1.1,   # runs for schema_version < 1.1
            code => \&plugin_field_a_fixer
        }
    }

=item * icon

Set the icon filename (not including the plugin's static web path).

=item * log_classes

Set the name of the plugin's log classes to use.  For example:

  MT->add_plugin({
    name => "My custom plugin",
    log_classes => { customlog => "MyCustomLog" }
  });

=back

=head1 METHODS

Each of the above arguments to the constructor is also a 'getter'
method that returns the corresponding value. C<MT::Plugin> also offers
the following methods:

=head2 MT::Plugin->new

Return a new I<MT::Plugin> instance.  This method calls the I<init> method.

=head2 $plugin->init

This construction helper method registers plugin I<callbacks>,
I<junk_filters>, I<text_filters>, I<log_classes>, I<template_tags>,
I<conditional_tags>, I<global_filters>.

=head2 $plugin->init_app

For subclassed MT::Plugins that declare this method, it is invoked when
the application starts up.

=head2 $plugin->init_request

For subclassed MT::Plugins that declare this method, it is invoked when
the application begins handling a new request.

=head2 $plugin->init_tasks

For subclassed MT::Plugins that declare this method, it is invoked when
the application begins handling a new task.

=head2 $plugin->envelope

Returns the path to the plugin, relative to the MT directory. This is
determined automatically when the plugin is loaded.

=head2 $plugin->set_config_value($key, $value[, $scope])

See the I<get_config_value> description below.

=head2 $plugin->get_config_value($key[, $scope])

These routines facilitate easy storage of simple configuration
options.  They make use of the PluginData table in the database to
store a set of key-value pairs for each plugin. Call them as follows:

    $plugin->set_config_value($key, $value);
    $value = $plugin->get_config_value($key);

The C<name> field of the plugin object is used as the namespace for
the keys. Thus it would not be wise for one plugin to use the
same C<name> as a different plugin.

=head2 $plugin->get_config_obj([$scope])

Retrieves the MT::PluginData object associated with this plugin
and the scope identified (which defaults to 'system' if unspecified).

=head2 $plugin->apply_default_settings($data[, $scope])

Applies the default plugin settings to the given data.

=head2 $plugin->get_config_hash([$scope])

Retrieves the configuration data associated with this plugin
and returns it a a Perl hash reference. If the scope parameter is not given,
the 'system' scope is assumed.

=head2 $plugin->config_template($params[, $scope])

Called to retrieve a HTML::Template object which will be output as the
configuration form for this plugin. Optionally a scope may be specified
(defaults to 'system').

    my $system_tmpl = $plugin->config_template($params, 'system');
    my $system_tmpl = $plugin->config_template($params);
    my $blog_tmpl = $plugin->config_template($params, 'blog:1');

=head2 $plugin->config_vars([$scope])

Returns an array of configuration setting names for the requested scope.

=head2 $plugin->save_config($param[, $scope])

Handles saving configuration data from the plugin configuration form.

    my $param = { 'option1' => 'x' };
    $plugin->save_config($param); # saves system configuration data
    $plugin->save_config($param, 'system'); # saves system configuration data
    $plugin->save_config($param, 'blog:1'); # saves blog configuration data

=head2 $plugin->load_config($param[, $scope])

This method returns the configuration data associated with a plugin (and
an optional scope) in the given I<param> hash reference.

=head2 $plugin->reset_config($scope)

This method drops the configuration data associated with this plugin
given the scope identified and reverts to th MT defaults.

Handles loading configuration data from the plugindata table.

=head2 $plugin->load_tmpl($file[, ...])

Used to load a HTML::Template object relative to the plugin's directory.
It will scan both the plugin's directory and a directory named 'tmpl'
underneath it. It will passthrough parameters that follow the $file
parameter into the HTML::Template constructor.

=head2 MT::Plugin->select([$class])

Return the list of plugins available for the calling class or of the given
class name argument.

=head2 $plugin->needs_upgrade()

This method compares any previously stored schema version for the
plugin to the current plugin schema version number to determine if an
upgrade is in order.

=head2 $plugin->translate($phrase [, @args])

This method translate the C<$phrase> to the currently selected language
using the localization module for the plugin. The C<@args> parameters
are passed through if given.

=head2 $plugin->translate_templatized($text)

This method calls the plugin's I<translate> method on any E<lt>MT_TRANSE<gt>
tags inside C<$text>.

=head2 $plugin->l10n_filter($text)

This method is an alias for the I<translate_templatized> method.

=head2 $plugin->l10n_class()

This method returns the I<l10n_class> attribute of the plugin or
I<MT::L10N> if not defined.

=head2 $plugin->register_importer()

This method gives plugins access to registry of importers.
Detailed information can be found in I<MT::Import> document.

=head2 Additional Accessor Methods

The following are plugin attributes with accompanying get/set methods.

=over 4

=item * key

=item * name

=item * author_name

=item * author_link

=item * plugin_link

=item * version

=item * schema_version

=item * config_link

=item * doc_link

=item * description

=item * envelope

=item * settings

=item * icon

=item * callbacks

=item * upgrade_functions

=item * object_classes

=item * junk_filters

=item * text_filters

=item * template_tags

=item * conditional_tags

=item * log_classes

=item * container_tags

=item * global_filters

=item * app_methods

=item * app_action_links

=item * app_itemset_actions

=item * tasks

=back

=head1 LOCALIZATION

Proper localization of a plugin requires a bit of structure and discipline.
First of all, your plugin should declare a 'l10n_class' element upon
registration. This defines the base L10N package to use for any translation
done by the plugin:

    # file l10nplugin.pl, in MT_DIR/plugins/l10nplugin

    my $plugin = new MT::Plugin({
        name => "My Localized Plugin",
        l10n_class => "l10nplugin::L10N",
    });

Then, you should have a file like this in C<MT_DIR/plugins/l10nplugin/lib/l10nplugin>:

    # file L10N.pm, in MT_DIR/plugins/l10nplugin/lib/l10nplugin

    package l10nplugin::L10N;
    use base 'MT::Plugin::L10N';
    1;

And then your actual localization modules in C<MT_DIR/plugins/l10nplugin/lib/l10nplugin/L10N>:

    # file en_us.pm, in MT_DIR/plugins/l10nplugin/lib/l10nplugin/L10N

    package l10n::L10N::en_us;

    use base 'l10nplugin::L10N';

    1;

Here's a French module, to localize the plugin name:

    # file fr.pm, in MT_DIR/plugins/l10nplugin/lib/l10nplugin/L10N

    package l10nplugin::L10N::fr;

    use base 'l10nplugin::L10N::en_us';

    our %Lexicon = (
        "My Localized Plugin" => "Mon Plugin Localise",
    );

    1;

And, the following methods of the plugin object are I<automatically>
translated for you, so you don't need to invoke translate on them
yourself:

=over 4

=item * name

=item * author_name

=item * description

=back

To translate individual strings of text from within your plugin code
is done like this:

    my $rebuild_str = $plugin->translate("Publish");

Note that if your plugin does not translate a phrase, it may be translated
by the MT translation matrix if the phrase is found there. So common
MT phrases like "Weblog", "User", etc., are already handled and you should
not have to duplicate the translation of such terms in your plugin's
localization modules.

To translate a template that has embedded E<lt>MT_TRANSE<gt> tags in
them, use the C<translate_templatized> method of the plugin object.

    $tmpl = $plugin->load_tmpl("my_template.tmpl");
    $tmpl->param(\%param);
    my $html = $plugin->translate_templatized($tmpl->output());

=head1 MT::PluginSettings

The MT::PluginSettings package is also declared with this module. It
is used to define a group of settings and their defaults for the plugin.
These settings are processed whenever configuration data is requested
from the plugin.

Example:

    $plugin->{settings} = new MT::PluginSettings([
        ['option1', { Default => 'default_setting' }],
        ['option2', { Default => 'system_default', Scope => 'system' }],
        ['option2', { Scope => 'blog' }],
    ]);

Settings can be assigned a default value and an applicable 'scope'.
Currently, recognized scopes are "system" and "blog".

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
