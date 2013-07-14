# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Upgrade::v5;

use strict;

sub upgrade_functions {
    return {

        #'v5_migrate_blog' => {
        #    version_limit => 5.0004,
        #    priority      => 3.2,
        #    code          => \&_v5_migrate_blog,
        #},
        'v5_create_new_role' => {
            version_limit => 5.0010,
            priority      => 3.1,
            code          => \&_v5_create_new_role,
        },
        'v5_migrate_system_privilege' => {
            version_limit => 5.0004,
            priority      => 3.1,
            code          => \&_v5_migrate_system_privilege,
        },
        'v5_migrate_mtview' => {
            version_limit => 5.0004,
            priority      => 3.1,
            code          => \&_v5_migrate_mtview,
        },
        'v5_migrate_default_site' => {
            version_limit => 5.0008,
            priority      => 3.3,
            code          => \&_v5_migrate_default_site
        },
        'v5_migrate_dashboard_widget_settings' => {
            version_limit => 5.0013,
            priority      => 3.3,
            updater       => {
                type      => 'author',
                label     => "Merging dashboard settings...",
                condition => sub { $_[0]->status == 1 && $_[0]->type == 1 },
                code      => \&_v5_migrate_dashboard,
            },
        },
        'v5_migrate_theme_privilege' => {
            version_limit => 5.0014,
            priority      => 3.1,
            code          => \&_v5_migrate_theme_privilege,
        },
        'v5_migrate_blog_only' => {
            version_limit => 5.0015,
            priority      => 3.2,
            updater       => {
                type      => 'blog',
                label     => "Classifying blogs...",
                condition => sub { !$_[0]->class },
                code      => sub { $_[0]->class('blog') },
                sql       => "update mt_blog set blog_class='blog'
                              where ( blog_class IS NULL ) or ( blog_class = '' )
                              or ( blog_class = '0' )",
            },
        },
        'v5_generate_websites_place_blogs' => {
            version_limit => 5.0015,
            priority      => 3.4,
            code          => \&_v5_generate_websites_place_blogs,
        },
        'v5_rebuild_permissions' => {
            version_limit => 5.0016,
            priority      => 3.0,
            updater       => {
                type      => 'permission',
                label     => 'Rebuilding permissions...',
                condition => sub { $_[0]->blog_id },
                code      => sub { $_[0]->rebuild; },
            },
        },
        'v5_remove_technorati' => {
            version_limit => 5.0017,
            priority      => 3.0,
            code          => \&_v5_remove_technorati,
        },
        'v5_remove_news_widget_cache' => {
            version_limit => 5.0,
            priority      => 3.0,
            code          => \&_v5_remove_news_widget_cache,
        },
        'v5_assign_entry_ceated_by' => {
            version_limit => 5.0019,
            priority      => 3.1,
            updater       => {
                type  => 'entry',
                label => 'Assigning ID of author for entries...',
                code  => sub {
                    $_[0]->created_by( $_[0]->author_id )
                        if !defined $_[0]->created_by;
                },
                sql => 'update mt_entry set entry_created_by = entry_author_id
                         where entry_created_by is null',
            },
        },
        'v5_recover_auth_type' => {
            version_limit => 5.0019,
            priority      => 3.1,
            code          => \&_v5_recover_auth_type,
        },
        'v5_remove_dashboard_widget' => {
            version_limit => 5.0020,
            priority      => 3.1,
            updater       => {
                type      => 'author',
                label     => 'Removing widget from dashboard...',
                condition => sub {
                    my $App = $MT::Upgrade::App;
                    my ($user) = @_;
                    if ( $user->type == MT::Author::AUTHOR() ) {
                        return 1
                            if $App
                                && UNIVERSAL::isa( $App, 'MT::App' )
                                && ( $user->id == $App->user->id );
                    }
                    return 0;
                },
                code => sub {
                    my ($user) = @_;
                    my $widgets = $user->widgets();
                    if ( $widgets && %$widgets ) {
                        my @keys
                            = qw( mt_shortcuts new_version new_user new_install );
                        for my $set ( keys %$widgets ) {
                            for my $key (@keys) {
                                delete $widgets->{$set}->{$key}
                                    if $widgets->{$set}->{$key};
                            }
                        }
                        $user->widgets($widgets);
                    }
                },
            },
        },
        'v5_make_blog_category_and_folder_order' => {
            version_limit => 5.0023,
            priority      => 3.2,
            updater       => {
                type  => 'blog',
                label => 'Ordering Categories and Folders of Blogs...',
                code  => sub {
                    my ($blog) = @_;
                    my @cats = MT->model('category')->load(
                        { blog_id => $blog->id, },
                        {   sort      => 'label',
                            direction => 'ascend',
                            fetchonly => { id => 1 },
                        }
                    );
                    my $order = join ',', ( map { $_->id } @cats );
                    $blog->category_order($order);
                    my @folders = MT->model('folder')->load(
                        { blog_id => $blog->id, },
                        {   sort      => 'label',
                            direction => 'ascend',
                            fetchonly => { id => 1 },
                        }
                    );
                    my $folder_order = join ',', ( map { $_->id } @folders );
                    $blog->folder_order($folder_order);
                    $blog->save;
                },
            },
        },
        'v5_make_website_category_order' => {
            version_limit => 5.0023,
            priority      => 3.2,
            updater       => {
                type  => 'website',
                label => 'Ordering Folders of Websites...',
                code  => sub {
                    my ($site) = @_;
                    my @folders = MT->model('folder')->load(
                        { blog_id => $site->id, },
                        {   sort      => 'label',
                            direction => 'ascend',
                            fetchonly => { id => 1 },
                        }
                    );
                    my $folder_order = join ',', ( map { $_->id } @folders );
                    $site->folder_order($folder_order);
                    $site->save;
                },
            },
        },
        'v5_assign_initial_user_ceated_by' => {
            version_limit => 5.0035,
            priority      => 3.0,
            updater       => {
                type  => 'author',
                label => 'Assigning ID of user who created for initial user...',
                code  => sub {
                    $_[0]->created_by( $_[0]->id )
                        if !defined $_[0]->created_by;
                },
                sql => 'update mt_author set author_created_by = author_id
                         where author_created_by is null',
            },
        },
        'v5_assign_blog_date_language' => {
            version_limit => 5.0036,
            priority      => 3.0,
            updater => {
                type  => 'blog',
                terms => { class => '*' },
                label =>
                    'Assigning language of blog to use for formatting date...',
                code => sub {
                    my @supporteds
                        = map { $_->{l_tag} } @{ MT::I18N::languages_list() };
                    my $language = $_[0]->language;
                    $_[0]->date_language($language);
                    $_[0]->language( ( grep { $_ eq $language } @supporteds )
                        ? $language
                        : MT->config('DefaultLanguage') );
                },
                sql => <<__SQL__,
UPDATE mt_blog SET
    blog_date_language = blog_language,
    blog_language = CASE
        WHEN blog_language IN(
            @{  [   join( ',',
                        map { "'" . $_->{l_tag} . "'" }
                            @{ MT::I18N::languages_list() } )
                ]
                }
            )
            THEN blog_language
        ELSE '@{[ MT->config('DefaultLanguage') ]}' END;
__SQL__
            },
        },
    };
}

