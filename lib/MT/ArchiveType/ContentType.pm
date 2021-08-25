# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentType;

use strict;
use warnings;
use base qw( MT::ArchiveType );

use MT::ContentStatus;
use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType';
}

sub archive_label {
    return MT->translate("CONTENTTYPE_ADV");
}

sub order {
    return 170;
}

sub template_params {
    return {
        archive_class       => "contenttype-archive",
        contenttype_archive => 1,
        archive_template    => 1,
    };
}

sub dynamic_template {
    'content/<$MTContentID$>';
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $content   = $ctx->{__stash}{content};

    my $file;
    Carp::confess("archive_file_for ContentType archive needs a content")
        unless $content;
    if ($file_tmpl) {
        $ctx->{current_timestamp} = $timestamp;
    }
    else {
        my $basename = $content->identifier();
        $basename ||= dirify( $content->label() );
        $file = sprintf( "%04d/%02d/%s",
            unpack( 'A4A2', $timestamp ), $basename );
    }
    $file;
}

sub archive_title {
    my $obj = shift;
    encode_html( remove_html( $_[1]->label ) );
}

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;

    my $order
        = ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $blog_id         = $ctx->stash('blog')->id;
    my $content_type_id = $ctx->stash('content_type')->id;

    my $map = $obj->get_preferred_map(
        {   blog_id         => $blog_id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
    );
    my $dt_field = $map ? $map->dt_field : undef;

    my $iter_args = { $args->{lastn} ? ( limit => $args->{lastn} ) : () };
    if ($dt_field) {
        $iter_args->{join} = MT->model('content_field_index')->join_on(
            undef,
            {   content_field_id => $dt_field->id,
                content_data_id  => \'= cd_id',
            },
            {   direction => $order,
                sort      => 'value_datetime',
            },
        );
    }
    else {
        $iter_args->{direction} = $order;
        $iter_args->{sort}      = 'authored_on';
    }

    require MT::ContentData;
    my $iter = MT::ContentData->load_iter(
        {   blog_id         => $blog_id,
            content_type_id => $content_type_id,
            status          => MT::ContentStatus::RELEASE(),
        },
        $iter_args,
    );
    return sub {
        while ( my $content = $iter->() ) {
            return ( 1, contents => [$content], content => $content );
        }
        undef;
        }
}

sub default_archive_templates {
    return [
        {   label           => MT->translate('yyyy/mm/content-basename.html'),
            template        => '%y/%m/%-f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
        {   label           => MT->translate('yyyy/mm/content_basename.html'),
            template        => '%y/%m/%f',
            required_fields => { date_and_time => 1 }
        },
        {   label    => MT->translate('yyyy/mm/content-basename/index.html'),
            template => '%y/%m/%-b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label    => MT->translate('yyyy/mm/content_basename/index.html'),
            template => '%y/%m/%b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label    => MT->translate('yyyy/mm/dd/content-basename.html'),
            template => '%y/%m/%d/%-f',
            required_fields => { date_and_time => 1 }
        },
        {   label    => MT->translate('yyyy/mm/dd/content_basename.html'),
            template => '%y/%m/%d/%f',
            required_fields => { date_and_time => 1 }
        },
        {   label => MT->translate('yyyy/mm/dd/content-basename/index.html'),
            template        => '%y/%m/%d/%-b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label => MT->translate('yyyy/mm/dd/content_basename/index.html'),
            template        => '%y/%m/%d/%b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label => MT->translate(
                'author/author-basename/content-basename/index.html'),
            template => 'author/%-a/%-b/%i',
            default  => 1
        },
        {   label => MT->translate(
                'author/author_basename/content_basename/index.html'),
            template => 'author/%a/%b/%i'
        },
        {   label =>
                MT->translate('author/author-basename/content-basename.html'),
            template => 'author/%-a/%-f',
            default  => 1
        },
        {   label =>
                MT->translate('author/author_basename/content_basename.html'),
            template => 'author/%a/%f'
        },
        {   label =>
                MT->translate('category/sub-category/content-basename.html'),
            template        => '%-c/%-f',
            required_fields => { category => 1 }
        },
        {   label => MT->translate(
                'category/sub-category/content-basename/index.html'),
            template        => '%-c/%-b/%i',
            required_fields => { category => 1 }
        },
        {   label =>
                MT->translate('category/sub_category/content_basename.html'),
            template        => '%c/%f',
            required_fields => { category => 1 }
        },
        {   label => MT->translate(
                'category/sub_category/content_basename/index.html'),
            template        => '%c/%b/%i',
            required_fields => { category => 1 }
        },
    ];
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

1;
