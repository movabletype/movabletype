# Movable Type (r) (C) 2006-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentData;

use strict;
use warnings;
use base qw( MT::Object MT::Revisable );

use JSON  ();
use POSIX ();

use MT;
use MT::Asset;
use MT::Author;
use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::ContentStatus;
use MT::ContentType;
use MT::ContentType::UniqueID;
use MT::ObjectAsset;
use MT::ObjectCategory;
use MT::ObjectTag;
use MT::Tag;
use MT::Util;

use constant TAG_CACHE_TIME => 7 * 24 * 60 * 60;    ## 1 week

our $MAX_DELETE_NUMBER_AT_ONE_TIME = 100;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'      => 'integer not null auto_increment',
            'blog_id' => 'integer not null',
            'status'  => {
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
            'ct_unique_id'    => 'string(40) not null',
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
            'revision'          => 'integer meta',
            'convert_breaks'    => 'string meta',
            'block_editor_data' => 'text meta',
            'week_number'       => 'integer',
        },
        indexes => {
            content_type_id => 1,
            ct_unique_id    => 1,
            status          => 1,
            unique_id       => { unique => 1 },
            site_author     => {
                columns =>
                    [ 'author_id', 'authored_on', 'blog_id', 'ct_unique_id' ],
            },
        },
        defaults    => { status => 0 },
        datasource  => 'cd',
        primary_key => 'id',
        audit       => 1,
        meta        => 1,
        child_of    => ['MT::ContentType'],
        class_type  => 'content_data',
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

    $hash->{'cd.content_html'} = $self->_generate_content_html;

    $hash->{'cd.permalink'} = $self->permalink;
    $hash->{'cd.status_text'}
        = MT::ContentStatus::status_text( $self->status );
    $hash->{ 'cd.status_is_' . $self->status } = 1;
    $hash->{'cd.created_on_iso'}
        = sub { MT::Util::ts2iso( $self->blog_id, $self->created_on ) };
    $hash->{'cd.modified_on_iso'}
        = sub { MT::Util::ts2iso( $self->blog_id, $self->modified_on ) };
    $hash->{'cd.authored_on_iso'}
        = sub { MT::Util::ts2iso( $self->blog_id, $self->authored_on ) };

    # Populate author info
    my $auth = $self->author or return $hash;
    my $auth_hash = $auth->to_hash;
    $hash->{"cd.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;

    $hash;
}

sub _generate_content_html {
    my $self           = shift;
    my $field_registry = MT->registry('content_field_types');

    my $html = '';
    for my $field ( @{ $self->content_type->fields } ) {
        my $label = $field->{options}{label};
        unless ( defined $label && $label ne '' ) {
            $label = '(Field ID:' . $field->{id} . ')';
        }

        my $handler = $field_registry->{ $field->{type} }{feed_value_handler};
        if ( $handler && !ref $handler ) {
            $handler = MT->handler_to_coderef($handler);
        }

        my $field_values = $self->data->{ $field->{id} };
        my $data
            = $handler
            ? $handler->( MT->app, $field, $field_values )
            : MT::Util::encode_html($field_values);

        $html .= "$label: $data<br>\n";
    }

    return $html;
}

sub unique_id {
    my $self = shift;
    $self->column('unique_id');
}

sub ct_unique_id {
    my $self = shift;
    $self->column('ct_unique_id');
}

