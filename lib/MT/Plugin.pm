# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Plugin;

use strict;
use warnings;
use base qw( MT::Component );

sub init {
    my $plugin = shift;
    $plugin->{__settings} = {};
    if (   exists $plugin->{app_action_links}
        || exists $plugin->{app_itemset_actions}
        || exists $plugin->{upgrade_functions}
        || exists $plugin->{app_methods}
        || exists $plugin->{junk_filters}
        || exists $plugin->{object_classes} )
    {

        # Found in MT::Compat::v3
        $plugin->legacy_init();
    }
    $plugin->SUPER::init(@_) or return;
    return $plugin;
}

sub id {
    my $plugin = shift;
    my $id     = $plugin->SUPER::id(@_);
    return $id || $plugin->{plugin_sig};
}

sub key { &MT::Component::_getset( shift, 'key', @_ ) }

sub author_name {
    &MT::Component::_getset_translate( shift, 'author_name', @_ );
}
sub author_link { &MT::Component::_getset( shift, 'author_link', @_ ) }
sub plugin_link { &MT::Component::_getset( shift, 'plugin_link', @_ ) }
sub config_link { &MT::Component::_getset( shift, 'config_link', @_ ) }
sub doc_link    { &MT::Component::_getset( shift, 'doc_link',    @_ ) }

sub description {
    &MT::Component::_getset_translate( shift, 'description', @_ );
}

sub settings {
    my $plugin = shift;
    my $s = &MT::Component::_getset( $plugin, 'settings', @_ );
    unless ( ref($s) eq 'MT::PluginSettings' ) {
        $s = MT::PluginSettings->new($s);
        &MT::Component::_getset( $plugin, 'settings', $s );
    }
    return $s;
}
sub icon { &MT::Component::_getset( shift, 'icon', @_ ) }

# Plugin-specific: configuration settings and data
sub load_config {
    my $plugin = shift;
    my ( $param, $scope ) = @_;
    my $setting_obj = $plugin->get_config_obj($scope);
    my $settings    = $setting_obj->data;
    %$param = %$settings;
    foreach my $key ( keys %$settings ) {
        next unless defined $key;
        my $value = $settings->{$key};
        next if !defined $value or $value =~ m/\s/ or length($value) > 100;
        $value = [$value] unless ref $value eq 'ARRAY';
        foreach my $v (@$value) {
            $param->{ $key . '_' . $v } = 1;
        }
    }
}

sub save_config {
    my $plugin = shift;
    my ( $param, $scope ) = @_;
    my $app        = MT->instance;
    my $pdata      = $plugin->get_config_obj($scope);
    my $vars_scope = $scope;
    $vars_scope =~ s/:.*//;
    my @vars = $plugin->config_vars($vars_scope);
    my $data = $pdata->data() || {};
    foreach (@vars) {
        $data->{$_} = exists $param->{$_} ? $param->{$_} : undef;
    }
    $app->run_callbacks( 'save_config_filter.' . $pdata->plugin,
        $plugin, $data, $scope )
        || return $app->error(
        "Error saving plugin settings: " . $plugin->errstr );

    $pdata->data($data);
    MT->request( 'plugin_config.' . $plugin->id, undef );
    $pdata->save() or die $pdata->errstr;
}

sub reset_config {
    my $plugin  = shift;
    my ($scope) = @_;
    my $obj     = $plugin->get_config_obj($scope);
    MT->request( 'plugin_config.' . $plugin->id, undef );
    $obj->remove if $obj->id;
}

