# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Blog.pm 4532 2009-10-02 02:25:27Z fumiakiy $

package MT::Blog;

use strict;
use base qw( MT::Object );

use MT::FileMgr;
use MT::Util;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'                        => 'integer not null auto_increment',
            'parent_id'                 => 'integer',
            'theme_id'                  => 'string(255)',
            'name'                      => 'string(255) not null',
            'description'               => 'text',
            'archive_type'              => 'string(255)',
            'archive_type_preferred'    => 'string(25)',
            'site_path'                 => 'string(255)',
            'site_url'                  => 'string(255)',
            'days_on_index'             => 'integer',
            'entries_on_index'          => 'integer',
            'file_extension'            => 'string(10)',
            'email_new_comments'        => 'boolean',
            'allow_comment_html'        => 'boolean',
            'autolink_urls'             => 'boolean',
            'sort_order_posts'          => 'string(8)',
            'sort_order_comments'       => 'string(8)',
            'allow_comments_default'    => 'boolean',
            'server_offset'             => 'float',
            'convert_paras'             => 'string(30)',
            'convert_paras_comments'    => 'string(30)',
            'allow_pings_default'       => 'boolean',
            'status_default'            => 'smallint',
            'allow_anon_comments'       => 'boolean',
            'words_in_excerpt'          => 'smallint',
            'moderate_unreg_comments'   => 'boolean',
            'moderate_pings'            => 'boolean',
            'allow_unreg_comments'      => 'boolean',
            'allow_reg_comments'        => 'boolean',
            'allow_pings'               => 'boolean',
            'manual_approve_commenters' => 'boolean',
            'require_comment_emails'    => 'boolean',
            'junk_folder_expiry'        => 'integer',
            'ping_weblogs'              => 'boolean',
            'mt_update_key'             => 'string(30)',
            'language'                  => 'string(5)',
            'date_language'             => 'string(5)',
            'welcome_msg'               => 'text',
            'google_api_key'            => 'string(32)',
            'email_new_pings'           => 'boolean',
            'ping_blogs'                => 'boolean',
            'ping_technorati'           => 'boolean',
            'ping_google'               => 'boolean',
            'ping_others'               => 'text',
            'autodiscover_links'        => 'boolean',
            'sanitize_spec'             => 'string(255)',
            'cc_license'                => 'string(255)',
            'is_dynamic'                => 'boolean',
            'remote_auth_token'         => 'string(50)',
            'children_modified_on'      => 'datetime',
            'custom_dynamic_templates'  => 'string(25)',
            'junk_score_threshold'      => 'float',
            'internal_autodiscovery'    => 'boolean',
            'basename_limit'            => 'smallint',
            'use_comment_confirmation'  => 'boolean',
            'allow_commenter_regist'    => 'boolean',
            'use_revision'              => 'boolean',
            'archive_url'               => 'string(255)',
            'archive_path'              => 'string(255)',
            'content_css'               => 'string(255)',
            ## Have to keep these around for use in mt-upgrade.cgi.
            'old_style_archive_links' => 'boolean',
            'archive_tmpl_daily'      => 'string(255)',
            'archive_tmpl_weekly'     => 'string(255)',
            'archive_tmpl_monthly'    => 'string(255)',
            'archive_tmpl_category'   => 'string(255)',
            'archive_tmpl_individual' => 'string(255)',
            ## end of fields for mt-upgrade.cgi

            # meta properties
            'image_default_wrap_text'  => 'integer meta',
            'image_default_align'      => 'string meta',
            'image_default_thumb'      => 'integer meta',
            'image_default_width'      => 'integer meta',
            'image_default_wunits'     => 'string meta',
            'image_default_constrain'  => 'integer meta',
            'image_default_popup'      => 'integer meta',
            'commenter_authenticators' => 'string meta',
            'require_typekey_emails'   => 'integer meta',
            'nofollow_urls'            => 'integer meta',
            'follow_auth_links'        => 'integer meta',
            'update_pings'             => 'string meta',
            'captcha_provider'         => 'string meta',
            'publish_queue'            => 'integer meta',
            'nwc_smart_replace'        => 'integer meta',
            'nwc_replace_field'        => 'string meta',
            'template_set'             => 'string meta',
            'page_layout'              => 'string meta',
            'include_system'           => 'string meta',
            'include_cache'            => 'integer meta',
            'max_revisions_entry'      => 'integer meta',
            'max_revisions_template'   => 'integer meta',
            'theme_export_settings'    => 'hash meta',
            'category_order'           => 'text meta',
            'folder_order'             => 'text meta',

        },
        meta    => 1,
        audit   => 1,
        indexes => {
            name      => 1,
            parent_id => 1,
        },
        defaults      => { 'custom_dynamic_templates' => 'none', },
        child_classes => [
            'MT::Entry',        'MT::Page',
            'MT::Template',     'MT::Asset',
            'MT::Category',     'MT::Folder',
            'MT::Notification', 'MT::Log',
            'MT::ObjectTag',    'MT::Association',
            'MT::Comment',      'MT::TBPing',
            'MT::Trackback',    'MT::TemplateMap',
            'MT::Touch',
        ],
        datasource  => 'blog',
        primary_key => 'id',
        class_type  => 'blog',
    }
);

# Image upload defaults.
sub ALIGN () {'none'}
sub UNITS () {'pixels'}

sub class_label {
    MT->translate("Blog");
}

sub class_label_plural {
    MT->translate("Blogs");
}

sub list_props {
    return {
        id => {
            base  => '__virtual.id',
            order => 100,
        },
        name => {
            auto      => 1,
            label     => 'Name',
            order     => 200,
            display   => 'force',
            html_link => sub {
                my ( $prop, $obj, $app ) = @_;
                return $app->uri(
                    mode => 'dashboard',
                    args => { blog_id => $obj->id, },
                );
            },
        },
        entry_count => {
            label              => 'Entries',
            filter_label       => '__ENTRY_COUNT',
            order              => 300,
            base               => '__virtual.object_count',
            display            => 'default',
            count_class        => 'entry',
            count_col          => 'blog_id',
            filter_type        => 'blog_id',
            list_screen        => 'entry',
            list_permit_action => 'access_to_entry_list',
        },
        page_count => {
            label              => 'Pages',
            filter_label       => '__PAGE_COUNT',
            order              => 400,
            base               => '__virtual.object_count',
            display            => 'default',
            count_class        => 'page',
            count_col          => 'blog_id',
            filter_type        => 'blog_id',
            list_screen        => 'page',
            list_permit_action => 'access_to_page_list',
        },
        asset_count => {
            label              => 'Assets',
            filter_label       => '__ASSET_COUNT',
            order              => 500,
            base               => '__virtual.object_count',
            count_class        => 'asset',
            count_col          => 'blog_id',
            filter_type        => 'blog_id',
            list_screen        => 'asset',
            count_args         => { no_class => 1 },
            list_permit_action => 'access_to_asset_list',
        },
        comment_count => {
            label              => 'Comments',
            filter_label       => '__COMMENT_COUNT',
            order              => 600,
            base               => '__virtual.object_count',
            count_class        => 'comment',
            count_col          => 'blog_id',
            filter_type        => 'blog_id',
            list_screen        => 'comment',
            list_permit_action => 'access_to_comment_list',
        },

        # not in use in 5.1
        # member_count => {
        #     label              => 'Members',
        #     order              => 700,
        #     base               => '__virtual.object_count',
        #     count_class        => 'permission',
        #     count_col          => 'blog_id',
        #     filter_type        => 'blog_id',
        #     list_screen        => 'member',
        #     count_terms        => { author_id => { not => 0 } },
        #     list_permit_action => 'access_to_member_list',
        # },
        parent_website => {
            view            => ['system'],
            label           => 'Website',
            order           => 800,
            display         => 'default',
            filter_editable => 0,
            raw             => sub {
                my ( $prop, $obj ) = @_;
                my $parent = $obj->website;
                return $parent
                    ? $parent->name
                    : ( MT->translate('*Website/Blog deleted*') );
            },
            bulk_sort => sub {
                my $prop    = shift;
                my ($objs)  = @_;
                my %parents = map { $_->parent_id => 1 } @$objs;
                return @$objs if scalar keys %parents <= 1;
                my @parents = MT->model('website')
                    ->load( { id => [ keys %parents ] } );
                my %parent_names = map { $_->id => $_->name } @parents;
                return sort {
                    $parent_names{ $a->parent_id }
                        cmp $parent_names{ $b->parent_id }
                } @$objs;
            },
        },
        created_on => {
            base  => '__virtual.created_on',
            order => 900,
        },
        description => {
            auto    => 1,
            label   => 'Description',
            display => 'none',
        },
        theme_id => {
            label                 => 'Theme',
            base                  => '__virtual.single_select',
            display               => 'none',
            col                   => 'theme_id',
            single_select_options => sub {
                my $prop = shift;
                require MT::Theme;
                my $themes = MT::Theme->load_all_themes;
                return [
                    map { { label => $_->label, value => $_->id } }
                        sort { $a->label cmp $b->label }
                        grep {
                               $_->{class} eq 'blog'
                            || $_->{class} eq 'both'
                        } values %$themes
                ];
            },
        },
        modified_on => {
            display => 'none',
            base    => '__virtual.modified_on',
        },
    };
}

