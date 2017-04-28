package MT::ContentFieldType::SingleLineText;
use strict;
use warnings;

use MT::ContentFieldType::Common qw( get_cd_ids_by_left_join );

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $join_terms = $prop->super(@_);
    my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
    { id => $cd_ids };
}

1;