### Subroutines

sub _v5_migrate_blog {
    my $self = shift;

    my $app     = $MT::Upgrade::App;
    my $user_id = ref $app ? $app->{author}->id : $MT::Upgrade::SuperUser;
    my $user    = MT::Author->load($user_id);
    return if $user->permissions(0)->has('administer_website');

    # Create generic website.
    my $class = MT->model('website');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Website' ) )
        unless $class;

    return if $class->count() > 0;

    $self->progress(
        $self->translate_escape(
            'Populating generic website for current blogs...')
    );

    my $website
        = $class->create_default_website( MT->translate('Generic Website') );
    $website->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $website->errstr
        )
        );

    # Load all blogs.
    my $blog_class = MT->model('blog');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Blog' ) )
        unless $blog_class;
    my $iter = $blog_class->load_iter();
    while ( my $blog = $iter->() ) {
        next if $blog->parent_id;
        $self->progress(
            $self->translate_escape(
                "Migrating [_1]([_2]).",
                $blog->name, $blog->id
            )
        );
        $blog->class('blog');
        $blog->parent_id( $website->id );
        $blog->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $blog->errstr
            )
            );
    }

    # Grant new role to system administrator
    $self->progress(
        $self->translate_escape(
            'Granting new role to system administrator...')
    );

    my $assoc_class = MT->model('association');
    return $self->error(
        $self->translate_escape(
            "Error loading class: [_1].", 'Association'
        )
    ) unless $assoc_class;
    my $role_class = MT->model('role');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Role' ) )
        unless $role_class;
    my $role = MT::Role->load_by_permission('administer_website');
    $assoc_class->link( $user => $role => $website );

    return;
}

