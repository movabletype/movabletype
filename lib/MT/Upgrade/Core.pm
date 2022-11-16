# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::Core;

use strict;
use warnings;

MT->add_callback( 'MT::Upgrade::seed_database', 5, undef, \&seed_database );
MT->add_callback( 'MT::Upgrade::upgrade_end', 5, undef,
    sub { $_[1]->add_step('core_upgrade_templates') } );
MT->add_callback( 'MT::Upgrade::upgrade_end', 6, undef,
    sub { $_[1]->add_step('core_remove_news_widget_cache') } );

sub upgrade_functions {
    my $self = shift;
    my (%param) = @_;
    return {
        'core_upgrade_templates' => {
            code     => \&upgrade_templates,
            priority => 5,
        },
        'core_init_blog_custom_dynamic_templates' => {
            on_field => 'MT::Blog->custom_dynamic_templates',
            priority => 3.1,
            updater  => {
                type      => 'blog',
                condition => sub { !defined $_[0]->custom_dynamic_templates },
                code      => sub { $_[0]->custom_dynamic_templates('none') },
                label     => 'Assigning custom dynamic template settings...',
                sql       => q{update mt_blog
                            set blog_custom_dynamic_templates = 'none'
                          where blog_custom_dynamic_templates is null},
            }
        },
        'core_init_author_type' => {
            on_field => 'MT::Author->type',
            priority => 3.1,
            updater  => {
                type      => 'author',
                condition => sub { !$_[0]->type },
                code      => sub { $_[0]->type(1) },
                label     => 'Assigning user types...',
                sql       => 'update mt_author set author_type = 1
                        where author_type is null or author_type = 0',
            }
        },
        'core_init_category_parent' => {
            on_field => 'MT::Category->parent',
            priority => 3.1,
            updater  => {
                type      => 'category',
                condition => sub { !defined $_[0]->parent },
                code      => sub { $_[0]->parent(0) },
                label     => 'Assigning category parent fields...',
                sql       => 'update mt_category set category_parent = 0
                        where category_parent is null',
            }
        },
        'core_init_template_build_dynamic' => {
            on_field => 'MT::Template->build_dynamic',
            priority => 3.1,
            updater  => {
                type      => 'template',
                condition => sub { !defined $_[0]->build_dynamic },
                code      => sub { $_[0]->build_dynamic(0) },
                label     => 'Assigning template build dynamic settings...',
                sql => 'update mt_template set template_build_dynamic = 0
                        where template_build_dynamic is null',
            }
        },
        'core_init_comment_visible' => {
            on_field => 'MT::Comment->visible',
            priority => 3.1,
            updater  => {
                type      => 'comment',
                condition => sub { !defined $_[0]->visible },
                code      => sub { $_[0]->visible(1) },
                label     => 'Assigning visible status for comments...',
                sql       => 'update mt_comment set comment_visible = 1
                        where comment_visible is null',
            }
        },
        'core_init_tbping_visible' => {
            on_field => 'MT::TBPing->visible',
            priority => 3.1,
            updater  => {
                type      => 'tbping',
                condition => sub { !defined $_[0]->visible },
                code      => sub { $_[0]->visible(1) },
                label     => 'Assigning visible status for TrackBacks...',
                sql       => 'update mt_tbping set tbping_visible = 1
                        where tbping_visible is null',
            }
        },
        'core_install_default_roles' => {
            code => sub {
                require MT::Role;
                return MT::Role->create_default_roles;
            },
            on_class => 'MT::Role',
            priority => 3.1,
        },
        ## FIXME: currently MT::Upgrade::core_update_records can't run
        ## with multi-class like asset.* ...
        ## should fix it and rewrite this as simple updater.
        'core_update_asset_pathinfo' => {
            version_limit => 5.0,
            priority      => 3.1,
            code          => sub {
                my $upgrade = shift;
                require MT::Asset;
                my $iter = MT::Asset->load_iter( { class => '*' } );
                $upgrade->progress(
                    MT::Upgrade->translate_escape(
                        "Upgrading asset path information...")
                );
                while ( my $asset = $iter->() ) {
                    my $values = $asset->get_values;
                    my ( $path, $url )
                        = ( $values->{file_path}, $values->{url} );
                    $path =~ s{%s(/||\\)support\1}{%s$1};
                    $url =~ s{%s/support/}{%s/};
                    $asset->file_path($path);
                    $asset->url($url);
                    $asset->save;
                }
                0;
            },
        },
        'core_remove_news_widget_cache' => {
            priority => 6,
            code     => \&_remove_news_widget_cache,
        },
    };
}

