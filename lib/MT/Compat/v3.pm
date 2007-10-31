# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Compat;

use strict;

our %app_ids;
our %api_map;
BEGIN {
    %app_ids = (
        'MT::App::CMS' => 'cms',
    );
    %api_map = (
        'MT::Template::Context::add_tag' => "Registry (path: tags, function)",
        'MT::Template::Context::add_container_tag' => "Registry (path: tags, block)",
        'MT::Template::Context::add_global_filter' => "Registry (path: tags, modifier)",
        'MT::add_text_filter' => "Registry (path: text_filters)",
        'MT::add_itemset_action' => "Registry (path: application, [app_id], list_actions)",
        'MT::add_plugin_action' => "Registry (path: application, [app_id], page_actions)",
        'MT::register_junk_filter' => "Registry (path: junk_filters)",
    );

    $MT::CallbackAlias{'BuildFileFilter'}     = 'build_file_filter';
    $MT::CallbackAlias{'BuildFile'}           = 'build_file';
    $MT::CallbackAlias{'BuildPage'}           = 'build_page';
    $MT::CallbackAlias{'PreEntrySave'}        = 'MT::Entry::pre_save';
    $MT::CallbackAlias{'PreCommentSave'}      = 'MT::Comment::pre_save';
    $MT::CallbackAlias{'RebuildOptions'}      = 'rebuild_options';
    $MT::CallbackAlias{'TakeDown'}            = 'take_down';
    $MT::CallbackAlias{'NewUserProvisioning'} = 'new_user_provisioning';
    # Unnecessary to map since all the v3 legacy callbacks would fail
    # anyway.
    # $MT::CallbackAlias{'AppTemplateSource'}   = 'template_source';
    # $MT::CallbackAlias{'AppTemplateParam'}    = 'template_param';
    # $MT::CallbackAlias{'AppTemplateOutput'}   = 'template_output';
    my @names = qw(
      CMSSavePermissionFilter_notification CMSSaveFilter_notification
      CMSSavePermissionFilter_banlist CMSSaveFilter_banlist
      CMSViewPermissionFilter_author CMSSavePermissionFilter_author
      CMSDeletePermissionFilter_author CMSSaveFilter_author
      CMSPreSave_author CMSPostSave_author CMSViewPermissionFilter_blog
      CMSSavePermissionFilter_blog CMSDeletePermissionFilter_blog
      CMSPreSave_blog CMSPostSave_blog CMSSaveFilter_blog CMSPostDelete_blog
      CMSViewPermissionFilter_category CMSSavePermissionFilter_category
      CMSDeletePermissionFilter_category CMSPreSave_category
      CMSPostSave_category CMSSaveFilter_category
      CMSViewPermissionFilter_comment CMSSavePermissionFilter_comment
      CMSDeletePermissionFilter_comment CMSPreSave_comment
      CMSPostSave_comment CMSViewPermissionFilter_commenter
      CMSDeletePermissionFilter_commenter CMSViewPermissionFilter_entry
      CMSDeletePermissionFilter_entry CMSPreSave_entry
      CMSViewPermissionFilter_ping CMSSavePermissionFilter_ping
      CMSDeletePermissionFilter_ping CMSPreSave_ping CMSPostSave_ping
      CMSViewPermissionFilter_template CMSSavePermissionFilter_template
      CMSDeletePermissionFilter_template CMSPreSave_template
      CMSPostSave_template
      CMSPostDelete_notification CMSPostDelete_author CMSPostDelete_category
      CMSPostDelete_comment CMSPostDelete_entry CMSPostDelete_ping
      CMSPostDelete_template CMSPostDelete_tag
      CMSPostSave_asset CMSPostDelete_asset
    );
    $MT::CallbackAlias{'AppPostEntrySave'}  = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPostSave.entry'} = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPostEntrySave'}  = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPostEntrySave'}  = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPreSave'}        = 'cms_pre_save';
    $MT::CallbackAlias{'CMSPostSave'}       = 'cms_post_save';
    $MT::CallbackAlias{'CMSSavePermissionFilter'} =
      'cms_save_permission_filter';
    $MT::CallbackAlias{'CMSDeletePermissionFilter'} =
      'cms_delete_permission_filter';
    $MT::CallbackAlias{'CMSViewPermissionFilter'} =
      'cms_view_permission_filter';
    $MT::CallbackAlias{'CMSPostDelete'}  = 'cms_post_delete';
    $MT::CallbackAlias{'CMSUploadFile'}  = 'cms_upload_file';
    $MT::CallbackAlias{'CMSUploadImage'} = 'cms_upload_image';
    $MT::CallbackAlias{'HandleJunk'}     = 'handle_spam';
    $MT::CallbackAlias{'HandleNotJunk'}  = 'handle_ham';

    for (@names) {
        my $x = $_;
        $x =~ s/_/./;
        my $y = lc $x;
        $y =~ s/^cms//;
        $y =~ s/(delete|view|pre|post|permission|save)(?=[a-z])/$1_/g;
        $y = 'MT::App::CMS::' . $y;
        $MT::CallbackAlias{$_} = $MT::CallbackAlias{$x} = $y;
    }
}

