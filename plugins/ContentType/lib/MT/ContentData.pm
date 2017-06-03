# Movable Type (r) (C) 2006-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentData;

use strict;
use base qw( MT::Object MT::Revisable );

use JSON ();

use MT;
use MT::Asset;
use MT::Author;
use MT::ContentField;
use MT::ContentType;
use MT::ContentType::UniqueID;
use MT::ObjectAsset;
use MT::ObjectCategory;
use MT::ObjectTag;
use MT::Tag;
use MT::Util;

use constant TAG_CACHE_TIME => 7 * 24 * 60 * 60;    ## 1 week

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'      => 'integer not null auto_increment',
            'blog_id' => 'integer not null',
            'title'   => {
                type       => 'string',
                size       => 255,
                label      => 'Title',
                revisioned => 1,
            },
            'status' => {
                type       => 'smallint',
                not_null   => 1,
                label      => 'Status',
                revisioned => 1,
            },
            'author_id' => {
                type       => 'integer',
                not_null   => 1,
                label      => 'Author',
                revisioned => 1,
            },
            'content_type_id' => 'integer not null',
            'unique_id'       => 'string(40) not null',
            'data'            => {
                type       => 'blob',
                label      => 'Data',
                revisioned => 1,
            },
            'identifier' => {
                type       => 'string',
                size       => 255,
                label      => 'Identifier',
                revisioned => 1,
            },
            'authored_on' => {
                type       => 'datetime',
                label      => 'Publish Date',
                revisioned => 1,
            },
            'unpublished_on' => {
                type       => 'datetime',
                label      => 'Unpublished Date',
                revisioned => 1,
            },
            'revision' => 'integer meta',
        },
        indexes     => { content_type_id => 1, unique_id => { unique => 1 } },
        defaults    => { status          => 0 },
        datasource  => 'cd',
        primary_key => 'id',
        audit       => 1,
        meta        => 1,
        child_of => ['MT::ContentType'],
    }
);

sub class_label {
    MT->translate("Content Data");
}

sub class_label_plural {
    MT->translate("Content Data");
}

sub to_hash {
    my $self = shift;
    my $hash = $self->SUPER::to_hash();
    $hash->{'cd.text_html'}
        = $self->_generate_text_html || $self->column('data');
    $hash;
}

sub _generate_text_html {
    my $self      = shift;
    my $data_hash = {};
    for my $field_id ( keys %{ $self->data } ) {
        my $field = MT::ContentField->load( $field_id || 0 );
        my $hash_key = $field ? $field->name : "field_id_${field_id}";
        $data_hash->{$hash_key} = $self->data->{$field_id};
    }
    eval { JSON::to_json( $data_hash, { canonical => 1, utf8 => 1 } ) };
}

sub unique_id {
    my $self = shift;
    $self->column('unique_id');
}

sub save {
    my $self = shift;

    my $content_field_types = MT->registry('content_field_types');
    my $content_type        = $self->content_type
        or return $self->error(
        MT->component('ContentType')->translate('Invalid content type') );

    unless ( $self->id ) {
        my $unique_id
            = MT::ContentType::UniqueID::generate_unique_id( $self->title );
        $self->column( 'unique_id', $unique_id );
    }

    ## If there's no identifier specified, create a unique identifier.
    if ( !defined( $self->identifier ) || ( $self->identifier eq '' ) ) {
        my $name = MT::Util::make_unique_basename($self);
        $self->identifier($name);
    }

    $self->SUPER::save(@_) or return;

    my $field_data = $self->data;

    foreach my $f ( @{ $content_type->fields } ) {
        my $idx_type  = $f->{type};
        my $data_type = $content_field_types->{$idx_type}{data_type};
        my $value     = $field_data->{ $f->{id} };
        $value = [$value] unless ref $value eq 'ARRAY';

        $value = [ grep { defined $_ && $_ ne '' } @$value ];

        if ( $idx_type eq 'asset' ) {
            $self->_update_object_assets( $content_type, $f, $value );
        }
        elsif ( $idx_type eq 'tag' ) {
            $self->_update_object_tags( $content_type, $f, $value );
        }
        elsif ( $idx_type eq 'category' ) {
            $self->_update_object_categories( $content_type, $f, $value );
        }

        MT::ContentFieldIndex->remove(
            {   content_type_id  => $content_type->id,
                content_data_id  => $self->id,
                content_field_id => $f->{id},
            }
        );

        for my $v (@$value) {
            my $cf_idx = MT::ContentFieldIndex->new;
            $cf_idx->set_values(
                {   content_type_id  => $content_type->id,
                    content_data_id  => $self->id,
                    content_field_id => $f->{id},
                }
            );

            $cf_idx->set_value( $data_type, $v )
                or return $self->error(
                MT->component('ContentType')->translate(
                    'Saving content field index failed: Invalid field type "[_1]"',
                    $data_type
                )
                );

            $cf_idx->save
                or return $self->error(
                MT->component('ContentType')->translate(
                    "Saving content field index failed: [_1]",
                    $cf_idx->errstr
                )
                );
        }
    }

    1;
}

