# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Plugin;

use strict;

use MT::ErrorHandler;
@MT::Plugin::ISA = qw( MT::ErrorHandler );

# static method
sub select {
    my ($pkg, $class)  = @_;
    if ($class && $class !~ m/::/) {
        $class = $pkg . '::' . $class;
    } elsif (!$class) {
        $class = $pkg;
    }
    my @plugins;
    foreach (@MT::Plugins) {
        push @plugins, $_ if UNIVERSAL::isa($_, $class);
    }
    @plugins;
}

sub new {
    my $class = shift;
    my ($self) = ref$_[0] ? @_ : {@_};
    $self->{__settings} = {};
    bless $self, $class;
    $self->init();
    $self;
}

sub init {
    my $plugin = shift;
    if (my $cb = $plugin->callbacks) {
        if (ref $cb eq 'ARRAY') {
            foreach (@$cb) {
                MT->add_callback($_->{name}, $_->{priority} || 5, $plugin, $_->{code});
            }
        } elsif (ref $cb eq 'HASH') {
            foreach (keys %$cb) {
                if (ref $cb->{$_} eq 'CODE') {
                    MT->add_callback($_, 5, $plugin, $cb->{$_});
                } elsif (ref $cb->{$_} eq 'HASH') {
                    MT->add_callback($_, $cb->{$_}{priority} || 5, $plugin, $cb->{$_}{code});
                }
            }
        }
    }
    if (my $jf = $plugin->junk_filters) {
        if (ref $jf eq 'ARRAY') {
            $_->{plugin} = $plugin for @$jf;
            MT->register_junk_filter($jf);
        } elsif (ref $jf eq 'HASH') {
            foreach (keys %$jf) {
                MT->register_junk_filter({
                    name => $_,
                    code => $jf->{$_},
                    plugin => $plugin
                });
            }
        }
    }
    if (my $filters = $plugin->text_filters) {
        MT->add_text_filter($_, $filters->{$_}) for keys %$filters;
    }
    if (my $classes = $plugin->log_classes) {
        MT->add_log_class($_, $classes->{$_}) for keys %$classes;
    }
    if (my $tags = $plugin->template_tags) {
        require MT::Template::Context;
        MT::Template::Context->add_tag($_, $tags->{$_}) for keys %$tags;
    }
    if (my $tags = $plugin->conditional_tags) {
        require MT::Template::Context;
        MT::Template::Context->add_conditional_tag($_, $tags->{$_}) for keys %$tags;
    }
    if (my $tags = $plugin->container_tags) {
        require MT::Template::Context;
        MT::Template::Context->add_container_tag($_, $tags->{$_}) for keys %$tags;
    }
    if (my $f = $plugin->global_filters) {
        require MT::Template::Context;
        MT::Template::Context->add_global_filter($_, $f->{$_}) for keys %$f;
    }
}

sub init_app {
    my $plugin = shift;
    my ($app) = @_;
    my $app_pkg = ref $app;
    if (my $init = $plugin->{init_app}) {
        if (ref $init eq 'HASH') {
            if ($init->{$app_pkg}) {
                $init->{$app_pkg}->($plugin, @_);
            }
        } elsif (ref $init eq 'CODE') {
            $init->($plugin, @_);
        }
    }
    if (my $methods = $plugin->app_methods) {
        if (my $app_methods = $methods->{$app_pkg}) {
            foreach my $meth (keys %$app_methods) {
                $MT::App::Global_actions{$app_pkg}{$meth} = $app_methods->{$meth};
            }
        }
    }
    # Localize these settings which are used by add_plugin_action to
    # construct the hyperlinks to the plugin CGI.
    local $MT::plugin_sig = $plugin->{plugin_sig};
    local $MT::plugin_envelope = $plugin->envelope;
    if (my $actions = $plugin->app_action_links) {
        if (my $app_actions = $actions->{$app_pkg}) {
            if (ref $app_actions eq 'ARRAY') {
                foreach (@$app_actions) {
                    $app->add_plugin_action($_->{type}, $_->{link}, $_->{link_text});
                }
            } elsif (ref $app_actions eq 'HASH') {
                $app->add_plugin_action($_, $app_actions->{$_}{link}, $app_actions->{$_}{link_text})
                    for keys %$app_actions;
            }
        }
    }
    if (my $actions = $plugin->app_itemset_actions) {
        if (my $app_actions = $actions->{$app_pkg}) {
            if (ref $app_actions eq 'ARRAY') {
                $app->add_itemset_action($_) for @$app_actions;
            } elsif (ref $app_actions eq 'HASH') {
                $app->add_itemset_action({ type => $_, %{ $app_actions->{$_} }})
                    for keys %$app_actions;
            }
        }
    }
}