# in case multiple MT::Compat::* modules are loaded, all of which contain
# this warn routine:
no warnings 'redefine';

# Module for holding deprecated API elements. If elements in this module
# are used, a warning is issued to alert the user or developer that they
# are using older APIs that will eventually be removed.

sub warn {
    my @c  = caller(1);
    my @c2 = caller(2);
    my $r = $MT::plugin_registry;
    $r->{compat_errors} ||= [];
    $r->{compat_flag} ||= {};
    if (!exists $r->{compat_flag}{$c[3]}) {
        $r->{compat_flag}{$c[3]} = 1;
        my $new = $api_map{$c[3]};
        if ($new) {
            push @{ $r->{compat_errors} },
                sub { MT->translate("uses: [_1], should use: [_2]", $c[3], $new); };
        } else {
            push @{ $r->{compat_errors} },
                sub { MT->translate("uses [_1]", $c[3]); };
        }
    }
    # warn "A deprecated MT 3.x API routine ($c[3]) has been called from $c2[3], line $c2[2].";
}

package MT;

use strict;

sub add_log_class {
    MT::Compat::warn();
    my $mt = shift;
    my ($ident, $class) = @_;
    my $r = $MT::plugin_registry;
    $r = $r->{object_types} ||= {};
    $r->{'log.' . $ident} = $class;
}

sub register_junk_filter {
    MT::Compat::warn();
    my $class = shift;
    my ($filter) = @_;
    if ( !( ref $filter eq 'ARRAY' ) ) {
        $filter = [$filter];
    }
    my $r = $MT::plugin_registry;
    $r = $r->{junk_filters} ||= {};
    foreach my $f (@$filter) {
        $f->{label} ||= $f->{name};
        $r->{$f->{name}} = $f;
    }
}

sub add_text_filter {
    MT::Compat::warn();
    my $mt = shift;
    my($key, $cfg) = @_;
    my $r = $MT::plugin_registry;
    $r->{text_filters} ||= {};
    $cfg->{label} ||= $key;
    $cfg->{code} ||= $cfg->{on_format};
    return $mt->trans_error("No executable code") unless $cfg->{code};
    $r->{text_filters}{$key} = $cfg;
}

sub add_task {
    MT::Compat::warn();
    my $mt = shift;
    my ($task) = @_;
    my $r = $MT::plugin_registry;
    $r->{tasks} ||= {};
    my $key;
    if (ref $task eq 'HASH') {
        $key = $task->{key};
    } elsif (ref($task) eq 'MT::Task') {
        $key = $task->key;
    }
    if (!$key) {
        die "Tasks cannot be registered without a key.";
    }
    $r->{tasks}{$key} = $task;
}

sub add_plugin_action {
    MT::Compat::warn();
    my $class = shift;
    if ( !ref $class ) {
        my ($page_id, $cgi, $label) = @_;
        my $mt = MT->instance;
        if ( $mt->can('id') ) {
            my $app_id = $mt->id;
            my $r = $MT::plugin_registry;
            require MT::Util;
            my $key = MT::Util::dirify($MT::plugin_sig . '_' . $page_id);
            $r->{applications}{$app_id}{page_actions}{$page_id}{$key} = {
                label => $label,
                key => $key,
                link => $cgi,
            };
        }
    }
}

sub add_itemset_action {
    MT::Compat::warn();
    my $app = shift;
    my ($itemset_action) = @_;
    $app = MT->instance unless ref $app;
    my $r = $MT::plugin_registry;
    if ($app->can('id')) {
        my $app_id = $app->id;
        my $type = $itemset_action->{type};
        Carp::croak 'itemset actions require a string called "key"' 
            unless ($itemset_action->{key}
                    && !(ref($itemset_action->{key})));
        Carp::croak 'itemset actions require a coderef called "code"'
            unless ($itemset_action->{code} && 
                    (ref $itemset_action->{code} eq 'CODE'));
        Carp::croak 'itemset actions require a string called "label"'
            unless ($itemset_action->{label} && 
                    !(ref $itemset_action->{label}));
        $r->{applications}{$app_id}{list_actions}{$type}{$itemset_action->{key}} = $itemset_action;
    }
}

package MT::Template::Context;

