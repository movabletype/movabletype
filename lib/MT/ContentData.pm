# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentData;

use strict;
use warnings;

use MT::Tag;    # Holds MT::Taggable
use base qw( MT::Object MT::Taggable MT::Revisable );

use POSIX ();

use MT;
use MT::Asset;
use MT::Author;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::ContentStatus qw(status_icon);
use MT::ContentType;
use MT::ContentType::UniqueID;
use MT::ObjectAsset;
use MT::ObjectCategory;
use MT::ObjectTag;
use MT::Tag;
use MT::Serialize;
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
            'label'           => {
                type       => 'string',
                size       => 255,
                label      => 'Data Label',
                revisioned => 1,
            },
            'data' => {
                type       => 'blob',
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
                label      => 'Unpublish Date',
                revisioned => 1,
            },
            'revision'            => 'integer meta',
            'convert_breaks'      => 'string meta',    # obsolete
            'blob_convert_breaks' => 'blob meta',
            'block_editor_data'   => 'text meta',
            'week_number'         => 'integer',
        },
        indexes => {
            content_type_id => 1,
            ct_unique_id    => 1,
            status          => 1,
            unique_id       => { unique => 1 },
            label           => 1,
            site_author     => {
                columns =>
                    [ 'author_id', 'authored_on', 'blog_id', 'ct_unique_id' ],
            },
        },
        defaults        => { status => 0 },
        datasource      => 'cd',
        long_datasource => 'content_data',
        primary_key     => 'id',
        audit           => 1,
        meta            => 1,
        child_classes => [ 'MT::ContentFieldIndex', 'MT::FileInfo' ],
        child_of      => [ 'MT::Blog', 'MT::Website', 'MT::ContentType' ],
    }
);

# Register entry post-save callback for rebuild triggers
MT->add_callback( 'cms_post_save.content_data', 10, MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_content_save', @_ ); }
);
MT->add_callback( 'api_post_save.content_data', 10, MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_content_save', @_ ); }
);
MT->add_callback(
    'cms_post_bulk_save.content_data',
    10,
    MT->component('core'),
    sub {
        MT->model('rebuild_trigger')->runner( 'post_contents_bulk_save', @_ );
    }
);
MT->add_callback(
    'scheduled_content_published', 10,
    MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_content_pub', @_ ); }
);
MT->add_callback( 'unpublish_past_contents', 10, MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_content_unpub', @_ ); }
);

__PACKAGE__->add_callback(
    'post_remove',
    5,
    MT->component('core'),
    sub {
        my ( $cb, $obj, $orig ) = @_;
        $obj->remove_children;
        $obj->remove_child_junction_table_records;
        __PACKAGE__->remove_content_data_from_content_type_field($obj);
    },
);