sub init_request {
    my $plugin = shift;
    my ($app) = @_;
    delete $plugin->{__config_obj} if exists $plugin->{__config_obj};
    my $app_pkg = ref $app;
    if (my $init = $plugin->{init_request}) {
        if (ref $init eq 'HASH') {
            if ($init->{$app_pkg}) {
                $init->{$app_pkg}->($plugin, @_);
            }
        } elsif (ref $init eq 'CODE') {
            $init->($plugin, @_);
        }
    }
}

sub init_tasks {
    my $plugin = shift;
    if (my $tasks = $plugin->tasks) {
        if (ref $tasks eq 'ARRAY') {  # an array of MT::Task objects
            MT->add_task($_) for @$tasks;
        } elsif (ref $tasks eq 'HASH') {  # an array of task metadata
            foreach (keys %$tasks) {
                my $task;
                if (ref $tasks->{$_} eq 'CODE') {
                    $task = { key => $_, code => $tasks->{$_} };
                } elsif (ref $tasks->{$_} eq 'HASH') {
                    $task = { %{ $tasks->{$_} }, key => $_ };
                }
                MT->add_task(MT::Task->new($task));
            }
        } elsif (UNIVERSAL::isa($tasks, 'MT::Task')) {
            MT->add_task($tasks);       # a single MT::Task object
        }
    }
}

sub _getset {
    my $p = (caller(1))[3]; $p =~ s/.*:://;
    @_ > 1 ? $_[0]->{$p} = $_[1] : $_[0]->{$p};
}

sub _getset_translate {
    my $p = (caller(1))[3]; $p =~ s/.*:://;
    $_[0]->{$p} = $_[1] if @_ > 1;
    $_[0]->l10n_filter($_[0]->{$p} || '');
}

sub key { &_getset }
sub name { &_getset_translate }
sub author_name { &_getset_translate }
sub author_link { &_getset }
sub plugin_link { &_getset }
sub version { &_getset }
sub schema_version { &_getset }
sub config_link { &_getset }
sub doc_link { &_getset }
sub description { &_getset_translate }
sub envelope { &_getset }
sub settings { &_getset }
sub icon { &_getset }
sub callbacks { &_getset }
sub upgrade_functions { &_getset }
sub object_classes { &_getset }
sub junk_filters { &_getset }
sub text_filters { &_getset }
sub template_tags { &_getset }
sub conditional_tags { &_getset }
sub log_classes { &_getset }
sub container_tags { &_getset }
sub global_filters { &_getset }
sub app_methods { &_getset }
sub app_action_links { &_getset }
sub app_itemset_actions { &_getset }
sub tasks { &_getset }

sub needs_upgrade {
    my $plugin = shift;
    my $sv = $plugin->schema_version;
    return 0 unless defined $sv;
    my $ver = MT->config('PluginSchemaVersion');
    my $cfg_ver = $ver->{$plugin->{plugin_sig}} if $ver;
    if ((!defined $cfg_ver) || ($cfg_ver < $sv)) {
        return 1;
    }
    0;
}

sub load_config {
    my $plugin = shift;
    my ($param, $scope) = @_;
    my $setting_obj = $plugin->get_config_obj($scope);
    my $settings = $setting_obj->data;
    %$param = %$settings;
    foreach my $key (%$settings) {
        next unless defined $key;
        next unless exists $settings->{$key};
        my $value = $settings->{$key};
        next if !defined $value or $value =~ m/\s/ or length($value) > 100;
        $param->{$key.'_'.$value} = 1;
    }
}

sub save_config {
    my $plugin = shift;
    my ($param, $scope) = @_;
    my $pdata = $plugin->get_config_obj($scope);
    $scope =~ s/:.*//;
    my @vars = $plugin->config_vars($scope);
    my $data = $pdata->data() || {};
    foreach (@vars) {
        $data->{$_} = exists $param->{$_} ? $param->{$_} : undef;
    }
    $pdata->data($data);
    $pdata->save() or die $pdata->errstr;
}

sub reset_config {
    my $plugin = shift;
    my ($scope) = @_;
    my $obj = $plugin->get_config_obj($scope);
    $obj->remove if $obj->id;
}

sub config_template {
    my $plugin = shift;
    my ($param, $scope) = @_;
    if ($scope) {
        $scope =~ s/:.*//;
    } else {
        $scope = 'system';
    }
    if (my $tmpl = $plugin->{"${scope}_config_template"} || $plugin->{'config_template'}) {
        return $tmpl->($plugin, @_) if ref $tmpl eq 'CODE';
        if ($tmpl =~ /\s/) {
            return $tmpl;
        } else { # no spaces in $tmpl; must be a filename...
            return $plugin->load_tmpl($tmpl);
        }
    }
    return undef;
}

