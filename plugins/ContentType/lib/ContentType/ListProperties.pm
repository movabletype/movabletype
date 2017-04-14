# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package ContentType::ListProperties;

use strict;
use warnings;

use MT;
use MT::ContentType;
use MT::ContentField;
use MT::ContentFieldIndex;

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
                terms       => sub { MT::ContentFieldIndex::make_terms(@_) },
                filter_tmpl => '<mt:var name="filter_form_string">',
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

            $order++;
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
        return qq{
        <span class="label">
          <a href="$edit_link">$label</a>
        </span>
        };
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