### Subroutines

sub seed_database {
    my $cb      = shift;
    my $self    = shift;
    my (%param) = @_;

    require MT::Author;
    return undef if MT::Author->exist;

    $self->progress(
        $self->translate_escape("Creating initial user records...") );

    local $MT::CallbacksEnabled = 1;

    require MT::L10N;
    my $lang
        = exists $param{user_lang}
        ? $param{user_lang}
        : MT->config->DefaultLanguage;
    my $LH = MT::L10N->get_handle($lang);

    # TBD: parameter for username/password provided by user from $app
    my $author = MT::Author->new;
    $author->name(
        exists $param{user_name}
        ? _uri_unescape_utf8( $param{user_name} )
        : 'Melody'
    );
    $author->type( MT::Author::AUTHOR() );
    $author->set_password(
        exists $param{user_password}
        ? _uri_unescape_utf8( $param{user_password} )
        : 'Nelson'
    );
    $author->email(
        exists $param{user_email}
        ? _uri_unescape_utf8( $param{user_email} )
        : ''
    );
    $author->nickname(
        exists $param{user_nickname}
        ? _uri_unescape_utf8( $param{user_nickname} )
        : ''
    );
    $author->is_superuser(1);
    $author->can_create_site(1);
    $author->can_view_log(1);
    $author->can_manage_plugins(1);
    $author->preferred_language($lang);
    $author->external_id(
        MT::Author->pack_external_id( $param{user_external_id} ) )
        if exists $param{user_external_id};
    $author->auth_type( MT->config->AuthenticationModule );
    $author->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $author->errstr
        )
        );

    $author->created_by( $author->id );
    $author->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $author->errstr
        )
        );

    my $App = $MT::Upgrade::App;
    $App->{author} = $author if ref $App;

    # disable system scope data api
    require MT::CMS::Blog;
    MT::CMS::Blog::save_data_api_settings( $App, 0, 0 );

    require MT::Role;
    MT::Role->create_default_roles(%param)
        or return $self->error(
        $self->translate_escape(
            "Error creating role record: [_1].",
            MT::Role->errstr
        )
        );
    $author->save;

    my $cfg = MT->config;
    if ( $param{use_system_email} ) {
        $cfg->EmailAddressMain( _uri_unescape_utf8( $param{user_email} ), 1 );
    }

    # for next major release
    my @plugins_to_disable = qw(
        Trackback OpenID FacebookCommenters
        spamlookup/spamlookup.pl spamlookup/spamlookup_urls.pl spamlookup/spamlookup_words.pl
        Textile/textile2.pl
        WidgetManager/WidgetManager.pl
    );
    my $switch = $cfg->PluginSwitch;
    for my $plugin (@plugins_to_disable) {
        next unless $switch->{$plugin};
        $switch->{$plugin} = 0;
    }
    $cfg->PluginSwitch($switch, 1);

    my %seen_apps;
    my @restricted_apps = $cfg->get('RestrictedPSGIApp');
    @restricted_apps = grep {!$seen_apps{$_}++} @restricted_apps, qw(xmlrpc atom feeds ft_search);
    $cfg->set(RestrictedPSGIApp => \@restricted_apps, 1);

    $cfg->set(DisableQuickPost => 1, 1);
    $cfg->set(DisableActivityFeeds => 1, 1);
    $cfg->set(DisableNotificationPings => 1, 1);
    $cfg->set(DefaultSupportedLanguages => 'en_us,ja', 1);

    $cfg->save;

    1;
}