__PACKAGE__->add_callback(
    'pre_direct_remove',
    5,
    MT->component('core'),
    sub {
        my ( $cb, $class, $terms, $args ) = @_;
        my @cds = $class->load( $terms, $args );
        for my $cd (@cds) {
            $cd->remove_children;
            $cd->remove_child_junction_table_records;
            $class->remove_content_data_from_content_type_field($cd);
        }
    },
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

    $hash->{'content_data.content_html'} = $self->_generate_content_html;

    $hash->{'content_data.permalink'} = $self->permalink;
    $hash->{'content_data.status_text'}
        = MT::ContentStatus::status_text( $self->status );
    $hash->{ 'content_data.status_is_' . $self->status } = 1;
    $hash->{'content_data.created_on_iso'}
        = sub { MT::Util::ts2iso( $self->blog_id, $self->created_on ) };
    $hash->{'content_data.modified_on_iso'}
        = sub { MT::Util::ts2iso( $self->blog_id, $self->modified_on ) };
    $hash->{'content_data.authored_on_iso'}
        = sub { MT::Util::ts2iso( $self->blog_id, $self->authored_on ) };

    # Populate author info
    my $auth = $self->author or return $hash;
    my $auth_hash = $auth->to_hash;
    $hash->{"content_data.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;

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

sub label {
    my $self = shift;
    if (@_) {
        $self->column( 'label', @_ );
    }
    else {
        if ( $self->id ) {
            my $ct = $self->content_type;
            if ( $ct->data_label ) {

                # Data label is linked to any field
                my $field = MT->model('content_field')->load(
                    {   content_type_id => $ct->id,
                        unique_id       => $ct->data_label,
                    }
                    )
                    or die MT->translate(
                    'Cannot load content field (UniqueID:[_1]).',
                    $ct->data_label );
                return $self->data->{ $field->id };
            }
            else {
                return $self->column('label');
            }
        }
        else {
            return '';
        }
    }
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
    $self->clear_cache('content_type') if $self->id;
    my $content_type = $self->content_type
        or return $self->error( MT->translate('Invalid content type') );

    unless ( $self->id ) {
        unless ( defined $self->unique_id ) {
            MT::ContentType::UniqueID::set_unique_id($self);
        }
        $self->column( 'ct_unique_id', $content_type->unique_id );
    }

    ## If there's no identifier specified, set unique_id.
    if ( !defined( $self->identifier ) || ( $self->identifier eq '' ) ) {
        $self->identifier( $self->unique_id );
    }

    require bytes;
    if ( bytes::length( $self->identifier ) > 246 ) {
        return $self->error( MT->translate("basename is too long.") );
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
        my $v = $cf_idx->$cf_idx_data_col;
        $v = '' unless defined $v;
        push @{ $cf_idx_hash{$v} ||= [] }, $cf_idx;
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

{
    my $ser = MT::Serialize->new('MT');

    sub data {
        my $obj = shift;
        if (@_) {
            my $data;
            if ( ref $_[0] ) {
                $data = $ser->serialize( \$_[0] );
            }
            else {
                $data = $_[0];
            }
            $obj->column( 'data', $data );
        }
        else {
            my $raw_data = $obj->column('data');
            return {} unless defined $raw_data;
            if ( $raw_data =~ /^SERG/ ) {
                my $data = $ser->unserialize($raw_data);
                $data ? $$data : {};
            }
            else {
                require Encode;
                require JSON;
                my $data;
                if ( Encode::is_utf8($raw_data) ) {
                    $data = eval { JSON::from_json($raw_data) } || {};
                }
                else {
                    $data = eval { JSON::decode_json($raw_data) } || {};
                }
                warn $@ if $@ && $MT::DebugMode;
                $data;
            }
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
            my $author_id = $self->author_id or return undef;
            my $req       = MT::Request->instance;
            my $cache     = $req->stash('author_cache');
            my $author    = $cache->{$author_id};
            unless ($author) {
                require MT::Author;
                $author = MT::Author->load($author_id) or return undef;
                $cache->{$author_id} = $author;
                $req->stash('author_cache', $cache);
            }
            $author;
        },
    );
}

sub modified_author {
    my $self = shift;
    $self->cache_property(
        'modified_author',
        sub {
            my $modified_by = $self->modified_by or return undef;
            my $req         = MT::Request->instance;
            my $cache       = $req->stash('author_cache');
            my $author      = $cache->{$modified_by};
            unless ($author) {
                require MT::Author;
                $author = MT::Author->load($modified_by) or return undef;
                $cache->{$modified_by} = $author;
                $req->stash('author_cache', $cache);
            }
            $author;
        },
    );
}

sub terms_for_tags {
    require MT::ContentStatus;
    return { status => MT::ContentStatus::RELEASE() };
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
    my ( $direction, $source_terms ) = @_;
    return undef unless ( $direction eq 'next' || $direction eq 'previous' );
    my $next = $direction eq 'next';

    # Deep copy
    my $terms = {};
    foreach my $key ( keys %$source_terms ) {
        $terms->{$key} = $source_terms->{$key};
    }

    $terms->{author_id} = $obj->author_id if delete $terms->{by_author};

    my ( $category_field_id, $category_id, $date_field_id, $date_field_value,
        $by );
    if ( my $id = delete $terms->{category_field} ) {
        my $cf = MT->model('cf')
            ->load_by_id_or_name( $id, $obj->content_type_id );
        $category_field_id = $cf->id if $cf;
        my @obj_cats = MT->model('objectcategory')->load(
            {   cf_id     => $category_field_id,
                object_ds => 'content_data',
                object_id => $obj->id
            }
        );
        foreach my $obj_cat (@obj_cats) {
            $category_id = $obj_cat->category_id if $obj_cat->is_primary;
        }
    }

    if ( my $id = delete $terms->{date_field} ) {
        if (   $id eq 'authored_on'
            || $id eq 'modified_on'
            || $id eq 'created_on' )
        {
            $by = $id;
        }
        else {
            my $df = MT->model('cf')->load( $id, $obj->content_type_id );
            $date_field_id = $df->id if $df;
        }
    }
    else {
        my ($map) = MT::TemplateMap->load(
            {   blog_id      => $obj->blog_id,
                archive_type => 'ContentType',
                is_preferred => 1,
            },
            {   join => MT::Template->join_on(
                    undef,
                    {   id              => \'= templatemap_template_id',
                        content_type_id => $obj->content_type_id,
                    },
                ),
            },
        );
        $date_field_id = $map->dt_field_id if $map;
    }
    if ($date_field_id) {
        my $data = $obj->data;
        $date_field_value = $data->{$date_field_id};
    }

    my $label = '__' . $direction;
    $label .= ':author=' . $terms->{author_id} if exists $terms->{author_id};
    $label .= ':by_' . $by if $by;
    $label
        .= ":category_field_id=${category_field_id}:category_id=${category_id}"
        if $category_field_id;
    $label .= ":date_field_id=${date_field_id}" if $date_field_id;
    return $obj->{$label} if $obj->{$label};

    my $args = {};

    if ($category_field_id) {
        my $join;
        if ($category_id) {
            $join = MT::ContentFieldIndex->join_on(
                'content_data_id',
                {   content_field_id => $category_field_id,
                    value_integer    => $category_id,
                },
                {   unique => 1,
                    alias  => 'category_field',
                },
            );
        }
        else {
            $join = MT::ContentFieldIndex->join_on(
                undef, undef,
                {   type      => 'left',
                    condition => {
                        content_data_id  => \'= cd_id',
                        content_field_id => $category_field_id,
                        value_integer    => \'IS NULL',
                    },
                    unique => 1,
                }
            );
        }
        push @{ $args->{joins} }, $join;
    }

    if ($date_field_id) {
        my $desc = $next ? 'ASC' : 'DESC';
        my $op   = $next ? '>'   : '<';

        my $join = MT->model('cf_idx')->join_on(
            'content_data_id',
            {   content_field_id => $date_field_id,
                value_datetime   => { $op => $date_field_value }
            },
            {   sort => [
                    { column => 'value_datetime', desc => $desc },
                    { column => 'id',             desc => $desc }
                ],
                alias => 'sort_by_date_field'
            }
        );
        push @{ $args->{joins} }, $join;
    }

    $by ||= 'authored_on';

    my $o;
    if ( $args->{joins} ) {
        $terms->{blog_id}         = $obj->blog_id;
        $terms->{content_type_id} = $obj->content_type_id;

        if ($date_field_id) {
            $o = MT::ContentData->load( $terms, $args );
        }
        else {
            my $desc = $next ? 'ASC' : 'DESC';
            my $op   = $next ? '>'   : '<';

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

sub list_props {
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
        label => {
            base    => '__virtual.label',
            display => 'force',
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

    my $common_list_props = _make_common_list_props();

    for my $content_type ( @{ MT::ContentType->load_all } ) {
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
                base    => '__virtual.id',
                display => 'optional',
                order   => 100,
            },
            label => {
                base    => '__virtual.string',
                display => 'force',
                col     => 'label',
                order   => 110,
                html    => \&_make_label_html,
                label   => sub {
                    MT->translate('Data Label');
                },
                bulk_sort => sub {
                    my $prop = shift;
                    my ( $objs, $app, $opts ) = @_;
                    return
                        sort { ( $a->label || '' ) cmp( $b->label || '' ) }
                        @$objs;
                },
                terms => sub {
                    my $prop = shift;
                    my ( $args, $db_terms, $db_args ) = @_;

                    my $content_type_id;
                    if ( ref $db_terms eq 'ARRAY' ) {
                        for my $t (@$db_terms) {
                            if ( ref $t eq 'HASH'
                                && exists $t->{content_type_id} )
                            {
                                $content_type_id = $t->{content_type_id};
                                last;
                            }
                        }
                    }
                    else {
                        $content_type_id = $db_terms->{content_type_id};
                    }
                    die MT->translate('No Content Type could be found.')
                      unless $content_type_id;
                    my $ct = MT->model('content_type')->load($content_type_id)
                      or die MT->translate( 'Cannot load content type #[_1]',
                        $content_type_id );

                    if ( !$ct->data_label ) {

                        # Use __virtual.string based filtering
                        my $code
                            = MT->handler_to_coderef( $prop->base->{terms} );
                        return $code->( $prop, @_ );
                    }
                    else {
                        # Filter by field value
                        my $option = $args->{option};
                        my $query  = $args->{string};

                        if ( 'contains' eq $option ) {
                            $query = { like => "%$query%" };
                        }
                        elsif ( 'not_contains' eq $option ) {
                            $query
                                = [ { not_like => "%$query%" }, \'IS NULL' ];
                        }
                        elsif ( 'beginning' eq $option ) {
                            $query = { like => "$query%" };
                        }
                        elsif ( 'end' eq $option ) {
                            $query = { like => "%$query" };
                        }
                        elsif ( 'blank' eq $option ) {
                            $query = [ \'IS NULL', '' ];
                        }
                        elsif ( 'not_blank' eq $option ) {
                            $query
                                = [ '-and', \'IS NOT NULL', { not => '' } ];
                        }

                        my $cf
                            = MT->model('content_field')
                            ->load( { unique_id => $ct->data_label, } )
                            or die MT->translate(
                            'Cannot load content field #[_1]',
                            $ct->data_label );
                        
                        my $data_type = $cf->data_type;

                        $db_args->{joins} ||= [];
                        push @{ $db_args->{joins} },
                            MT->model('content_field_index')->join_on(
                            undef,
                            [   
                                { content_data_id => \'= cd_id' },
                                { "value_$data_type" => $query },
                            ],
                            {   join => MT->model('content_field')->join_on(
                                    undef,
                                    {   id => \'= cf_idx_content_field_id',
                                        unique_id => $ct->data_label,
                                    },
                                ),
                                unique => 1,
                            },
                            );
                    }
                },
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
                auto    => 1,
                display => 'default',
                label   => sub {
                    MT->translate('Publish Date');
                },
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
                label   => sub {
                    MT->translate('Unpublish Date');
                },
                order => $order + 400,
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
            __mobile => { base => 'entry.__mobile', col => 'label' },
            modified_by => {
                base  => '__virtual.modified_by',
                order => $order + 500,
            },
            %{$field_list_props},
        };
        MT::__merge_hash( $props->{$key}, $common_list_props );
        if ( $content_type->_get_tag_field_ids ) {
            $props->{$key}{tags_field} = {
                base  => '__virtual.tag',
                label => sub {
                    MT->translate('Tags fields');
                },
                display         => 'none',
                filter_editable => 0,
                use_blank       => 1,
                tagged_class    => '*',
            };
        }
    }

    return $props;
}

sub _make_label_html {
    my ( $prop, $obj ) = @_;
    my $app = MT->instance;

    my $status = $obj->status;
    my $status_class
        = $status == MT::ContentStatus::HOLD()      ? 'Draft'
        : $status == MT::ContentStatus::RELEASE()   ? 'Published'
        : $status == MT::ContentStatus::REVIEW()    ? 'Review'
        : $status == MT::ContentStatus::FUTURE()    ? 'Future'
        : $status == MT::ContentStatus::JUNK()      ? 'Junk'
        : $status == MT::ContentStatus::UNPUBLISH() ? 'Unpublish'
        :                                             '';
    my $lc_status_class = lc $status_class;
    my $status_class_trans = MT->translate($status_class);

    my $status_icon_id
        = $status == MT::ContentStatus::HOLD()      ? 'ic_draft'
        : $status == MT::ContentStatus::RELEASE()   ? 'ic_checkbox'
        : $status == MT::ContentStatus::REVIEW()    ? 'ic_error'
        : $status == MT::ContentStatus::FUTURE()    ? 'ic_clock'
        : $status == MT::ContentStatus::JUNK()      ? 'ic_error'
        : $status == MT::ContentStatus::UNPUBLISH() ? 'ic_stop'
        :                                             '';
    my $status_icon_color_class
        = $status == MT::ContentStatus::HOLD()      ? ''
        : $status == MT::ContentStatus::RELEASE()   ? ' mt-icon--success'
        : $status == MT::ContentStatus::REVIEW()    ? ' mt-icon--warning'
        : $status == MT::ContentStatus::FUTURE()    ? ' mt-icon--info'
        : $status == MT::ContentStatus::JUNK()      ? ' mt-icon--warning'
        : $status == MT::ContentStatus::UNPUBLISH() ? ' mt-icon--danger'
        :                                             '';

    my $status_img = '';
    if ($status_icon_id) {
        my $static_uri = MT->static_path;
        $status_img = qq{
          <svg role="img" class="mt-icon mt-icon--sm$status_icon_color_class">
              <title>$status_class_trans</title>
              <use xlink:href="${static_uri}images/sprite.svg#$status_icon_id"></use>
          </svg>
        };
    }

    my $label = MT::Util::encode_html($obj->label || MT->translate('No Label'), 1);
    my $edit_link;
    if ( $app->user->permissions( $obj->blog_id )
        ->can_edit_content_data( $obj, $app->user ) )
    {
        $edit_link = $app->uri(
            mode => 'view',
            args => {
                _type           => 'content_data',
                id              => $obj->id,
                blog_id         => $obj->blog_id,
                content_type_id => $obj->content_type_id,
            },
        );
    }

    my $permalink  = MT::Util::encode_html( $obj->permalink );
    my $static_uri = MT->static_path;
    my $view_title = MT->translate('View Content Data');
    my $view_link  = ( $status == MT::ContentStatus::RELEASE() && $permalink )
        ? qq{
            <span class="view-link">
              <a href="$permalink" class="d-inline-block" target="_blank">
                <svg role="img" class="mt-icon mt-icon--sm">
                  <title>${view_title}</title>
                  <use xlink:href="${static_uri}images/sprite.svg#ic_permalink"></use>
                </svg>
              </a>
            </span>
        }
        : '';

    if ($edit_link) {
        return qq{
            <span class="icon status $lc_status_class">
              <a href="$edit_link" class="d-inline-block">$status_img</a>
            </span>
            <a href="$edit_link">$label</a>
            $view_link
        };
    }
    else {
        return qq{
            <span class="icon status $lc_status_class">
              $status_img
            </span>
            $label
            $view_link
        };
    }
}

sub _make_field_list_props {
    my ( $content_type, $order, $parent_field_data ) = @_;
    my $props               = {};
    my $content_field_types = MT->registry('content_field_types');

    require MT::Util::BlessedString;
    for my $field_data ( @{ $content_type->fields } ) {
        my $idx_type   = $field_data->{type};
        my $field_key  = 'content_field_' . $field_data->{id};
        my $field_type = $content_field_types->{$idx_type} or next;

        for my $prop_name ( keys %{ $field_type->{list_props} || {} } ) {
            next if $prop_name eq 'plugin';
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
                $label = MT->translate($label);
                $label = $field_data->{options}{label} . " ${label}";
            }
            if ($parent_field_data) {
                $label = $parent_field_data->{options}{label} . " ${label}";
            }
            $label = MT::Util::BlessedString->new($label);

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
                    bulk_sort          => \&_default_bulk_sort,
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

sub _default_bulk_sort {
    my $prop = shift;
    my ($objs) = @_;
    my @sorted_objs;

    my $data_type = $prop->data_type;
    my $cf_id     = $prop->content_field_id;

    if (   $data_type eq 'integer'
        || $data_type eq 'float'
        || $data_type eq 'double'
        || $data_type eq 'datetime' )
    {
        @sorted_objs = sort {
            ( _get_field_first_value( $a->data->{$cf_id} ) || 0 )
                <=> ( _get_field_first_value( $b->data->{$cf_id} ) || 0 )
        } @$objs;
    }
    else {
        @sorted_objs = sort {
            _get_field_first_value( $a->data->{$cf_id} )
                cmp _get_field_first_value( $b->data->{$cf_id} )
        } @$objs;
    }

    return @sorted_objs;
}

sub _get_field_first_value {
    my $field_data = shift;
    my $value;
    if ( ref $field_data eq 'ARRAY' ) {
        $value = $field_data->[0];
    }
    else {
        $value = $field_data;
    }
    return defined $value ? $value : '';
}

sub _make_common_list_props {
    my $props = {};
    my $common_props
        = MT->registry( 'list_properties', 'content_data' ) || {};
    for my $key ( keys %$common_props ) {
        my $prop = $common_props->{$key};
        next if $prop->{plugin}->isa('MT::Core');
        $props->{$key} = $prop;
    }
    $props;
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

    my $map = MT->publisher->archiver($at)->get_preferred_map({
        blog_id         => $blog->id,
        content_type_id => $self->content_type_id,
    });

    # Load category
    my $cat;
    if ($map && $map->cat_field_id) {
        my $obj_category = MT->model('objectcategory')->load({
            object_ds  => 'content_data',
            object_id  => $self->id,
            is_primary => 1,
            cf_id      => $map->cat_field_id,
        });
        $cat = $obj_category ? MT->model('category')->load($obj_category->category_id) : '';
    }
    my $file = MT::Util::archive_file_for($self, $blog, $at, $cat, $map);
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
            my $category_ids = $self->data->{$content_field_id} or return [];
            return [] if ref $category_ids eq 'ARRAY' && !@$category_ids;
            my @cats = MT::Category->load(
                {   id              => $category_ids,
                    blog_id         => $self->blog_id,
                    category_set_id => { not => 0 },
                },
            );
            \@cats;
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

    $obj->{changed_revisioned_cols} = $changed_cols;

    1;
}

sub preview_data {
    my $self         = shift;
    my $content_type = $self->content_type;
    return [] unless $content_type;

    my $registry = MT->registry('content_field_types');

    my $data = '';
    for my $f ( @{ $content_type->fields } ) {
        next unless defined $f->{type} && $f->{type} ne '';
        next unless $registry->{ $f->{type} };

        my $preview_handler = $registry->{ $f->{type} }{preview_handler};
        if ( $preview_handler && !ref $preview_handler ) {
            $preview_handler = MT->handler_to_coderef($preview_handler)
                or next;
        }

        my $field_data
            = $preview_handler
            ? $preview_handler->( $f, $self->data->{ $f->{id} }, $self )
            : $self->data->{ $f->{id} };
        $field_data = '' unless defined $field_data && $field_data ne '';
        my $escaped_field_data = MT::Util::encode_html($field_data);

        my $field_label = ( $f->{options} || +{} )->{label}
            || MT->translate('(No label)');

        my $escaped_field_label = MT::Util::encode_html($field_label);

        $data
            .= qq{<div class="mb-3"><div><b>$escaped_field_label:</b></div><div class="ml-5">$escaped_field_data</div></div>};
    }
    $data;
}

sub search {
    my $class = shift;
    my ( $terms, $args ) = @_;

    return $class->SUPER::search(@_)
        unless _has_content_field_sort( $args && $args->{sort} );

    my $sort      = $args->{sort};
    my $direction = $args->{direction};

    require MT::ObjectDriver::Driver::DBI;
    my $prepare_statement
        = \&MT::ObjectDriver::Driver::DBI::prepare_statement;
    no warnings 'redefine';
    local *MT::ObjectDriver::Driver::DBI::prepare_statement = sub {
        my ( $driver, $class, $orig_terms, $orig_args ) = @_;
        my $stmt = $prepare_statement->( $driver, $class, $orig_terms,
            $orig_args );

        return $stmt unless $class eq __PACKAGE__;

        my $dbd = $driver->dbd;
        my $tbl = $driver->table_for($class);
        unless ( ref $sort eq 'ARRAY' ) {
            $sort = [
                {   column => $sort,
                    desc   => $direction
                        && $direction eq 'descend' ? 'DESC' : 'ASC',
                }
                ],
                ;
        }
        my @order;
        my $sort_index = 1;
        my $from_stmt  = $stmt->from_stmt;
        for my $s (@$sort) {
            my $col = $s->{column};
            if ( $col =~ /^field:([^:]+)$/ ) {
                my $search_fields = _get_search_fields($1);
                next unless $search_fields && @$search_fields;
                my $stmt_sort;
                if ( _is_single_float_or_double_field($search_fields) ) {
                    $stmt_sort
                        = $class->_prepare_statement_for_single_number_sort(
                        search_fields => $search_fields,
                        sort_index    => $sort_index,
                        );
                }
                else {
                    if ( lc( MT->config->ObjectDriver ) =~ /mssqlserver/ ) {
                        $stmt_sort
                            = $class
                            ->_prepare_statement_for_normal_sort_on_mssql(
                            search_fields => $search_fields,
                            sort_index    => $sort_index,
                            );
                    }
                    else {
                        $stmt_sort
                            = $class->_prepare_statement_for_normal_sort(
                            search_fields => $search_fields,
                            sort_index    => $sort_index,
                            );
                    }
                }
                my $sql_sort_table
                    = '('
                    . $stmt_sort->as_sql . ')'
                    . _as_operator()
                    . " sort$sort_index";
                my $join_condition
                    = $dbd->db_column_name( $tbl, 'id', $args->{alias} )
                    . " = sort$sort_index."
                    . $driver->_decorate_column_name(
                    MT->model('content_field_index'),
                    'content_data_id' );
                ( $from_stmt || $stmt )->add_join(
                    $tbl,
                    {   condition => $join_condition,
                        table     => $sql_sort_table,
                        type      => 'left',
                    },
                );
                unshift @{ $stmt->bind }, @{ $stmt_sort->bind };
                if ($from_stmt) {
                    unshift @{ $from_stmt->bind }, @{ $stmt_sort->bind };
                }
                push @order,
                    {
                    column => "sort$sort_index",
                    desc   => $s->{desc},
                    };
                $sort_index++;
            }
            else {
                push @order,
                    {
                    column =>
                        $dbd->db_column_name( $tbl, $col, $args->{alias} ),
                    desc => $s->{desc},
                    };
            }
        }
        ( $from_stmt || $stmt )->order( \@order ) if @order;

        $stmt;
    };

    local $args->{sort};
    local $args->{direction};
    $class->SUPER::search( $terms, $args );
}

sub _as_operator {
    if ( lc MT->config->ObjectDriver eq 'oracle' ) {
        '';
    }
    else {
        ' AS';
    }
}

sub _sort_columns {
    my $class = shift;
    qw(
        value_datetime
        value_double
        value_float
        value_text
        value_varchar
        value_blob
        value_integer
    );
}

sub _prepare_statement_for_tmp {
    my $class = shift;
    my ($search_fields) = @_;

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;

    my $stmt = $dbd->sql_class->new;

    for my $col ( 'content_data_id', $class->_sort_columns ) {
        my $db_col = $driver->_decorate_column_name(
            MT->model('content_field_index'), $col );
        $stmt->add_select( $db_col => $col );
    }
    $stmt->from(
        [   $driver->table_for( MT->model('content_field') ),
            $driver->table_for( MT->model('content_field_index') ),
        ]
    );
    my $id_column
        = $driver->_decorate_column_name( MT->model('content_field'), 'id' );
    $stmt->add_complex_where(
        [   {   $id_column => \(
                    '= '
                        . $driver->_decorate_column_name(
                        MT->model('content_field_index'),
                        'content_field_id'
                        )
                ),
            },
            { $id_column => [ map { $_->id } @$search_fields ], },
        ]
    );
    $stmt->order(
        [   {   column => $driver->_decorate_column_name(
                    MT->model('content_field_index'), 'id'
                ),
                desc => 'ASC',
            }
        ]
    );

    $stmt;
}

sub _prepare_statement_for_normal_sort {
    my $class         = shift;
    my %args          = @_;
    my $search_fields = $args{search_fields};
    my $sort_index    = $args{sort_index};

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;

    my $stmt = $dbd->sql_class->new;

    my $content_data_id_col = 'content_data_id';
    my $content_data_id_db_col
        = $driver->_decorate_column_name( MT->model('content_field_index'),
        $content_data_id_col );
    $stmt->add_select( $content_data_id_db_col => $content_data_id_col );

    my $decimal_s         = _get_decimal_s();
    my $decimal_p_minus_s = _get_decimal_p_minus_s();
    my $oracle_number_format
        = ( '9' x $decimal_p_minus_s ) . '.' . ( '9' x $decimal_s );

    my $sort_col = q{''};
    for my $col ( reverse $class->_sort_columns ) {
        my $db_col = $driver->_decorate_column_name(
            MT->model('content_field_index'), $col );
        if ( lc MT->config->ObjectDriver eq 'oracle' ) {
            if ( $col eq 'value_blob' ) {
                $sort_col
                    = "NVL(LISTAGG(UTL_RAW.CAST_TO_NVARCHAR2(DBMS_LOB.SUBSTR($db_col, 4000, 1)), ',') WITHIN GROUP (ORDER BY $content_data_id_db_col), $sort_col)";
            }
            elsif ( $col eq 'value_float' || $col eq 'value_double' ) {
                $sort_col
                    = "NVL(LISTAGG(TRIM(TO_NCHAR($db_col, '$oracle_number_format')), ',') WITHIN GROUP (ORDER BY $content_data_id_db_col), $sort_col)";
            }
            elsif ( $col eq 'value_datetime' ) {
                $sort_col
                    = "NVL(LISTAGG(TO_NCHAR($db_col, 'YYYY/MM/DD HH24:MI:SS'), ',') WITHIN GROUP (ORDER BY $content_data_id_db_col), $sort_col)";
            }
            else {
                $sort_col
                    = "NVL(LISTAGG($db_col, ',') WITHIN GROUP (ORDER BY $content_data_id_db_col), $sort_col)";
            }
        }
        else {
            $sort_col = "IFNULL(GROUP_CONCAT($db_col), $sort_col)";
        }
    }
    $sort_col .= _as_operator() . " sort$sort_index";
    $stmt->add_select($sort_col);

    my $stmt_tmp = $class->_prepare_statement_for_tmp($search_fields);
    my $sql_tmp  = $stmt_tmp->as_sql;
    $stmt->from( [ "($sql_tmp)" . _as_operator() . " tmp$sort_index" ] );
    $stmt->bind( $stmt_tmp->bind );
    $stmt->group(
        [   {   column => $driver->_decorate_column_name(
                    MT->model('content_field_index'),
                    'content_data_id'
                )
            }
        ]
    );

    $stmt;
}

sub _get_decimal_s {
    my $decimal_s = MT->config->NumberFieldDecimalPlaces;
    if ( defined $decimal_s && $decimal_s =~ /^[0-9]+$/ && $decimal_s >= 0 ) {
        $decimal_s;
    }
    else {
        MT->config->default('NumberFieldDecimalPlaces');
    }
}

sub _get_decimal_p_minus_s {
    my $max_length = length( MT->config->NumberFieldMaxValue ) || 0;
    my $min_length = length( MT->config->NumberFieldMinValue ) || 0;
    my $p_minus_s = $max_length > $min_length ? $max_length : $min_length;
    if ( $p_minus_s > 0 ) {
        $p_minus_s;
    }
    else {
        length MT->config->default('NumberFieldMaxValue');
    }
}

sub _prepare_statement_for_sub_on_mssql {
    my $class = shift;
    my ( $search_fields, $sort_index ) = @_;

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;

    my $stmt = $dbd->sql_class->new;

    my $convert_to
        = lc( MT->config->ObjectDriver ) eq 'umssqlserver'
        ? 'nvarchar'
        : 'varchar';
    my $decimal_s = _get_decimal_s();
    my $decimal_p = $decimal_s + _get_decimal_p_minus_s();

    my @sort_cols;
    for my $col ( $class->_sort_columns ) {
        my $db_col = $driver->_decorate_column_name(
            MT->model('content_field_index'), $col );
        if ( $col eq 'value_varchar' || $col eq 'value_text' ) {
            push @sort_cols, "$db_col + ','";
        }
        elsif ( $col eq 'value_float' || $col eq 'value_double' ) {
            push @sort_cols,
                "CONVERT($convert_to, CAST($db_col AS decimal($decimal_p,$decimal_s))) + ','";
        }
        elsif ( $col eq 'value_datetime' ) {
            push @sort_cols, "CONVERT($convert_to, $db_col, 20) + ','";
        }
        else {
            push @sort_cols, "CONVERT($convert_to, $db_col) + ','";
        }
    }
    my $sort_col = join ',', @sort_cols;
    $stmt->add_select($sort_col);
    $stmt->from(
        [   $driver->table_for( MT->model('content_field_index') )
                . " AS sub$sort_index",
        ]
    );
    my $id_column
        = $driver->_decorate_column_name( MT->model('content_field'), 'id' );
    my $sub_cd_id_column
        = $driver->_decorate_column_name( MT->model('content_field_index'),
        'content_data_id', "sub$sort_index" );
    my $tmp_cd_id_column
        = $driver->_decorate_column_name( MT->model('content_field_index'),
        'content_data_id', "tmp$sort_index" );
    $stmt->add_complex_where(
        [   { $sub_cd_id_column => \("= $tmp_cd_id_column"), },
            { $id_column        => [ map { $_->id } @$search_fields ], },
        ]
    );
    $stmt->order(
        [   {   column => $driver->_decorate_column_name(
                    MT->model('content_field_index'), 'id'
                ),
                desc => 'ASC',
            }
        ]
    );

    $stmt;
}

sub _prepare_statement_for_normal_sort_on_mssql {
    my $class         = shift;
    my %args          = @_;
    my $search_fields = $args{search_fields};
    my $sort_index    = $args{sort_index};

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;

    my $stmt = $dbd->sql_class->new;

    my $content_data_id_col = 'content_data_id';
    $stmt->add_select(
        $driver->_decorate_column_name( MT->model('content_field_index'),
            $content_data_id_col ) => $content_data_id_col,
    );

    my $stmt_sub
        = $class->_prepare_statement_for_sub_on_mssql( $search_fields,
        $sort_index );
    my $sql_sub = $stmt_sub->as_sql;
    $stmt->add_select("($sql_sub FOR XML PATH('')) as sort$sort_index");

    $stmt->from(
        [   $driver->table_for( MT->model('content_field') ),
            $driver->table_for( MT->model('content_field_index') )
                . " AS tmp$sort_index",
        ]
    );

    my $cf_id_column
        = $driver->_decorate_column_name( MT->model('content_field'), 'id' );
    my $tmp_cf_id_column
        = $driver->_decorate_column_name( MT->model('content_field_index'),
        'content_field_id', "tmp$sort_index" );
    $stmt->add_complex_where(
        [   { $cf_id_column => \("= $tmp_cf_id_column"), },
            { $cf_id_column => [ map { $_->id } @$search_fields ], },
        ]
    );

    unshift @{ $stmt->bind }, @{ $stmt_sub->bind };

    $stmt;
}

sub _prepare_statement_for_single_number_sort {
    my $class         = shift;
    my %args          = @_;
    my $search_fields = $args{search_fields};
    my $sort_index    = $args{sort_index};

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;

    my $stmt = $dbd->sql_class->new;

    my $content_data_id_col = 'content_data_id';
    $stmt->add_select(
        $driver->_decorate_column_name( MT->model('content_field_index'),
            $content_data_id_col ) => $content_data_id_col
    );

    my $data_type = $search_fields->[0]->data_type;
    my $sort_col
        = $driver->_decorate_column_name( MT->model('content_field_index'),
        "value_$data_type" )
        . _as_operator()
        . " sort$sort_index";
    $stmt->add_select($sort_col);

    my $stmt_tmp = $class->_prepare_statement_for_tmp($search_fields);
    my $sql_tmp  = $stmt_tmp->as_sql;
    $stmt->from( [ "($sql_tmp)" . _as_operator . " tmp$sort_index" ] );
    $stmt->bind( $stmt_tmp->bind );

    $stmt;
}

sub _has_content_field_sort {
    my ($sort) = @_;
    return 0 unless $sort;
    my $has_field_prefix = sub { $_[0] =~ /^field:/ };
    if ( ref $sort ) {
        for my $s (@$sort) {
            return 1 if $has_field_prefix->( $s->{column} );
        }
    }
    else {
        return 1 if $has_field_prefix->($sort);
    }
    0;
}

sub _get_search_fields {
    my ($value) = @_;
    my @terms = (
        ( $value =~ /^[0-9]+$/ ) ? ( { id => $value }, '-or', ) : (),
        { unique_id => $value },
        '-or', { name => $value },
    );
    my $iter = MT->model('content_field')->load_iter( \@terms );
    my @search_fields;
    while ( my $content_field = $iter->() ) {
        push @search_fields, $content_field;
    }
    \@search_fields;
}

sub _is_single_float_or_double_field {
    my ($search_fields) = @_;
    return unless $search_fields && @$search_fields;
    return 0
        if ( grep { $_->type ne $search_fields->[0]->type } @$search_fields );
    my $data_type = $search_fields->[0]->data_type;
    ( $data_type eq 'float' || $data_type eq 'double' ) ? 1 : 0;
}

sub pack_revision {
    my $self   = shift;
    my $values = $self->SUPER::pack_revision(@_);
    $values->{data} = $self->data;
    $values;
}

sub convert_breaks {
    my $self = shift;
    if (@_) {
        $self->blob_convert_breaks(@_);
    }
    else {
        unless ( defined $self->blob_convert_breaks ) {
            $self->blob_convert_breaks( $self->meta('convert_breaks') );
        }
        $self->blob_convert_breaks;
    }
}

sub remove_category_from_categories_field {
    my $class = shift;
    my ($objcat) = @_;
    return unless $objcat->cf_id;
    my $cd = $class->load( $objcat->object_id || 0 );
    return unless $cd;
    $cd->_remove_data_from_fields( $objcat->category_id, $objcat->cf_id );
}

sub remove_tag_from_tags_field {
    my $class = shift;
    my ($objtag) = @_;
    return unless $objtag->cf_id;
    my $cd = $class->load( $objtag->object_id || 0 );
    return unless $cd;
    $cd->_remove_data_from_fields( $objtag->tag_id, $objtag->cf_id );
}

sub remove_asset_from_asset_field {
    my $class = shift;
    my ($objasset) = @_;
    return unless $objasset->cf_id;
    my $cd = $class->load( $objasset->object_id || 0 );
    return unless $cd;
    $cd->_remove_data_from_fields( $objasset->asset_id, $objasset->cf_id );
}

sub remove_content_data_from_content_type_field {
    my $class        = shift;
    my ($remove_cd)  = @_;
    my @ct_field_ids = map { $_->id } MT->model('content_field')->load(
        {   type                    => 'content_type',
            related_content_type_id => $remove_cd->content_type_id,
        },
        { fetchonly => { id => 1 } },
    );
    return unless @ct_field_ids;
    my $iter = $class->load_iter(
        undef,
        {   join => MT->model('content_field_index')->join_on(
                undef,
                {   content_data_id  => \'= cd_id',
                    content_field_id => \@ct_field_ids,
                    value_integer    => $remove_cd->id,
                },
            ),
            unique => 1,
        }
    );
    my @update_cds;
    while ( my $update_cd = $iter->() ) {
        push @update_cds, $update_cd;
    }
    $_->_remove_data_from_fields( $remove_cd->id, \@ct_field_ids )
        for @update_cds;
}

sub _remove_data_from_fields {
    my $self = shift;
    my ( $remove_data_id, $field_ids ) = @_;
    return unless $remove_data_id && $field_ids;
    my @field_ids = ref $field_ids ? @$field_ids : ($field_ids);
    my $changed;
    for my $field_id (@field_ids) {
        my @old_field_data = @{ $self->data->{$field_id} || [] };
        my @new_field_data = grep { $_ != $remove_data_id } @old_field_data;
        next unless @new_field_data < @old_field_data;
        $self->data( { %{ $self->data }, $field_id => \@new_field_data } );
        $changed = 1;
    }
    $self->save if $changed;
}

sub remove_child_junction_table_records {
    my $self = shift;
    MT->model('objectasset')
        ->remove_children_multi(
        { object_ds => 'content_data', object_id => $self->id } );
    MT->model('objectcategory')
        ->remove_children_multi(
        { object_ds => 'content_data', object_id => $self->id } );
    MT->model('objecttag')
        ->remove_children_multi(
        { object_datasource => 'content_data', object_id => $self->id } );
}

sub load_by_id_or_name {
    my ( $class, $id_or_name, $blog_id ) = @_;

    my $cd;
    if ( $id_or_name =~ /\A[0-9]+\z/ ) {
        $cd = $class->load($id_or_name);
        return $cd if $cd;
    }
    if ( $id_or_name =~ /\A[a-zA-Z0-9]{40}\z/ ) {
        $cd = $class->load( { unique_id => $id_or_name } );
        return $cd if $cd;
    }
    if ( defined $blog_id ) {
        $cd = $class->load( { name => $id_or_name, blog_id => $blog_id } );
    }
    $cd;
}

1;
