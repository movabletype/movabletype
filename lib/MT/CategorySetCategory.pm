# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CategorySetCategory;

use strict;
use warnings;
use base 'MT::Category';

use MT;

__PACKAGE__->install_properties(
    {   class_type    => 'category_set_category',
        child_of      => [ 'MT::Blog', 'MT::CategorySet' ],
        child_classes => [ 'MT::ObjectCategory', 'MT::FileInfo' ],
    },
);

sub list_props {
    return +{
        label       => { base => 'category.label' },
        basename    => 'Basename',
        id          => { base => 'category.id' },
        parent      => { base => 'category.parent' },
        custom_sort => {
            class     => 'category_set_category',
            bulk_sort => sub {
                my ( $prop, $objs ) = @_;
                my $rep = $objs->[0] or return;
                my $set
                    = MT->model('category_set')
                    ->load( $rep->category_set_id );
                my $text = $set->order || '';
                require MT::Category;
                my @cats = MT::Category::_sort_by_id_list(
                    $text,
                    $objs,
                    unknown_place        => 'top',
                    secondary_sort       => 'created_on',
                    secondary_sort_order => 'descend'
                );
                @cats = grep { ref $_ }
                    MT::Category::_flattened_category_hierarchy( \@cats );
                return @cats;
            },
        },
        user_custom => {
            base    => 'category_set_category.custom_sort',
            display => 'none',
        },
        content         => { base => 'category.content' },
        created_by      => { base => 'category.created_by' },
        blog_id         => { base => 'category.blog_id' },
        category_set_id => {
            auto    => 1,
            display => 'none',
        },
    };
}

sub basename_prefix {
    my $self   = shift;
    my ($dash) = @_;
    my $prefix = 'cscat';
    if ($dash) {
        $prefix .= MT->instance->config('CategoryNameNodash') ? '' : '-';
    }
    $prefix;
}

sub category_set_id {
    my $self = shift;
    $self->column( 'category_set_id', @_ );
}

sub category_set {
    my $self = shift;
    $self->cache_property(
        'cateogry_list',
        sub {
            require MT::CategorySet;
            MT::CategorySet->load( $self->category_set_id || 0 );
        },
    );
}

sub siblings {
    my $self = shift;
    $self->cache_property(
        'siblings',
        sub {
            my $pkg      = ref $self;
            my @siblings = $pkg->load(
                {   category_set_id => $self->category_set_id,
                    parent          => $self->parent,
                }
            );
            if ( $self->id ) {
                @siblings = grep { $_->id != $self->id } @siblings;
            }
            \@siblings;
        },
    );
}

1;

