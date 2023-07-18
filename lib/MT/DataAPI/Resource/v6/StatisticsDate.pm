# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v6::StatisticsDate;

use strict;
use warnings;
use MT::Stats qw(default_provider_has);

sub fields {
    my $fields = default_provider_has('fields_for_statistics_date') or return;
    return [
        { name => 'date',      schema => undef },
        { name => 'pageviews', schema => undef },
        { name => 'visits',    schema => undef },
        @$fields,
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v6::StatisticsDate - Resources definitions of the statistics API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