sub _v5_create_new_role {
    my $self = shift;

    my $role_class = MT->model('role');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Role' ) )
        unless $role_class;

    $self->progress(
        $self->translate_escape('Updating existing role name...') );

    my $role
        = $role_class->load( { name => MT->translate('_WEBMASTER_MT4'), } );
    if ($role) {
        return if $role->has('administer_website');
        $role->name( MT->translate('Webmaster (MT4)') );
        $role->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $role->errstr
            )
            );
    }

    $self->progress(
        $self->translate_escape('Populating new role for website...') );
    $role = $role_class->load(
        { name => MT->translate('Website Administrator'), } );
    if ( !$role ) {
        $role = $role_class->new();
        $role->name( MT->translate('Website Administrator') );
        $role->description( MT->translate('Can administer the website.') );
        $role->clear_full_permissions;
        $role->set_these_permissions(
            [ 'administer_website', 'manage_member_blogs' ] );
        $role->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $role->errstr
            )
            );
    }

    my $new_role = $role_class->new();
    $new_role->name( MT->translate('Webmaster') );
    $new_role->description(
        MT->translate(
            'Can manage pages, Upload files and publish blog templates.')
    );
    $new_role->clear_full_permissions;
    $new_role->set_these_permissions(
        [ 'manage_pages', 'rebuild', 'upload' ] );
    $new_role->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $new_role->errstr
        )
        );
}

sub _v5_migrate_theme_privilege {
    my $self = shift;

    my $role_class = MT->model('role');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Role' ) )
        unless $role_class;

    $self->progress(
        $self->translate_escape('Updating existing role name...') );
    my $role = $role_class->load( { name => MT->translate('Designer'), } );
    if ($role) {
        return if $role->has('manage_themes');
        $role->name( MT->translate('Designer (MT4)') );
        $role->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $role->errstr
            )
            );
    }

    $self->progress(
        $self->translate_escape('Populating new role for theme...') );
    my $new_role = $role_class->new();
    $new_role->name( MT->translate('Designer') );
    $new_role->description(
        MT->translate(
            'Can edit, manage and publish blog templates and themes.')
    );
    $new_role->clear_full_permissions;
    $new_role->set_these_permissions(
        [ 'manage_themes', 'edit_templates', 'rebuild' ] );
    $new_role->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $new_role->errstr
        )
        );
}

sub _v5_migrate_system_privilege {
    my $self = shift;
    $self->progress(
        $self->translate_escape(
            'Assigning new system privilege for system administrator...')
    );

    my $perm_class = MT->model('permission');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Permission' )
    ) unless $perm_class;
    my $iter = $perm_class->load_iter( { blog_id => 0, } );
    while ( my $perm = $iter->() ) {
        if ( $perm->has('administer') ) {
            $self->progress(
                $self->translate_escape(
                    'Assigning to  [_1]...',
                    $perm->author->name
                )
            );
            $perm->set_these_permissions( ['create_website'] );
            $perm->save
                or return $self->error(
                $self->translate_escape(
                    "Error saving record: [_1].",
                    $perm->errstr
                )
                );
        }
    }
}