{
    my $default_text_format;

    sub set_defaults {
        my $blog = shift;
        $blog->SUPER::set_defaults(@_);

        unless ($default_text_format) {
            if ( my $allowed = MT->config('AllowedTextFilters') ) {
                $allowed =~ s/\s*,.*//;
                $default_text_format = $allowed; # choose first allowed format
            }
            else {
                $default_text_format = 'richtext';    # MT system default
            }
            my $filters = MT->registry("text_filters");

            # If the 'richtext' filter exists,
            # and is uncondition or it meets the condition, use
            # it as the blog default text format.
            if (!(  $filters->{$default_text_format}
                    && (  !$filters->{$default_text_format}{condition}
                        || $filters->{$default_text_format}{condition}
                        ->('blog') )
                )
                )
            {
                $default_text_format = '__default__';
            }
        }
        $blog->set_values_internal(
            {   days_on_index            => 0,
                entries_on_index         => 10,
                words_in_excerpt         => 40,
                sort_order_posts         => 'descend',
                language                 => MT->config('DefaultLanguage'),
                date_language            => MT->config('DefaultLanguage'),
                sort_order_comments      => 'ascend',
                file_extension           => 'html',
                convert_paras            => $default_text_format,
                allow_unreg_comments     => 0,
                allow_reg_comments       => 1,
                allow_pings              => 1,
                moderate_unreg_comments  => MT::Blog::MODERATE_UNTRSTD(),
                moderate_pings           => 1,
                require_comment_emails   => 1,
                allow_comments_default   => 1,
                allow_comment_html       => 1,
                autolink_urls            => 1,
                allow_pings_default      => 1,
                require_comment_emails   => 0,
                convert_paras_comments   => 1,
                email_new_pings          => 1,
                email_new_comments       => 1,
                allow_commenter_regist   => 1,
                use_comment_confirmation => 1,
                sanitize_spec            => 0,
                ping_weblogs             => 0,
                ping_blogs               => 0,
                ping_technorati          => 0,
                ping_google              => 0,
                archive_type             => '',
                archive_type_preferred   => '',
                status_default           => 2,
                junk_score_threshold     => 0,
                junk_folder_expiry       => 14,       # 14 days
                custom_dynamic_templates => 'none',
                internal_autodiscovery   => 0,
                basename_limit           => 100,
                server_offset => MT->config('DefaultTimezone') || 0,

               # something far in the future to force dynamic side to read it.
                children_modified_on => '20101231120000',
                use_revision         => 1,
            }
        );
        return $blog;
    }
}

sub is_blog {
    my $class = shift;
    return $class->class eq 'blog';
}

sub create_default_blog {
    my $class = shift;
    my ( $blog_name, $blog_template, $website_id ) = @_;
    $blog_name ||= MT->translate("First Blog");
    $class = ref $class if ref $class;

    my $blog = new $class;
    $blog->name($blog_name);

    # Enable nofollow options
    $blog->nofollow_urls(1);
    $blog->follow_auth_links(1);

    # Enable default commenter authentication
    $blog->commenter_authenticators( MT->config('DefaultCommenterAuth') );

    # set default page layout
    $blog->page_layout('layout-wtt');

    # Set class type
    $blog->class('blog');

    # Set parent
    $blog->parent_id($website_id);

    $blog->save or return $class->error( $blog->errstr );
    $blog->create_default_templates( $blog_template || 'mt_blog' )
        or return $class->error( $blog->errstr );
    return $blog;
}

sub create_default_templates {
    my $blog = shift;

    my $app       = MT->instance;
    my $curr_lang = $app->current_language;
    $app->set_language( $blog->language );

    require MT::DefaultTemplates;
    my $tmpl_list = MT::DefaultTemplates->templates(@_);
    if ( !$tmpl_list || ( ref($tmpl_list) ne 'ARRAY' ) || ( !@$tmpl_list ) ) {
        $app->set_language($curr_lang);
        return $blog->error(
            MT->translate("No default templates were found.") );
    }

    require MT::Template;
    my @arch_tmpl;
    for my $val (@$tmpl_list) {
        next if $val->{global};

        my $obj = MT::Template->new;
        my $p   = $val->{plugin}
            || 'MT';    # component and/or MT package for translate
        local $val->{name}
            = $val->{name};    # name field is translated in "templates" call
        my $text = $val->{text};
        local $val->{text};
        $val->{text} = $p->translate_templatized($text) if defined $text;
        $obj->build_dynamic(0);

        foreach my $v ( keys %$val ) {
            $obj->column( $v, $val->{$v} ) if $obj->has_column($v);
        }
        $obj->blog_id( $blog->id );
        if ( my $pub_opts = $val->{publishing} ) {
            $obj->include_with_ssi(1) if $pub_opts->{include_with_ssi};
        }
        if (   ( 'widgetset' eq $val->{type} )
            && ( exists $val->{widgets} ) )
        {
            my $modulesets = delete $val->{widgets};
            $obj->modulesets(
                MT::Template->widgets_to_modulesets( $modulesets, $blog->id )
            );
        }
        $obj->save;
        if ( $val->{mappings} ) {
            push @arch_tmpl,
                {
                template => $obj,
                mappings => $val->{mappings},
                exists( $val->{preferred} )
                ? ( preferred => $val->{preferred} )
                : ()
                };
        }
    }

    my %archive_types;
    if (@arch_tmpl) {
        require MT::TemplateMap;
        for my $map_set (@arch_tmpl) {
            my $tmpl     = $map_set->{template};
            my $mappings = $map_set->{mappings};
            foreach my $map_key ( keys %$mappings ) {
                my $m  = $mappings->{$map_key};
                my $at = $m->{archive_type};
                $archive_types{$at} = 1;

                # my $preferred = $mappings->{$map_key}{preferred};
                my $map = MT::TemplateMap->new;
                $map->archive_type($at);
                if ( exists $m->{preferred} ) {
                    $map->is_preferred( $m->{preferred} );
                }
                else {
                    $map->is_preferred(1);
                }
                $map->template_id( $tmpl->id );
                $map->file_template( $m->{file_template} )
                    if $m->{file_template};
                $map->blog_id( $tmpl->blog_id );
                $map->build_type( $m->{build_type} )
                    if defined $m->{build_type};
                $map->save;
            }
        }
    }

    $blog->archive_type( join ',', keys %archive_types );
    foreach my $at (qw( Individual Daily Weekly Monthly Category )) {
        $blog->archive_type_preferred($at), last
            if exists $archive_types{$at};
    }
    $blog->custom_dynamic_templates('none');
    $blog->save;

    MT->run_callbacks( ref($blog) . '::post_create_default_templates',
        $blog, $tmpl_list );

    $app->set_language($curr_lang);
    return $blog;
}

# As of MT 4, we always manage fileinfo records.
sub needs_fileinfo {
    return 1;
}

sub current_timestamp {
    my $blog = shift;
    require MT::Util;
    my @ts = MT::Util::offset_time_list( time, $blog->id );
    return sprintf '%04d%02d%02d%02d%02d%02d',
        $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
}

sub website {
    my $blog = shift;
    return $blog unless $blog->is_blog;
    return undef unless $blog->parent_id;

    require MT::Website;
    return MT::Website->load( $blog->parent_id );
}

sub theme {
    require MT::Theme;
    my $blog = shift;
    my $id   = $blog->theme_id;
    return MT::Theme->load($id);
}

