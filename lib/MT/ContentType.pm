# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentType;

use strict;
use base qw( MT::Object );

use MT;
use MT::CategorySet;
use MT::ContentField;
use MT::ContentType::UniqueID;
use MT::Serialize;
use MT::Util;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'               => 'integer not null auto_increment',
            'blog_id'          => 'integer not null',
            'name'             => 'string(255)',
            'description'      => 'text',
            'version'          => 'integer',
            'unique_id'        => 'string(40) not null',
            'data_label'       => 'string(40)',
            'fields'           => 'blob',
            'user_disp_option' => 'boolean',
        },
        indexes => {
            blog_id   => 1,
            unique_id => { unique => 1 }
        },
        datasource    => 'content_type',
        primary_key   => 'id',
        audit         => 1,
        child_of      => [ 'MT::Blog', 'MT::Website' ],
        child_classes => [ 'MT::ContentData', 'MT::ContentField' ],
    }
);

__PACKAGE__->add_callback( 'post_save', 5, MT->component('core'),
    \&_post_save );

__PACKAGE__->add_callback( 'post_remove', 5, MT->component('core'),
    \&_post_remove );

sub class_label {
    MT->translate("Content Type");
}

sub class_label_plural {
    MT->translate("Content Types");
}

sub list_props {
    {   id => {
            base  => '__virtual.id',
            order => 100,
        },
        name => {
            base      => '__virtual.name',
            order     => 200,
            link_mode => 'view',
            html      => \&_make_name_html,
        },
        author_name => { base => '__virtual.author_name', order => 300 },
        created_on => {
            base    => '__virtual.created_on',
            order   => 350,
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'default',
            order   => 400,
        },
        category_set => {
            base                  => '__virtual.single_select',
            terms                 => \&_cs_terms,
            single_select_options => \&_cs_single_select_options,
            label                 => 'Category Set',
            display               => 'none',
        },
        blog_name => { display => 'none', filter_editable => 0 },
        current_context => { filter_editable => 0 },
        content_count   => {
            label        => 'Content Data',
            filter_label => 'Content Data Count',
            display      => 'default',
            order        => 500,
            base         => '__virtual.object_count',
            col_class    => 'num',
            count_class  => 'content_data',
            count_col    => 'content_type_id',
            filter_type  => 'content_type_id',
            html         => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                my $count = $prop->raw(@_);
                my $user  = $app->user;
                my $perm  = $user->permissions( $obj->blog_id );

                return $count
                    unless $perm->can_do('access_to_content_data_list')
                    || $perm->can_do(
                    'access_to_content_data_list_' . $obj->unique_id );

                my $args;
                $args = {
                    _type   => 'content_data',
                    type    => 'content_data_' . $obj->id,
                    blog_id => $obj->blog_id,
                };
                my $uri = $app->uri(
                    mode => 'list',
                    args => $args,
                );
                return qq{<a href="$uri">$count</a>};
            },
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw(name)],
            display => 'none',
        },
    };
}

sub _cs_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;
    my $cf_join = MT::ContentField->join_on(
        'content_type_id',
        {   type               => 'categories',
            related_cat_set_id => $args->{value},
        },
    );
    $db_args->{joins} ||= [];
    push @{ $db_args->{joins} }, $cf_join;
    return;
}

sub _cs_single_select_options {
    my $prop = shift;
    my @options;
    my $iter = MT::CategorySet->load_iter(
        { blog_id   => MT->app->blog->id },
        { fetchonly => { id => 1, name => 1 } },
    );
    while ( my $cs = $iter->() ) {
        my $id   = $cs->id;
        my $name = $cs->name;
        push @options, {
            label => sub {
                MT->translate( '[_1] (ID:[_2])', $name, $id );
            },
            value => $id
        };
    }
    \@options;
}

sub _make_name_html {
    my ( $prop, $obj, $app ) = @_;
    my $blog_id = $app->param('blog_id');
    my $mode    = $prop->{link_mode};

    my $name      = MT::Util::encode_html( $obj->name );
    my $edit_link = $app->uri(
        mode => $mode,
        args => {
            _type   => 'content_type',
            id      => $obj->id,
            blog_id => $blog_id,
        },
    );
    return qq{
        <span class="sync-name">
          <a href="$edit_link">$name</a>
        </span>
    };
}

