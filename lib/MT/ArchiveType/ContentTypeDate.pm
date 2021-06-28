# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ArchiveType::ContentTypeDate;

use strict;
use warnings;
use base qw( MT::ArchiveType::Date );

use MT::ContentStatus;

sub contenttype_group_based {
    return 1;
}

sub dated_group_contents {
    my $obj = shift;
    my ( $ctx, $at, $ts, $limit, $content_type_id ) = @_;

    $content_type_id ||=
          $ctx->stash('template')
        ? $ctx->stash('template')->content_type_id
        : undef;

    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
        $ctx->{current_timestamp}     = $start;
        $ctx->{current_timestamp_end} = $end;
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my $map = $obj->get_preferred_map(
        {   archive_type    => $at,
            blog_id         => $blog->id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
    );
    my $dt_field_id = $map ? $map->dt_field_id : '';
    require MT::ContentData;
    my @content_data = MT::ContentData->load(
        {   blog_id => $blog->id,
            (   $content_type_id ? ( content_type_id => $content_type_id )
                : ()
            ),
            status => MT::ContentStatus::RELEASE(),
            ( !$dt_field_id ? ( authored_on => [ $start, $end ] ) : () ),
        },
        {   ( !$dt_field_id ? ( range_incl => { authored_on => 1 } ) : () ),
            ( !$dt_field_id ? ( 'sort' => 'authored_on' ) : () ),
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
            (   $dt_field_id
                ? ( 'join' => [
                        'MT::ContentFieldIndex',
                        'content_data_id',
                        {   content_field_id => $dt_field_id,
                            value_datetime   => [ $start, $end ]
                        },
                        {   sort       => 'value_datetime',
                            range_incl => { value_datetime => 1 }
                        }
                    ]
                    )
                : ()
            ),
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@content_data;
}

sub dated_category_contents {
    my $obj = shift;
    my ( $ctx, $at, $cat, $ts, $limit, $content_type_id ) = @_;

    $content_type_id ||=
          $ctx->stash('template')
        ? $ctx->stash('template')->content_type_id
        : undef;

    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my $map = $obj->get_preferred_map(
        {   archive_type    => $at,
            blog_id         => $blog->id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
    );
    my $cat_field_id = $map ? $map->cat_field_id : '';
    my $dt_field_id  = $map ? $map->dt_field_id  : '';
    my @contents     = MT::ContentData->load(
        {   blog_id => $blog->id,
            (   $content_type_id ? ( content_type_id => $content_type_id )
                : ()
            ),
            status => MT::ContentStatus::RELEASE(),
            ( !$dt_field_id ? ( authored_on => [ $start, $end ] ) : () ),
        },
        {   ( !$dt_field_id ? ( range_incl => { authored_on => 1 } ) : () ),
            ( !$dt_field_id ? ( 'sort' => 'authored_on' ) : () ),
            'direction' => 'descend',
            (   $dt_field_id
                ? ( 'joins' => [
                        MT::ContentFieldIndex->join_on(
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
                            {   sort  => 'value_datetime',
                                alias => 'dt_cf_idx'
                            }
                        ),
                        MT::ContentFieldIndex->join_on(
                            'content_data_id',
                            {   content_field_id => $cat_field_id,
                                value_integer    => $cat->id
                            },
                            { alias => 'cat_cf_idx' }
                        )
                    ],
                    )
                : ( join => MT::ContentFieldIndex->join_on(
                        'content_data_id',
                        {   content_field_id => $cat_field_id,
                            value_integer    => $cat->id
                        }
                    )
                )
            ),
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@contents;
}

sub dated_author_contents {
    my $obj = shift;
    my ( $ctx, $at, $author, $ts, $limit, $content_type_id ) = @_;

    $content_type_id ||=
          $ctx->stash('template')
        ? $ctx->stash('template')->content_type_id
        : undef;

    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my $map = $obj->get_preferred_map(
        {   archive_type    => $at,
            blog_id         => $blog->id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
    );
    my $dt_field_id = $map ? $map->dt_field_id : '';
    my @contents = MT::ContentData->load(
        {   blog_id   => $blog->id,
            author_id => $author->id,
            (   $content_type_id ? ( content_type_id => $content_type_id )
                : ()
            ),
            status => MT::ContentStatus::RELEASE(),
            ( !$dt_field_id ? ( authored_on => [ $start, $end ] ) : () ),
        },
        {   (   !$dt_field_id ? ( range_incl => { authored_on => 1 } )
                : ()
            ),
            ( !$dt_field_id ? ( 'sort' => 'authored_on' ) : () ),
            'direction' => 'descend',
            (   $dt_field_id
                ? ( 'join' => [
                        'MT::ContentFieldIndex',
                        'content_data_id',
                        {   content_field_id => $dt_field_id,
                            value_datetime   => [ $start, $end ]
                        },
                        {   sort       => 'value_datetime',
                            range_incl => { value_datetime => 1 }
                        }
                    ]
                    )
                : ()
            ),
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@contents;
}

sub archive_contents_count {
    my $obj = shift;
    my ( $blog, $at, $content_data, $timestamp, $map ) = @_;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
        }
    ) unless $content_data;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $timestamp,
            TemplateMap => $map,
            ContentData => $content_data,
        }
    );
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };

    $obj->archive_contents_count(
        $params{Blog},      $params{ArchiveType}, $params{ContentData},
        $params{Timestamp}, $params{TemplateMap},
    );
}

sub target_dt {
    my $archiver = shift;
    my ( $content_data, $map ) = @_;

    my $target_dt;
    my $dt_field_id = $map->dt_field_id;
    if ($dt_field_id) {
        my $data = $content_data->data;
        $target_dt = $data->{$dt_field_id};
    }
    $target_dt = $content_data->authored_on unless $target_dt;

    return $target_dt;
}

sub make_archive_group_terms {
    my $obj = shift;
    my ( $blog_id, $dt_field_id, $ts, $tsend, $author_id, $content_type_id )
        = @_;
    my $terms = {
        blog_id => $blog_id,
        status  => MT::ContentStatus::RELEASE(),
        ( $content_type_id ? ( content_type_id => $content_type_id ) : () ),
    };
    $terms->{author_id} = $author_id
        if $author_id;
    $terms->{authored_on} = [ $ts, $tsend ]
        if !$dt_field_id && $ts && $tsend;
    return $terms;
}

sub make_archive_group_args {
    my $obj = shift;
    my ($type,  $date_type, $map, $ts, $tsend,
        $lastn, $order,     $cat, $cat_field_id
    ) = @_;
    $cat_field_id ||= defined $map && $map ? $map->cat_field_id : '';
    my $dt_field_id = defined $map && $map ? $map->dt_field_id : '';
    if ( !$cat_field_id && $cat ) {
        my $category_set_id = $cat->category_set_id;
    }
    my $target_column
        = $date_type eq 'weekly'
        ? $dt_field_id
            ? ( $type eq 'category' ? 'dt_cf_idx.' : '' )
        . "cf_idx_value_integer"
            : "week_number"
        : $dt_field_id ? ( $type eq 'category' ? 'dt_cf_idx.' : '' )
        . 'cf_idx_value_datetime'
        : 'authored_on';
    my $args = {};
    $args->{lastn} = $lastn if $lastn;
    $args->{range_incl} = { authored_on => 1 }
        if !$dt_field_id && $ts && $tsend;

    if (   $date_type eq 'daily'
        || $date_type eq 'monthly'
        || $date_type eq 'yearly' )
    {
        $args->{group} = ["extract(year from $target_column) AS year"];
        push @{ $args->{group} },
            "extract(month from $target_column) AS month"
            if $date_type eq 'daily' || $date_type eq 'monthly';
        push @{ $args->{group} }, "extract(day from $target_column) AS day"
            if $date_type eq 'daily';
    }
    elsif ( $date_type eq 'weekly' ) {
        $args->{group} = [$target_column];
    }
    if ( $date_type eq 'daily' ) {
        $args->{sort} = [
            {   column => "extract(year from $target_column)",
                desc   => $order
            },
            {   column => "extract(month from $target_column)",
                desc   => $order
            },
            {   column => "extract(day from $target_column)",
                desc   => $order
            },
        ];
    }
    elsif ( $date_type eq 'weekly' ) {
        $args->{sort} = [
            {   column => $target_column,
                desc   => $order
            }
        ];
    }
    elsif ( $date_type eq 'monthly' ) {
        $args->{sort} = [
            {   column => "extract(year from $target_column)",
                desc   => $order
            },
            {   column => "extract(month from $target_column)",
                desc   => $order
            }
        ];
    }
    elsif ( $date_type eq 'yearly' ) {
        $args->{sort} = [
            {   column => "extract(year from $target_column)",
                desc   => $order
            }
        ];
    }
    if ( $type eq 'category' ) {
        $args->{joins} = [
            (   $dt_field_id
                ? ( MT::ContentFieldIndex->join_on(
                        'content_data_id',
                        [   { content_field_id => $dt_field_id },
                            (   $ts && $tsend
                                ? ( '-and',
                                    [   {   value_datetime => {
                                                op    => '>=',
                                                value => $ts
                                            }
                                        },
                                        '-and',
                                        {   value_datetime => {
                                                op    => '<=',
                                                value => $tsend
                                            }
                                        }
                                    ]
                                    )
                                : ()
                            ),
                        ],
                        { alias => 'dt_cf_idx' }
                    )
                    )
                : ()
            ),
            MT::ContentFieldIndex->join_on(
                'content_data_id',
                {   content_field_id => $cat_field_id,
                    value_integer    => $cat->id
                },
                { alias => 'cat_cf_idx' }
            )
        ];
    }
    else {
        $args->{join} = MT::ContentFieldIndex->join_on(
            'content_data_id',
            {   content_field_id => $dt_field_id,
                (   $ts && $tsend
                    ? ( value_datetime => [ $ts, $tsend ] )
                    : ()
                )
            },
            { range_incl => { value_datetime => 1 } },
        ) if $dt_field_id;
    }
    return $args;
}

# get a content data in the next or previous archive for dated-based ArchiveType
sub next_archive_content_data {
    $_[0]->adjacent_archive_content_data( { %{ $_[1] }, order => 'next' } );
}

sub previous_archive_content_data {
    $_[0]->adjacent_archive_content_data(
        { %{ $_[1] }, order => 'previous' } );
}

sub adjacent_archive_content_data {
    my $obj = shift;
    my ($param) = @_;

    my $order = ( $param->{order} eq 'previous' ) ? 'descend' : 'ascend';

    my $terms = { status => MT::ContentStatus::RELEASE() };

    $terms->{author_id} = $param->{author}->id if $obj->author_based;

    if ( $param->{blog_id} ) {
        $terms->{blog_id} = $param->{blog_id};
    }
    elsif ( $param->{blog} ) {
        $terms->{blog_id} = $param->{blog}->id;
    }

    my ( $category_field_id, $category_id );
    if ( $obj->category_based ) {
        $category_field_id = $param->{category_field_id};
        $category_id       = $param->{category_id};
    }

    my $datetime_field_id = $param->{datetime_field_id};

    my $ts = $param->{ts};

    # if $param->{content_data} given, override $ts and $blog_id.
    if ( my $cd = $param->{content_data} ) {
        if ($datetime_field_id) {
            $ts = $cd->data->{$datetime_field_id};
        }
        $ts ||= $cd->authored_on;

        $terms->{blog_id}         = $cd->blog_id;
        $terms->{content_type_id} = $cd->content_type_id;
    }

    my ( $start, $end ) = $obj->date_range($ts);
    $ts = ( $order eq 'descend' ) ? $start : $end;

    my $category_join;
    if ( $category_field_id && $category_id ) {
        $category_join = MT::ContentFieldIndex->join_on(
            undef,
            {   content_data_id  => \'= cd_id',
                content_field_id => $category_field_id,
                value_integer    => $category_id,
            },
            { alias => 'cat_cf_idx' },
        );
    }

    require MT::ContentData;
    my $content_data;
    if ($datetime_field_id) {
        $content_data = MT::ContentData->load(
            $terms,
            {   limit => 1,
                joins => [
                    MT::ContentFieldIndex->join_on(
                        undef,
                        {   content_data_id  => \'= cd_id',
                            content_field_id => $datetime_field_id,
                            value_datetime   => {
                                op => $order eq 'descend' ? '<' : '>',
                                value => $ts,
                            },
                        },
                        {   sort      => 'value_datetime',
                            direction => $order,
                            alias     => 'dt_cf_idx',
                        },
                    ),
                    $category_join || (),
                ],
            }
        );
    }
    else {
        $content_data = MT::ContentData->load(
            $terms,
            {   limit     => 1,
                sort      => 'authored_on',
                direction => $order,
                start_val => $ts,
                $category_join ? ( join => $category_join ) : (),
            }
        );
    }

    return $content_data;
}

1;
