# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType;

use strict;
use warnings;

sub new {
    my $pkg  = shift;
    my $self = {@_};
    bless $self, $pkg;
}

sub _getset {
    my $self = shift;
    my $name = shift;
    @_ ? $self->{$name} = $_[0] : $self->{$name};
}

sub _getset_coderef {
    my ( $obj, $key, @param ) = @_;

    # We only do this weird thing for MT::ArchiveType, which for MT 4
    # allowed assignment of a coderef to the base MT::ArchiveType class.
    # With MT 4.2 and later, this routine should be overridden by a
    # subclass, and therefore, shouldn't do anything by itself.
    if ( ref($obj) eq __PACKAGE__ ) {
        if ( @param && ref( $param[0] ) eq 'CODE' ) {
            $obj->_getset( $key, @param );
            return;
        }
        if ( my $code = $obj->_getset($key) ) {
            return $code->(@param);
        }
    }
    return;
}

sub name { shift->_getset( 'name', @_ ) }

# The base class routine should handle coderef assignment
# calling date_range with other parameters invokes this routine
# and returns the result
sub archive_group_iter {
    shift->_getset_coderef( 'archive_group_iter', @_ );
}

sub archive_group_entries {
    shift->_getset_coderef( 'archive_group_entries', @_ );
}

sub archive_group_contents {
    shift->_getset_coderef( 'archive_group_contents', @_ );
}

sub archive_file {
    shift->_getset_coderef( 'archive_file', @_ );
}

sub archive_title {
    shift->_getset_coderef( 'archive_title', @_ );
}

sub archive_label {
    shift->_getset_coderef( 'archive_label', @_ );
}

sub archive_short_label {
    shift->_getset_coderef( 'archive_short_label', @_ );
}

sub group_based {
    my $obj = shift;
    if ( ref($obj) eq __PACKAGE__ ) {
        return $obj->_getset('archive_group_entries') ? 1 : 0;
    }
    return 0;
}

sub contenttype_group_based {
    my $obj = shift;
    if ( ref($obj) eq __PACKAGE__ ) {
        return $obj->_getset('archive_group_contents') ? 1 : 0;
    }
    return 0;
}

sub default_archive_templates {
    shift->_getset( 'default_archive_templates', @_ );
}
sub dynamic_template { shift->_getset( 'dynamic_template', @_ ) }
sub entry_class { shift->_getset( 'entry_class', @_ ) || 'entry' }
sub category_class { shift->_getset( 'category_class', @_ ) || 'category' }
sub template_params { shift->_getset('template_params') }

sub dynamic_support {
    my $obj = shift;
    if ( ref $obj ne __PACKAGE__ ) {
        return 1;    # assume support unless overridden
    }
    $obj->_getset( 'dynamic_support', @_ );
}

sub category_based {
    my $obj = shift;
    return $obj->{category_based} if exists $obj->{category_based};
    return $obj->{category_based} = $obj->isa('MT::ArchiveType::Category');
}

sub entry_based {
    my $obj = shift;
    return $obj->{entry_based} if exists $obj->{entry_based};
    return $obj->{entry_based} = $obj->isa('MT::ArchiveType::Individual');
}

sub date_based {
    my $obj = shift;
    return $obj->{date_based} if exists $obj->{date_based};
    return $obj->{date_based} = $obj->isa('MT::ArchiveType::Date');
}

sub author_based {
    my $obj = shift;
    return $obj->{author_based} if exists $obj->{author_based};
    return $obj->{author_based} = $obj->isa('MT::ArchiveType::Author');
}

sub contenttype_based {
    my $obj = shift;
    return $obj->{contenttype_based} if exists $obj->{contenttype_based};
    return $obj->{contenttype_based} = $obj->isa('MT::ArchiveType::ContentType');
}

sub contenttype_category_based {
    my $obj = shift;
    return $obj->{contenttype_category_based} if exists $obj->{contenttype_category_based};
    return $obj->{contenttype_category_based} = $obj->isa('MT::ArchiveType::ContentTypeCategory');
}

sub contenttype_author_based {
    my $obj = shift;
    return $obj->{contenttype_author_based} if exists $obj->{contenttype_author_based};
    return $obj->{contenttype_author_based} = $obj->isa('MT::ArchiveType::ContentTypeAuthor');
}

sub contenttype_date_based {
    my $obj = shift;
    return $obj->{contenttype_date_based} if exists $obj->{contenttype_date_based};
    return $obj->{contenttype_date_based} = $obj->isa('MT::ArchiveType::ContentTypeDate');
}

sub archive_entries_count {
    my $self = shift;

    return $self->_getset_coderef( 'archive_entries_count', @_ )
        if ref($self) eq __PACKAGE__;

    my ($params) = @_;
    my $blog     = $params->{Blog};
    my $at       = $params->{ArchiveType};
    my $ts       = $params->{Timestamp};
    my $cat      = $params->{Category};
    my $auth     = $params->{Author};
    my ( $start, $end );
    if ($ts) {
        my $archiver = MT->publisher->archiver($at);
        ( $start, $end ) = $archiver->date_range($ts) if $archiver;
    }

    my $count = MT->model('entry')->count(
        {   blog_id => $blog->id,
            status  => MT::Entry::RELEASE(),
            ( $ts ? ( authored_on => [ $start, $end ] ) : () ),
            ( $auth ? ( author_id => $auth->id ) : () ),
        },
        {   ( $ts ? ( range_incl => { authored_on => 1 } ) : () ),
            (   $cat
                ? ( 'join' => [
                        'MT::Placement', 'entry_id',
                        { category_id => $cat->id }
                    ]
                    )
                : ()
            ),
        }
    );
    return $count;
}