sub raw_site_url {
    my $blog = shift;
    my $site_url = $blog->SUPER::site_url || '';
    if ( my ( $subdomain, $path ) = split( '/::/', $site_url ) ) {
        if ( $subdomain ne $site_url ) {
            return ( $subdomain, $path );
        }
    }
    return $site_url;
}

sub site_url {
    my $blog = shift;

    if (@_) {
        return $blog->SUPER::site_url(@_);
    }
    elsif ( $blog->is_dynamic ) {
        my $cfg  = MT->config;
        my $path = $cfg->CGIPath;
        if ( $path =~ m!^/! ) {

            # relative path, prepend blog domain
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $path = $blog_domain . $path;
        }
        $path .= '/' unless $path =~ m{/$};
        return $path;
    }
    else {
        my $url = '';
        if ( $blog->is_blog() ) {
            if ( my $website = $blog->website() ) {
                $url = $website->SUPER::site_url;
            }
            else {

                # FIXME: there are a few occasions where
                # a blog does not have its parent, like (bugid:102749)
                return $blog->SUPER::site_url;
            }
            my @paths = $blog->raw_site_url;
            if ( 2 == @paths ) {
                if ( $paths[0] ) {
                    $url =~ s!^(https?)://(.+)/$!$1://$paths[0]$2/!;
                }
                if ( $paths[1] ) {
                    $url = MT::Util::caturl( $url, $paths[1] );
                }
            }
            else {
                $url = MT::Util::caturl( $url, $paths[0] );
            }
        }
        else {
            $url = $blog->SUPER::site_url;
        }

        return $url;
    }
}

sub is_site_path_absolute {
    my $blog = shift;

    my $raw_path;
    if ( ref $blog ) {
        $raw_path = $blog->SUPER::site_path;
    }
    else {
        $raw_path = $_[0];
    }

    return 1 if $raw_path =~ m!^/!;
    return 1 if $raw_path =~ m!^[a-zA-Z]:\\!;
    return 1 if $raw_path =~ m!^\\\\[a-zA-Z0-9\.]+!;    # UNC
    return 0;
}

sub site_path {
    my $blog = shift;

    if (@_) {
        $blog->SUPER::site_path(@_);
    }
    else {
        my $raw_path = $blog->SUPER::site_path;
        return $raw_path if $blog->is_site_path_absolute;

        my $base_path = '';
        my $path      = '';
        my $website   = $blog->website();
        if ( $blog->is_blog() && $website ) {
            $base_path = $website->column('site_path');
            if ($base_path) {
                $path = File::Spec->catdir( $base_path, $raw_path );
            }
            else {
                $path = $raw_path;
            }
        }
        else {
            $path = $raw_path;
        }
        return $path;
    }
}

sub raw_archive_url {
    my $blog = shift;
    my $archive_url = $blog->SUPER::archive_url || '';
    if ( my ( $subdomain, $path ) = split( '/::/', $archive_url ) ) {
        return ( $subdomain, $path );
        if ( $subdomain ne $archive_url ) {
            return ( $subdomain, $path );
        }
    }
    return $archive_url;
}

sub archive_url {
    my $blog = shift;

    if (@_) {
        $blog->SUPER::archive_url(@_) || $blog->site_url;
    }
    elsif ( $blog->is_dynamic ) {
        return $blog->site_url;
    }
    else {
        my $url = $blog->site_url;
        if ( $blog->is_blog() ) {
            if ( my $website = $blog->website() ) {
                $url = $website->SUPER::site_url;
            }
            my $archive_url = $blog->SUPER::archive_url;
            return $blog->site_url unless $archive_url;
            return $archive_url if $archive_url =~ m!^https?://!;
            my @paths = $blog->raw_archive_url;
            if ( 2 == @paths ) {
                if ( $paths[0] ) {
                    $url =~ s!^(https?)://(.+)/$!$1://$paths[0]$2/!;
                }
                if ( $paths[1] ) {
                    $url = MT::Util::caturl( $url, $paths[1] );
                }
            }
            else {
                $url = MT::Util::caturl( $url, $paths[0] );
            }
        }
        return $url;
    }
}

sub is_archive_path_absolute {
    my $blog = shift;

    my $raw_path = $blog->SUPER::archive_path;
    return 0 unless $raw_path;
    return 1 if $raw_path =~ m!^/!;
    return 1 if $raw_path =~ m!^[a-zA-Z]:\\!;
    return 1 if $raw_path =~ m!^\\\\[a-zA-Z0-9\.]+!;    # UNC
    return 0;
}

sub archive_path {
    my $blog = shift;

    if (@_) {
        $blog->SUPER::archive_path(@_) || $blog->site_path;
    }
    else {
        return $blog->site_path if !$blog->column('archive_path');

        my $raw_path = $blog->SUPER::archive_path;
        return $raw_path if $blog->is_archive_path_absolute;

        my $base_path = '';
        my $path      = '';
        if ( my $website = $blog->website() ) {
            $base_path = $website->SUPER::site_path;
        }
        $path = $raw_path;
        if ($base_path) {
            $path = File::Spec->catdir( $base_path, $raw_path );
        }
        else {
            $path = $blog->site_path;
        }
        return $path;
    }
}

sub comment_text_filters {
    my $blog    = shift;
    my $filters = $blog->convert_paras_comments;
    return [] unless $filters;
    if ( $filters eq '1' ) {
        return ['__default__'];
    }
    else {
        return [ split /\s*,\s*/, $filters ];
    }
}

sub cc_license_url {
    my $cc = $_[0]->cc_license or return '';
    MT::Util::cc_url($cc);
}

sub email_all_comments {
    return $_[0]->email_new_comments == 1;
}

sub email_attn_reqd_comments {
    return $_[0]->email_new_comments == 2;
}

sub email_all_pings {
    return $_[0]->email_new_pings == 1;
}

sub email_attn_reqd_pings {
    return $_[0]->email_new_pings == 2;
}

sub MODERATE_NONE ()    {0}
sub MODERATE_ALL ()     {1}
sub MODERATE_UNTRSTD () {2}
sub MODERATE_UNAUTHD () {3}

sub publish_trusted_commenters {
    !( $_[0]->moderate_unreg_comments == MODERATE_ALL );
}

sub publish_authd_untrusted_commenters {
    return $_[0]->moderate_unreg_comments == MODERATE_UNAUTHD
        || $_[0]->moderate_unreg_comments == MODERATE_NONE;
}

sub publish_unauthd_commenters {
    $_[0]->moderate_unreg_comments == MODERATE_NONE;
}

sub include_path_parts {
    my $blog = shift;
    my ($param) = @_;

    my $filestem = MT::Util::dirify( $param->{name} )
        || 'template';
    $filestem .= '_' . $param->{id};
    my $filename = join q{.}, $filestem, $blog->file_extension;
    my $path = $param->{path} || '';
    my @path;
    if ( $path =~ s!^/!! ) {

        # absolute
        @path = split q{/}, $path;
    }
    else {

        # relative
        push @path, MT->config('IncludesDir');
        push @path, split q{/}, $path;
    }
    return ( $filename, @path );
}

sub include_path {
    my $blog = shift;

    my ( $filename, @path ) = $blog->include_path_parts(@_);
    my $extra_path = File::Spec->catdir(@path);
    my $full_path  = File::Spec->catdir( $blog->site_path, $extra_path );
    my $file_path  = File::Spec->catfile( $full_path, $filename );
    return wantarray ? ( $file_path, $full_path, $filename ) : $file_path;
}

sub include_url {
    my $blog = shift;

    my ( $filename, @path ) = $blog->include_path_parts(@_);
    my $url = join q{/}, $blog->site_url, @path, $filename;
    return $url;
}