sub add_tag {
    MT::Compat::warn();
    my $class = shift;
    my($name, $code) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{function}{$name} = $code;
}

sub add_container_tag {
    MT::Compat::warn();
    my $class = shift;
    my($name, $code) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{block}{$name} = $code;
}

sub add_conditional_tag {
    MT::Compat::warn();
    my $class = shift;
    my($name, $condition) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{block}{$name} = sub {
        $condition->(@_)
            ? MT::Template::Context::_hdlr_pass_tokens(@_)
            : MT::Template::Context::_hdlr_pass_tokens_else(@_)
    };
}

sub add_global_filter {
    MT::Compat::warn();
    my $class = shift;
    my($name, $code) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{modifier}{$name} = $code;
}

sub register_handler {
    MT::Compat::warn();
    my ($pkg, $tag, $handler);
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    if (ref $handler eq 'ARRAY') {
        if ($handler->[1]) {
            return $r->{tags}{block}{$tag} = $handler->[0];
        } else {
            return $r->{tags}{function}{$tag} = $handler->[0];
        }
    }
    return $r->{tags}{function}{$tag} = $handler;
}

package MT::TaskMgr;

*add_task = \&MT::add_task;

package MT::App;

use strict;

*plugin_actions = \&page_actions;

sub add_methods {
    my $app = shift;
    my %meths = @_;
    if (ref($app)) {
        my $vtbl;
        if (my $r = $MT::plugin_registry) {
            $vtbl = $r->{applications}{$app->id} ||= {};
        } else {
            $vtbl = $app->{vtbl} ||= {};
        }
        for my $meth (keys %meths) {
            $vtbl->{$meth} = $meths{$meth};
        }
    } else {
        for my $meth (keys %meths) {
            $MT::App::Global_actions{$app}{$meth} = $meths{$meth};
        }
    }
}

sub add_plugin_action {
    MT::Compat::warn();

    my $app = shift;

    my ( $object_type, $action_link, $link_text ) = @_;
    my $plugin_envelope = $MT::plugin_envelope;
    my $plugin_sig      = $MT::plugin_sig;
    unless ($plugin_envelope) {
        warn
"MT->add_plugin_action improperly called outside of MT plugin load loop.";
        return;
    }
    $action_link .= '?' unless $action_link =~ m.\?.;
    push @{ $MT::Plugins{$plugin_sig}{actions} }, "$object_type Action"
      if $plugin_sig;
    my $page = $app->config->AdminCGIPath || $app->config->CGIPath;
    $page .= '/' unless $page =~ m!/$!;
    $page .= $plugin_envelope . '/' if $plugin_envelope;
    $page .= $action_link;
    my $has_params = ( $page =~ m/\?/ )
      && ( $page !~ m!(&|;|\?)$! );
    my $param = {
        page            => $page,
        page_has_params => $has_params,
        link_text       => $link_text,
        orig_link_text  => $link_text,
        plugin          => $plugin_sig
    };
    $app->{plugin_actions} ||= {};
    push @{ $app->{plugin_actions}{$object_type} }, $param;
}

package MT::Upgrade;

sub register_class {
    MT::Compat::warn();
    my $pkg = shift;
    my ( $name, $param ) = @_;
    my @classes = ref $name eq 'ARRAY' ? @$name : ( [ $name, $param ] );
    foreach (@classes) {
        if ( ref $_ eq 'ARRAY' ) {
            $MT::Upgrade::classes{ $_[0] } = $_[1];
        }
        else {
            $MT::Upgrade::classes{$_} = 1;
        }
    }
}

sub register_upgrade_function {
    MT::Compat::warn();
    my $pkg = shift;
    my ( $name, $param ) = @_;
    if ( ref $name eq 'HASH' ) {
        foreach ( keys %$name ) {
            $MT::Upgrade::functions{$_} = $name->{$_};
            $MT::Upgrade::functions{$_}->{priority} ||= 9.5;
        }
    }
    else {
        my @fns = ref $name eq 'ARRAY' ? @$name : ( [ $name, $param ] );
        $MT::Upgrade::functions{ $_[0] } = $_[1] foreach @fns;
    }
}

package MT::App::CMS;

use strict;

sub register_type {
    warn "Deprecated: MT::App::CMS->register_type";
}