sub _update_object_assets {
    my $self = shift;
    my ( $content_type, $field, $values ) = @_;

    MT::ObjectAsset->remove(
        {   object_ds => 'content_field',
            object_id => $field->{id},
        }
    );

    for my $asset_id (@$values) {
        my $obj_asset = MT::ObjectAsset->new;
        $obj_asset->set_values(
            {   blog_id   => $self->blog_id,
                asset_id  => $asset_id,
                object_ds => 'content_field',
                object_id => $field->{id},
            }
        );
        $obj_asset->save or die $obj_asset->errstr;
    }
}

sub _update_object_tags {
    my $self = shift;
    my ( $content_type, $field, $values ) = @_;

    MT::ObjectTag->remove(
        {   blog_id           => $self->blog_id,
            object_datasource => 'content_field',
            object_id         => $field->{id},
        }
    );

    for my $tag_id (@$values) {
        my $obj_tag = MT::ObjectTag->new;
        $obj_tag->set_values(
            {   blog_id           => $self->blog_id,
                tag_id            => $tag_id,
                object_datasource => 'content_field',
                object_id         => $field->{id},
            }
        );
        $obj_tag->save or die $obj_tag->errstr;
    }
}

sub _update_object_categories {
    my $self = shift;
    my ( $content_type, $field, $values ) = @_;

    MT::ObjectCategory->remove(
        {   blog_id   => $self->blog_id,
            object_ds => 'content_field',
            object_id => $field->{id},
        }
    );

    my $is_primary = 1;
    for my $cat_id (@$values) {
        my $obj_cat = MT::ObjectCategory->new;
        $obj_cat->set_values(
            {   blog_id     => $self->blog_id,
                category_id => $cat_id,
                object_ds   => 'content_field',
                object_id   => $field->{id},
                is_primary  => $is_primary,
            }
        );
        $obj_cat->save or die $obj_cat->errstr;
        $is_primary = 0;
    }
}

sub data {
    my $obj = shift;
    if (@_) {
        my $json;
        if ( ref $_[0] ) {
            $json = eval { JSON::encode_json( $_[0] ) } || '{}';
        }
        else {
            $json = $_[0];
        }
        $obj->column( 'data', $json );
    }
    else {
        eval { JSON::decode_json( $obj->column('data') ) } || {};
    }
}

sub content_type {
    my $self = shift;
    $self->cache_property(
        'content_type',
        sub {
            MT::ContentType->load( $self->content_type_id || 0 ) || undef;
        },
    );
}

sub blog {
    my ($ct_data) = @_;
    $ct_data->cache_property(
        'blog',
        sub {
            my $blog_id = $ct_data->blog_id;
            require MT::Blog;
            MT::Blog->load( $blog_id || 0 )
                or $ct_data->error(
                MT->translate(
                    "Loading blog '[_1]' failed: [_2]",
                    $blog_id,
                    MT::Blog->errstr
                        || MT->translate("record does not exist.")
                )
                );
        }
    );
}

sub author {
    my $self = shift;
    $self->cache_property(
        'author',
        sub {
            scalar MT::Author->load( $self->author_id || 0 );
        },
    );
}

sub terms_for_tags {
    return {};
}

sub get_tag_objects {
    my $obj = shift;
    $obj->__load_tags;
    return $obj->{__tag_objects};
}

sub __load_tags {
    my $obj = shift;
    my $t   = MT->get_timer;
    $t->pause_partial if $t;

    if ( !$obj->id ) {
        $obj->{__tags} = [];
        return $obj->{__tag_objects} = [];
    }
    return if exists $obj->{__tag_objects};

    require MT::Memcached;
    my $cache  = MT::Memcached->instance;
    my $memkey = $obj->tag_cache_key;
    my @tags;
    if ( my $tag_ids = $cache->get($memkey) ) {
        @tags = grep {defined} @{ MT::Tag->lookup_multi($tag_ids) };
    }
    else {
        my @field_ids;
        my $cf_iter
            = MT::ContentField->load_iter(
            { content_type_id => $obj->content_type_id },
            { fetchonly       => { id => 1 } } );
        while ( my $cf = $cf_iter->() ) {
            push @field_ids, $cf->id;
        }

        my $tag_iter = MT::Tag->load_iter(
            undef,
            {   sort => 'name',
                join => [
                    'MT::ObjectTag',
                    'tag_id',
                    {   blog_id           => $obj->blog_id,
                        object_id         => \@field_ids,
                        object_datasource => 'content_field',
                    },
                    { unique => 1 }
                ],
            }
        );
        while ( my $tag = $tag_iter->() ) {
            push @tags, $tag;
        }
        $cache->set( $memkey, [ map { $_->id } @tags ], TAG_CACHE_TIME );
    }
    $obj->{__tags} = [ map { $_->name } @tags ];
    $t->mark('MT::Tag::__load_tags') if $t;
    $obj->{__tag_objects} = \@tags;
}