sub include_statement {
    my $blog = shift;

    my $system = $blog->include_system or return;

    my ( $statement, $include );
    if ( $system eq 'shtml' ) {
        $statement = q{<!--#include virtual="%s" -->};

        my ( $filename, @path ) = $blog->include_path_parts(@_);
        my $site_url = $blog->site_url;
        $site_url =~ s{ \A \w+ :// [^/]+ }{}xms;
        $site_url =~ s{ / \z }{}xms;
        $include = join q{/}, $site_url, @path, $filename;
    }
    else {
        $include = $blog->include_path(@_);
        $statement
            = $system eq 'php' ? q{<?php include("%s") ?>}
            : $system eq 'jsp' ? q{<%@ include file="%s" %>}
            : $system eq 'asp' ? '<!--#include file="%s" -->'
            :                    return;
    }
    return sprintf $statement, MT::Util::encode_php( $include, q{qq} );
}

sub file_mgr {
    my $blog = shift;
    unless ( exists $blog->{__file_mgr} ) {
## xxx need to add remote_host, remote_user, remote_pwd fields
## then pull params from there; if remote_host is defined, we
## assume we are using FTP?
        $blog->{__file_mgr} = MT::FileMgr->new('Local');
    }
    $blog->{__file_mgr};
}

sub remove {
    my $blog    = shift;
    my $blog_id = $blog->id
        if ref($blog);

    # Load all the models explicitly.
    MT->all_models;

    $blog->remove_children( { key => 'blog_id' } );
    my $res = $blog->SUPER::remove(@_);
    if ( $blog_id && $res ) {
        require MT::Permission;
        MT::Permission->remove( { blog_id => $blog_id } );
        require MT::PluginData;
        MT::PluginData->remove( { blog_id => $blog_id } );
    }
    $res;
}

# deprecated: use $blog->remote_auth_token instead
sub effective_remote_auth_token {
    my $blog = shift;
    if ( scalar @_ ) {
        return $blog->remote_auth_token(@_);
    }
    if ( $blog->remote_auth_token() ) {
        return $blog->remote_auth_token();
    }
    undef;
}

sub flush_has_archive_type_cache {
    my $blog = shift;
    my ($type) = @_;

    my $cache_key = 'has_archive_type::blog:' . $blog->id;
    my $cache = MT->request($cache_key) or return;
    delete $cache->{$type}
        if exists $cache->{$type};
    1;
}

sub has_archive_type {
    my $blog   = shift;
    my ($type) = @_;
    my %at     = map { lc $_ => 1 } split( /,/, $blog->archive_type );
    return 0 unless exists $at{ lc $type };

    my $cache_key = 'has_archive_type::blog:' . $blog->id;

    my $r     = MT->request;
    my $cache = $r->cache($cache_key);
    if ( !$cache || ( $cache && !$cache->{$type} ) ) {
        require MT::PublishOption;
        require MT::TemplateMap;
        my $count = MT::TemplateMap->count(
            {   blog_id      => $blog->id,
                archive_type => $type,
                build_type   => { not => MT::PublishOption::DISABLED() },
            }
        );
        $cache->{$type} = $count;
        $r->cache( $cache_key, $cache );
    }
    return $cache->{$type};
}

sub accepts_registered_comments {
    $_[0]->allow_reg_comments && $_[0]->commenter_authenticators;
}

sub accepts_comments {
    $_[0]->accepts_registered_comments || $_[0]->allow_unreg_comments;
}

sub count_static_templates {
    my $blog           = shift;
    my ($archive_type) = @_;
    my $result         = 0;
    require MT::TemplateMap;
    my @maps = MT::TemplateMap->load(
        {   blog_id      => $blog->id,
            archive_type => $archive_type
        }
    );
    return 0 unless @maps;
    require MT::PublishOption;
    foreach my $map (@maps) {
        $result++ if $map->build_type != MT::PublishOption::DYNAMIC();
    }

    #$result ||= 1 if ($blog->custom_dynamic_templates || '') ne 'custom';
    return $result;
}

sub touch {
    my $blog = shift;
    my (@types) = @_;
    my ( $s, $m, $h, $d, $mo, $y ) = localtime(time);
    my $mod_time = sprintf( "%04d%02d%02d%02d%02d%02d",
        1900 + $y, $mo + 1, $d, $h, $m, $s );
    require MT::Touch;
    MT::Touch->touch( $blog->id, @types );
    $blog->children_modified_on($mod_time);
    $mod_time;
}

sub clone {
    my $blog = shift;
    my ($param) = @_;
    if ( $param && $param->{Children} ) {
        $blog->clone_with_children(@_);
    }
    else {
        $blog->SUPER::clone(@_);
    }
}

sub clone_with_children {
    my $blog       = shift;
    my ($params)   = @_;
    my $callback   = $params->{Callback} || sub { };
    my $classes    = $params->{Classes};
    my $blog_name  = $params->{BlogName};
    my $website_id = $params->{Website};
    delete $$params{Children} if ( $params->{Children} );
    my $old_blog_id = $blog->id;

    # we must clone:
    #    Blog record
    #    Entry records
    #       - Comment records
    #       - TrackBack records
    #       - TBPing records
    #       - ObjectTag records (if running 3.3)
    #    Category records
    #    Placement records
    #    Template records
    #    Permission records
    #    IPBanList records???
    #    Notification records???

    my $new_blog_id;
    my ( %entry_map, %cat_map, %tb_map, %tmpl_map, %comment_map, $counter,
        $iter );

    # Cloning blog
    my $new_blog = $blog->clone($params);
    $new_blog->name(
          $blog_name
        ? $blog_name
        : MT->translate( "Clone of [_1]", $blog->name )
    );
    $new_blog->parent_id($website_id);
    delete $new_blog->{column_values}->{id};
    delete $new_blog->{changed_cols}->{id};
    $new_blog->modified_on(undef);
    $new_blog->created_on(undef);
    $new_blog->save or die $new_blog->errstr;
    $new_blog_id = $new_blog->id;
    $callback->(
        MT->translate( "Cloned blog... new id is [_1].", $new_blog_id ) );

    if ( ( !exists $classes->{'MT::Permission'} )
        || $classes->{'MT::Permission'} )
    {

        # Cloning PERMISSIONS records
        $counter = 0;
        my $state = MT->translate("Cloning permissions for blog:");
        $callback->( $state, "perms" );
        require MT::Permission;
        $iter = MT::Permission->load_iter( { blog_id => $old_blog_id } );

        while ( my $perm = $iter->() ) {
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed...", $counter ),
                'perms'
            ) if $counter && ( $counter % 100 == 0 );
            $counter++;
            my $new_perm = $perm->clone();
            delete $new_perm->{column_values}->{id};
            delete $new_perm->{changed_cols}->{id};
            $new_perm->blog_id($new_blog_id);
            $new_perm->save or die $new_perm->errstr;
        }
        $callback->(
            $state . " "
                . MT->translate( "[_1] records processed.", $counter ),
            'perms'
        );
    }

    if ( ( !exists $classes->{'MT::Association'} )
        || $classes->{'MT::Association'} )
    {

        # Cloning association records
        $counter = 0;
        my $state = MT->translate("Cloning associations for blog:");
        $callback->( $state, "assoc" );
        require MT::Association;
        $iter = MT::Association->load_iter( { blog_id => $old_blog_id } );
        while ( my $assoc = $iter->() ) {
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed...", $counter ),
                'assoc'
            ) if $counter && ( $counter % 100 == 0 );
            $counter++;
            my $new_assoc = $assoc->clone();
            delete $new_assoc->{column_values}->{id};
            delete $new_assoc->{changed_cols}->{id};
            $new_assoc->blog_id($new_blog_id);
            $new_assoc->save or die $new_assoc->errstr;
        }
        $callback->(
            $state . " "
                . MT->translate( "[_1] records processed.", $counter ),
            'assoc'
        );
    }

    # include/exclude class logic
    # if user has not specified 'Classes' element, clone everything
    # if user has specified Classes, but a particular class is not
    # identified, clone it (forward compatibility). if a class is
    # specified and the flag is '1', clone it. if a class is specified
    # but the flag is '0', skip it.

    # MT::Entry -> MT::Category, MT::Comment, MT::Tracback, MT::TBPing
    # MT::Page -> MT::Folder, MT::Comment, MT::Trackback, MT::TBPing

    if ( ( !exists $classes->{'MT::Entry'} ) || $classes->{'MT::Entry'} ) {

        # Cloning ENTRY records
        my $state = MT->translate("Cloning entries and pages for blog...");
        $callback->( $state, "entries" );
        $counter = 0;
        require MT::Entry;
        $iter = MT::Entry->load_iter(
            { blog_id => $old_blog_id, class => '*' } );
        while ( my $entry = $iter->() ) {
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed...", $counter ),
                'entries'
            ) if $counter && ( $counter % 100 == 0 );
            $counter++;
            my $entry_id  = $entry->id;
            my $new_entry = $entry->clone();
            delete $new_entry->{column_values}->{id};
            delete $new_entry->{changed_cols}->{id};
            $new_entry->blog_id($new_blog_id);
            $new_entry->save or die $new_entry->errstr;
            $entry_map{$entry_id} = $new_entry->id;
        }
        $callback->(
            $state . " "
                . MT->translate( "[_1] records processed.", $counter ),
            'entries'
        );

        if ( ( !exists $classes->{'MT::Category'} )
            || $classes->{'MT::Category'} )
        {

            # Cloning CATEGORY records
            my $state = MT->translate("Cloning categories for blog...");
            $callback->( $state, "cats" );
            $counter = 0;
            require MT::Category;
            $iter = MT::Category->load_iter(
                { blog_id => $old_blog_id, class => '*' } );
            my %cat_parents;
            while ( my $cat = $iter->() ) {
                $callback->(
                    $state . " "
                        . MT->translate(
                        "[_1] records processed...", $counter
                        ),
                    'cats'
                ) if $counter && ( $counter % 100 == 0 );
                $counter++;
                my $cat_id     = $cat->id;
                my $old_parent = $cat->parent;
                my $new_cat    = $cat->clone();
                delete $new_cat->{column_values}->{id};
                delete $new_cat->{changed_cols}->{id};
                $new_cat->blog_id($new_blog_id);

                # temporarily wipe the parent association
                # to avoid constraint issues.
                $new_cat->parent(0);
                $new_cat->save or die $new_cat->errstr;
                $cat_map{$cat_id} = $new_cat->id;
                if ($old_parent) {
                    $cat_parents{ $new_cat->id } = $old_parent;
                }
            }

            # reassign the new category parents
            foreach ( keys %cat_parents ) {
                my $cat = MT::Category->load($_);
                if ($cat) {
                    $cat->parent( $cat_map{ $cat_parents{ $cat->id } } );
                    $cat->save or die $cat->errstr;
                }
            }

            # reconstruct the category order
            $new_blog->category_order(
                join(
                    ',',
                    map( $cat_map{$_},
                        split( /,/, ( $blog->category_order || '' ) ) )
                )
            );

            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed.", $counter ),
                'cats'
            );

            # Placements are automatically cloned if categories are
            # cloned.
            $state = MT->translate("Cloning entry placements for blog...");
            $callback->( $state, "places" );
            require MT::Placement;
            $iter = MT::Placement->load_iter( { blog_id => $old_blog_id } );
            $counter = 0;
            while ( my $place = $iter->() ) {
                $callback->(
                    $state . " "
                        . MT->translate(
                        "[_1] records processed...", $counter
                        ),
                    'places'
                ) if $counter && ( $counter % 100 == 0 );
                $counter++;
                my $new_place = $place->clone();
                delete $new_place->{column_values}->{id};
                delete $new_place->{changed_cols}->{id};
                $new_place->blog_id($new_blog_id);
                $new_place->category_id( $cat_map{ $place->category_id } );
                $new_place->entry_id( $entry_map{ $place->entry_id } );
                $new_place->save or die $new_place->errstr;
            }
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed.", $counter ),
                'places'
            );
        }

        if ( ( !exists $classes->{'MT::Comment'} )
            || $classes->{'MT::Comment'} )
        {

            # Comments can only be cloned if entries are cloned.
            my $state = MT->translate("Cloning comments for blog...");
            $callback->( $state, "comments" );
            require MT::Comment;
            $iter = MT::Comment->load_iter( { blog_id => $old_blog_id } );
            $counter = 0;
            my %comment_parents;
            while ( my $comment = $iter->() ) {
                $callback->(
                    $state . " "
                        . MT->translate(
                        "[_1] records processed...", $counter
                        ),
                    'comments'
                ) if $counter && ( $counter % 100 == 0 );
                $counter++;

                my $new_comment = $comment->clone();
                delete $new_comment->{column_values}->{id};
                delete $new_comment->{changed_cols}->{id};
                $new_comment->entry_id( $entry_map{ $comment->entry_id } );
                $new_comment->blog_id($new_blog_id);
                $new_comment->save or die $new_comment->errstr;
                $comment_map{ $comment->id } = $new_comment->id;
                if ( $comment->parent_id ) {
                    $comment_parents{ $new_comment->id }
                        = $comment->parent_id;
                }
            }
            foreach ( keys %comment_parents ) {
                my $comment = MT::Comment->load($_);
                if ($comment) {
                    $comment->parent_id(
                        $comment_map{ $comment_parents{ $comment->id } } );
                    $comment->save or die $comment->errstr;
                }
            }
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed.", $counter ),
                'comments'
            );
        }

        if ( ( !exists $classes->{'MT::ObjectTag'} )
            || $classes->{'MT::ObjectTag'} )
        {

            # conditionally do MT::ObjectTag since it is only
            # available with MT 3.3.
            if ( $MT::VERSION >= 3.3 ) {
                my $state = MT->translate("Cloning entry tags for blog...");
                $callback->( $state, "tags" );
                require MT::ObjectTag;
                $iter
                    = MT::ObjectTag->load_iter(
                    { blog_id => $old_blog_id, object_datasource => 'entry' }
                    );
                $counter = 0;
                while ( my $entry_tag = $iter->() ) {
                    $callback->(
                        $state . " "
                            . MT->translate(
                            "[_1] records processed...", $counter
                            ),
                        "tags"
                    ) if $counter && ( $counter % 100 == 0 );
                    $counter++;
                    my $new_entry_tag = $entry_tag->clone();
                    delete $new_entry_tag->{column_values}->{id};
                    delete $new_entry_tag->{changed_cols}->{id};
                    $new_entry_tag->blog_id($new_blog_id);
                    $new_entry_tag->object_id(
                        $entry_map{ $entry_tag->object_id } );
                    $new_entry_tag->save or die $new_entry_tag->errstr;
                }
                $callback->(
                    $state . " "
                        . MT->translate( "[_1] records processed.",
                        $counter ),
                    'tags'
                );
            }
        }
    }
    elsif ( ( !exists $classes->{'MT::Category'} )
        || $classes->{'MT::Category'} )
    {

        # Cloning CATEGORY records
        my $state = MT->translate("Cloning categories for blog...");
        $callback->( $state, "cats" );
        $counter = 0;
        require MT::Category;
        $iter = MT::Category->load_iter(
            { blog_id => $old_blog_id, class => '*' } );
        my %cat_parents;
        while ( my $cat = $iter->() ) {
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed...", $counter ),
                'cats'
            ) if $counter && ( $counter % 100 == 0 );
            $counter++;
            my $cat_id     = $cat->id;
            my $old_parent = $cat->parent;
            my $new_cat    = $cat->clone();
            delete $new_cat->{column_values}->{id};
            delete $new_cat->{changed_cols}->{id};
            $new_cat->blog_id($new_blog_id);

            # temporarily wipe the parent association
            # to avoid constraint issues.
            $new_cat->parent(0);
            $new_cat->save or die $new_cat->errstr;
            $cat_map{$cat_id} = $new_cat->id;
            if ($old_parent) {
                $cat_parents{ $new_cat->id } = $old_parent;
            }
        }

        # reassign the new category parents
        foreach ( keys %cat_parents ) {
            my $cat = MT::Category->load($_);
            if ($cat) {
                $cat->parent( $cat_map{ $cat_parents{ $cat->id } } );
                $cat->save or die $cat->errstr;
            }
        }

        # reconstruct the category order
        $new_blog->category_order(
            join(
                ',',
                map( $cat_map{$_},
                    split( /,/, ( $blog->category_order || '' ) ) )
            )
        );

        $callback->(
            $state . " "
                . MT->translate( "[_1] records processed.", $counter ),
            'cats'
        );
    }

    if ( ( !exists $classes->{'MT::Trackback'} )
        || $classes->{'MT::Trackback'} )
    {
        my $state = MT->translate("Cloning TrackBacks for blog...");
        $callback->( $state, "tbs" );
        require MT::Trackback;
        $iter = MT::Trackback->load_iter( { blog_id => $old_blog_id } );
        $counter = 0;
        while ( my $tb = $iter->() ) {
            next
                unless ( $tb->entry_id && $entry_map{ $tb->entry_id } )
                || ( $tb->category_id && $cat_map{ $tb->category_id } );

            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed...", $counter ),
                'tbs'
            ) if $counter && ( $counter % 100 == 0 );
            $counter++;
            my $tb_id  = $tb->id;
            my $new_tb = $tb->clone();
            delete $new_tb->{column_values}->{id};
            delete $new_tb->{changed_cols}->{id};

            if ( $tb->category_id ) {
                if ( my $cid = $cat_map{ $tb->category_id } ) {
                    my $cat_tb
                        = MT::Trackback->load( { category_id => $cid } );
                    if ($cat_tb) {
                        my $changed;
                        if ( $tb->passphrase ) {
                            $cat_tb->passphrase( $tb->passphrase );
                            $changed = 1;
                        }
                        if ( $tb->is_disabled ) {
                            $cat_tb->is_disabled(1);
                            $changed = 1;
                        }
                        $cat_tb->save if $changed;
                        $tb_map{$tb_id} = $cat_tb->id;
                        next;
                    }
                }
            }
            elsif ( $tb->entry_id ) {
                if ( my $eid = $entry_map{ $tb->entry_id } ) {
                    my $entry_tb = MT::Entry->load($eid)->trackback;
                    if ($entry_tb) {
                        my $changed;
                        if ( $tb->passphrase ) {
                            $entry_tb->passphrase( $tb->passphrase );
                            $changed = 1;
                        }
                        if ( $tb->is_disabled ) {
                            $entry_tb->is_disabled(1);
                            $changed = 1;
                        }
                        $entry_tb->save if $changed;
                        $tb_map{$tb_id} = $entry_tb->id;
                        next;
                    }
                }
            }

            # A trackback wasn't created when saving the entry/category,
            # (perhaps trackbacks are now disabled for the entry/category?)
            # so create one now
            $new_tb->entry_id( $entry_map{ $tb->entry_id } )
                if $tb->entry_id && $entry_map{ $tb->entry_id };
            $new_tb->category_id( $cat_map{ $tb->category_id } )
                if $tb->category_id && $cat_map{ $tb->category_id };
            $new_tb->blog_id($new_blog_id);
            $new_tb->save or die $new_tb->errstr;
            $tb_map{$tb_id} = $new_tb->id;
        }
        $callback->(
            $state . " "
                . MT->translate( "[_1] records processed.", $counter ),
            'tbs'
        );

        if ( ( !exists $classes->{'MT::TBPing'} )
            || $classes->{'MT::TBPing'} )
        {
            my $state = MT->translate("Cloning TrackBack pings for blog...");
            $callback->( $state, "pings" );
            require MT::TBPing;
            $iter = MT::TBPing->load_iter( { blog_id => $old_blog_id } );
            $counter = 0;
            while ( my $ping = $iter->() ) {
                next unless $tb_map{ $ping->tb_id };
                $callback->(
                    $state . " "
                        . MT->translate(
                        "[_1] records processed...", $counter
                        ),
                    'pings'
                ) if $counter && ( $counter % 100 == 0 );
                $counter++;
                my $new_ping = $ping->clone();
                delete $new_ping->{column_values}->{id};
                delete $new_ping->{changed_cols}->{id};
                $new_ping->tb_id( $tb_map{ $ping->tb_id } );
                $new_ping->blog_id($new_blog_id);
                $new_ping->save or die $new_ping->errstr;
            }
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed.", $counter ),
                'pings'
            );
        }
    }

    if ( ( !exists $classes->{'MT::Template'} )
        || $classes->{'MT::Template'} )
    {
        my $state = MT->translate("Cloning templates for blog...");
        $callback->( $state, "tmpls" );
        require MT::Template;
        $iter = MT::Template->load_iter(
            { blog_id => $old_blog_id, type => { not => 'widgetset' } } );
        my $tmpl_processor = sub {
            my ( $new_blog_id, $counter, $tmpl, $new_tmpl, $tmpl_map ) = @_;
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed...", $$counter ),
                'tmpls'
            ) if $counter && ( $$counter % 100 == 0 );
            my $tmpl_id = $tmpl->id;
            $$counter++;
            delete $new_tmpl->{column_values}->{id};
            delete $new_tmpl->{changed_cols}->{id};

            # linked_file won't be cloned for now because
            # new blog does not have site_path - breaks relative path
            delete $new_tmpl->{column_values}->{linked_file};
            delete $new_tmpl->{column_values}->{linked_file_mtime};
            delete $new_tmpl->{column_values}->{linked_file_size};
            $new_tmpl->blog_id($new_blog_id);
            $new_tmpl->save or die $new_tmpl->errstr;
            $tmpl_map->{$tmpl_id} = $new_tmpl->id;
        };
        $counter = 0;
        while ( my $tmpl = $iter->() ) {
            my $new_tmpl = $tmpl->clone();
            $tmpl_processor->(
                $new_blog_id, \$counter, $tmpl, $new_tmpl, \%tmpl_map
            );
        }
        $iter = MT::Template->load_iter(
            { blog_id => $old_blog_id, type => 'widgetset' } );
        while ( my $tmpl = $iter->() ) {
            my @old_widgets = split /,/, $tmpl->modulesets;
            my $new_tmpl = $tmpl->clone();
            $tmpl_processor->(
                $new_blog_id, \$counter, $tmpl, $new_tmpl, \%tmpl_map
            );
            my @new_widgets;
            foreach (@old_widgets) {
                if ( exists $tmpl_map{$_} ) {
                    push @new_widgets, $tmpl_map{$_};
                }
                else {
                    my $global_widget = MT::Template->load($_);
                    push @new_widgets, $_
                        if $global_widget
                            && $global_widget->blog_id == 0
                            && $global_widget->type eq 'widget';
                }
            }
            $new_tmpl->modulesets( join( ',', @new_widgets ) );
            $new_tmpl->save;
        }
        $callback->(
            $state . " "
                . MT->translate( "[_1] records processed.", $counter ),
            'tmpls'
        );

        $state = MT->translate("Cloning template maps for blog...");
        $callback->( $state, "tmplmaps" );
        require MT::TemplateMap;
        $iter = MT::TemplateMap->load_iter( { blog_id => $old_blog_id } );
        $counter = 0;
        while ( my $map = $iter->() ) {
            $callback->(
                $state . " "
                    . MT->translate( "[_1] records processed...", $counter ),
                'tmplmaps'
            ) if $counter && ( $counter % 100 == 0 );
            $counter++;
            my $new_map = $map->clone();
            delete $new_map->{column_values}->{id};
            delete $new_map->{changed_cols}->{id};
            $new_map->template_id( $tmpl_map{ $map->template_id } );
            $new_map->blog_id($new_blog_id);
            $new_map->save or die $new_map->errstr;
        }
        $callback->(
            $state . " "
                . MT->translate( "[_1] records processed.", $counter ),
            'tmplmaps'
        );
    }

    MT->run_callbacks(
        ref($blog) . '::post_clone',
        OldBlogId     => $blog->id,
        old_blog_id   => $blog->id,
        NewBlogId     => $new_blog->id,
        new_blog_id   => $new_blog->id,
        OldObject     => $blog,
        old_object    => $blog,
        NewObject     => $new_blog,
        new_object    => $new_blog,
        EntryMap      => \%entry_map,
        entry_map     => \%entry_map,
        CategoryMap   => \%cat_map,
        category_map  => \%cat_map,
        TrackbackMap  => \%tb_map,
        trackback_map => \%tb_map,
        TemplateMap   => \%tmpl_map,
        template_map  => \%tmpl_map,
        Callback      => $callback,
        callback      => $callback,
    );
    $new_blog;
}