sub config_vars {
    my $plugin = shift;
    my ($scope) = @_;
    $scope ||= 'system';
    my @settings;
    if (my $s = $plugin->settings) {
        foreach my $setting (@$s) {
            my ($name, $param) = @$setting;
            next if $scope && $param->{Scope} && $param->{Scope} ne $scope;
            push @settings, $name;
        }
    }
    @settings;
}

sub set_config_value {
    my $plugin = shift;
    my ($vars, $scope);
    if (ref $_[0] eq 'HASH') {
        ($vars, $scope) = @_;
    } else {
        my ($variable, $value);
        ($variable, $value, $scope) = @_;
        $vars = { $variable => $value };
    }
    my $pdata_obj = $plugin->get_config_obj($scope);
    my $configuration = $pdata_obj->data() || {};
    $configuration->{$_} = $vars->{$_} for keys %$vars;
    $pdata_obj->data($configuration);
    $pdata_obj->save();
}

sub get_config_obj {
    my $plugin = shift;
    my ($scope_id) = @_;
    my $key;
    my $scope = $scope_id;
    if ($scope && $scope ne 'system') {
        $scope =~ s/:.*//; # strip off id, leave identifier
        $key = 'configuration:'.$scope_id;
    } else {
        $scope_id = 'system';
        $scope = 'system';
        $key = 'configuration';
    }
    return $plugin->{__config_obj}{$scope_id} if $plugin->{__config_obj}{$scope_id};
    require MT::PluginData;
    # calling "name" directly here to avoid localization
    my $pdata_obj = MT::PluginData->load({plugin => $plugin->key || $plugin->{name},
                                          key => $key});
    if (!$pdata_obj) {
        $pdata_obj = MT::PluginData->new();
        $pdata_obj->plugin($plugin->key || $plugin->{name});
        $pdata_obj->key($key);
    }
    $plugin->{__config_obj}{$scope_id} = $pdata_obj;
    my $data = $pdata_obj->data() || {};
    $plugin->apply_default_settings($data, $scope_id);
    $pdata_obj->data($data);
    $pdata_obj;
}

sub apply_default_settings {
    my $plugin = shift;
    my ($data, $scope_id) = @_;
    my $scope = $scope_id;
    if ($scope =~ m/:/) {
        $scope =~ s/:.*//;
    } else {
        $scope_id = 'system';
    }
    my $defaults;
    my $s = $plugin->settings;
    if ($s && ($defaults = $s->defaults($scope))) {
        foreach (keys %$defaults) {
            $data->{$_} = $defaults->{$_} if !exists $data->{$_};
        }
    }
}

sub get_config_hash {
    my $plugin = shift;
    $plugin->get_config_obj(@_)->data() || {};
}

sub get_config_value {
    my $plugin = shift;
    my ($var, $scope) = @_;
    my $config = $plugin->get_config_hash($scope);
    return exists $config->{$_[0]} ? $config->{$_[0]} : undef;
}

sub load_tmpl {
    my $plugin = shift;
    my($file, @p) = @_;

    my $mt = MT->instance;
    my $path = $mt->config('TemplatePath');
    require HTML::Template;
    my $tmpl;
    my $err; 

    my @paths;
    my $dir = File::Spec->catdir($mt->mt_dir, $plugin->envelope, 'tmpl');
    push @paths, $dir if -d $dir;
    $dir = File::Spec->catdir($mt->mt_dir, $plugin->envelope);
    push @paths, $dir if -d $dir;
    if (my $alt_path = $mt->config('AltTemplatePath')) {
        my $dir = File::Spec->catdir($path, $alt_path);
        if (-d $dir) {              # AltTemplatePath is relative
            push @paths, File::Spec->catdir($dir, $mt->{template_dir})
                if $mt->{template_dir};
            push @paths, $dir;
        } elsif (-d $alt_path) {    # AltTemplatePath is absolute
            push @paths, File::Spec->catdir($alt_path,
                                            $mt->{template_dir})
                if $mt->{template_dir};
            push @paths, $alt_path;
        }
    }
    push @paths, File::Spec->catdir($path, $mt->{template_dir})
        if $mt->{template_dir};
    push @paths, $path;
    my $cache_dir = File::Spec->catdir($path, 'cache');
    undef $cache_dir if (!-d $cache_dir) || (!-w $cache_dir);
    my $type = {'SCALAR' => 'scalarref', 'ARRAY' => 'arrayref'}->{ref $file}
        || 'filename';
    eval {
        $tmpl = HTML::Template->new(
            type => $type, source => $file,
            path => \@paths,
            search_path_on_include => 1,
            die_on_bad_params => 0, global_vars => 1,
            loop_context_vars => 1,
            $cache_dir ? (file_cache_dir => $cache_dir, file_cache => 1, file_cache_dir_mode => 0777) : (),
            @p);
    };
    $err = $@;
    return $plugin->error(
        $mt->translate("Loading template '[_1]' failed: [_2]", $file, $err))
        if $@;

    $tmpl->param(static_uri => $mt->static_path);
    $tmpl->param(script_path => $mt->path);
    $tmpl->param(mt_version => MT->version_id);

    $tmpl->param(language_tag => $mt->current_language);
    my $enc = $mt->config('PublishCharset') ||
              $mt->language_handle->encoding;
    $tmpl->param(language_encoding => $enc);
    $mt->{charset} = $enc;

    if (my $author = $mt->user) {
        $tmpl->param(author_id => $author->id);
        $tmpl->param(author_name => $author->name);
    }

    ## We do this in load_tmpl because show_error and login don't call
    ## build_page; so we need to set these variables here.
    if (UNIVERSAL::isa($mt, 'MT::App')) {
        $tmpl->param(script_url => $mt->uri);
        $tmpl->param(mt_url => $mt->mt_uri);
        $tmpl->param(script_full_url => $mt->base . $mt->uri);
    }

    $tmpl;
}