sub _v5_migrate_mtview {
    my $self = shift;

    $self->progress(
        $self->translate_escape('Migrating mtview.php to MT5 style...') );

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');

    my $blog_class = MT->model('blog');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Website' ) )
        unless $blog_class;

    require File::Spec;
    my $iter = $blog_class->load_iter( { class => 'blog' } );
    while ( my $blog = $iter->() ) {
        my $site_path = $blog->site_path;
        my $mtview = File::Spec->catfile( $site_path, 'mtview.php' );
        if ( $fmgr->exists($mtview) ) {
            my $data = $fmgr->get_data($mtview);
            if ($data) {
                $data =~ s/new MT/MT::get_instance/;
                $fmgr->rename( $mtview, $mtview . '.bak' );
                $fmgr->put_data( $data, $mtview );
            }
        }
    }
}

sub _v5_migrate_default_site {
    my $self = shift;

    my $site_url   = MT->config('DefaultSiteURL');
    my $site_path  = MT->config('DefaultSiteRoot');
    my $default_id = MT->config('NewUserDefaultWebsiteId');

    if ( $site_url && $site_path && !$default_id ) {
        $self->progress(
            $self->translate_escape(
                'Migrating DefaultSiteURL/DefaultSiteRoot to website...')
        );

        my $class = MT->model('website');
        return $self->error(
            $self->translate_escape(
                "Error loading class: [_1].", 'Website'
            )
        ) unless $class;

        my $website = $class->create_default_website(
            MT->translate("New user's website"),
            site_url  => $site_url,
            site_path => $site_path,
        );
        $website->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $website->errstr
            )
            );

        MT->config( 'NewUserDefaultWebsiteId', $website->id, 1 );
        MT->config( 'DefaultSiteURL',          undef,        1 );
        MT->config( 'DefaultSiteRoot',         undef,        1 );

        # Grant new role to system administrator
        my $app     = $MT::Upgrade::App;
        my $user_id = ref $app ? $app->{author}->id : $MT::Upgrade::SuperUser;
        my $user    = MT::Author->load($user_id);
        my $assoc_class = MT->model('association');
        return $self->error(
            $self->translate_escape(
                "Error loading class: [_1].",
                'Association'
            )
        ) unless $assoc_class;
        my $role_class = MT->model('role');
        return $self->error(
            $self->translate_escape( "Error loading class: [_1].", 'Role' ) )
            unless $role_class;
        my $role = MT::Role->load_by_permission('administer_website');
        $assoc_class->link( $user => $role => $website );
    }
}

sub _v5_migrate_dashboard {
    my $user = shift;
    my $conf = $user->widgets;
    return 1 unless $conf;

    my $new_widgets;
    my @keys = keys %$conf;
    foreach my $key (@keys) {
        my @widget_keys = keys %{ $conf->{$key} };
        foreach my $widget (@widget_keys) {
            if ( $widget eq 'mt_shortcuts' ) {
                next;
            }
            elsif ($widget eq 'this_is_you-1'
                || $widget eq 'new_install'
                || $widget eq 'new_user' )
            {
                $new_widgets->{ 'dashboard:user:' . $user->id }->{$widget}
                    ->{order} = $conf->{$key}->{$widget}->{order};
                $new_widgets->{ 'dashboard:user:' . $user->id }->{$widget}
                    ->{set} = 'main';
                next;
            }
            elsif ( $widget eq 'mt_news' ) {
                $new_widgets->{ 'dashboard:user:' . $user->id }->{$widget}
                    ->{order} = $conf->{$key}->{$widget}->{order};
                $new_widgets->{ 'dashboard:user:' . $user->id }->{$widget}
                    ->{set} = 'sidebar';
                next;
            }
            elsif ( $widget eq 'blog_stats' && $key eq 'dashboard:system' ) {
                next;
            }
            $new_widgets->{$key}->{$widget} = $conf->{$key}->{$widget};
        }
    }

    # New widgets from MT5
    $new_widgets->{ 'dashboard:user:' . $user->id }->{'favorite_blogs'}
        ->{order} = 3;
    $new_widgets->{ 'dashboard:user:' . $user->id }->{'favorite_blogs'}->{set}
        = 'main';
    $new_widgets->{'dashboard:system'}->{'recent_websites'}->{order} = 1;
    $new_widgets->{'dashboard:system'}->{'recent_websites'}->{set}   = 'main';

    my $class = MT->model('website');
    return unless $class;
    my $generic_website
        = $class->load( { name => MT->translate('Generic Website') } );
    return unless $generic_website;

    $new_widgets->{ 'dashboard:blog:' . $generic_website->id }
        ->{'recent_blogs'}->{order} = 1;
    $new_widgets->{ 'dashboard:blog:' . $generic_website->id }
        ->{'recent_blogs'}->{set} = 'main';

    $user->widgets($new_widgets);
    $user->save;
}

