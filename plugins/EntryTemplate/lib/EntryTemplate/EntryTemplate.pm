package EntryTemplate::EntryTemplate;

use strict;
use warnings;

use MT;
use MT::Object;
use MT::Util qw( trim encode_html );
use base qw( MT::Object );

use EntryTemplate;

__PACKAGE__->install_properties(
    {   column_defs => {
            id      => 'integer not null auto_increment',
            blog_id => 'integer not null',
            label   => {
                type => 'string',
                size => 255,
            },
            text        => { type => 'text', },
            description => { type => 'text', },
        },
        indexes => { blog_id => 1, },

        child_of => 'MT::Blog',
        audit    => 1,

        datasource  => 'entry_template',
        primary_key => 'id',
    }
);

sub class_type {
    'entry_template';
}

sub class_label {
    translate('EntryTemplate');
}

sub class_label_plural {
    translate('EntryTemplates');
}

sub list_props {
    return {
        id => {
            base  => '__virtual.id',
            order => 100,
        },
        label => {
            base    => '__virtual.label',
            display => 'force',
            order   => 200,
        },
        author_name => {
            base    => '__virtual.author_name',
            order   => 300,
            display => 'default',
        },
        blog_name => {
            base => '__common.blog_name',
            label =>
                sub { MT->app->blog ? 'Blog Name' : 'Website/Blog Name' },
            display   => 'default',
            site_name => sub { MT->app->blog ? 0 : 1 },
            order     => 500,
        },
        modified_on => {
            base  => '__virtual.modified_on',
            order => 600,
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
    };
}

sub save_filter {
    my ( $cb, $app ) = @_;

    my %values = ();
    $values{$_} = $app->param($_) for ( 'id', 'label' );
    if ( my $user = $app->user ) {
        $values{created_by} = $user->id;
    }
    validate( $cb, \%values );
}

sub validate {
    my ( $cb, $values ) = @_;

    my $label = trim( $values->{label} );

    if ( !$label ) {
        return $cb->error( translate('Label is required.') );
    }

    return 1;
}

1;