sub tag_cache_key {
    my $obj = shift;
    return undef unless $obj->id;
    return sprintf "%stags-%d", $obj->datasource, $obj->id;
}

sub edit_link {
    my ( $self, $app ) = @_;
    $app->uri(
        mode => 'edit_content_data',
        args => {
            id              => $self->id,
            blog_id         => $self->blog_id,
            content_type_id => $self->content_type_id,
        },
    );
}

sub next {
    my $self = shift;
    my ($opt) = @_;
    my $terms;
    if ( ref $opt ) {
        $terms = $opt;
    }
    else {
        $terms = $opt ? { status => MT::Entry::RELEASE() } : {};
    }
    $self->_nextprev( 'next', $terms );
}

sub previous {
    my $self = shift;
    my ($opt) = @_;
    my $terms;
    if ( ref $opt ) {
        $terms = $opt;
    }
    else {
        $terms = $opt ? { status => MT::Entry::RELEASE() } : {};
    }
    $self->_nextprev( 'previous', $terms );
}

sub _nextprev {
    my $obj   = shift;
    my $class = ref($obj);
    my ( $direction, $terms ) = @_;
    return undef unless ( $direction eq 'next' || $direction eq 'previous' );
    my $next = $direction eq 'next';

    $terms->{author_id} = $obj->author_id if delete $terms->{by_author};

    my ( $content_field_id, $category_id );
    if ( my $by_category = delete $terms->{by_category} ) {
        if ( ref $by_category eq 'HASH' ) {
            $content_field_id = $by_category->{content_field_id};
            $category_id => $by_category->{category_id};
        }
        $content_field_id ||= $obj->content_type->get_first_category_field_id
            or return undef;
        $category_id ||= ${ $obj->data->{$content_field_id} || [] }[0] || 0;
    }

    my $label = '__' . $direction;
    $label .= ':author=' . $terms->{author_id} if exists $terms->{author_id};
    $label
        .= ":content_field_id=${content_field_id}:category_id=${category_id}"
        if $content_field_id;
    $label .= ':by_modified_on' if $terms->{by_modified_on};
    return $obj->{$label} if $obj->{$label};

    my $args = {};

    if ($content_field_id) {
        my $join;
        if ($category_id) {
            $join = MT::ContentFieldIndex->join_on(
                'content_data_id',
                {   content_field_id => $content_field_id,
                    value_integer    => $category_id,
                },
                { unique => 1 }
            );
        }
        else {
            $join = MT::ContentFieldIndex->join_on(
                undef, undef,
                {   type      => 'left',
                    condition => {
                        content_data_id  => \'= cd_id',
                        content_field_id => $content_field_id,
                        value_integer    => \'IS NULL',
                    },
                    unique => 1,
                }
            );
        }
        $args->{join} = $join;
    }

    my $by = delete $terms->{by_modified_on} ? 'modified_on' : 'authored_on';

    my $o;
    if ( $args->{join} ) {
        my $desc = $next ? 'ASC' : 'DESC';
        my $op   = $next ? '>'   : '<';

        $terms->{blog_id}         = $obj->blog_id;
        $terms->{content_type_id} = $obj->content_type_id;

        $args->{sort} = [
            { column => $by,  desc => $desc },
            { column => 'id', desc => $desc },
        ];

        $o = MT::ContentData->load(
            { %{$terms}, $by => { $op => $obj->$by } }, $args );
        $o
            ||= MT::ContentData->load(
            { %{$terms}, $by => $obj->$by, id => { $op => $obj->id } },
            $args );
    }
    else {
        $o = $obj->nextprev(
            direction => $direction,
            terms     => {
                blog_id         => $obj->blog_id,
                content_type_id => $obj->content_type_id,
                %$terms,
            },
            args => $args,
            by   => $by,
        );
    }
    MT::Util::weaken( $obj->{$label} = $o ) if $o;
    return $o;
}

sub is_in_category {
    my $self         = shift;
    my ($cat)        = @_;
    my $content_type = $self->content_type or return;
    my @category_fields
        = grep { $_->{type} eq 'category' } @{ $content_type->fields }
        or return;
    for my $f (@category_fields) {
        my $category_ids = $self->data->{ $f->{id} } || [];
        if ( grep { $_ == $cat->id } @{$category_ids} ) {
            return 1;
        }
    }
    0;
}

1;