sub upgrade_templates {
    my $self = shift;
    my (%opt) = @_;

    my $install = $opt{Install} || 0;

    my $updated = 0;

    my $tmpl_list;
    require MT::DefaultTemplates;
    $tmpl_list = MT::DefaultTemplates->templates || [];

    my $mt = MT->instance;
    my @arch_tmpl;

    require MT::Template;
    require MT::Blog;

    my $installer = sub {
        my ( $val, $blog_id ) = @_;

        my $terms = {};
        $terms->{type} = $val->{type};
        $terms->{name} = $val->{name}
            if $val->{set} ne 'system';
        $terms->{blog_id} = $blog_id;

        return 1 if MT::Template->exist($terms);

        $self->progress(
            $self->translate_escape(
                "Creating new template: '[_1]'.",
                $val->{name}
            )
        );

        my $obj = MT::Template->new;
        $obj->build_dynamic(0);
        if (   ( 'widgetset' eq $val->{type} )
            && ( exists $val->{widgets} ) )
        {
            my $modulesets = delete $val->{widgets};
            $obj->modulesets(
                MT::Template->widgets_to_modulesets( $modulesets, $blog_id )
            );
        }
        foreach my $v ( keys %$val ) {
            $obj->column( $v, $val->{$v} ) if $obj->has_column($v);
        }
        $obj->blog_id($blog_id);
        $obj->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $obj->errstr
            )
            );
        $updated = 1;
        if ( $val->{mappings} ) {
            push @arch_tmpl,
                {
                template => $obj,
                mappings => $val->{mappings},
                };
        }
        return 1;
    };

    my $Installing = $MT::Upgrade::Installing;

    for my $val (@$tmpl_list) {
        if ( !$Installing ) {
            next if $val->{type} eq 'search_results';
        }
        if ( !$install ) {
            if ( !$val->{global} ) {
                next if $val->{set} ne 'system';
            }
        }

        my $p = $val->{plugin} || $mt;
        if ( $val->{global} ) {
            $val->{name} = $p->translate( $val->{name} );
            $val->{text} = $p->translate_templatized( $val->{text} );
            $installer->( $val, 0 ) or return;
        }
        else {
            my $iter = MT::Blog->load_iter();
            while ( my $blog = $iter->() ) {
                my $current_language = MT->current_language;
                MT->set_language( $blog->language );
                $val->{name} = $p->translate( $val->{name} );
                $val->{text} = $p->translate_templatized( $val->{text} );
                MT->set_language($current_language);
                $installer->( $val, $blog->id );
            }
        }
    }

    if (@arch_tmpl) {
        $self->progress(
            $self->translate_escape(
                "Mapping templates to blog archive types...")
        );
        require MT::TemplateMap;

        for my $map_set (@arch_tmpl) {
            my $tmpl     = $map_set->{template};
            my $mappings = $map_set->{mappings};
            foreach my $map_key ( sort keys %$mappings ) {
                my $m  = $mappings->{$map_key};
                my $at = $m->{archive_type};

                # my $preferred = $mappings->{$map_key}{preferred};
                my $map = MT::TemplateMap->new;
                $map->archive_type($at);
                $map->is_preferred(1);
                $map->template_id( $tmpl->id );
                $map->file_template( $m->{file_template} )
                    if $m->{file_template};
                $map->blog_id( $tmpl->blog_id );
                $map->save;
            }
        }
    }

    $updated;
}

sub _remove_news_widget_cache {
    my $self = shift;
    $self->progress(
        $self->translate_escape( 'Expiring cached MT News widget...', ) );
    my $class = MT->model('session')
        or return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'session' ) );
    $class->remove( { kind => [qw( NW LW )] } );
}

sub _uri_unescape_utf8 {
    my ($text) = @_;
    unless ($MT::Upgrade::CLI) {
        use URI::Escape;
        $text = uri_unescape($text);
    }
    return Encode::decode_utf8($text)
        unless Encode::is_utf8($text);
}

1;