sub unique_id {
    my $self = shift;
    if ( $self->id || !@_ ) {
        $self->column('unique_id');
    }
    else {
        $self->column( 'unique_id', @_ );
    }
}

sub is_name_empty {
    my $self = shift;
    !( defined $self->name && $self->name ne '' );
}

sub exist_same_name_in_site {
    my $self = shift;
    __PACKAGE__->exist(
        {   blog_id => $self->blog_id,
            name    => $self->name,
            $self->id ? ( id => { not => $self->id } ) : (),
        }
    );
}

sub save {
    my $self = shift;

    if ( $self->is_name_empty ) {
        return $self->error( MT->translate('name is required.') );
    }
    if ( $self->exist_same_name_in_site ) {
        return $self->error(
            MT->translate( 'name "[_1]" is already used.', $self->name ) );
    }

    if ( !$self->id && !defined $self->unique_id ) {
        MT::ContentType::UniqueID::set_unique_id($self);
    }
    delete $self->{__cached_fields};

    $self->SUPER::save(@_);
}

{
    my $ser = MT::Serialize->new('MT');

    sub fields {
        my $obj = shift;
        if (@_) {
            my @fields        = ref $_[0] eq 'ARRAY' ? @{ $_[0] } : @_;
            my $sorted_fields = _sort_fields( \@fields );
            my $data          = $ser->serialize( \$sorted_fields );
            $obj->column( 'fields', $data );
        }
        else {
            return $obj->{__cached_fields}
                if exists $obj->{__cached_fields}
                && !$obj->is_changed('fields');
            my $raw_data = $obj->column('fields');
            return $obj->{__cached_fields} = [] unless defined $raw_data;
            if ( $raw_data =~ /^SERG/ ) {
                my $fields = $ser->unserialize( $obj->column('fields') );
                $obj->{__cached_fields}
                    = _sort_fields( $fields ? $$fields : [] );
            }
            else {
                require JSON;
                my $fields = eval { JSON::decode_json($raw_data) } || [];
                warn $@ if $@ && $MT::DebugMode;
                $obj->{__cached_fields} = _sort_fields($fields);
            }
        }
    }
}

sub replaceable_fields {
    my $obj    = shift;
    my $fields = $obj->fields;
    my @replaceable_fields;
    for my $f (@$fields) {
        my $field_registry = MT->registry( 'content_field_types', $f->{type} )
            or next;
        if (   $field_registry->{replaceable}
            || $field_registry->{replace_handler} )
        {
            push @replaceable_fields, $f;
        }
    }
    \@replaceable_fields;
}

sub searchable_fields {
    my $obj    = shift;
    my $fields = $obj->fields;
    my @searchable_fields;
    for my $f (@$fields) {
        if ( $obj->_is_searchable_field_type( $f->{type} ) ) {
            push @searchable_fields, $f;
        }
    }
    \@searchable_fields;
}

sub searchable_field_types_for_search {
    my $class = shift;
    my @field_types;
    my $field_registry = MT->registry('content_field_types');
    for my $type ( keys %$field_registry ) {
        next unless $class->_is_searchable_field_type($type);

        my $data_type = $field_registry->{$type}{data_type};
        next unless $class->_is_searchable_data_type_for_search($data_type);

        push @field_types, $type;
    }
    \@field_types;
}

sub _is_searchable_data_type_for_search {
    my $class = shift;
    my ($data_type) = @_;
    (          $data_type eq 'varchar'
            || $data_type eq 'text'
            || $data_type eq 'float'
            || $data_type eq 'double' ) ? 1 : 0;
}

sub _is_searchable_field_type {
    my $class          = shift;
    my ($field_type)   = @_;
    my $field_registry = MT->registry( 'content_field_types', $field_type )
        or return 0;
    (          $field_registry->{replaceable}
            || $field_registry->{replace_handler}
            || $field_registry->{searchable}
            || $field_registry->{search_handler} ) ? 1 : 0;
}

