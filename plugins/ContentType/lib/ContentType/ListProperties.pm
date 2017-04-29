# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package ContentType::ListProperties;

use strict;
use warnings;

use MT;
use MT::CategoryList;
use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::ContentType;
use MT::CMS::CategoryList;

sub make_listing_screens {
    my $props = {

        # entity_type => {
        #     screen_label        => 'Manage Entity Type',
        #     object_label        => 'Entity Type',
        #     object_label_plural => 'Entity Types',
        #     object_type         => 'entity_type',
        #     scope_mode          => 'this',
        #     use_filters         => 0,
        #     view                => ['system'],
        # },
        content_type => {
            screen_label        => 'Manage Content Type',
            object_label        => 'Content Type',
            object_label_plural => 'Content Types',
            object_type         => 'content_type',
            scope_mode          => 'this',
            use_filters         => 0,
            view                => [ 'website', 'blog' ],
        },
        category_list => MT::CMS::CategoryList::list_screens(),
    };

    my @content_types = MT::ContentType->load();
    foreach my $content_type (@content_types) {
        my $key = 'content_data_' . $content_type->id;

        $props->{$key} = {
            screen_label        => 'Manage ' . $content_type->name,
            object_label        => $content_type->name,
            object_label_plural => $content_type->name,
            object_type         => 'content_data',
            scope_mode          => 'this',
            use_filters         => 0,
            view                => [ 'website', 'blog' ],
            feed_link           => sub {

                # TODO: fix permission
                my ($app) = @_;
                return 1 if $app->user->is_superuser;

                if ( $app->blog ) {
                    return 1
                        if $app->user->can_do( "get_${key}_feed",
                        at_least_one => 1 );
                }
                else {
                    my $iter = MT->model('permission')->load_iter(
                        {   author_id => $app->user->id,
                            blog_id   => { not => 0 },
                        }
                    );
                    my $cond;
                    while ( my $p = $iter->() ) {
                        $cond = 1, last
                            if $p->can_do("get_${key}_feed");
                    }
                    return $cond ? 1 : 0;
                }
                0;
            },
        };
    }

    return $props;
}

sub make_list_properties {
    my $props = {

        # entity_type => {
        #     id => {
        #         base  => '__virtual.id',
        #         order => 100,
        #     },
        #     name => {
        #         base      => '__virtual.name',
        #         order     => 200,
        #         link_mode => 'cfg_entity_type',
        #         html      => sub { make_name_html(@_) },
        #     },
        # },
        content_type => {
            id => {
                base  => '__virtual.id',
                order => 100,
            },
            name => {
                base      => '__virtual.name',
                order     => 200,
                link_mode => 'cfg_content_type',
                html      => sub { make_name_html(@_) }
            },
            category_list => {
                base                  => '__virtual.single_select',
                terms                 => \&_cl_terms,
                single_select_options => \&_cl_single_select_options,
                label                 => 'Category List',
                display               => 'none',
            },
        },
        category_list => MT::CategoryList::list_props(),
    };

    my @content_types = MT::ContentType->load();
    foreach my $content_type (@content_types) {
        my $key   = 'content_data_' . $content_type->id;
        my $order = 200;
        my $field_list_props
            = _make_field_list_props( $content_type, $order );

        $props->{$key} = {
            id => {
                base  => '__virtual.id',
                order => 100,
            },
            modified_on => {
                base    => '__virtual.modified_on',
                display => 'force',
                order   => 300,
            },
            author_name => {
                base    => '__virtual.author_name',
                order   => 400,
                display => 'optional',
            },
            status     => { base => 'entry.status' },
            created_on => {
                base    => '__virtual.created_on',
                display => 'none',
            },
            author_status => { base => 'entry.author_status' },
            %{$field_list_props},
        };
    }

    return $props;
}

sub _make_field_list_props {
    my ( $content_type, $order, $parent_field ) = @_;
    my $props               = {};
    my $content_field_types = MT->registry('content_field_types');

    for my $field ( @{ $content_type->fields } ) {
        my $idx_type   = $field->{type};
        my $field_key  = 'content_field_' . $field->{id};
        my $field_type = $content_field_types->{$idx_type} or next;

        for my $prop_name ( keys %{ $field_type->{list_props} || {} } ) {

            next
                if $parent_field
                && $prop_name ne $idx_type
                && !( $idx_type eq 'content_type' && $prop_name eq 'id' );

            my $label;
            if ( $prop_name eq $idx_type ) {
                $label = $field->{name};
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
                $label = $field->{name} . " ${label}";
            }
            if ($parent_field) {
                $label = $parent_field->{name} . " ${label}";
            }
            $label = MT->translate($label);

            my $prop_key;
            if ( $prop_name eq $idx_type ) {
                $prop_key = $field_key;
            }
            else {
                $prop_key = "${field_key}_${prop_name}";
            }
            if ($parent_field) {
                my $parent_field_key = 'content_field_' . $parent_field->{id};
                $prop_key = "${parent_field_key}_${prop_key}";
            }

            my $display;
            if ($parent_field) {
                $display = 'none';
            }
            else {
                # TODO: should use $field->{options}{display}
                $display = $field->{label} ? 'force' : 'default';
            }

            $props->{$prop_key} = {
                (   content_field_id   => $field->{id},
                    data_type          => $field_type->{data_type},
                    default_sort_order => 'ascend',
                    display            => $display,
                    filter_label       => $label,
                    html               => \&make_title_html,
                    idx_type           => $idx_type,
                    label              => $label,
                    order              => $order,
                    sort               => \&_default_sort,
                ),
                %{ $field_type->{list_props}{$prop_name} },
            };

            if ($parent_field) {
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

                        local $prop->{content_field_id} = $parent_field->{id};

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
                            local $prop->{content_field_id}
                                = $parent_field->{id};
                            my $cd_ids = get_cd_ids_by_inner_join( $prop,
                                $join_terms, undef, @_ );
                            { id => $cd_ids };
                        }
                    };
                }
            }

            $order++;
        }

        if ( !$parent_field && $idx_type eq 'content_type' ) {
            my $cf = MT::ContentField->load( $field->{id} ) or next;
            my $related_ct = $cf->related_content_type or next;
            my $child_props
                = _make_field_list_props( $related_ct, $order, $field );
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

sub _cl_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;
    my $cf_join = MT::ContentField->join_on(
        'content_type_id',
        {   type                => 'category',
            related_cat_list_id => $args->{value},
        },
    );
    $db_args->{joins} ||= [];
    push @{ $db_args->{joins} }, $cf_join;
    return;
}

