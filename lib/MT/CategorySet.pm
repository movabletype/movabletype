# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
        },
        indexes => {
            blog_id => 1,
            name    => 1,
        },
        defaults => { name => '' },
        child_of      => [ 'MT::Blog', 'MT::Website' ],
        audit         => 1,
        child_classes => ['MT::Category'],
        datasource    => 'category_set',
        primary_key   => 'id',
    }
);

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
            bulk_html    => \&_cat_count_bulk_html,
            display      => 'default',
            order        => 400,
        },
        content_type_count => {
            base         => '__virtual.integer',
            label        => 'Content Types',
            filter_label => 'Content Type Count',
            bulk_html    => \&_ct_count_bulk_html,
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
        content => {
            base    => '__virtual.content',
            fields  => [qw(name)],
            display => 'none',
        },
    };
}

sub cat_count_by_blog {
    my $class      = shift;
    my ($blog_id)  = @_;
    my $count_iter = MT->model('category')->count_group_by({
            blog_id => $blog_id,
        },
        {
            group              => ['category_set_id'],
            no_category_set_id => 1,
        });
    my %count;
    while (my ($count, $set_id) = $count_iter->()) {
        $count{$set_id} = $count;
    }
    return \%count;
}

sub _cat_count_bulk_html {
    my ($prop, $objs, $app, $load_options) = @_;
    my $cat_count = __PACKAGE__->cat_count_by_blog($app->blog->id);
    my @out;
    for my $obj (@$objs) {
        my $count = $cat_count->{ $obj->id } || 0;
        push @out, $count;
    }
    return @out;
}

sub ct_count_by_blog {
    my $class     = shift;
    my ($blog_id) = @_;
    my $cf_join   = MT->model('cf')->join_on(
        'content_type_id',
        {
            type => 'categories',
        },
    );
    my $count_iter = MT->model('content_type')->count_group_by({
            blog_id => $blog_id,
        },
        {
            group => ['cf_related_cat_set_id'],
            join  => $cf_join,
        });
    my %count;
    while (my ($count, $set_id) = $count_iter->()) {
        $count{$set_id} = $count;
    }
    return \%count;
}

sub _ct_count_bulk_html {
    my ($prop, $objs, $app, $load_options) = @_;
    my $ct_count = __PACKAGE__->ct_count_by_blog($app->blog->id);
    my @out;
    for my $obj (@$objs) {
        my $count = $ct_count->{ $obj->id } || 0;
        push @out, $count;
    }
    return @out;
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
            {   type               => 'categories',
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
            {   type               => 'categories',
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
    if ( $self->is_name_empty ) {
        return $self->error( MT->translate('name is required.') );
    }
    if ( $self->exist_same_name_in_site ) {
        return $self->error(
            MT->translate( 'name "[_1]" is already used.', $self->name ) );
    }
    if ( $self->id ) {
        if ( my $blog = $self->blog ) {
            $self->modified_on( $blog->current_timestamp );
        }
        if ( MT->app && eval { MT->app->isa('MT::App') } && MT->app->user ) {
            $self->modified_by( MT->app->user->id );
        }
    }
    $self->SUPER::save(@_);
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
            my @cats;
            my $iter = MT->model('category')
                ->load_iter( { category_set_id => $self->id } );
            while ( my $c = $iter->() ) {
                push @cats, $c;
            }
            \@cats;
        },
    );
}

1;