sub smart_replace {
    my $blog = shift;
    if (@_) {
        $blog->nwc_smart_replace(@_);
        return;
    }
    my $val = $blog->nwc_smart_replace;
    return defined($val) ? $val : MT->config->NwcSmartReplace;
}

sub smart_replace_fields {
    my $blog = shift;
    if (@_) {
        $blog->nwc_replace_field(@_);
        return;
    }
    my $val = $blog->nwc_replace_field;
    return defined($val) ? $val : MT->config->NwcReplaceField;
}

sub apply_theme {
    my $blog = shift;
    my ($theme_id) = @_;
    require MT::Theme;
    $theme_id ||= $blog->theme_id;
    $theme_id ||=
        $blog->is_blog
        ? MT->config->DefaultBlogTheme
        : MT->config->DefaultWebsiteTheme;
    my $theme = MT::Theme->load($theme_id);
    if ( !defined $theme ) {
        return $blog->error(
            MT->translate(
                "Failed to load theme [_1]: [_2]", $theme_id,
                MT::Theme->errstr
            )
        );
    }
    $theme->apply($blog)
        or return $blog->error(
        MT->translate(
            "Failed to apply theme [_1]: [_2]", $theme_id,
            MT::Theme->errstr
        )
        );
    return 1;
}

sub use_revision {
    my $blog = shift;
    return unless ref($blog);
    return $blog->SUPER::use_revision(@_)
        if 0 < scalar(@_);
    return 0 unless MT->config->TrackRevisions;
    return $blog->SUPER::use_revision;
}