sub save {
    my $self = shift;

    my $content_field_types = MT->registry('content_field_types');
    my $content_type        = $self->content_type
        or return $self->error( MT->translate('Invalid content type') );

    unless ( $self->id ) {
        my $unique_id = MT::ContentType::UniqueID::generate_unique_id();
        $self->column( 'unique_id', $unique_id );

        $self->column( 'ct_unique_id', $content_type->unique_id );
    }

    ## If there's no identifier specified, set unique_id.
    if ( !defined( $self->identifier ) || ( $self->identifier eq '' ) ) {
        $self->identifier( $self->unique_id );
    }

    if ( !$self->id && !$self->authored_on ) {
        my @ts = MT::Util::offset_time_list( time, $self->blog_id );
        my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
            $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
        $self->authored_on($ts);
    }

    # Week Number for authored_on
    if ( my $week_number = _get_week_number( $self, 'authored_on' ) ) {
        $self->week_number($week_number)
            if $week_number != ( $self->week_number || 0 );
    }

    $self->SUPER::save(@_) or return;

    my $data = $self->data;

    foreach my $f ( @{ $content_type->fields } ) {
        my $idx_type = $f->{type};
        next unless defined $idx_type;

        my $data_type = $content_field_types->{$idx_type}{data_type};
        next unless defined $data_type;

        my $value = $data->{ $f->{id} };
        $value = [$value] unless ref $value eq 'ARRAY';
        $value = [ grep { defined $_ && $_ ne '' } @$value ];

        if (   $idx_type eq 'asset'
            || $idx_type eq 'asset_audio'
            || $idx_type eq 'asset_video'
            || $idx_type eq 'asset_image' )
        {
            $self->_update_object_assets( $content_type, $f, $value );
        }
        elsif ( $idx_type eq 'tags' ) {
            $self->_update_object_tags( $content_type, $f, $value );
        }
        elsif ( $idx_type eq 'categories' ) {
            $self->_update_object_categories( $content_type, $f, $value );
        }

        my $cf_idx_data_col = 'value_' . $data_type;
        next unless MT::ContentFieldIndex->has_column($cf_idx_data_col);
        $self->_update_cf_idx( $content_type, $f, $value, $cf_idx_data_col,
            $idx_type );
    }

    1;
}

sub _update_cf_idx {
    my $self = shift;
    my ( $content_type, $f, $value, $cf_idx_data_col, $idx_type ) = @_;

    my $iter = MT::ContentFieldIndex->load_iter(
        {   content_type_id  => $content_type->id,
            content_data_id  => $self->id,
            content_field_id => $f->{id},
        }
    );

    my %cf_idx_hash;
    while ( my $cf_idx = $iter->() ) {
        push @{ $cf_idx_hash{ $cf_idx->$cf_idx_data_col } ||= [] }, $cf_idx;
    }

    my @new_values;
    for my $v (@$value) {
        if ( exists $cf_idx_hash{$v} && @{ $cf_idx_hash{$v} } ) {
            pop @{ $cf_idx_hash{$v} };
        }
        else {
            push @new_values, $v;
        }
    }

    my @removed_cf_idx = map {@$_} values %cf_idx_hash;

    for my $new_value (@new_values) {
        my $cf_idx = pop @removed_cf_idx;
        $cf_idx ||= MT::ContentFieldIndex->new(
            content_type_id  => $content_type->id,
            content_data_id  => $self->id,
            content_field_id => $f->{id},
        );

        $cf_idx->$cf_idx_data_col($new_value);

        # Week Number for Content Field
        if ( $idx_type eq 'date_and_time' || $idx_type eq 'date_only' ) {
            if ( my $week_number
                = _get_week_number( $cf_idx, 'value_datetime' ) )
            {
                $cf_idx->value_integer($week_number);
            }
        }

        $cf_idx->save
            or die MT->translate( 'Saving content field index failed: [_1]',
            $cf_idx->errstr );
    }

    _remove_objects( \@removed_cf_idx )
        or die MT->translate(
        'Removing content field indexes failed: [_1]',
        MT->model('content_field_index')->errstr,
        );
}

