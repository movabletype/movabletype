package MT::ContentFieldType::AssetCommon;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw( data_getter_common );

use MT::Asset;

sub data_getter_common {
    my ( $app, $field_id, $asset_class ) = @_;

    my $asset_ids = $app->param( 'content-field-' . $field_id ) || '';
    my @asset_ids = split ',', $asset_ids;

    my %valid_assets = map { $_->id => 1 } MT::Asset->load(
        {   id      => \@asset_ids,
            blog_id => $app->blog->id,
            class   => $asset_class,
        },
        { fetchonly => { id => 1 } },
    );

    [ grep { $valid_assets{$_} } @asset_ids ];
}

1;