sub raw_template_set {
    my $blog = shift;
    $blog->theme_id || $blog->SUPER::template_set || '';
}

sub template_set {
    my $blog = shift;
    if (@_) {
        return $blog->SUPER::template_set(@_);
    }

    my $theme = $blog->theme;
    unless ($theme) {

        # Try to load template set as theme.
        require MT::Theme;
        $theme = MT::Theme->load( $blog->SUPER::template_set );
    }

    if ($theme) {
        my @elements = $theme->elements;
        my ($elem) = grep { $_->{importer} eq 'template_set' } @elements;
        if ($elem) {
            my $set = $elem->{data};
            $set->{envelope} = $theme->path
                if ref $set;
            return $set;
        }
    }

    $blog->SUPER::template_set;
}

sub to_hash {
    my $obj  = shift;
    my $hash = $obj->SUPER::to_hash(@_);
    $hash->{'blog.site_url'}    = $obj->site_url;
    $hash->{'blog.archive_url'} = $obj->archive_url
        if exists( $hash->{'blog.archive_url'} );
    return $hash;
}

1;
__END__

=head1 NAME

MT::Blog - Movable Type blog record

=head1 SYNOPSIS

    use MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    $blog->name('Some new name');
    $blog->save
        or die $blog->errstr;

=head1 DESCRIPTION