sub _cl_single_select_options {
    my $prop = shift;
    my @options;
    my $iter = MT::CategoryList->load_iter(
        { blog_id   => MT->app->blog->id },
        { fetchonly => { id => 1, name => 1 } },
    );
    while ( my $cl = $iter->() ) {
        my $id   = $cl->id;
        my $name = $cl->name;
        push @options, { label => "${name} (id:${id})", value => $id };
    }
    \@options;
}

sub make_name_html {
    my ( $prop, $obj, $app ) = @_;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $mode    = $prop->{link_mode};

    my $name      = MT::Util::encode_html( $obj->name );
    my $icon_url  = MT->static_path . 'images/nav_icons/color/settings.gif';
    my $edit_link = $app->uri(
        mode => $mode,
        args => {
            id      => $obj->id,
            blog_id => $blog_id,
        },
    );
    return qq{
        <span class="icon settings">
          <img src="$icon_url" />
        </span>
        <span class="sync-name">
          <a href="$edit_link">$name</a>
        </span>
    };
}

sub make_title_html {
    my ( $prop, $content_data, $app ) = @_;

    my $label = $content_data->data->{ $prop->content_field_id };
    if ( $label && ref $label eq 'ARRAY' ) {
        my $delimiter = $app->registry('content_field_types')
            ->{ $prop->{idx_type} }{options_delimiter} || ',';
        $label = join "${delimiter} ", @$label;
    }

    $label = '' unless defined $label;

    my ($field)
        = grep { $_->{id} == $prop->content_field_id }
        @{ $content_data->content_type->fields };
    if ( $field->{label} ) {
        my $edit_link = $app->uri(
            mode => 'edit_content_data',
            args => {
                blog_id         => $content_data->blog->id,
                content_type_id => $content_data->content_type_id,
                id              => $content_data->id,
            },
        );
        if ( $label eq '' ) {
            my $content_data_id = $content_data->id;
            return qq{
                <span class="label">
                    (<a href="${edit_link}">id:${content_data_id}</a>)
                </span>
            };
        }
        else {
            return qq{
                <span class="label">
                    <a href="$edit_link">$label</a>
                </span>
            };
        }
    }
    else {
        return qq{
        <span class="label">$label</span>
        };
    }
}

sub make_content_actions {
    my $props = {
        content_type => {
            new => {
                label => 'Create new content type',
                order => 100,
                mode  => 'cfg_content_type',
                class => 'icon-create',
            }
        },
    };

    my @content_types = MT::ContentType->load();
    foreach my $content_type (@content_types) {
        my $key = 'content_data_' . $content_type->id;

        $props->{$key} = {
            new => {
                label => 'Create new ' . $content_type->name,
                order => 100,
                mode  => 'edit_content_data',
                args  => {
                    blog_id         => $content_type->blog_id,
                    content_type_id => $content_type->id,
                },
                class => 'icon-create',
            }
        };
    }

    return $props;
}

sub make_list_actions {
    my $props = {

        # entity_type => {
        #     delete => {
        #         label      => 'Delete',
        #         order      => 100,
        #         mode       => 'delete',
        #         button     => 1,
        #         js_message => 'delete',
        #     }
        # },
        content_type => {
            delete => {
                label      => 'Delete',
                order      => 100,
                mode       => 'delete',
                button     => 1,
                js_message => 'delete',
            }
        },
        category_list => MT::CMS::CategoryList::list_actions(),
    };

    my @content_types = MT::ContentType->load();
    foreach my $content_type (@content_types) {
        my $key = 'content_data_' . $content_type->id;

        $props->{$key} = {
            delete => {
                label => 'Delete',
                order => 100,
                code =>
                    '$ContentType::ContentType::App::CMS::delete_content_data',
                button     => 1,
                js_message => 'delete',
            }
        };
    }

    return $props;
}

1;