sub _sort_fields {
    my $fields = shift;
    return [] unless $fields && ref $fields eq 'ARRAY';
    my @sorted_fields
        = sort { ( $a->{order} || 0 ) <=> ( $b->{order} || 0 ) } @{$fields};
    \@sorted_fields;
}

sub get_field {
    my $self = shift;
    my ($field_id) = @_ or return;
    my ($field)
        = grep { $_->{id} && $field_id && $_->{id} == $field_id }
        @{ $self->fields };
    $field;
}

sub label_field {
    my $self = shift;
    @{ $self->fields } ? $self->fields->[0] : undef;
}

sub field_objs {
    my $obj = shift;
    my @field_objs
        = map { MT->model('content_field')->load( $_->{id} || 0 ) }
        @{ $obj->fields };
    return \@field_objs;
}

sub permissions {
    my $self = shift;
    return +{ $self->permission, %{ $self->field_permissions } };
}

sub permission {
    my $self = shift;
    (   $self->_manage_content_data_permission,
        $self->_create_content_data_permission,
        $self->_publish_content_data_permission,
        $self->_edit_all_content_data_permission,
    );
}

sub _manage_content_data_permission {
    my $self = shift;

    my $field_permission = $self->field_permissions;

    my @permissions = (
        $self->_create_content_data_permission,
        $self->_publish_content_data_permission,
        $self->_edit_all_content_data_permission,
        %$field_permission,
    );
    my @perms = grep { ref $_ ne 'HASH' } @permissions;

    my $permission_name = 'blog.manage_content_data:' . $self->unique_id;
    (   $permission_name => {
            group => $self->permission_group,
            label => sub {
                MT->translate('Manage Content Data');
            },
            order                  => 100,
            content_type_unique_id => $self->unique_id,
            inherit_from           => \@perms,
        }
    );
}

sub _create_content_data_permission {
    my $self            = shift;
    my $permission_name = 'blog.create_content_data:' . $self->unique_id;
    (   $permission_name => {
            group => $self->permission_group,
            label => sub {
                MT->translate('Create Content Data');
            },
            order            => 200,
            permitted_action => {
                'access_to_content_data_list_' . $self->unique_id       => 1,
                'create_new_content_data_' . $self->unique_id           => 1,
                'search_content_data_' . $self->unique_id               => 1,
                'edit_own_unpublished_content_data_' . $self->unique_id => 1,
                'access_to_insert_asset_list'                           => 1,
                'insert_asset'                                          => 1,
                'use_tools:search'                                      => 1,
            },
            content_type_unique_id => $self->unique_id,
        }
    );
}

sub _publish_content_data_permission {
    my $self = shift;

    my @permissions = ( $self->_create_content_data_permission, );
    my @perms = grep { ref $_ ne 'HASH' } @permissions;

    my $permission_name = 'blog.publish_content_data:' . $self->unique_id;
    (   $permission_name => {
            group => $self->permission_group,
            label => sub {
                MT->translate('Publish Content Data');
            },
            order            => 300,
            permitted_action => {
                'access_to_content_data_list_' . $self->unique_id     => 1,
                'edit_own_published_content_data_' . $self->unique_id => 1,
                'publish_own_content_data_' . $self->unique_id        => 1,
                'set_entry_draft_via_list_' . $self->unique_id        => 1,
                'publish_content_data_via_list_' . $self->unique_id   => 1,
                'search_content_data_' . $self->unique_id             => 1,
                'use_tools:search'                                    => 1,
            },
            content_type_unique_id => $self->unique_id,
            inherit_from           => \@perms,
        }
    );
}

sub _edit_all_content_data_permission {
    my $self            = shift;
    my $permission_name = 'blog.edit_all_content_data:' . $self->unique_id;
    (   $permission_name => {
            group => $self->permission_group,
            label => sub {
                MT->translate('Edit All Content Data');
            },
            order            => 400,
            permitted_action => {
                'access_to_content_data_list_' . $self->unique_id       => 1,
                'edit_all_content_data_' . $self->unique_id             => 1,
                'edit_all_published_content_data_' . $self->unique_id   => 1,
                'edit_all_unpublished_content_data_' . $self->unique_id => 1,
                'publish_all_content_data_' . $self->unique_id          => 1,
                'set_entry_draft_via_list_' . $self->unique_id          => 1,
                'search_content_data_' . $self->unique_id               => 1,
                'access_to_insert_asset_list'                           => 1,
                'insert_asset'                                          => 1,
                'use_tools:search'                                      => 1,
            },
            content_type_unique_id => $self->unique_id,
        }
    );
}