An I<MT::Blog> object represents a blog in the Movable Type system. It
contains all of the settings, preferences, and configuration for a particular
blog. It does not contain any per-author permissions settings--for those,
look at the I<MT::Permission> object.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Blog> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Blog> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the blog.

=item * parent_id

The ID of the Website (MT::Website) this blog belongs to

=item * theme_id

If a theme was applied for this blog, this field will hold the theme ID

=item * name

The name of the blog.

=item * description

The blog description.

=item * archive_type

A comma-separated list of archive types used in this particular blog, where
an archive type is one of the following: C<Individual>, C<Daily>, C<Weekly>,
C<Monthly>, or C<Category>. For example, a blog's I<archive_type> would be
C<Individual,Monthly> if the blog were using C<Individual> and C<Monthly>
archives.

=item * archive_type_preferred

The "preferred" archive type, which is used when constructing a link to the
archive page for a particular archive--if multiple archive types are selected,
for example, the link can only point to one of those archives. The preferred
archive type (which should be one of the archive types set in I<archive_type>,
above) specifies to which archive this link should point (among other things).

=item * site_path

The path to the directory containing the blog's output index templates

=item * site_url

The URL corresponding to the I<site_path>

=item * days_on_index

The number of days to be displayed on the index

=item * entries_on_index

The number of entries to be displayed on the index

=item * file_extension

The file extension to be used for archive pages.

=item * email_new_comments

A three-states boolean flag specifying whether authors should be notified
of all new comments posted on entries they have written, just moderated
comments or don't send at all

=item * allow_comment_html

A boolean flag specifying whether HTML should be allowed in comments. If it
is not allowed, it is automatically stripped before building the page (note
that the content stored in the database is B<not> stripped).

=item * autolink_urls

A boolean flag specifying whether URLs in comments should be turned into
links. Note that this setting is only taken into account if
I<allow_comment_html> is turned off.

=item * sort_order_posts

The default sort order for entries. Valid values are either C<ascend> or
C<descend>.

=item * sort_order_comments

The default sort order for comments. Valid values are either C<ascend> or
C<descend>.

=item * allow_comments_default

The default value for the I<allow_comments> field in the I<MT::Entry> object.

=item * server_offset

A slight misnomer, this is actually the timezone that the B<user> has
selected; the value is the offset from GMT.

=item * convert_paras

A comma-separated list of text filters to apply to each entry when it
is built.

=item * convert_paras_comments

A comma-separated list of text filters to apply to each comment when it
is built.

=item * allow_pings_default

The default value for the I<allow_pings> field in the I<MT::Entry> object.

=item * status_default

The default value for the I<status> field in the I<MT::Entry> object.

=item * allow_anon_comments

A boolean flag specifying whether anonymous comments (those posted without
a name or an email address) are allowed.

=item * allow_unreg_comments

A boolean flag specifying whether unregistered comments (those posted
without a validated email/password pair) are allowed.

=item * allow_reg_comments

A boolean flag specifying whether registered users's comments (those posted
with a validated email/password pair) are allowed.

=item * moderate_unreg_comments

Specifying which comments will not be displayed until approved by the
entry author. can be MT::Blog::MODERATE_NONE, (all comments are to be
published immediately) MODERATE_UNTRSTD, (unused) MODERATE_UNAUTHD,
(moderate only comments from unauthenticated users) or MODERATE_ALL

=item * manual_approve_commenters

Specify that the author need to approve each commenter before their
comment will be displayed. this override the MODERATE_NONE setting in
moderate_unreg_comments

=item * allow_commenter_regist

A boolean flag specifying if we should allow commenters to register
to the website, or should they ask the administrator to add them

=item * require_comment_emails

Force the commenters to enter a valid email address

=item * words_in_excerpt

The number of words in an auto-generated excerpt.

=item * allow_pings

Allow blog-level pings

=item * email_new_pings

A flag wether MT should email the blog owner for all new pings, just
moderated pings, or not at all

=item * ping_weblogs

boolean indicating wether to ping weblogs.com

=item * ping_blogs

unused

=item * ping_technorati

unused

=item * ping_google

boolean indicating wether to ping blogsearch.google.com

=item * ping_others

A list of servers to ping after an entry is saved, using XML-RPC.
the list is \r delimited

=item * junk_folder_expiry

How many days junk is kept before automatically deleted. zero to
immediately delete spam

=item * mt_update_key

The Movable Type Recently Updated Key to be sent to I<movabletype.org> after
an entry is saved

=item * google_api_key

unused

=item * autodiscover_links

Search entries for links and upgrade them to pings

=item * internal_autodiscovery

Search entries for links to the same domain of this blog, and upgrade
them to pings

=item * sanitize_spec

sanitize spec to pass MT::Sanitize for sanitizing HTML comments. can
be '0' to disable sanitizing, '1' to enable, or a full spec string

=item * cc_license

IF the blog is CC license, this property holds the variation. for example
'nc-sa' for NonCommercial-ShareAlike

=item * is_dynamic

Specify if this blog is published dynamically or statically

=item * remote_auth_token

A TypePad token

=item * children_modified_on

Field used to communicate to the dynamic publishing (PHP) when this blog
changed - new entry was added, or an entry was edited

=item * custom_dynamic_templates

When using dynamic publishing, this field controls when a template will be
converted to a PHP page. possible values: 'all' - all templates are to
built dynamically. 'none' - all the template will be build on-demand.
'async_all' - all the template will be build a-synchronically.
'async_partial' - the main index, feed and the preferred archive type
are to by build on-demand, and the rest will be built a-synchronically.
'archives' - only the index is to be build on-demand, all the rest will
be built dynamically

=item * junk_score_threshold

When a new comment is entered, it is checked if it is spam using spam
filters. each filter is voting by returning a number between -10 to 10,
(or ABSTAIN) and then numbers are merged to a single spam score. if this
score is bigger then junk_score_threshold, this comment is considered
spam

=item * basename_limit

Maximum number of words that will appear in the base name of an entry.
the base name if based on the entry title, and used to build the entry URL

=item * use_comment_confirmation

If true, after entring a comment the commenter will be redirected to
a 'comment accepted' page

=item * language

The language for date and time display for this particular blog.

=item * welcome_msg

The welcome message to be displayed on the main Editing Menu for this blog.
Should contain all desired HTML formatting.

=item * use_revision

If the global TrackRevisions configuration is enabled, enables the
revision tracking for this blog

=item * archive_path

The path to the directory where the blog's archives are stored.

=item * archive_url

