# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::FileInfo;
use strict;
use warnings;

use base qw(MT::Object);

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'             => 'integer not null auto_increment',
            'blog_id'        => 'integer not null',
            'entry_id'       => 'integer',
            'url'            => 'string(255)',
            'file_path'      => 'text',
            'templatemap_id' => 'integer',
            'template_id'    => 'integer',
            'archive_type'   => 'string(255)',
            'category_id'    => 'integer',
            'author_id'      => 'integer',
            'startdate'      => 'string(80)',
            'virtual'        => 'boolean',
            'cd_id'          => 'integer',
        },
        indexes => {
            blog_id        => 1,
            entry_id       => 1,
            template_id    => 1,
            templatemap_id => 1,
            archive_type   => 1,
            url            => 1,
            startdate      => 1,
            category_id    => 1,
            author_id      => 1,
            cd_id          => 1,
        },
        datasource  => 'fileinfo',
        primary_key => 'id',
        cacheable   => 0,
    }
);

=pod

=head1 NAME

MT::FileInfo

=head1 SYNOPSIS

A FileInfo gives you information about a certain file or
server-relative URL (it assumes a one-to-one mapping between files and
URLs).

More precisely A FileInfo maps a file path to a "Specifier" which
tells what kind of file it is and how to rebuild it; also included is
the URL where it is expected to be served.

A Specifier is a variant record with the following types and fields:

            Index of template_id
          | Entry of templatemap_id * entry_id
          | DateBased of templatemap_id * date_spec * archive_type
          | Category of templatemap_id * category_id

A FileInfo is tagged with an archive_type field (from the set
{Individual, Daily, Monthly, Weekly, Category, Index}), which
determines which of those variants is held in the record.

=head1 METHODS

=over 4

=item set_info_for_url($url, $file_path, $archive_type, $spec)

Creates a FileInfo record in the database to indicate that the URL
C<$url> serves the file at C<$file_path> and can be rebuilt from the
parameters in C<$spec>.

The C<$spec> argument is a hash ref with at least one of {TemplateMap,
Template} defined, and at least one of the following: {Entry,
StartDate, Category}.

If $archive_type is 'index' then Template should be given; otherwise
TemplateMap should be given.

=back

=cut

# think: We need a set({a => v, ...}, {b => u, ...}) routine which
#    guarantees that subsequently load({a => v, ...}) will return a
#    record that matches {b => u}

sub set_info_for_url {
    my $class = shift;
    my ( $url, $file_path, $archive_type, $args ) = @_;
    my $url_map = MT::FileInfo->new();
    $url_map->blog_id( $args->{Blog} );
    if ( $archive_type eq 'index' ) {
        $url_map->template_id( $args->{Template} );
    }
    else {
        $url_map->templatemap_id( $args->{TemplateMap} )
            if $args->{TemplateMap};
        $url_map->template_id( $args->{Template} )
            if $args->{Template};
        $args->{Entry} = $args->{Entry}->id
            if ref $args->{Entry};
        $url_map->entry_id( $args->{Entry} )
            if $args->{Entry};
        $url_map->startdate( $args->{StartDate} )
            if $args->{StartDate};
        $args->{Category} = $args->{Category}->id
            if ref $args->{Category};
        $url_map->category_id( $args->{Category} )
            if $args->{Category};
        $args->{Author} = $args->{Author}->id
            if ref $args->{Author};
        $url_map->author_id( $args->{Author} )
            if $args->{Author};
        $args->{ContentData} = $args->{ContentData}->id
            if ref $args->{ContentData};
        $url_map->cd_id( $args->{ContentData} )
            if $args->{ContentData};
    }
    $url_map->archive_type($archive_type);
    $url_map->url($url);
    $url_map->file_path($file_path);
    $url_map->save() || return $class->error( $url_map->errstr() );
    return $url_map;
}

sub parent_names {
    my $obj     = shift;
    my $parents = {
        blog        => 'MT::Blog',
        template    => 'MT::Template',
        templatemap => 'MT::TemplateMap',
        category    => 'MT::Category',
        entry       => 'MT::Entry',
        author      => 'MT::Author',
    };
    $parents;
}

sub cleanup {
    my $class = shift;
    require MT::Template;
    my $iter = $class->load_iter(
        undef,
        {   'join' => MT::Template->join_on(
                undef,
                {   'type' => 'backup',
                    'id'   => \'= fileinfo_template_id',
                }
            )
        }
    );
    while ( my $obj = $iter->() ) {
        $obj->remove;
    }
}

sub mark_to_remove {
    my ( $self, $build_type ) = @_;
    if ( !$build_type ) {
        if ( $self->templatemap_id ) {
            require MT::TemplateMap;
            my $map = MT::TemplateMap->load( $self->templatemap_id );
            $build_type = $map ? $map->build_type : 0;
        }
    }
    require MT::PublishOption;
    if ( $build_type != MT::PublishOption::DYNAMIC() ) {
        require MT::DeleteFileInfo;
        my $del = MT::DeleteFileInfo->new(
            blog_id    => $self->blog_id,
            file_path  => $self->file_path,
            build_type => $build_type || 0,
        );
        $del->save;
    }
    $self->remove;
}

1;
