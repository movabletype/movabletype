# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Blog;

use strict;
use warnings;

sub save_filter {
    my ( $eh, $app, $obj, $original ) = @_;

    # Check empty fields.
    my @not_empty_fields = (
        { field => 'name',      parameter => 'name' },
        { field => 'site_path', parameter => 'sitePath' },
        { field => 'theme_id',  parameter => 'themeId' },
    );
    for (@not_empty_fields) {
        my $field = $_->{field};
        if ( !( defined $obj->column($field) ) || $obj->column($field) eq '' )
        {
            return $app->errtrans( 'A parameter "[_1]" is required.',
                $_->{parameter} );
        }
    }

    # Check positive interger fields.
    my @positive_inteter_columns
        = qw( max_revisions_entry max_revisions_template );
    for my $col (@positive_interger_columns) {
        if ( !( $obj->$col && $obj->$col =~ m/^\d+$/ ) ) {
            return $eh->error(
                $app->translate(
                    "The number of revisions to store must be a positive integer."
                )
            );
        }
    }

    # Check whether blog has a preferred archive type or not.
    if ( _blog_has_archive_type($obj) && !$obj->archive_type_preferred ) {
        return $eh->error(
            $app->translate("Please choose a preferred archive type.") );
    }

    # Check whether theme_id is valid or not.
    require MT::Theme;
    if ( !MT::Theme->load( $obj->theme_id ) ) {
        return $app->errtrans( 'Invalid theme_id: [_1]', $obj->theme_id );
    }

    # Check whether site_path is within BaseSitePath or not,
    # if site_path is absolute.
    require File::Spec;
    my $site_path = $obj->column('site_path');
    if ( $app->config->BaseSitePath
        && File::Spec->file_name_is_absolute($site_path) )
    {
        my $l_path = $app->config->BaseSitePath;
        require MT::CMS::Common;
        if ( !MT::CMS::Common::is_with_base_sitepath( $app, $site_path ) ) {
            return $app->errtrans(
                "The blog root directory must be within [_1]", $l_path );
        }
    }

    return 1;
}

sub _blog_has_archive_type {
    my ($blog) = @_;
    my $app = MT->instance;

    my $has_archive_type;
    for my $at ( split /\s*,\s*/, $blog->archive_type ) {
        my $archiver = $app->publisher->archiver($at);
        next unless $archiver;
        next if 'entry' ne $archiver->entry_class;
        $has_archive_type = 1;
        last;
    }

    return $has_archive_type;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $terms = $load_options->{terms};
    delete $terms->{blog_id};
    $terms->{parent_id} = $load_options->{blog_id}
        if $app->blog;
    $terms->{class} = 'blog' unless $terms->{class} eq '*';

    if ( my $user = $load_options->{user} ) {

        return   if $user->is_superuser;
        return 1 if $user->permissions(0)->can_do('edit_templates');

        my $iter = MT::Permission->load_iter(
            {   author_id   => $user->id,
                blog_id     => { not => 0 },
                permissions => { not => 'comment' },
            }
        );

        my $blog_ids = [];
        while ( my $perm = $iter->() ) {
            push @$blog_ids, $perm->blog_id if $perm->blog_id;
        }
        if ( $terms->{class} eq '*' ) {
            push @$blog_ids,
                map { $_->parent_id } $app->model('blog')->load(
                { class     => 'blog', id => $blog_ids },
                { fetchonly => ['parent_id'] }
                );
        }

        if ( $blog_ids && @$blog_ids ) {
            if ( $terms->{class} eq '*' ) {
                delete $terms->{class};
                $load_options->{args}{no_class} = 1;
            }
            $terms->{id} = $blog_ids;
        }
        else {
            $terms->{id} = 0;
        }

    }

    $load_options->{terms} = $terms;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Blog - Movable Type class for Data API's callbacks about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
