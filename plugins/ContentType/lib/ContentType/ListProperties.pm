# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package ContentType::ListProperties;

use strict;
use warnings;

use MT::ContentType;
use MT::Entity;
use MT::ContentFieldIndex;

sub make_listing_screens {
    my $props = {
        entity_type => {
            screen_label        => 'Manage Entity Type',
            object_label        => 'Entity Type',
            object_label_plural => 'Entity Types',
            object_type         => 'entity_type',
            scope_mode          => 'this',
            use_filters         => 0,
            view                => ['system'],
        },
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
        entity_type => {
            id => {
                base  => '__virtual.id',
                order => 100,
            },
            name => {
                base      => '__virtual.name',
                order     => 200,
                link_mode => 'cfg_entity_type',
                html      => sub { make_name_html(@_) },
            },
        },
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

        my $json = $content_type->entities();
        require JSON;
        my $entities = $json ? JSON::decode_json($json) : [];
        my $order = 200;

        foreach my $entity (@$entities) {
            my $idx_type   = $entity->{type};
            my $entity_key = 'entity_' . $entity->{id};
            $props->{$key}{$entity_key} = {
                label     => $entity->{name},
                display   => ( $entity->{label} ? 'force' : 'none' ),
                order     => $order,
                idx_type  => $idx_type,
                entity_id => $entity->{id},
                html      => (
                    $entity->{label} ? ( sub { make_title_html(@_) } ) : ''
                ),
                terms => sub { MT::ContentFieldIndex::make_terms(@_) },
                filter_tmpl => '<mt:var name="filter_form_string">',
            };
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
    my ( $prop, $obj, $app ) = @_;
    require JSON;
    my $content_type = MT::ContentType->load( $obj->ct_id );
    my $json         = $content_type->entities();
    my $entities     = $json ? JSON::decode_json($json) : [];
    my @label        = grep { $_->{label} } @$entities;
    my $hash         = JSON::decode_json( $obj->data );
    my $label        = '';
    foreach my $key ( keys(%$hash) ) {
        $label = $hash->{$key} if $key == $label[0]->{id};
    }
    my $edit_link = $app->uri(
        mode => 'edit_content_data',
        args => {
            blog_id         => $app->blog->id,
            content_type_id => $obj->ct_id,
            id              => $obj->id,
        },
    );
    return qq{
        <span class="label">
          <a href="$edit_link">$label</a>
        </span>
    };
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
        entity_type => {
            delete => {
                label      => 'Delete',
                order      => 100,
                mode       => 'delete',
                button     => 1,
                js_message => 'delete',
            }
        },
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
                label      => 'Delete',
                order      => 100,
                mode       => 'delete',
                button     => 1,
                js_message => 'delete',
            }
        };
    }

    return $props;
}

1;
