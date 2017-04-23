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
use MT::ContentType;
use MT::ContentField;
use MT::ContentFieldIndex;
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
        },
        category_list => MT::CategoryList::list_props(),
    };

    my $content_field_types = MT->registry('content_field_types');

    my @content_types = MT::ContentType->load();
    foreach my $content_type (@content_types) {
        my $key = 'content_data_' . $content_type->id;

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
        };

        my $order = 200;

        foreach my $f ( @{ $content_type->fields } ) {
            my $idx_type   = $f->{type};
            my $field_key  = 'content_field_' . $f->{id};
            my $field_type = $content_field_types->{$idx_type} or next;

            my $default_sort_prop = sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                $args->{joins} ||= [];
                push @{ $args->{joins} },
                    MT->model('content_field_index')->join_on(
                    undef,
                    {   content_type_id  => \'= cd_content_type_id',
                        content_data_id  => \'= cd_id',
                        content_field_id => $f->{id},
                    },
                    {   sort      => 'value_' . $field_type->{data_type},
                        direction => delete $args->{direction},
                    },
                    );
                return;
            };

            $props->{$key}{$field_key} = {
                label   => $f->{name},
                display => $f->{label}
                ? 'force'
                : 'default',    # TODO: should use $f->{options}{display}
                order            => $order,
                idx_type         => $idx_type,
                data_type        => $field_type->{data_type},
                content_field_id => $f->{id},
                html             => \&make_title_html,
                sort             => $default_sort_prop,
                terms            => \&terms_text,
                filter_tmpl      => '<mt:var name="filter_form_string">',
            };

            # set html properties of content field type to list_properties
            if ( exists $field_type->{bulk_html} ) {
                $props->{$key}{$field_key}{bulk_html}
                    = $field_type->{bulk_html};
            }
            if ( exists $field_type->{html} ) {
                $props->{$key}{$field_key}{html} = $field_type->{html};
            }
            if ( exists $field_type->{html_link} ) {
                $props->{$key}{$field_key}{html_link}
                    = $field_type->{html_link};
            }
            if ( exists $field_type->{raw} ) {
                $props->{$key}{$field_key}{raw} = $field_type->{raw};
            }

            # set sort properties of content field type to list_properties
            if ( exists $field_type->{bulk_sort} ) {
                $props->{$key}{$field_key}{bulk_sort}
                    = $field_type->{bulk_sort};
            }
            if ( exists $field_type->{sort} ) {
                $props->{$key}{$field_key}{sort} = $field_type->{sort};
            }
            if ( exists $field_type->{sort_method} ) {
                $props->{$key}{$field_key}{sort_method}
                    = $field_type->{sort_method};
            }

            if ( exists $field_type->{filter_tmpl} ) {
                $props->{$key}{$field_key}{filter_tmpl}
                    = $field_type->{filter_tmpl};
            }
            if ( exists $field_type->{single_select_options} ) {
                $props->{$key}{$field_key}{single_select_options}
                    = $field_type->{single_select_options};
            }
            if ( exists $field_type->{terms} ) {
                $props->{$key}{$field_key}{terms} = $field_type->{terms};
            }
            if ( exists $field_type->{col} ) {
                $props->{$key}{$field_key}{col} = $field_type->{col};
            }

            $order++;

            if ( $idx_type eq 'asset' ) {
                $props->{$key}{"${field_key}_author_name"} = {
                    base         => '__virtual.author_name',
                    filter_label => $f->{name} . ' Author Name',
                    display      => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::author_name_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_author_status"} = {
                    base    => 'author.status',
                    label   => $f->{name} . ' Author Status',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::author_status_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_modified_on"} = {
                    base    => '__virtual.date',
                    label   => $f->{name} . ' Date Modified',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::modified_on_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_created_on"} = {
                    base    => '__virtual.date',
                    label   => $f->{name} . ' Date Created',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::created_on_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_tag"} = {
                    base    => '__virtual.tag',
                    label   => $f->{name} . ' Tag',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::tag_terms',
                    content_field_id => $f->{id},
                    tagged_class     => '*',
                    tag_ds           => 'asset',
                };

                $props->{$key}{"${field_key}_image_width"} = {
                    base  => 'asset.image_width',
                    label => $f->{name} . ' Pixel Width',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::image_width_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_image_height"} = {
                    base  => 'asset.image_height',
                    label => $f->{name} . ' Pixel Height',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::image_width_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_missing_file"} = {
                    base  => 'asset.missing_file',
                    label => $f->{name} . ' Missing File',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::missing_file_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_label"} = {
                    base    => '__virtual.string',
                    col     => 'label',
                    label   => $f->{name} . ' Label',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::label_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_id"} = {
                    base             => '__virtual.integer',
                    col              => 'id',
                    label            => $f->{name} . ' ID',
                    display          => 'none',
                    terms            => \&terms_number,
                    data_type        => $field_type->{data_type},
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_file_name"} = {
                    base    => '__virtual.string',
                    col     => 'file_name',
                    label   => $f->{name} . ' Filename',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::label_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_file_ext"} = {
                    base    => '__virtual.string',
                    col     => 'file_ext',
                    label   => $f->{name} . ' File Extension',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::label_terms',
                    content_field_id => $f->{id},
                };

                $props->{$key}{"${field_key}_description"} = {
                    base    => '__virtual.string',
                    col     => 'description',
                    label   => $f->{name} . ' Description',
                    display => 'none',
                    terms =>
                        '$ContentType::MT::ContentFieldType::Asset::label_terms',
                    content_field_id => $f->{id},
                };
            }
        }
    }

    return $props;
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
        $label = join $delimiter, @$label;
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

sub terms_text {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $string = $args->{string};
    my $query_string
        = $args->{option} eq 'contains' ? { like => "%$string%" }
        : $args->{option} eq 'not_contains'
        ? [ { not_like => "%$string%" }, \'IS NULL' ]
        : $args->{option} eq 'equal'     ? $string
        : $args->{option} eq 'blank'     ? [ \'IS NULL', '' ]
        : $args->{option} eq 'beginning' ? { like => "$string%" }
        : $args->{option} eq 'end'       ? { like => "%$string" }
        :                                  { not_like => '%' };     # no data

    my $data_type = $prop->data_type;
    my $join      = MT::ContentFieldIndex->join_on(
        undef,
        { "value_${data_type}" => $query_string },
        {   type      => 'left',
            condition => {
                content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
        },
    );

    $db_args->{joins} ||= [];
    push @{ $db_args->{joins} }, $join;
}

sub terms_number {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;
    my $option = $args->{option};
    my $value  = $args->{value};

    my $query;
    if ( 'equal' eq $option ) {
        $query = $value;
    }
    elsif ( 'not_equal' eq $option ) {
        $query = [ { not => $value }, \'IS NULL' ];
    }
    elsif ( 'greater_than' eq $option ) {
        $query = { '>' => $value };
    }
    elsif ( 'greater_equal' eq $option ) {
        $query = { '>=' => $value };
    }
    elsif ( 'less_than' eq $option ) {
        $query = { '<' => $value };
    }
    elsif ( 'less_equal' eq $option ) {
        $query = { '<=' => $value };
    }
    elsif ( 'blank' eq $option ) {
        $query = \'IS NULL';
    }

    my $data_type = $prop->{data_type};
    my $join      = MT::ContentFieldIndex->join_on(
        undef,
        { "value_${data_type}" => $query },
        {   type      => 'left',
            condition => {
                content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
        },
    );

    $db_args->{joins} ||= [];
    push @{ $db_args->{joins} }, $join;
}

1;

