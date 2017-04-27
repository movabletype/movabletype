package MT::ContentFieldType::SingleLineText;
use strict;
use warnings;

use MT::ContentData;
use MT::ContentFieldIndex;

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $query = $prop->super(@_);

    my $join = MT::ContentFieldIndex->join_on(
        undef, $query,
        {   type      => 'left',
            condition => {
                content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
        },
    );
    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( $db_terms,
        { join => $join, fetchonly => { id => 1 } } );

    { id => @cd_ids ? \@cd_ids : 0 };
}

1;