sub l10n_class { $_[0]->{'l10n_class'} || 'MT::L10N' }

sub translate {
    my $plugin = shift;
    unless ($plugin->{__l10n_handle}) {
        my $lang = MT->current_language || 'en_us';
        eval "require " . $plugin->l10n_class . ";";
        $plugin->{__l10n_handle} = $plugin->l10n_class->get_handle($lang);
    }
    my ($format, @args) = @_;
    my $enc = MT->instance->config('PublishCharset');
    my $str;
    if ($plugin->{__l10n_handle}) {
        if ($enc =~ m/utf-?8/i) {
            $str = $plugin->{__l10n_handle}->maketext($format, @args);
        } else {
            $str = MT::I18N::encode_text($plugin->{__l10n_handle}->maketext($format, map {MT::I18N::encode_text($_, $enc, 'utf-8')} @args),'utf-8', $enc);
        }
    }
    if (!defined $str) {
        $str = MT->translate(@_);
    }
    $str;
}

sub translate_templatized {
    my $plugin = shift;
    my($text) = @_;
    $text =~ s!(<MT_TRANS(?:\s+((?:\w+)\s*=\s*(["'])(?:<[^>]+?>|[^\3]+?)+?\3))+?\s*/?>)!
        my($msg, %args) = ($1);
        while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<[^>]+?>|[^\2])*?)\2/g) {  #"
            $args{$1} = $3;
        }
        $args{params} = '' unless defined $args{params};
        my @p = map MT::Util::decode_html($_),
            split /\s*%%\s*/, $args{params};
        @p = ('') unless @p;
        my $translation = $plugin->translate($args{phrase}, @p);
        $translation =~ s/([\\'])/\\$1/sg if $args{escape};
        $translation;
    !ge;
    $text;
}

sub l10n_filter { $_[0]->translate_templatized($_[1]) }

package MT::PluginSettings;

sub new {
    my $pkg = shift;
    my ($self) = @_;
    bless $self, $pkg;
}

sub defaults {
    my $settings = shift;
    my ($scope) = @_;
    my $defaults = {};
    foreach my $setting (@$settings) {
        my ($name, $param) = @$setting;
        next unless exists $param->{Default};
        next if $scope && $param->{Scope} && $param->{Scope} ne $scope;
        $defaults->{$name} = $param->{Default};
    }
    $defaults;
}

1;
__END__

=head1 NAME

MT::Plugin - Movable Type class holding information that describes a
plugin

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
            'type' => {
                key => 'unique_action_name',
                label => 'Uppercase text',
                code => \&itemset_handler
            }
        }
    }

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

=head1 METHODS

Each of the above arguments to the constructor is also a 'getter'
method that returns the corresponding value. C<MT::Plugin> also offers
the following methods:

=head2 $plugin->init_app

For subclassed MT::Plugins that declare this method, it is invoked when
the application starts up.

=head2 $plugin->init_request

For subclassed MT::Plugins that declare this method, it is invoked when
the application begins handling a new request.

=head2 $plugin->envelope

Returns the path to the plugin, relative to the MT directory. This is
determined automatically when the plugin is loaded.

=head2 $plugin->set_config_value($key, $value[, $scope])

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

Handles loading configuration data from the plugindata table.

=head2 $plugin->load_tmpl($file[, ...])

Used to load a HTML::Template object relative to the plugin's directory.
It will scan both the plugin's directory and a directory named 'tmpl'
underneath it. It will passthrough parameters that follow the $file
parameter into the HTML::Template constructor.

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

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
