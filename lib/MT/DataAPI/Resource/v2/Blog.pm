# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Blog;

use strict;
use warnings;

use boolean ();
use File::Spec;

use MT::Entry;
use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [
        # v1 fields
        qw(
            name
            description
            url
            archiveUrl
            ),

        # v2 fields

        # Create Blog screen
        qw(
            themeId
            serverOffset
            language
            sitePath
            archivePath
            ),

        # General Settings screen
        qw(
            fileExtension
            archiveTypePreferred
            publishEmptyArchive
            includeSystem
            includeCache
            useRevision
            maxRevisionsEntry
            maxRevisionsTemplate
            ),

        # Compose Settings screen
        qw(
            listOnIndex
            daysOrPosts
            sortOrderPosts
            wordsInExcerpt
            basenameLimit
            statusDefault
            convertParas
            contentCss
            smartReplace
            smartReplaceFields
            ),

        # Feedback Settings screen
        qw(
            junkFolderExpiry
            junkScoreThreshold
            nofollowUrls
            followAuthLinks
            sanitizeSpec
            autolinkUrls
            autodiscoverLinks
            internalAutodiscovery
            ),

        # Registration Settings screen
        qw(
            newCreatedUserRole
            ),

        # template tags
        qw(
            dateLanguage
            ),

        # Others
        qw(
            customDynamicTemplates
            ),
    ];
}

