# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CategorySet;
use strict;
use warnings;
use base qw( MT::Object );

use MT;
use MT::Blog;
use MT::Category;
use MT::ContentField;
use MT::ContentType;
use MT::ObjectCategory;

__PACKAGE__->install_properties(
    {   column_defs => {
            id        => 'integer not null auto_increment',
            blog_id   => 'integer not null',
            name      => 'string(255) not null',
            order     => 'text',
            cat_count => 'integer not null',
            ct_count  => 'integer not null',
        },
        indexes => {
            blog_id => 1,
            name    => 1,
        },
        defaults => { name => '', cat_count => 0, ct_count => 0 },
        child_of => 'MT::Blog',
        audit    => 1,
        child_classes => ['MT::Category'],
        datasource    => 'category_set',
        primary_key   => 'id',
    }
);

MT::ContentField->add_callback( 'post_save', 5, MT->component('core'),
    \&_post_update_content_type );
MT::ContentField->add_callback( 'post_remove', 5, MT->component('core'),
    \&_post_update_content_type );

sub _post_update_content_type {
    my ( $cb, $cf, $orig ) = @_;
    if ( $cf->related_cat_set_id || $orig->related_cat_set_id ) {
        if ( my $cat_set = __PACKAGE__->load( $cf->related_cat_set_id ) ) {
            $cat_set->_calculate_ct_count;
            $cat_set->SUPER::save();
        }
        if ( $cf->related_cat_set_id != $orig->related_cat_set_id ) {
            my $old_cat_set = __PACKAGE__->load( $orig->related_cat_set_id )
                or return;
            $old_cat_set->_calculate_ct_count;
            $old_cat_set->SUPER::save();
        }
    }
}

sub class_label {
    MT->translate('Category Set');
}

sub class_label_plural {
    MT->translate('Category Sets');
}

sub class_type {
    'category_set';
}

sub list_props {
    {   id => {
            base  => '__virtual.id',
            order => 100,
        },
        name => {
            base    => '__virtual.label',
            label   => 'Name',
            display => 'force',
            order   => 200,
        },
        author_name => {
            base  => '__virtual.author_name',
            order => 300,
        },
        category_count => {
            base         => '__virtual.integer',
            label        => 'Categories',
            filter_label => 'Category Count',
            col          => 'cat_count',
            display      => 'default',
            order        => 400,
        },
        content_type_count => {
            base         => '__virtual.integer',
            label        => 'Content Types',
            filter_label => 'Content Type Count',
            col          => 'ct_count',
            html_link    => \&_ct_count_html_link,
            display      => 'default',
            order        => 500,
        },
        created_on => {
            base    => '__virtual.created_on',
            order   => 600,
            display => 'default',
        },
        modified_on => {
            base    => '__virtual.modified_on',
            order   => 700,
            display => 'optional',
        },
        blog_name       => { display         => 'none' },
        current_context => { filter_editable => 0 },
        category_label  => {
            base    => '__virtual.string',
            label   => 'Category Label',
            col     => 'label',
            display => 'none',
            terms   => \&_category_label_terms,
        },
        content_type_name => {
            base    => '__virtual.string',
            label   => 'Content Type Name',
            col     => 'name',
            display => 'none',
            terms   => \&_content_type_name_terms,
        },
    };
}

sub _ct_count_html_link {
    my ( $prop, $obj, $app ) = @_;

    # TODO: permission check
    $app->uri(
        mode => 'list',
        args => {
            _type      => 'content_type',
            blog_id    => $obj->blog_id,
            filter     => 'category_set',
            filter_val => $obj->id,
        },
    );
}

sub _category_label_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option};

    if ( $option eq 'not_contains' ) {
        my $string   = $args->{string};
        my $cat_join = MT::Category->join_on(
            'category_set_id',
            { label  => { like => "%${string}%" } },
            { unique => 1 },
        );
        my @cat_set_ids;
        my $iter
            = MT::CategorySet->load_iter( { blog_id => MT->app->blog->id },
            { join => $cat_join, fetchonly => { id => 1 } } );
        while ( my $cat_set = $iter->() ) {
            push @cat_set_ids, $cat_set->id;
        }
        @cat_set_ids ? { id => { not => \@cat_set_ids } } : ();
    }
    else {
        my $query    = $prop->super(@_);
        my $cat_join = MT::Category->join_on( 'category_set_id', $query,
            { unique => 1 } );
        $db_args->{joins} ||= [];
        push @{ $db_args->{joins} }, $cat_join;
        return;
    }
}

sub _content_type_name_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option};

    if ( $option eq 'not_contains' ) {
        my $string  = $args->{string};
        my $ct_join = MT::ContentType->join_on(
            undef,
            {   id   => \'= cf_content_type_id',
                name => { like => "%${string}%" },
            }
        );
        my $cf_join = MT::ContentField->join_on(
            undef,
            {   type               => 'category',
                related_cat_set_id => \'= category_set_id',
            },
            { join => $ct_join },
        );
        my @cat_set_ids;
        my $iter = MT::CategorySet->load_iter( $db_terms,
            { join => $cf_join, fetchonly => { id => 1 } } );
        while ( my $cat_set = $iter->() ) {
            push @cat_set_ids, $cat_set->id;
        }
        @cat_set_ids ? { id => { not => \@cat_set_ids } } : ();
    }
    else {
        my $query   = $prop->super(@_);
        my $ct_join = MT::ContentType->join_on( undef,
            [ $query, { id => \'= cf_content_type_id' } ] );
        my $cf_join = MT::ContentField->join_on(
            undef,
            {   type               => 'category',
                related_cat_set_id => \'= category_set_id',
            },
            { join => $ct_join },
        );
        $db_args->{joins} ||= [];
        push @{ $db_args->{joins} }, $cf_join;
        return;
    }
}

sub save {
    my $self = shift;
    if ( $self->id ) {
        if ( my $blog = $self->blog ) {
            $self->modified_on( $blog->current_timestamp );
        }
        if ( MT->app && eval { MT->app->isa('MT::App') } && MT->app->user ) {
            $self->modified_by( MT->app->user->id );
        }

        $self->_calculate_cat_count;
        $self->_calculate_ct_count;
    }
    $self->SUPER::save(@_);
}

sub _calculate_cat_count {
    my $self = shift;
    return unless $self->id;
    my $count = MT::Category->count( { category_set_id => $self->id } );
    $self->cat_count($count);
}

sub _calculate_ct_count {
    my $self = shift;
    return unless $self->id;
    my $cf_join = MT::ContentField->join_on(
        'content_type_id',
        {   type               => 'category',
            related_cat_set_id => $self->id,
        },
    );
    my $count = MT::ContentType->count( { blog_id => $self->blog_id },
        { join => $cf_join } );
    $self->ct_count($count);
}

sub remove {
    my $self = shift;
    if ( ref $self ) {
        $self->remove_children( { key => 'category_set_id' } );
    }
    $self->SUPER::remove(@_);
}

sub blog {
    my $self = shift;
    $self->cache_property(
        'blog',
        sub {
            MT::Blog->load( $self->blog_id || 0 );
        },
    );
}

sub categories {
    my $self = shift;
    $self->cache_property(
        'categories',
        sub {
            my $join = MT::ObjectCategory->join_on(
                'category_id',
                undef,
                {   sort      => 'is_primary',
                    direction => 'descend',
                },
            );
            my @cats;
            my $iter = MT::Category->load_iter(
                { category_set_id => $self->id },
                { join            => $join },
            );
            while ( my $cat = $iter->() ) {
                push @cats, $cat;
            }
            \@cats;
        },
    );
}

1;

