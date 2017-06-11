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
use MT::Util ();
use POSIX    ();

sub make_list_properties {
    my $props = {};

    my $iter = MT::ContentType->load_iter;
    while ( my $content_type = $iter->() ) {
        my $key   = 'content_data_' . $content_type->id;
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
                base  => '__virtual.id',
                order => 100,
            },
            title => {
                base    => '__virtual.title',
                label   => 'Title',
                display => 'force',
                order   => 200,
                html    => \&_make_content_data_title_html,
            },
            modified_on => {
                base    => '__virtual.modified_on',
                display => 'force',
                order   => $order,
            },
            author_name => {
                base    => '__virtual.author_name',
                order   => $order + 100,
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

sub _make_content_data_title_html {
    my $prop = shift;
    my ( $obj, $app ) = @_;
    my $col       = $prop->col;
    my $alt_label = $prop->alternative_label;
    my $id        = $obj->id;
    my $label     = $obj->$col;
    $label = '' if !defined $label;
    $label =~ s/^\s+|\s+$//g;
    my $blog_id           = $app->blog ? $app->blog->id : 0;
    my $datasource        = $app->param('datasource');
    my ($content_type_id) = $datasource =~ /(\d+)$/;
    my $edit_link         = $app->uri(
        mode => 'edit_content_data',
        args => {
            id              => $id,
            blog_id         => $blog_id,
            content_type_id => $content_type_id,
        },
    );

    if ( defined $label && $label ne '' ) {
        my $can_double_encode = 1;
        $label = MT::Util::encode_html( $label, $can_double_encode );
        return qq{<a href="$edit_link">$label</a>};
    }
    else {
        return MT->translate(
            qq{[_1] (<a href="[_2]">id:[_3]</a>)},
            $alt_label ? $alt_label : 'No ' . $label,
            $edit_link, $id,
        );
    }
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
                    html               => \&make_title_html,
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

sub make_title_html {
    my ( $prop, $content_data, $app ) = @_;

    my $label = $content_data->data->{ $prop->content_field_id };
    if ( $label && ref $label eq 'ARRAY' ) {
        my $delimiter = $app->registry('content_field_types')
            ->{ $prop->{idx_type} }{options_delimiter} || ',';
        $label = join "${delimiter} ", @$label;
    }

    $label = '' unless defined $label;

    return qq{<span class="label">$label</span>};
}

1;