The URL corresponding to the I<archive_path>.

=back

=head1 META DATA ACCESS METHODS

=over 4

=item * image_default_wrap_text

Default setting for embedded images in entries

=item * image_default_align

Default setting for embedded images in entries

=item * image_default_thumb

Default setting for embedded images in entries

=item * image_default_width

Default setting for embedded images in entries

=item * image_default_wunits

Default setting for embedded images in entries

=item * image_default_constrain

Default setting for embedded images in entries

=item * image_default_popup

Default setting for embedded images in entries

=item * commenter_authenticators

A comma-delimited list of authentication options for commenters.
for example: "MovableType,TypeKey,LiveJournal"

=item * require_typekey_emails

If true, force typepad commenters to enter their email

=item * nofollow_urls

If true, add a 'nofollow' tag to all the URLs in the comments and
TrackBacks

=item * follow_auth_links

If true, do not add a 'nofollow' tag to URLs in comments written by
trusted commenter, even if the nofollow_urls property is true

=item * update_pings

Comma-delimited list of server to ping for blog-level updates

=item * captcha_provider

The name of the captcha provider to use for commenter. By default the
captcha option is off, and there is a built-in captcha generator named
'mt_default'. plugins can add more generators

=item * publish_queue

The flag is set to 1 if custom_dynamic_templates is async_all or
async_partially, acting as a flag to use TheSchwartz publishing queue
instead of publishing immediately (in the case of static publishing)

=item * nwc_smart_replace

Replace UTF-8 characters frequently used by word processors with their
more common web equivalents. possible values: 2 - don't replace. 1 -
replace to HTML entities. 0 - replace to ASCII characters

=item * nwc_replace_field

A comma-delimited list specifying where to do the smart replace. possible
values are: qw{title text text_more keywords excerpt tags}

=item * template_set

Returns the template_set that was applied for this blog

=item * page_layout

IF you have a style applied to this blog, it is possible to tweak the
layout of the page, specifying how many columns to use, and do we want
wide or thin columns. all values start with 'layout-', concatenated with
one of: qw{wt tw wm mw wtt twt}, there 't' stand for thin, 'w' for wide
and 'm' for medium

=item * include_system

If this meta field exists, turns the mt:Include tags to Server Side
Includes. It can specify one of these include systems: shtml,
php, jsp or asp

=item * include_cache

=item * max_revisions_entry

If revisions are enabled for this blog, (see use_revision) specify how
many revision to keep for each entry

=item * max_revisions_template

If revisions are enabled for this blog, (see use_revision) specify how
many revision to keep for each template

=item * theme_export_settings

A hash that remembers the last configuration a theme was exported from
this blog. contains at least a "core" key, that contains a hash
with all the configuration, such as name, version, author etc. If there
are plugins with theme exporters installed, they will have an entry in
this hash as well

=item * category_order

Contain a comma-delimiter list of category ids, ordered

=item * folder_order

Contain a comma-delimiter list of folder ids, ordered

=back

=head1 METHODS

=head2 $blog->set_defaults

Set default values to all of the data fields

=head2 $blog->is_blog

returns true if this object is a blog and not some subclass (such as
MT::Website)

=head2 MT::Blog->create_default_blog( [ $blog_name, $blog_template, $website_id ] )

Create a default blog to a newly created website

=head2 $blog->create_default_templates( @templates )

Apply a set of default templates to the blog, from a given template set

=head2 $blog->current_timestamp

Create a time stamp for the blog's time zone, in the "YYYYMMDDHHMMSS"
format

=head2 $blog->website

Returns the blog's parent MT::Website object, or undef if it does not
have one

=head2 $blog->theme

returns the blog's theme (a MT::Theme object)

=head2 $blog->raw_site_url

=head2 $blog->raw_archive_url

=head2 $blog->is_site_path_absolute

returns true is site_path is absolute, (i.e. start with X:\ on DOS,
with '/' on Unix, etc)

=head2 $blog->is_archive_path_absolute

returns true is archive_path is absolute, (i.e. start with X:\ on DOS,
with '/' on Unix, etc)

=head2 $blog->comment_text_filters

Returns an arrayref containing the names of the text filters to be
applied to comments

=head2 $blog->cc_license_url

Returns a URL to a website explaining about the Creative Commons license
that was chosen for this blog

=head2 $blog->email_all_comments

returns true if email will be sent to entry authors for every comment

=head2 $blog->email_attn_reqd_comments

returns true if email will be sent to entry authors only for comments
that require moderation

=head2 $blog->email_all_pings

returns true if email will be sent to entry authors for every ping

=head2 $blog->email_attn_reqd_pings

returns true if email will be sent to entry authors only for pings
that require moderation

=head2 $blog->publish_trusted_commenters

true if it is OK to publish comments from thrusted commenters

=head2 $blog->publish_authd_untrusted_commenters

true if it is OK to publish comments from authenticated but non-thrusted
commenters

=head2 $blog->publish_unauthd_commenters

true if it is OK to publish comments even from un-authenticated
commenters - everyone

=head2 $blog->include_path_parts( %$param )

Accept $param hashref that should contain either a "name" key, for a file
name, or an "id" key for template_id. from these keys a filename will
be created

the path to this file can be passed by the "path" key. if not passed or
if not absolute path, will return a path that start with the IncludeDir
configuration directive

returns ($filename, @path). for using these:

    $file = File::Spec->catfile(
        File::Spec->catdir($blog->site_path, @path),
        $filename
        );

=head2 $blog->include_path

Similar to include_path_parts, but will calculate that final path for you.
In scalar context, returns the final path. in list context returns
(full path, directory, filename)

=head2 $blog->include_url

Similar to include_path_parts, but will return the URL to this file

=head2 $blog->include_statement

Similar to include_path, but wrap the path with an include statement,
according to the include_system defined

=head2 $blog->file_mgr

Returns the I<MT::FileMgr> object specific to this particular blog.

=head2 $blog->has_archive_type( $type )

returns true if this blog support a $type archive type, and have
templates for it

=head2 $blog->accepts_registered_comments

returns true if the blog is configured to allow comments from registered
commenters, and have authenticators to let them register

=head2 $blog->accepts_comments

returns true if commenting is allowed for registered and unregistered
commenters

=head2 $blog->count_static_templates( $archive_type )

returns how many static templates (non-dynamic) the blog have

=head2 $blog->touch( @types )

update the last-modified record (an MT::Touch object) for the passed
@types respectably to this blog to 'now'. @types should be model names,
like 'author' or 'entry'

=head2 clone( [ \%parameters ] )

MT::Blog provides a clone method that supports cloning of all known child
records related to the MT::Blog object. To invoke this behavior, you
simply specify a parameter hash with a 'Children' key set.

    # Clones blog and all data related to this blog within the database.
    my $new_blog = $original_blog->clone({ Children => 1 });

You may further specify what kind of records are cloned in the process
of cloning child objects. Use the 'Classes' parameter to specifically
exclude particular classes:

    # Clones everything except comments and trackback pings
    my $new_blog = $original_blog->clone({
        Children => 1,
        Classes => { 'MT::Comments' => 0, 'MT::TBPing' => 0 }
    });

Note: Certain exclusions will prevent the clone process from including
other classes. For instance, if you exclude MT::Trackback, all MT::TBPing
objects are automatically excluded.

=head2 $blog->smart_replace( [ $new_value ] )

get/set the nwc_smart_replace property. when getting, if not set for
this blog, returns whatever is configured in the global NwcSmartReplace

=head2 $blog->smart_replace_fields( [ $new_value ] )

get/set the nwc_replace_field property. when getting, if not set for
this blog, returns whatever is configured in the global NwcReplaceField

=head2 $blog->apply_theme( [ $theme_id ] )

apply a theme to the blog. if not specify, try to re-apply the current
theme, and if not exists, apply the default theme

=head1 NOTES

=over 4

=item *

When you remove a blog using I<MT::Blog::remove>, in addition to removing the
blog record, all of the entries, notifications, permissions, comments,
templates, and categories in that blog will also be removed.

=item *

Because the system needs to load I<MT::Blog> objects from disk relatively
often during the duration of one request, I<MT::Blog> objects are cached by
the I<MT::Blog::load> object so that each blog only need be loaded once. The
I<MT::Blog> objects are cached in the I<MT::Request> singleton object; note
that this caching B<only occurs> if the blogs are loaded by numeric ID.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