sub archive_contents_count {
    my $self = shift;

    return $self->_getset_coderef( 'archive_contents_count', @_ )
        if ref($self) eq __PACKAGE__;
    my $count = MT->model('content_data')->count( $self->archive_contents_count_params(@_) );
}

sub alternative_content {
    my ( $self, $params ) = @_;
    my ( $terms, $opts ) = $self->archive_contents_count_params($params);
    my $content_data = $params->{ContentData} or return;
    $terms->{id} = { op => '!=', value => $content_data->id };
    $opts->{limit} = 1;
    my $similar_content_data = MT->model('content_data')->load( $terms, $opts );
}

sub archive_contents_count_params {
    my $self = shift;

    my ($params)     = @_;
    my $blog         = $params->{Blog};
    my $at           = $params->{ArchiveType};
    my $ts           = $params->{Timestamp};
    my $cat          = $params->{Category};
    my $author       = $params->{Author};
    my $map          = $params->{TemplateMap};
    my $content_data = $params->{ContentData};

    my $blog_id   = $blog && ref $blog ? $blog->id : $blog;
    my $cat_id    = $cat && ref $cat ? $cat->id : $cat;
    my $author_id = $author && ref $author ? $author->id : $author;

    my $content_type_id = $content_data ? $content_data->content_type_id : undef;

    my ( $start, $end );
    if ($ts) {
        my $archiver = MT->publisher->archiver($at);
        ( $start, $end ) = $archiver->date_range($ts) if $archiver;
    }

    my $cat_field_id
        = ( $at eq 'ContentType' || $self->category_based )
        && defined $map
        && $map ? $map->cat_field_id : '';
    my $dt_field_id
        = ( $at eq 'ContentType' || $self->date_based )
        && defined $map
        && $map ? $map->dt_field_id : '';

    require MT::ContentStatus;
    return (
        {   blog_id => $blog_id,
            status  => MT::ContentStatus::RELEASE(),
            (   $content_type_id ? ( content_type_id => $content_type_id ) : () ),
            (   !$dt_field_id && $ts ? ( authored_on => [ $start, $end ] )
                : ()
            ),
            ( $author_id ? ( author_id => $author_id ) : () ),
        },
        {   (   !$dt_field_id && $ts ? ( range_incl => { authored_on => 1 } )
                : ()
            ),
            joins => [
                (   $cat_field_id
                    ? ( MT::ContentFieldIndex->join_on(
                            'content_data_id',
                            {   content_field_id => $cat_field_id,
                                value_integer    => $cat_id
                            },
                            { alias => 'cat_cf_idx' }
                        )
                        )
                    : ()
                ),
                (   $dt_field_id && $ts
                    ? ( MT::ContentFieldIndex->join_on(
                            'content_data_id',
                            [   { content_field_id => $dt_field_id },
                                '-and',
                                [   {   value_datetime =>
                                            { op => '>=', value => $start }
                                    },
                                    '-and',
                                    {   value_datetime =>
                                            { op => '<=', value => $end }
                                    }
                                ],
                            ],
                            { alias => 'dt_cf_idx' }
                        )
                        )
                    : ()
                ),
            ]
        }
    );
}

sub does_publish_file {
    return 1;
}

# For user-defined date-based archive types
sub date_range {
    shift->_getset_coderef( 'date_range', @_ );
}

sub next_archive_entry {
    shift->_getset_coderef( 'next_archive_entry', @_ );
}

sub previous_archive_entry {
    shift->_getset_coderef( 'previous_archive_entry', @_ );
}

sub next_archive_content_data {
    shift->_getset_coderef( 'next_archive_content_data', @_ );
}

sub previous_archive_content_data {
    shift->_getset_coderef( 'previous_archive_content_data', @_ );
}

sub get_content {
    shift->_getset_coderef( 'get_content', @_ );
}

sub get_preferred_map {
    my $self = shift;
    my ($args) = @_;
    $args ||= {};
    my $map             = $args->{map};
    my $content_type_id = $args->{content_type_id};

    return $map if $self->_is_valid_map( $map, $content_type_id );

    return $self->_search_preferred_map($args);
}

sub _is_valid_map {
    my $self = shift;
    my ( $map, $content_type_id ) = @_;

    return unless $map;

    return 1 unless $self->_is_contenttype_archiver;

    my $tmpl = $map->template or return;

    if (   $tmpl->content_type
        && $content_type_id
        && $tmpl->content_type_id eq $content_type_id )
    {
        return 1;
    }

    return;
}

sub _search_preferred_map {
    my $self = shift;
    my ($args) = @_;
    $args ||= {};

    my $archive_type = $args->{archive_type} || $self->name;
    my $blog_id      = $args->{blog_id};
    my $ct_id        = $args->{content_type_id};
    require MT::Request;
    my $cache_map = MT::Request->instance->cache('maps') || MT::Request->instance->cache('maps', {});
    my $cache_key = join(':', $blog_id, $ct_id ? $ct_id : (), $self->name);
    my $map       = $cache_map->{$cache_key};

    if (!$map) {
        my $map_args = ($self->_is_contenttype_archiver && $ct_id)
            ? +{
            join => MT->model('template')->join_on(
                undef,
                {
                    id              => \'= templatemap_template_id',
                    content_type_id => $ct_id,
                },
            ),
            }
            : undef;

        $map = MT->model('templatemap')->load({
                archive_type => $archive_type,
                blog_id      => $blog_id,
                is_preferred => 1,
            },
            $map_args || (),
        );
        $cache_map->{$cache_key} = $map if $map;
    }
    return $map;
}

sub _is_contenttype_archiver {
    my $self = shift;
    return $self->contenttype_based || $self->contenttype_group_based;
}

1;
