package MT::CategoryList;
use strict;
use warnings;
use base qw( MT::Object );

use MT;

__PACKAGE__->install_properties(
    {   column_defs => {
            id      => 'integer not null auto_increment',
            blog_id => 'integer not null',
            name    => 'string(255) not null',
            order   => 'text',
        },
        indexes => {
            blog_id => 1,
            name    => 1,
        },
        defaults      => { name => '' },
        child_of      => 'MT::Blog',
        audit         => 1,
        child_classes => ['MT::Category'],
        datasource    => 'category_list',
        primary_key   => 'id',
    }
);

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
        blog_name => {
            base    => '__common.blog_name',
            display => 'default',
            order   => 300,
        },
    };
}

sub remove {
    my $self = shift;
    if ( ref $self ) {
        $self->remove_children( { key => 'list_id' } );
    }
    $self->SUPER::remove(@_);
}

1;

