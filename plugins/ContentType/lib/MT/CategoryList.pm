package MT::CategoryList;
use strict;
use warnings;
use base qw( MT::Object );

use MT;
use MT::Blog;
use MT::ContentField;
use MT::ContentType;

__PACKAGE__->install_properties(
    {   column_defs => {
            id        => 'integer not null auto_increment',
            blog_id   => 'integer not null',
            name      => 'string(255) not null',
            order     => 'text',
            cat_count => 'integer',
            ct_count  => 'integer',
        },
        indexes => {
            blog_id => 1,
            name    => 1,
        },
        defaults => { name => '', cat_count => 0, ct_count => 0 },
        child_of => 'MT::Blog',
        audit    => 1,
        child_classes => ['MT::Category'],
        datasource    => 'category_list',
        primary_key   => 'id',
    }
);

MT::ContentField->add_callback( 'post_save', 5, MT->component('core'),
    \&_post_update_content_type );
MT::ContentField->add_callback( 'post_remove', 5, MT->component('core'),
    \&_post_update_content_type );

sub _post_update_content_type {
    my ( $cb, $cf, $orig ) = @_;
    if ( $cf->related_cat_list_id || $orig->related_cat_list_id ) {
        if ( my $cat_list = __PACKAGE__->load( $cf->related_cat_list_id ) ) {
            $cat_list->_calculate_ct_count;
            $cat_list->SUPER::save();
        }
        if ( $cf->related_cat_list_id != $orig->related_cat_list_id ) {
            my $old_cat_list = __PACKAGE__->load( $cf->related_cat_list_id )
                or return;
            $old_cat_list->_calculate_ct_count;
            $old_cat_list->SUPER::save();
        }
    }
}

sub class_label {
    MT->translate('Category List');
}

sub class_label_plural {
    MT->translate('Category Lists');
}

sub class_type {
    'category_list';
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
            base    => '__virtual.integer',
            label   => 'Categories',
            col     => 'cat_count',
            display => 'default',
            order   => 400,
        },
        content_type_count => {
            base      => '__virtual.integer',
            label     => 'Content Types',
            col       => 'ct_count',
            html_link => \&_ct_count_html_link,
            display   => 'default',
            order     => 500,
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
        blog_name => { display => 'none' },
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
            filter     => 'category_list',
            filter_val => $obj->id,
        },
    );
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
    my $count = MT::Category->count( { list_id => $self->id } );
    $self->cat_count($count);
}

sub _calculate_ct_count {
    my $self = shift;
    return unless $self->id;
    my $cf_join = MT::ContentField->join_on(
        'content_type_id',
        {   blog_id             => $self->blog_id,
            type                => 'category',
            related_cat_list_id => $self->id,
        },
    );
    my $count = MT::ContentType->count( { blog_id => $self->blog_id },
        { join => $cf_join } );
    $self->ct_count($count);
}

sub remove {
    my $self = shift;
    if ( ref $self ) {
        $self->remove_children( { key => 'list_id' } );
    }
    $self->SUPER::remove(@_);
}

sub blog {
    my $self = shift;
    $self->cache_property(
        'blog',
        sub {
            MT::Blog->load( $self->blog_id );
        },
    );
}

sub categories {
    my $self = shift;
    $self->cache_property(
        'categories',
        sub {
            [ MT->model('category')->load( { list_id => $self->id } ) ];
        },
    );
}

1;

