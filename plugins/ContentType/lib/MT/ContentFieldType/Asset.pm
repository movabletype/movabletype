package MT::ContentFieldType::Asset;
use strict;
use warnings;

use MT::Asset;
use MT::ObjectAsset;

sub field_html {
    my ( $app, $id, $value ) = @_;
    $value = [$value] unless ref $value eq 'ARRAY';
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'content_data',
            object_id => $ct_data_id
        }
    );
    my $html
        .= '<input type="text" name="content-field-'
        . $id
        . '" class="text long" value="';
    $html .= join ',', @$value;
    $html .= '" />';
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $asset_ids = $app->param( 'content-field-' . $id );
    my @asset_ids = split ',', $asset_ids;

    my @valid_assets = MT::Asset->load( { id => \@asset_ids },
        { no_class => 1, fetchonly => { id => 1 } } );
    my %valid_assets = map { $_->id => 1 } @valid_assets;

    [ grep { $valid_assets{$_} } @asset_ids ];
}

sub single_select_options {
    my $prop = shift;
    my $app = shift || MT->app;

    my @assets = MT::Asset->load( { blog_id => $app->blog->id },
        { fetchonly => { id => 1, label => 1 }, no_class => 1 } );

    my @options;
    for my $asset (@assets) {
        my $label = $asset->label . ' (id:' . $asset->id . ')';
        push @options,
            {
            label => $label,
            value => $asset->id,
            };
    }
    \@options;
}

sub author_name_terms {
    my $prop = shift;
    my ( $args, $load_terms, $load_args ) = @_;
    my $col
        = $prop->datasource->has_column('author_id')
        ? 'author_id'
        : 'created_by';
    my $driver = $prop->datasource->driver;
    my $colname
        = $driver->dbd->db_column_name( $prop->datasource->datasource, $col );

    my $prop_super = MT->registry( 'list_properties', '__virtual', 'string' );

    $prop->{col} = 'name';
    my $name_query = $prop_super->{terms}->( $prop, @_ );

    $prop->{col} = 'nickname';
    my $nick_query = $prop_super->{terms}->( $prop, @_ );

    my $author_join = MT->model('author')->join_on(
        undef,
        [   { id => \'= asset_created_by' },
            [   $name_query,
                (   $args->{'option'} eq 'not_contains'
                    ? '-and'
                    : '-or'
                ),
                $nick_query,
            ]
        ]
    );
    my $asset_join = MT->model('asset')->join_on(
        undef,
        {   id      => \'= cf_idx_value_integer',
            blog_id => MT->app->blog->id,
        },
        {   no_class => 1,
            join     => $author_join,
        }
    );
    my $cf_idx_join = MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
        },
        {   join   => $asset_join,
            unique => 1,
        },
    );

    $load_args->{joins} ||= [];
    push @{ $load_args->{joins} }, $cf_idx_join;
}

1;