sub _v5_generate_websites_place_blogs {
    my $self = shift;

    require MT::Blog;
    my $iter = MT::Blog->load_iter(
        [   { class => 'blog' },
            '-and', [ { parent_id => \'IS NULL' }, '-or', { parent_id => 0 } ]
        ]
    );

    my %by_domain;
    my $blog_count = 0;
    while ( my $blog = $iter->() ) {
        my ( $protocol, $domain, $url_path )
            = $blog->site_url =~ m!^(https?://)([^/]+)((?:/.*)?)$!;
        my $subdomain = '';
        if ( $domain =~ m!^([^\.].*\.)([^\.]+\.\w+)$! ) {

            # XXX: domains that starts with a "." are not considers
            # to have subdomain
            $subdomain = $1;
            $domain    = $2;
        }
        my $rec = {
            blog          => $blog,
            url_protocol  => $protocol,
            url_subdomain => $subdomain,
            url_domain    => $domain,
            url_path      => $url_path,
        };
        my $websites = ( $by_domain{ $protocol . $domain } ||= [] );
        push @$websites, $rec;
        $blog_count++;
    }

    return unless %by_domain;

    $self->progress(
        $self->translate_escape(
            'Migrating existing [quant,_1,blog,blogs] into websites and their children...',
            $blog_count
        )
    );

    my $assoc_class = MT->model('association');
    return $self->error(
        $self->translate_escape(
            "Error loading class: [_1].", 'Association'
        )
    ) unless $assoc_class;
    my $role_class = MT->model('role');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Role' ) )
        unless $role_class;
    my $role = $role_class->load_by_permission('administer_website');
    return $self->error(
        $self->translate_escape(
            "Error loading role: [_1].",
            'administer_website'
        )
    ) unless $role;

    my @sysadmins = MT::Author->load(
        { type => MT::Author::AUTHOR() },
        {   join => MT::Permission->join_on(
                'author_id',
                {   permissions => "\%'administer'\%",
                    blog_id     => '0',
                },
                { 'like' => { 'permissions' => 1 } }
            )
        }
    );

    my $website_class = MT->model('website');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'Website' ) )
        unless $website_class;

    while ( my ( $website_site_url, $blogs ) = each %by_domain ) {
        my $website
            = $website_class->load( { site_url => $website_site_url } );
        unless ($website) {
            require File::Spec;

            # lets try to figure out a common directory to all the blogs
            my @blogs_dirs = sort { scalar(@$a) <=> scalar(@$b) }
                map { [ $_->[0], File::Spec->splitdir( $_->[1] ) ] }
                map { [ File::Spec->splitpath( $_->{blog}->site_path, 1 ) ] }
                @$blogs;
            my @built_path;
            for ( my $i = 0; $i < scalar( @{ $blogs_dirs[0] } ); $i++ ) {
                my $part = $blogs_dirs[0]->[$i];
                last
                    unless scalar(@blogs_dirs) == grep { $part eq $_->[$i] }
                        @blogs_dirs;
                push @built_path, $part;
            }
            unless ( grep length($_), @built_path ) {

                # could not find anything in common -
                # try figure out a path from one of the blogs
                my $blog_rec = $blogs->[0];
                my $dir_depth = grep { defined($_) and length($_) }
                    split '/', $blog_rec->{url_path};
                my ( $volume, $dirs, undef )
                    = File::Spec->splitpath( $blog_rec->{blog}->site_path,
                    1 );
                @built_path = ( $volume, File::Spec->splitdir($dirs) );
                pop @built_path for 1 .. $dir_depth;
                unless (@built_path) {

                    # if could not, just take this blog path
                    @built_path = ( $volume, File::Spec->splitdir($dirs) );
                }
            }
            my $volume            = shift @built_path;
            my $website_site_path = File::Spec->catpath( $volume,
                File::Spec->catdir(@built_path) );
            $website_site_url = $website_site_url . '/'
                if $website_site_url !~ m!/$!;
            $website = $website_class->create_default_website(
                MT->translate( 'New WebSite [_1]', $website_site_url ),
                site_theme => MT->config->DefaultWebsiteTheme,
                site_url   => $website_site_url,
                site_path  => $website_site_path,
            );
            $website->save
                or return $self->error(
                $self->translate_escape(
                    "An error occured during generating a website upon upgrade: [_1]",
                    $website->errstr
                )
                );

            foreach (@sysadmins) {
                $assoc_class->link( $_ => $role => $website )
                    or die $role->name . $website->name;
            }
            $self->progress(
                $self->translate_escape(
                    'Generated a website [_1]',
                    $website_site_url
                )
            );
        }
        foreach my $blog_rec (@$blogs) {
            my $url_path  = $blog_rec->{url_path};
            my $subdomain = $blog_rec->{url_subdomain};
            my $domain    = $blog_rec->{url_domain};
            my $blog      = $blog_rec->{blog};
            $url_path = $url_path . '/' if $url_path !~ m!/$!;
            $url_path =~ s!^/!!;
            my $old_site_url = $blog->site_url;
            $blog->site_url("$subdomain/::/$url_path");
            $blog->parent_id( $website->id );

  # if archive_url is "under" the website url (i.e. either subdomain or path)
  # use the new data syntax (/::/).  otherwise leave it as-is.  config screens
  # and everything should handle both relative and absolute url correctly.
            if ( my $archive_url = $blog->column('archive_url') ) {
                my $protocol = $blog_rec->{url_protocol};
                if ( $archive_url
                    =~ m!$protocol((?:[^/]+\.)?)$domain((?:/.*)?)$! )
                {
                    my ( $subd, $path ) = ( $1, $2 );
                    $path =~ s!^/!!;
                    $blog->archive_url("$subd/::/$path");
                }
            }
            $blog->save
                or return $self->error(
                $self->translate_escape(
                    "An error occured during migrating a blog's site_url: [_1]",
                    $website->errstr
                )
                );
            $self->progress(
                $self->translate_escape(
                    'Moved blog [_1] ([_2]) under website [_3]',
                    $blog->name, $old_site_url, $domain
                )
            );
        }
    }
    1;
}