sub config_template {
    my $plugin = shift;
    my ( $param, $scope ) = @_;
    if ($scope) {
        $scope =~ s/:.*//;
    }
    else {
        $scope = 'system';
    }
    my $r = $plugin->registry;
    if ( my $tmpl
           = $r->{"${scope}_config_template"}
        || $r->{"config_template"}
        || $plugin->{"${scope}_config_template"}
        || $plugin->{'config_template'} )
    {
        if ( ref $tmpl eq 'HASH' ) {
            $tmpl = MT->handler_to_coderef( $tmpl->{code} );
        }
        return $tmpl->( $plugin, @_ ) if ref $tmpl eq 'CODE';
        if ( $tmpl =~ /\s/ ) {
            return $tmpl;
        }
        else {    # no spaces in $tmpl; must be a filename...
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
    if ( my $s = $plugin->settings ) {
        foreach my $setting (@$s) {
            my ( $name, $param ) = @$setting;
            next if $scope && $param->{scope} && $param->{scope} ne $scope;
            push @settings, $name;
        }
    }
    @settings;
}

sub set_config_value {
    my $plugin = shift;
    my ( $vars, $scope );
    if ( ref $_[0] eq 'HASH' ) {
        ( $vars, $scope ) = @_;
    }
    else {
        my ( $variable, $value );
        ( $variable, $value, $scope ) = @_;
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
    if ( $scope && $scope ne 'system' ) {
        $scope =~ s/:.*//;    # strip off id, leave identifier
        $key = 'configuration:' . $scope_id;
    }
    else {
        $scope_id = 'system';
        $scope    = 'system';
        $key      = 'configuration';
    }
    my $cfg = MT->request( 'plugin_config.' . $plugin->id );
    unless ($cfg) {
        $cfg = {};
        MT->request( 'plugin_config.' . $plugin->id, $cfg );
    }
    return $cfg->{$scope_id} if $cfg->{$scope_id};
    require MT::PluginData;

    # calling "name" directly here to avoid localization
    my $pdata_obj = MT::PluginData->load(
        {   plugin => $plugin->key || $plugin->{name},
            key => $key
        }
    );
    if ( !$pdata_obj ) {
        $pdata_obj = MT::PluginData->new();
        $pdata_obj->plugin( $plugin->key || $plugin->{name} );
        $pdata_obj->key($key);
    }
    $cfg->{$scope_id} = $pdata_obj;
    my $data = $pdata_obj->data() || {};
    $plugin->apply_default_settings( $data, $scope_id );
    $pdata_obj->data($data);
    $pdata_obj;
}

sub apply_default_settings {
    my $plugin = shift;
    my ( $data, $scope_id ) = @_;
    my $scope = $scope_id;
    if ( $scope =~ m/:/ ) {
        $scope =~ s/:.*//;
    }
    else {
        $scope_id = 'system';
    }
    my $defaults;
    my $s = $plugin->settings;
    if ( $s && ( $defaults = $s->defaults($scope) ) ) {
        foreach ( keys %$defaults ) {
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
    my ( $var, $scope ) = @_;
    my $config = $plugin->get_config_hash($scope);
    return exists $config->{ $_[0] } ? $config->{ $_[0] } : undef;
}

package MT::PluginSettings;

sub new {
    my $pkg = shift;
    my ($self) = @_;
    $self ||= [];
    if ( ref $self eq 'HASH' ) {

        # convert a hash-style setting structure into what PluginSettings
        # expects
        my $settings = [];
        foreach my $key ( keys %$self ) {
            if ( defined $self->{$key} ) {
                push @$settings, [ $key, $self->{$key} ];
            }
            else {
                push @$settings, [$key];
            }
        }
        @$settings = sort {
            ( $a->[1] ? $a->[1]->{order} || 0 : 0 )
                <=> ( $b->[1] ? $b->[1]->{order} || 0 : 0 )
        } @$settings;
        $self = $settings;
    }

    # Lowercase all settings keys
    foreach my $setting (@$self) {
        my ( $name, $param ) = @$setting;
        $param->{ lc $_ } = $param->{$_} for keys %$param;
    }
    bless $self, $pkg;
}

sub defaults {
    my $settings = shift;
    my ($scope)  = @_;
    my $defaults = {};
    foreach my $setting (@$settings) {
        my ( $name, $param ) = @$setting;
        next unless exists $param->{default};
        next if $scope && $param->{scope} && $param->{scope} ne $scope;
        $defaults->{$name} = $param->{default};
    }
    $defaults;
}

1;
__END__

=head1 NAME

MT::Plugin - Movable Type class that describes a plugin

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

Defines a C<MT::Template> file by name to use for plugin configuration.
This value may also be a code reference, which MT would call
passing three arguments: the plugin object instance, a hashref of
C<MT::Template> parameter data and the scope value (either "system"
for system-wide configuration or "blog:N" where N is the active blog id).

=item * system_config_template

Defines a C<MT::Template> file by name to use for system-wide
plugin configuration. If not defined, MT will fall back to the config_template
setting. This value may also be a code reference, which MT would call
passing three arguments: the plugin object instance, a hashref of
C<MT::Template> parameter data and the scope value (always "system" in
this case).

=item * blog_config_template

Defines a C<MT::Template> file by name to use for weblog-specific
plugin configuration. If not defined, MT will fall back to the config_template
setting. This value may also be a code reference, which MT would call
passing three arguments: the plugin object instance, a hashref of
C<MT::Template> parameter data and the scope value (for weblogs, this
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

Called to retrieve a MT::Template object which will be output as the
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

Used to load a MT::Template object relative to the plugin's directory.
It will scan both the plugin's directory and a directory named 'tmpl'
underneath it. It will passthrough parameters that follow the $file
parameter into the MT::Template constructor.

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

=head1 CALLBACKS

=over 4

=item save_config_filter.<plugin key>

This filter callback will be called before saving new configuration of
a plugin, giving the plugin a chance to inspect and reject it, if
there is some error in it. The callback has the following signature:

    sub save_config_filter($cb, $plugin, $data, $scope)
    {
        ...
    }

return true if this config is ok, false if it is to be rejected

=back

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