sub fields {
    [   {   name        => 'updatable',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ($obj) = @_;
                return if !$obj->id;

                my $app = MT->instance;
                my $user = $app->user or return;

                return $user->permissions( $obj->id )
                    ->can_do('edit_blog_config');
            },
        },

        # v1 fields
        {   name      => 'name',
            to_object => sub {
                my ($hash) = @_;
                my $name = $hash->{name};
                $name =~ s/(^\s+|\s+$)//g;
                return $name;
            },
        },
        {   name      => 'url',
            alias     => 'site_url',
            to_object => sub {
                my ( $hash, $obj ) = @_;

                return if !_can_save_blog_pathinfo($obj);

                my $subdomain = $hash->{siteSubdomain};
                if ( defined( $hash->{siteSubdomain} )
                    && $hash->{siteSubdomain} ne '' )
                {
                    $subdomain = $hash->{siteSubdomain};
                    $subdomain .= '.' if $subdomain !~ /\.$/;
                    $subdomain =~ s/\.{2,}/\./g;
                }
                else {
                    $subdomain = '';
                }
                my $path = $hash->{url};
                return "$subdomain/::/$path";
            },
        },
        {   name      => 'archiveUrl',
            alias     => 'archive_url',
            to_object => sub {
                my ( $hash, $obj ) = @_;

                return if !_can_save_blog_pathinfo($obj);

                if ( defined( $hash->{archiveSubdomain} )
                    && $hash->{archiveSubdomain} ne '' )
                {
                    my $subdomain = $hash->{archiveSubdomain};
                    $subdomain .= '.' if $subdomain !~ /\.$/;
                    $subdomain =~ s/\.{2,}/\./g;

                    my $path = $hash->{archiveurl};
                    return "$subdomain/::/$path";
                }
                else {
                    return $hash->{archiveUrl};
                }
            },
        },

        # Create Blog screen
        {   name      => 'themeId',
            alias     => 'theme_id',
            condition => \&_can_view,
        },
        {   name      => 'sitePath',
            alias     => 'site_path',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return $hash->{sitePath}
                    if _can_save_blog_pathinfo($obj);
                return;
            },
            condition => \&_can_view,
        },
        {   name      => 'archivePath',
            alias     => 'archive_path',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return $hash->{archivePath}
                    if _can_save_blog_pathinfo($obj);
                return;
            },
            condition => \&_can_view,
        },
        qw(
            serverOffset
            language
            ),

        # General Settings screen
        {   name        => 'dynamicCache',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ( $obj, $hash ) = @_;

                my $mtview_path
                    = File::Spec->catfile( $obj->site_path(), "mtview.php" );

                if ( -f $mtview_path ) {
                    open my $fh, "<", $mtview_path
                        or die "Couldn't open $mtview_path: $!";
                    while ( my $line = <$fh> ) {
                        $hash->{dynamicCache} = 1
                            if $line =~ m/^\s*\$mt->caching\(true\);/i;
                        $hash->{dynamicConditional} = 1
                            if $line =~ /^\s*\$mt->conditional\(true\);/i;
                    }
                    close $fh;
                }

                return;
            },
            condition => \&_can_view,
        },
        {   name        => 'dynamicConditional',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {

                # Do nothing. Set when dynamicCache field is set.
            },
            condition => \&_can_view,
        },
        {   name      => 'fileExtension',
            alias     => 'file_extension',
            to_object => sub {
                my ($hash) = @_;
                my $file_extension = $hash->{fileExtension};
                $file_extension =~ s/^\.*//
                    if defined($file_extension) && $file_extension ne '';
                return $file_extension;
            },
            condition => \&_can_view,
        },
        {   name      => 'archiveTypePreferred',
            alias     => 'archive_type_preferred',
            condition => \&_can_view,
        },
        {   name        => 'publishEmptyArchive',
            alias       => 'publish_empty_archive',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub { $_[0]->publish_empty_archive }
            ,    # meta column.
            condition => \&_can_view,
        },
        {   name        => 'includeSystem',
            alias       => 'include_system',
            from_object => sub { $_[0]->include_system },    # meta column.
            condition   => \&_can_view,
        },
        {   name  => 'includeCache',
            alias => 'include_cache',
            type  => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub { $_[0]->include_cache },     # meta column.
            condition   => \&_can_view,
        },
        {   name      => 'useRevision',
            alias     => 'use_revision',
            type      => 'MT::DataAPI::Resource::DataType::Boolean',
            condition => \&_can_view,
        },
        {   name        => 'maxRevisionsEntry',
            alias       => 'max_revisions_entry',
            from_object => sub { $_[0]->max_revisions_entry },  # meta column.
            condition   => \&_can_view,
        },
        {   name        => 'maxRevisionsTemplate',
            alias       => 'max_revisions_template',
            from_object => sub { $_[0]->max_revisions_template }
            ,                                                   # meta column.
            condition => \&_can_view,
        },

        # Compose Settings screen
        {   name        => 'listOnIndex',
            from_object => sub {
                my ($obj) = @_;
                return $obj->entries_on_index || $obj->days_on_index || 0;
            },
            to_object => sub {
                my ( $hash, $obj ) = @_;

                if ( $hash->{daysOrPosts} && $hash->{daysOrPosts} eq 'posts' )
                {
                    $obj->entries_on_index( $hash->{listOnIndex} || 0 );
                    $obj->days_on_index(0);
                }
                else {
                    $obj->entries_on_index(0);
                    $obj->days_on_index( $hash->{listOnIndex} || 0 );
                }

                return;
            },
            condition => \&_can_view_cfg_screens,
        },
        {   name        => 'daysOrPosts',
            from_object => sub {
                my ($obj) = @_;
                my $type = $obj->entries_on_index ? 'posts' : 'days';
                return $type;
            },
            to_object => sub {

                # Do nothing here. Set when setting listOnIndex field.
            },
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'sortOrderPosts',
            alias     => 'sort_order_posts',
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'wordsInExcerpt',
            alias     => 'words_in_excerpt',
            condition => \&_can_view_cfg_screens,
        },

        # dateLanguaage is defined in template tags.
        {   name      => 'basenameLimit',
            alias     => 'basename_limit',
            condition => \&_can_view_cfg_screens,
        },
        {   name        => 'statusDefault',
            alias       => 'status_default',
            from_object => sub {
                my ($obj) = @_;
                MT::Entry::status_text( $obj->status_default );
            },
            to_object => sub {
                my ($hash) = @_;
                MT::Entry::status_int( $hash->{statusDefault} );
            },
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'convertParas',
            alias     => 'convert_paras',
            condition => \&_can_view_cfg_screens,
        },
        {   name        => 'entryCustomPrefs',
            from_object => sub {
                my $app = MT->instance;
                my $pref_param
                    = $app->load_entry_prefs( { type => 'entry' } );
                my @fields;
                for my $f ( @{ $pref_param->{disp_prefs_default_fields} } ) {
                    push @fields, $f->{name}
                        if $pref_param->{ 'entry_disp_prefs_show_'
                            . $f->{name} };
                }
                return \@fields;
            },
            condition => \&_can_view_cfg_screens,
            schema => {
                type  => 'array',
                items => { type => 'string' },
            },
        },
        {   name        => 'pageCustomPrefs',
            from_object => sub {
                my $app = MT->instance;
                my $pref_param = $app->load_entry_prefs( { type => 'page' } );
                my @fields;
                for my $f ( @{ $pref_param->{disp_prefs_default_fields} } ) {
                    push @fields, $f->{name}
                        if $pref_param->{ 'page_disp_prefs_show_'
                            . $f->{name} };
                }
                return \@fields;
            },
            condition => \&_can_view_cfg_screens,
            schema => {
                type  => 'array',
                items => { type => 'string' },
            },
        },
        {   name      => 'contentCss',
            alias     => 'content_css',
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'smartReplace',
            alias     => 'smart_replace',
            condition => \&_can_view_cfg_screens,
        },
        {   name        => 'smartReplaceFields',
            alias       => 'smart_replace_fields',
            from_object => sub {
                my ($obj) = @_;
                return [ split ',', $obj->smart_replace_fields ];
            },
            to_object => sub {
                my ($hash) = @_;

                my @new_fields;
                for my $f ( @{ $hash->{smartReplaceFields} } ) {
                    push( @new_fields, $f )
                        if grep { $f eq $_ }
                        qw/title text text_more keywords excerpt tags/;
                }

                my $new_fields = @new_fields ? join( ',', @new_fields ) : 0;
                return $new_fields;
            },
            condition => \&_can_view_cfg_screens,
            schema => {
                type  => 'array',
                items => { type => 'string' },
            },
        },

        # Feedback Settings screen
        {   name      => 'junkFolderExpiry',
            alias     => 'junk_folder_expiry',
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'junkScoreThreshold',
            alias     => 'junk_score_threshold',
            condition => \&_can_view_cfg_screens,
        },
        {   name  => 'nofollowUrls',
            alias => 'nofollow_urls',
            type  => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub { $_[0]->nofollow_urls },    # meta column.
            condition   => \&_can_view_cfg_screens,
        },
        {   name  => 'followAuthLinks',
            alias => 'follow_auth_links',
            type  => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub { $_[0]->follow_auth_links },    # meta column.
            condition   => \&_can_view_cfg_screens,
        },
        {   name      => 'sanitizeSpec',
            alias     => 'sanitize_spec',
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'autolinkUrls',
            alias     => 'autolink_urls',
            type      => 'MT::DataAPI::Resource::DataType::Boolean',
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'autodiscoverLinks',
            alias     => 'autodiscover_links',
            type      => 'MT::DataAPI::Resource::DataType::Boolean',
            condition => \&_can_view_cfg_screens,
        },
        {   name      => 'internalAutodiscovery',
            alias     => 'internal_autodiscovery',
            type      => 'MT::DataAPI::Resource::DataType::Boolean',
            condition => \&_can_view_cfg_screens,
        },

        # Registration Settings screen
        {   name        => 'newCreatedUserRoles',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;
                my @def = split ',', $app->config('DefaultAssignments');
                my @roles;
                while ( my $r_id = shift @def ) {
                    my $b_id = shift @def;
                    next unless $b_id eq $obj->id;
                    my $role = $app->model('role')->load($r_id)
                        or next;
                    push @roles, $role;
                }
                return MT::DataAPI::Resource->from_object( \@roles,
                    [qw/ id name /] );
            },
            condition => \&_can_view_cfg_screens,
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id   => { type => 'integer' },
                        name => { type => 'string' },
                    },
                },
            },
        },

        # template tags
        {   name        => 'ccLicenseImage',
            from_object => sub {
                my ($obj) = @_;
                my $cc = $obj->cc_license or return '';
                my ( $code, $license, $image_url )
                    = $cc =~ /(\S+) (\S+) (\S+)/;
                return $image_url if $image_url;
                "http://creativecommons.org/images/public/"
                    . ( $cc eq 'pd' ? 'norights' : 'somerights' );
            },
        },
        qw(
            ccLicenseUrl
            dateLanguage
            ),
        {   name        => 'host',
            from_object => sub {
                my ($obj) = @_;
                my $host = $obj->site_url;
                return '' unless defined $host;
                if ( $host =~ m!^https?://([^/:]+)(:\d+)?/?! ) {
                    return $1 . ( $2 || '' );
                }
                else {
                    return '';
                }
            },
        },
        {   name        => 'relativeUrl',
            from_object => sub {
                my ($obj) = @_;
                my $host = $obj->site_url;
                return '' unless defined $host;
                if ( $host =~ m{^https?://[^/]+(/.*)$} ) {
                    return $1;
                }
                else {
                    return '';
                }
            },
        },
        {   name        => 'timezone',
            from_object => sub {
                my ($obj)               = @_;
                my $so                  = $obj->server_offset;
                my $partial_hour_offset = 60 * abs( $so - int($so) );
                return sprintf( "%s%02d:%02d",
                    $so < 0 ? '-' : '+',
                    abs($so),, $partial_hour_offset );
            },
        },

        # Publishing Profile screen.
        {   name                => 'customDynamicTemplates',
            alias               => 'custom_dynamic_templates',
            from_object_default => 'none',
            condition           => \&_can_view_cfg_screens,
        },

        {   name        => 'parent',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;
                return undef unless $obj->parent_id;
                my $parent = $app->model('blog')->load( $obj->parent_id );
                return $parent
                    ? MT::DataAPI::Resource->from_object( $parent,
                    [qw( id name )] )
                    : undef;
            },
            schema => {
                type       => 'object',
                properties => {
                    id   => { type => 'string' },
                    name => { type => 'string' },
                },
            },
        },

        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

sub _can_view {
    my $app  = MT->instance;
    my $user = $app->user;

    require MT::CMS::Blog;
    if (!(  $user && ( $user->is_superuser
                || $app->can_do('access_to_blog_config_screen')
                || MT::CMS::Blog::can_view( undef, $app, 1 ) )
        )
        )
    {
        return;
    }

    return 1;
}

sub _can_view_cfg_screens {
    my $app = MT->instance;
    return $app->can_do('edit_config');
}

sub _can_save_blog_pathinfo {
    my ($obj) = @_;
    my $app  = MT->instance or return;
    my $user = $app->user   or return;

    return 1 if $user->is_superuser;

    if ( $obj->id ) {
        my $perms = $app->permissions or return;
        return 1
            if $app->can_do('save_all_settings_for_blog')
            || $perms->can_do('save_blog_pathinfo');
    }

    return;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Blog - Movable Type class for resources definitions of the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