sub _v5_remove_technorati {
    my $self = shift;

    my $class = MT->model('blog');
    return $self->error(
        $self->translate_escape(
            "Error loading class: [_1].",
            $class->class_label
        )
    ) unless $class;

    my $iter = $class->load_iter( { class => '*' } );
    while ( my $blog = $iter->() ) {
        next unless ( $blog->update_pings || '' ) =~ m/technorati/i;

        my @pings = split ',', $blog->update_pings;
        @pings = grep { $_ ne 'technorati' } @pings;
        my $pings;
        $pings = join ',', @pings if @pings;
        $blog->update_pings($pings);
        $blog->save;
        $self->progress(
            $self->translate_escape(
                "Removing technorati update-ping service from [_1] (ID:[_2]).",
                $blog->name,
                $blog->id,
            )
        );
    }
}

sub _v5_remove_news_widget_cache {
    my $self = shift;
    $self->progress(
        $self->translate_escape( 'Expiring cached MT News widget...', ) );
    my $class = MT->model('session')
        or return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'session' ) );
    $class->remove( { kind => [qw( NW LW )] } );
}

sub _v5_recover_auth_type {
    my $self = shift;
    $self->progress(
        $self->translate_escape( 'Recovering type of author...', ) );

    my $authenticators = MT->registry('commenter_authenticators');
    my @keys           = keys %$authenticators;
    return unless @keys;

    my $author_class = MT->model('author')
        or return $self->error(
        $self->translate_escape( "Error loading class: [_1].", 'author' ) );

    my $auth_iter = $author_class->load_iter(
        {   type      => MT::Author::AUTHOR(),
            auth_type => \@keys,
        }
    );
    while ( my $author = $auth_iter->() ) {
        $author->type( MT::Author::COMMENTER() );
        $author->save;
    }
}

1;
__END__