sub _update_object_assets {
    my $self = shift;
    my ( $content_type, $field_data, $values ) = @_;

    my $iter = MT::ObjectAsset->load_iter(
        {   blog_id   => $self->blog_id,
            object_ds => 'content_data',
            object_id => $self->id,
            cf_id     => $field_data->{id},
        }
    );

    my %object_assets;
    while ( my $oa = $iter->() ) {
        push @{ $object_assets{ $oa->asset_id } ||= [] }, $oa;
    }

    my @new_asset_ids;
    for my $asset_id (@$values) {
        if ( $object_assets{$asset_id} && @{ $object_assets{$asset_id} } ) {
            pop @{ $object_assets{$asset_id} };
        }
        else {
            push @new_asset_ids, $asset_id;
        }
    }

    my @removed_object_assets = map {@$_} values %object_assets;

    for my $asset_id (@new_asset_ids) {
        my $oa = pop @removed_object_assets;
        $oa ||= MT::ObjectAsset->new(
            blog_id   => $self->blog_id,
            object_ds => 'content_data',
            object_id => $self->id,
            cf_id     => $field_data->{id},
        );
        $oa->asset_id($asset_id);
        $oa->save
            or die MT->translate( 'Saving object asset failed: [_1]',
            $oa->errstr, );
    }

    _remove_objects( \@removed_object_assets )
        or die MT->translate(
        'Removing object assets failed: [_1]',
        MT->model('objectasset')->errstr,
        );
}

sub _update_object_tags {
    my $self = shift;
    my ( $content_type, $field_data, $values ) = @_;

    my $iter = MT::ObjectTag->load_iter(
        {   blog_id           => $self->blog_id,
            object_datasource => 'content_data',
            object_id         => $self->id,
            cf_id             => $field_data->{id},
        }
    );

    my %object_tags;
    while ( my $ot = $iter->() ) {
        push @{ $object_tags{ $ot->tag_id } ||= [] }, $ot;
    }

    my @new_tag_ids;
    for my $tag_id (@$values) {
        if ( $object_tags{$tag_id} && @{ $object_tags{$tag_id} } ) {
            pop @{ $object_tags{$tag_id} };
        }
        else {
            push @new_tag_ids, $tag_id;
        }
    }

    my @removed_object_tags = map {@$_} values %object_tags;

    for my $tag_id (@new_tag_ids) {
        my $ot = pop @removed_object_tags;
        $ot ||= MT::ObjectTag->new(
            blog_id           => $self->blog_id,
            object_datasource => 'content_data',
            object_id         => $self->id,
            cf_id             => $field_data->{id},
        );
        $ot->tag_id($tag_id);
        $ot->save
            or
            die MT->translate( 'Saving object tag failed: [_1]', $ot->errstr,
            );
    }

    _remove_objects( \@removed_object_tags )
        or die MT->translate( 'Removing object tags failed: [_1]',
        MT->model('objecttag')->errstr );
}

sub _update_object_categories {
    my $self = shift;
    my ( $content_type, $field_data, $values ) = @_;

    my $primary_cat_id = $values->[0];
    my $is_primary     = 1;

    my $iter = MT::ObjectCategory->load_iter(
        {   blog_id   => $self->blog_id,
            object_ds => 'content_data',
            object_id => $self->id,
            cf_id     => $field_data->{id},
        }
    );

    my %object_cats;
    while ( my $oc = $iter->() ) {
        push @{ $object_cats{ $oc->category_id } ||= [] }, $oc;
    }

    my @new_cat_ids;
    for my $cat_id (@$values) {
        if ( $object_cats{$cat_id} && @{ $object_cats{$cat_id} } ) {
            my $cat = pop @{ $object_cats{$cat_id} };
            if ( $cat_id == $primary_cat_id && $is_primary ) {
                unless ( $cat->is_primary ) {
                    $cat->is_primary(1);
                    $cat->save or die $cat->errstr;
                    $is_primary = 0;
                }
            }
            else {
                if ( $cat->is_primary ) {
                    $cat->is_primary(0);
                    $cat->save or die $cat->errstr;
                }
            }
        }
        else {
            push @new_cat_ids, $cat_id;
        }
    }

    my @removed_object_cats = map {@$_} values %object_cats;

    for my $cat_id (@new_cat_ids) {
        my $oc = pop @removed_object_cats;
        $oc ||= MT::ObjectCategory->new(
            blog_id   => $self->blog_id,
            object_ds => 'content_data',
            object_id => $self->id,
            cf_id     => $field_data->{id},
        );
        $oc->category_id($cat_id);
        if ( $cat_id == $primary_cat_id && $is_primary ) {
            $oc->is_primary(1);
            $is_primary = 0;
        }
        else {
            $oc->is_primary(0);
        }
        $oc->save
            or die MT->translate( 'Saving object category failed: [_1]',
            $oc->errstr, );
    }

    _remove_objects( \@removed_object_cats )
        or die MT->translate(
        'Removing object categories failed: [_1]',
        MT->model('objectcategory')->errstr,
        );
}