sub field_permissions {
    my $obj = shift;
    my %permissions;
    my $order = 500;
    for my $f ( @{ $obj->field_objs } ) {
        %permissions = ( %permissions, %{ $f->permission($order) } );
        $order += 100;
    }
    return \%permissions;
}

sub permission_group {
    my $obj  = shift;
    my $name = $obj->name;
    my $site = $obj->blog or return MT->translate( '[_1]', $name );
    return MT->translate( '"[_1]" (Site: "[_2]" ID: [_3])',
        $name, $site->name, $site->id );
}

sub blog {
    my ($obj) = @_;
    $obj->cache_property(
        'blog',
        sub {
            my $blog_id = $obj->blog_id;
            require MT::Blog;
            MT::Blog->load($blog_id)
                or $obj->error(
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

# class method
sub permission_groups {
    my $class  = shift;
    my @groups = map {
        +{  ct_perm_group_unique_id => $_->unique_id,
            ct_perm_group_label     => $_->permission_group,
            }
    } grep { $_->blog } @{ $class->load_all };
    return \@groups;
}

sub _eval_if_mssql_server_or_oracle {
    my ($sub) = @_;
    my $using_mssql_server_or_oracle
        = lc( MT->config->ObjectDriver ) =~ /mssqlserver|oracle/;
    $using_mssql_server_or_oracle ? eval { $sub->() } : $sub->();
}

# class method
sub all_permissions {
    my $class = shift;
    my @all_permissions;
    my @content_types
        = _eval_if_mssql_server_or_oracle( sub { @{ $class->load_all } } );
    for my $content_type (@content_types) {
        push( @all_permissions, $content_type->permissions )
            if $content_type->blog;
    }
    my %all_permission = map { %{$_} } @all_permissions;
    return \%all_permission;
}

sub _post_save {
    my ( $cb, $obj, $original ) = @_;

    MT->app->reboot;
}

sub _post_remove {
    my ( $cb, $obj, $original ) = @_;

    $obj->remove_children( { key => 'content_type_id' } );

    my @perm_names = (
        'manage_content_data:' . $obj->unique_id,
        'create_content_data:' . $obj->unique_id,
        'publish_content_data:' . $obj->unique_id,
        'edit_all_content_data:' . $obj->unique_id,
    );

    require MT::Role;
    my @roles = MT::Role->load(
        {   'permissions' =>
                { like => '%_content_data:' . $obj->unique_id . '%' }
        },
    );
    foreach my $role (@roles) {
        my $permissions = $role->permissions;
        my @permissions = split ',', $permissions;

        foreach my $perm_name (@perm_names) {
            @permissions = grep { $_ !~ /$perm_name/ } @permissions;
            @permissions = map { $_ =~ s/'//g; $_; } @permissions;
        }
        $role->clear_full_permissions;
        $role->set_these_permissions(@permissions);
        $role->save;
    }

    MT->app->reboot;
}

sub generate_object_log_class {
    my $self = shift;
    return unless $self->id;

    eval $self->_generate_object_log_code;
    die $@ if $@;
}

sub _generate_object_log_code {
    my $self = shift;
    my $id   = $self->id;

    return <<"__CODE__";
package MT::Log::ContentData${id};
use strict;
use warnings;
use base qw( MT::Log );

use MT;

__PACKAGE__->install_properties({ class_type => 'content_data_${id}' });

sub class_label {
    MT->translate('Content Data');
}

sub metadata_class {
    'MT::ContentData';
}

sub description {
    my \$self = shift;
    if ( my \$content_data = \$self->metadata_object ) {
        \$content_data->to_hash->{'cd.text_html'};
    } else {
        MT->translate( 'Content Data # [_1] not found.', \$self->metadata );
    }
}

1;
__CODE__
}

sub get_related_content_type_loop {
    my $class = shift;
    my ( $blog_id, $content_type_id ) = @_;

    my $parent_content_type_ids;
    if ($content_type_id) {
        $parent_content_type_ids
            = MT::ContentField->get_parent_content_type_ids($content_type_id);
        push @{ $parent_content_type_ids ||= [] }, $content_type_id;
    }

    my $iter = __PACKAGE__->load_iter(
        {   $parent_content_type_ids
            ? ( id => { not => $parent_content_type_ids } )
            : (),
            blog_id => $blog_id,
        },
        { fetchonly => { id => 1, name => 1 } }
    );
    my @loop;
    while ( my $ct = $iter->() ) {
        push @loop,
            {
            id   => $ct->id,
            name => $ct->name,
            };
    }
    \@loop;
}

sub is_parent_content_type_id {
    my $self = shift;
    my ($content_type_id) = @_;
    return unless $content_type_id && $self->id;
    return MT::ContentField->is_parent_content_type_id( $content_type_id,
        $self->id );
}

sub get_first_category_field_id {
    my $self = shift;
    for my $f ( @{ $self->fields } ) {
        if ( $f->{type} eq 'categories' ) {
            return $f->{id};
        }
    }
    undef;
}

sub has_multi_line_text_field {
    my $self = shift;
    ( grep { $_->{type} && $_->{type} eq 'multi_line_text' }
            @{ $self->fields } ) ? 1 : 0;
}

sub load_all {
    my $class      = shift;
    my $r          = MT->request;
    my $cache_key  = 'MT::ContentType::load_all';
    my $cache_data = $r->cache($cache_key);
    return $cache_data if $cache_data;
    $cache_data = [
        $class->load(
            undef,
            {   sort => [
                    {   column => 'blog_id',
                        desc   => 'ASC',
                    },
                    {   column => 'name',
                        desc   => 'ASC',
                    },
                ],
            }
        )
    ];
    $r->cache( $cache_key, $cache_data );
}

sub make_tag_list_props {
    my $class      = shift;
    my $order      = 500;
    my $list_props = {};
    for my $content_type ( @{ $class->load_all } ) {
        next unless $content_type->_get_tag_field_ids;
        $list_props = {
            %$list_props,
            %{ $content_type->_make_tag_list_prop_count($order) },
            %{ $content_type->_make_tag_list_prop_filter },
        };
        $order += 100;
    }
    $list_props;
}

sub _make_tag_list_prop_count {
    my $self           = shift;
    my ($order)        = @_;
    my $id             = $self->id;
    my $blog_id        = $self->blog_id;
    my $unique_id      = $self->unique_id;
    my @tags_field_ids = @{ $self->_get_tag_field_ids || [] };
    {   "site_${blog_id}_id_${id}_count" => {
            label       => $self->name,
            base        => '__virtual.integer',
            display     => 'default',
            order       => $order,
            view        => [ 'website', 'blog' ],
            view_filter => 'none',
            condition   => sub {
                my $blog = MT->app->blog or return;
                $blog->id == $blog_id;
            },
            raw => sub {
                my ( $prop, $obj ) = @_;
                my $blog_id = MT->app->param('blog_id') || 0;
                my $iter = MT->model('objecttag')->count_group_by(
                    {   $blog_id ? ( blog_id => $blog_id ) : (),
                        tag_id            => $obj->id,
                        object_datasource => 'content_data',
                        cf_id => @tags_field_ids ? \@tags_field_ids : 0,
                    },
                    {   sort      => 'cnt',
                        direction => 'descend',
                        group     => [ 'tag_id', 'object_id', 'cf_id' ],
                    },
                );
                my $total = 0;
                while( my ( $count, @ids ) = $iter->() ) {
                    $total += $count;
                }
                $total;
            },
            html_link => sub {
                my ( $prop, $obj, $app ) = @_;
                return
                    unless $app->can_do(
                    "access_to_content_data_list_$unique_id")
                    || $app->can_do('access_to_content_data_list');
                $app->uri(
                    mode => 'list',
                    args => {
                        _type      => 'content_data',
                        type       => 'content_data_' . $self->id,
                        blog_id    => $app->param('blog_id') || 0,
                        filter     => 'tags_field',
                        filter_val => $obj->name,
                    },
                );
            },
            bulk_sort => sub {
                my $prp = shift;
                my ( $objs, $options ) = @_;
                my $iter = MT->model('objecttag')->count_group_by(
                    {   $options->{blog_id}
                        ? ( blog_id => $options->{blog_id} )
                        : (),
                        object_datasource => 'content_data',
                        cf_id             => \@tags_field_ids,
                    },
                    {   sort      => 'cnt',
                        direction => 'ascend',
                        group     => [ 'tag_id', 'object_id', 'cf_id' ],
                    },
                );
                my %counts;
                while ( my ( $cnt, $id ) = $iter->() ) {
                    $counts{$id} = $cnt;
                }
                return sort {
                    ( $counts{ $a->id } || 0 ) <=> ( $counts{ $b->id } || 0 )
                } @$objs;
            },
        },
    };
}

sub _make_tag_list_prop_filter {
    my $self           = shift;
    my $id             = $self->id;
    my $blog_id        = $self->blog_id;
    my @tags_field_ids = @{ $self->_get_tag_field_ids || [] };
    {   "for_site_${blog_id}_id_${id}" => {
            base  => '__virtual.hidden',
            label => sub {
                MT->translate( 'Tags with [_1]', $self->name );
            },
            display   => 'none',
            view      => [ 'website', 'blog' ],
            singleton => 1,
            condition => sub {
                my $blog = MT->app->blog or return;
                $blog->id == $blog_id;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args, $options ) = @_;
                my $blog_id = $options->{blog_ids};
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('objecttag')->join_on(
                    'tag_id',
                    {   object_datasource => 'content_data',
                        cf_id => @tags_field_ids ? \@tags_field_ids : 0,
                    },
                    {   group  => ['tag_id'],
                        unique => 1,
                    },
                    );
                return;
            },
        },
    };
}

sub make_tag_system_filters {
    my $class          = shift;
    my $order          = 400;
    my $system_filters = {};
    for my $content_type ( @{ $class->load_all } ) {
        next unless $content_type->_get_tag_field_ids;
        $system_filters = {
            %$system_filters,
            %{ $content_type->_make_tag_system_filter($order) },
        };
        $order += 100;
    }
    $system_filters;
}

sub _make_tag_system_filter {
    my $self    = shift;
    my ($order) = @_;
    my $id      = $self->id;
    my $blog_id = $self->blog_id;
    {   "site_${blog_id}_id_${id}" => {
            label => sub {
                MT->translate( 'Tags with [_1]', $self->name );
            },
            view => [ 'website', 'blog' ],
            items     => [ { type => "for_site_${blog_id}_id_${id}" } ],
            order     => $order,
            condition => sub {
                my $blog = MT->app->blog or return;
                $blog->id == $blog_id;
            },
        }
    };
}

sub _get_tag_field_ids {
    my $self = shift;
    $self->cache_property(
        '_get_tag_field_ids',
        sub {
            my @ids = map { $_->{id} }
                grep { $_->{type} eq 'tags' } @{ $self->fields };
            @ids ? \@ids : undef;
        },
    );
}

sub categories_fields {
    my $self = shift;
    my @fields;
    for my $field_hash ( @{ $self->fields } ) {
        next
            unless $field_hash
            && %$field_hash
            && ( $field_hash->{type} || '' ) eq 'categories';
        push @fields, $field_hash;
    }
    return \@fields;
}

sub load_by_id_or_name {
    my ( $class, $id_or_name, $blog_id ) = @_;

    my $ct;
    if ( $id_or_name =~ /\A[0-9]+\z/ ) {
        $ct = $class->load($id_or_name);
        return $ct if $ct;
    }
    if ( $id_or_name =~ /\A[a-zA-Z0-9]{40}\z/ ) {
        $ct = $class->load( { unique_id => $id_or_name } );
        return $ct if $ct;
    }
    if ( defined $blog_id ) {
        $ct = $class->load( { name => $id_or_name, blog_id => $blog_id } );
    }
    $ct;
}

1;