sub add_rebuild_option {
    MT::Compat::warn();
    my $class  = shift;
    my $app    = $class->instance;
    my ($args) = @_;
    $args->{label} ||= $args->{Name} || $args->{name};
    return $class->error(
        MT->translate(
            "Rebuild-option name must not contain special characters")
      )
      if ( $args->{label} ) =~
      /[\"\']/;    #/[^A-Za-z0-9.:\[\]\(\)\+=!@\#\$\%\^\&\*-]/;
    my $rec = {};
    $rec->{code}  = $args->{Code} || $args->{code};
    $rec->{label} = $args->{label};
    $rec->{key}   = $args->{key} || dirify( $rec->{label} );
    $app->{rebuild_options} ||= [];
    push @{ $app->{rebuild_options} }, $rec;
}

*core_itemset_actions   = \&core_list_actions;
*plugin_itemset_actions = \&plugin_list_actions;
#*itemset_actions        = \&list_actions;

package MT::Author;

use strict;

sub session {
    MT::Compat::warn();
    die "MT::Author::session was removed";
}

sub magic_token {
    MT::Compat::warn();
    die "MT::Author::magic_token was removed";
}

package MT::Plugin;

use strict;

sub legacy_init {
    my $plugin = shift;

    # Change location of app_action_links from
    #   app_action_links -> app package -> stuff
    # to
    #   applications -> app id -> page_actions -> stuff 
    if (my $actions = delete $plugin->{app_action_links} || ($plugin->can('app_action_links') ? $plugin->app_action_links : undef)) {
        my $r = $MT::plugin_registry;
        $r = $r->{applications} ||= {};
        foreach my $app (keys %$actions) {
            my $app_id = $MT::Compat::app_ids{$app} or next;
            my $app_actions = $actions->{$app};
            if (ref($app_actions) eq 'ARRAY') {
                foreach my $action (@$app_actions) {
                    my $type = $action->{type} or next;
                    my $key = $action->{key} or next;
                    $r->{$app_id}{page_actions}{$type}{$key} = $action;
                }
            } elsif (ref($app_actions) eq 'HASH') {
                # app_action_links -> MT::App::CMS -> type -> stuff
                my $i = 0;
                foreach my $type (%$app_actions) {
                    $i++;
                    my $key = MT::Util::dirify($MT::plugin_sig . '_' . $type + $i);
                    $r->{$app_id}{page_actions}{$type}{$key} = $app_actions->{$type};
                }
            }
        }
    }
    # Change location of app_itemset_actions from
    #   app_itemset_actions -> app package -> stuff
    # to
    #   applications -> app id -> list_actions -> stuff 
    if (my $actions = delete $plugin->{app_itemset_actions} || ($plugin->can('app_itemset_actions') ? $plugin->app_itemset_actions : undef)) {
        my $r = $MT::plugin_registry;
        $r = $r->{applications} ||= {};
        foreach my $app (keys %$actions) {
            my $app_id = $MT::Compat::app_ids{$app} or next;
            my $app_actions = $actions->{$app};
            if (ref($app_actions) eq 'ARRAY') {
                foreach my $action (@$app_actions) {
                    my $type = $action->{type} or next;
                    my $key = $action->{key} or next;
                    $r->{$app_id}{list_actions}{$type}{$key} = $action;
                }
            } elsif (ref($app_actions) eq 'HASH') {
                # app_action_links -> MT::App::CMS -> type -> stuff
                foreach my $type (%$app_actions) {
                    my $key = $app_actions->{$type}{key} or next;
                    $r->{$app_id}{list_actions}{$type}{$key} = $app_actions->{$type};
                }
            }
        }
    }
    # Remap app_methods -> app pkg -> method hash
    # to applications -> app id -> method hash
    if (my $methods = delete $plugin->{app_methods} || ($plugin->can('app_methods') ? $plugin->app_methods : undef)) {
        my $r = $MT::plugin_registry;
        $r = $r->{applications} ||= {};
        foreach my $app (keys %$methods) {
            my $app_id = $MT::Compat::app_ids{$app} or next;
            my $app_methods = $methods->{$app};
            if (ref($app_methods) eq 'HASH') {
                foreach my $m (keys %$app_methods) {
                    $r->{$app_id}{methods}{$m} = { code => $app_methods->{$m} };
                }
            }
        }
    }

    # Store upgrade_functions in the plugin registry.
    if (my $functions = delete $plugin->{upgrade_functions} || ($plugin->can('upgrade_functions') ? $plugin->upgrade_functions : undef)) {
        my $r = $MT::plugin_registry;
        $r = $r->{upgrade_functions} ||= {};
        foreach my $fn (keys %$functions) {
            $r->{$fn} = $functions->{$fn};
        }
    }
    # Store object_classes in the plugin registry as a hash
    # with the key 'object_types'.
    if (my $classes = delete $plugin->{object_classes} || ($plugin->can('object_classes') ? $plugin->object_classes : undef)) {
        my $r = $MT::plugin_registry;
        $r = $r->{object_types} ||= {};
        foreach my $class (@$classes) {
            $r->{$class} = $class;
        }
    }
}

1;