sub _remove_objects {
    my ($objs) = @_;
    my $class = ref $objs->[0];
    my @ids = map { $_->id } @$objs;
    while ( my @partial_ids = splice @ids, 0, $MAX_DELETE_NUMBER_AT_ONE_TIME )
    {
        $class->remove( { id => \@partial_ids } ) or return;
    }
    1;
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
        my $json = $obj->column('data');
        if ( Encode::is_utf8($json) ) {
            eval { JSON::from_json($json) } || {};
        }
        else {
            eval { JSON::decode_json($json) } || {};
        }
    }
}

sub content_type {
    my $self = shift;
    $self->cache_property(
        'content_type',
        sub {
            MT::ContentType->load( $self->content_type_id || 0 );
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
        mode => 'view',
        args => {
            _type           => 'content_data',
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
        $terms = $opt ? { status => MT::ContentStatus::RELEASE() } : {};
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
        $terms = $opt ? { status => MT::ContentStatus::RELEASE() } : {};
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
            $category_id      = $by_category->{category_id};
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
    my @category_field_data
        = grep { $_->{type} eq 'categories' } @{ $content_type->fields }
        or return;
    for my $f (@category_field_data) {
        my $category_ids = $self->data->{ $f->{id} } || [];
        if ( grep { $_ == $cat->id } @{$category_ids} ) {
            return 1;
        }
    }
    0;
}

sub list_props_for_data_api {
    +{  authored_on => {
            base    => 'entry.authored_on',
            display => 'none',
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
        id => {
            base    => '__virtual.id',
            display => 'none',
        },
        identifier => {
            auto    => 1,
            display => 'none',
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        status => {
            base    => 'entry.status',
            display => 'none',
        },
    };
}

sub make_list_props {
    my $props = {};

    my $iter = MT::ContentType->load_iter;
    while ( my $content_type = $iter->() ) {
        my $key   = 'content_data.content_data_' . $content_type->id;
        my $order = 1000;
        my $field_list_props
            = _make_field_list_props( $content_type, $order );

        if ( $order < 2000 ) {
            $order = 2000;
        }
        else {
            $order = ( POSIX::floor( $order / 100 ) + 1 ) * 100;
        }

        $props->{$key} = {
            id => {
                base       => '__virtual.id',
                display    => 'force',
                order      => 100,
                html       => \&_make_id_html,
                sub_fields => [
                    {   class   => 'status',
                        label   => 'Status',
                        display => 'default',
                    },
                    {   class   => 'view-link',
                        label   => 'Link',
                        display => 'default',
                    },
                ],
            },
            author_name => {
                base  => '__virtual.author_name',
                order => $order,
            },
            authored_on => {
                auto       => 1,
                display    => 'default',
                label      => 'Publish Date',
                use_future => 1,
                order      => $order + 100,
                sort       => sub {
                    my $prop = shift;
                    my ( $terms, $args ) = @_;
                    my $dir = delete $args->{direction};
                    $dir = ( 'descend' eq $dir ) ? "DESC" : "ASC";
                    $args->{sort} = [
                        { column => $prop->col, desc => $dir },
                        { column => "id",       desc => $dir },
                    ];
                    return;
                },
            },
            created_on => {
                base  => '__virtual.created_on',
                order => $order + 200,
            },
            modified_on => {
                base  => '__virtual.modified_on',
                order => $order + 300,
            },
            unpublished_on => {
                auto    => 1,
                display => 'optional',
                label   => 'Unpublish Date',
                order   => $order + 400,
            },
            status    => { base => 'entry.status' },
            author_id => {
                base            => 'entry.author_id',
                label_via_param => sub {
                    my $prop = shift;
                    my ( $app, $val ) = @_;
                    my $author = MT->model('author')->load( $val || 0 )
                        or return $prop->error(
                        MT->translate(
                            '[_1] ( id:[_2] ) does not exists.',
                            MT->translate("Author"),
                            defined $val ? $val : ''
                        )
                        );
                    return MT->translate( 'Contents by [_1]',
                        $author->nickname );
                },
            },
            author_status => { base    => 'entry.author_status' },
            blog_name     => { display => 'none', filter_editable => 0 },
            current_context => { filter_editable => 0 },
            %{$field_list_props},
        };
    }

    return $props;
}

sub _make_id_html {
    my ( $prop, $obj ) = @_;
    my $app = MT->instance;

    my $status = $obj->status;
    my $status_class
        = $status == MT::Entry::HOLD()      ? 'Draft'
        : $status == MT::Entry::RELEASE()   ? 'Published'
        : $status == MT::Entry::REVIEW()    ? 'Review'
        : $status == MT::Entry::FUTURE()    ? 'Future'
        : $status == MT::Entry::JUNK()      ? 'Junk'
        : $status == MT::Entry::UNPUBLISH() ? 'Unpublish'
        :                                     '';
    my $lc_status_class = lc $status_class;

    my $status_icon_id
        = $status == MT::Entry::HOLD()      ? 'ic_statusdraft'
        : $status == MT::Entry::RELEASE()   ? 'ic_checkbox'
        : $status == MT::Entry::REVIEW()    ? 'ic_error'
        : $status == MT::Entry::FUTURE()    ? 'ic_time'
        : $status == MT::Entry::JUNK()      ? 'ic_error'
        : $status == MT::Entry::UNPUBLISH() ? 'ic_stop'
        :                                     '';
    my $status_icon_color_class
        = $status == MT::Entry::HOLD()      ? ''
        : $status == MT::Entry::RELEASE()   ? ' mt-icon--success'
        : $status == MT::Entry::REVIEW()    ? ' mt-icon--warning'
        : $status == MT::Entry::FUTURE()    ? ' mt-icon--info'
        : $status == MT::Entry::JUNK()      ? ' mt-icon--warning'
        : $status == MT::Entry::UNPUBLISH() ? ' mt-icon--danger'
        :                                     '';

    my $status_img = '';
    if ($status_icon_id) {
        my $static_uri = MT->static_path;
        $status_img = qq{
          <svg title="$status_class" role="img" class="mt-icon mt-icon--sm$status_icon_color_class">
              <use xlink:href="${static_uri}images/sprite.svg#$status_icon_id">
          </svg>
        };
    }

    my $id        = $obj->id;
    my $edit_link = $app->uri(
        mode => 'view',
        args => {
            _type           => 'content_data',
            id              => $obj->id,
            blog_id         => $obj->blog_id,
            content_type_id => $obj->content_type_id,
        },
    );

    my $permalink  = MT::Util::encode_html( $obj->permalink );
    my $static_uri = MT->static_path;
    my $view_link  = $status == MT::ContentStatus::RELEASE()
        ? qq{
            <span class="view-link">
              <a href="$permalink" class="d-inline-block" target="_blank">
                <svg title="View" role="img" class="mt-icon mt-icon--sm">
                  <use xlink:href="${static_uri}images/sprite.svg#ic_permalink">
                </svg>
              </a>
            </span>
        }
        : '';

    return qq{
        <span class="icon status $lc_status_class">
          <a href="$edit_link" class="d-inline-block">$status_img</a>
        </span>
        <a href="$edit_link">$id</a>
        $view_link
    };
}

sub _make_field_list_props {
    my ( $content_type, $order, $parent_field_data ) = @_;
    my $props               = {};
    my $content_field_types = MT->registry('content_field_types');

    for my $field_data ( @{ $content_type->fields } ) {
        my $idx_type   = $field_data->{type};
        my $field_key  = 'content_field_' . $field_data->{id};
        my $field_type = $content_field_types->{$idx_type} or next;

        for my $prop_name ( keys %{ $field_type->{list_props} || {} } ) {

            next
                if $parent_field_data
                && $prop_name ne $idx_type
                && !( $idx_type eq 'content_type' && $prop_name eq 'id' );

            my $label;
            if ( $prop_name eq $idx_type ) {
                $label = $field_data->{options}{label};
            }
            else {
                $label = $prop_name;
                if ( $label eq 'id' ) {
                    $label = 'ID';
                }
                else {
                    $label =~ s/^([a-z])/\u$1/g;
                    $label =~ s/_([a-z])/ \u$1/g;
                }
                $label = $field_data->{options}{label} . " ${label}";
            }
            if ($parent_field_data) {
                $label = $parent_field_data->{options}{label} . " ${label}";
            }
            $label = MT->translate($label);

            my $prop_key;
            if ( $prop_name eq $idx_type ) {
                $prop_key = $field_key;
            }
            else {
                $prop_key = "${field_key}_${prop_name}";
            }
            if ($parent_field_data) {
                my $parent_field_key
                    = 'content_field_' . $parent_field_data->{id};
                $prop_key = "${parent_field_key}_${prop_key}";
            }

            my $display
                = $parent_field_data
                ? 'none'
                : $field_data->{options}{display};

            $props->{$prop_key} = {
                (   content_field_id   => $field_data->{id},
                    data_type          => $field_type->{data_type},
                    default_sort_order => 'ascend',
                    display            => $display,
                    filter_label       => $label,
                    html               => \&_make_title_html,
                    idx_type           => $idx_type,
                    label              => $label,
                    order              => $order,
                    sort               => \&_default_sort,
                ),
                %{ $field_type->{list_props}{$prop_name} },
            };

            if ($parent_field_data) {
                my $terms = $props->{$prop_key}{terms};
                if ( $terms && !ref $terms && $terms =~ /^(sub|\$)/ ) {
                    $terms = MT->handler_to_coderef($terms);
                    $props->{$prop_key}{terms} = sub {
                        my $prop = shift;
                        my ( $args, $db_terms, $db_args ) = @_;

                        my $child_ret;
                        {
                            local $db_terms->{content_type_id}
                                = $content_type->id;
                            $child_ret = $terms->( $prop, @_ );
                        }
                        return $child_ret
                            unless $child_ret && $child_ret->{id};

                        local $prop->{content_field_id}
                            = $parent_field_data->{id};

                        my $option = $args->{option} || '';
                        if (   $option eq 'not_contains'
                            || $option eq 'not_equal' )
                        {
                            my $cd_terms;
                            if ( ref $child_ret->{id} eq 'HASH'
                                && $child_ret->{id}{not} )
                            {
                                $cd_terms = { id => $child_ret->{id}{not} };
                            }
                            else {
                                $cd_terms
                                    = { id => { not => $child_ret->{id} } };
                            }
                            my @child_contains_cd_ids
                                = map { $_->id }
                                MT::ContentData->load( $cd_terms,
                                { fetchonly => { id => 1 } } );
                            my $join_terms = { value_integer =>
                                    [ \'IS NULL', @child_contains_cd_ids ] };
                            my $cd_ids = get_cd_ids_by_left_join( $prop,
                                $join_terms, undef, @_ );
                            $cd_ids ? { id => { not => $cd_ids } } : ();
                        }
                        else {
                            my $join_terms
                                = { value_integer => $child_ret->{id} };
                            my $cd_ids = get_cd_ids_by_inner_join( $prop,
                                $join_terms, undef, @_ );
                            { id => $cd_ids };
                        }
                    };
                }
            }

            $order++;
        }

        if ( !$parent_field_data && $idx_type eq 'content_type' ) {
            my $cf = MT::ContentField->load( $field_data->{id} ) or next;
            my $related_ct = $cf->related_content_type or next;
            my $child_props
                = _make_field_list_props( $related_ct, $order, $field_data );
            $props = { %{$props}, %{$child_props} };
        }
    }

    $_[1] = $order;

    $props;
}

sub _default_sort {
    my $prop = shift;
    my ( $terms, $args ) = @_;

    my $cf_idx_join = MT::ContentFieldIndex->join_on(
        undef, undef,
        {   type      => 'left',
            condition => {
                content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            sort      => 'value_' . $prop->data_type,
            direction => delete $args->{direction},
            unique    => 1,
        },
    );

    $args->{joins} ||= [];
    push @{ $args->{joins} }, $cf_idx_join;

    return;
}

sub _make_title_html {
    my ( $prop, $content_data, $app ) = @_;

    my $label = $content_data->data->{ $prop->content_field_id };
    if ( $label && ref $label eq 'ARRAY' ) {
        my $delimiter = $app->registry('content_field_types')
            ->{ $prop->{idx_type} }{options_delimiter} || ',';
        $label = join "${delimiter} ", @$label;
    }

    $label = '' unless defined $label;
    my $can_double_encode = 1;
    $label = MT::Util::encode_html( $label, $can_double_encode );

    return qq{<span class="label">$label</span>};
}

sub _get_week_number {
    my ( $obj, $column ) = @_;
    if ( my $dt = $obj->column_as_datetime($column) ) {
        my ( $yr, $w ) = $dt->week;
        return $yr * 100 + $w;
    }
    return undef;
}

sub archive_file {
    my $self = shift;
    my ($at) = @_;
    my $blog = $self->blog or return '';
    $at ||= 'ContentType';    # should check $blog->archive_type here
    my $file = MT::Util::archive_file_for( $self, $blog, $at );
    $file = '' unless defined $file;
    return $file;
}

sub archive_url {
    my $self = shift;
    my $blog = $self->blog or return;
    my $url  = $blog->archive_url || '';
    $url .= '/' unless $url =~ m!/$!;
    $url . $self->archive_file(@_);
}

sub permalink {
    my $self                   = shift;
    my $blog                   = $self->blog or return;
    my $url                    = $self->archive_url( $_[0] );
    my $effective_archive_type = ( $_[0] || 'ContentType' );
    $url
        .= '#'
        . ( $_[1]->{valid_html} ? 'a' : '' )
        . sprintf( "%06d", $self->id )
        unless ( $effective_archive_type eq 'ContentType'
        || $_[1]->{no_anchor} );
    $url;
}

sub field_categories {
    my $self = shift;
    my ($content_field_id) = @_ or return;
    $self->cache_property(
        "field_categories:$content_field_id",
        sub {
            my $category_ids = $self->data->{$content_field_id} || [];
            return unless @$category_ids;
            return MT::Category->load(
                {   id              => $category_ids,
                    blog_id         => $self->blog_id,
                    category_set_id => { not => 0 },
                },
            );
        }
    );
}

# overrides MT::Revisable method
sub gather_changed_cols {
    my $obj = shift;
    my ( $orig, $app ) = @_;

    MT::Revisable::gather_changed_cols( $obj, @_ );
    my $changed_cols = $obj->{changed_revisioned_cols} || [];

    # Check data column.
    my $obj_data  = MT::Util::to_json( $obj->data,  { canonical => 1 } );
    my $orig_data = MT::Util::to_json( $orig->data, { canonical => 1 } );
    if ( $obj_data eq $orig_data ) {
        @$changed_cols = grep { $_ ne 'data' } @$changed_cols;
    }

    # When a content data is saved at first and 'unpublished_on' is undef,
    # 'unpublished_on' is added to 'changed_revisioned_cols'.
    unless ( $obj->id ) {
        unless ( $obj->unpublished_on ) {
            push @$changed_cols, 'unpublished_on';
        }
    }

    $obj->{changed_revisioned_cols} = @$changed_cols ? $changed_cols : undef;

    1;
}

1;

