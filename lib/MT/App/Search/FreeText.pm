# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::Search::FreeText;

use strict;
use base qw( MT::App::Search );
use MT::ObjectDriver::SQL qw( :constants );

sub id {'new_search'}

sub query_parse {
    my $app = shift;
    my (%columns) = @_;

    my @column_names = keys %columns;

    my $args = {
        'freetext' => {
            columns       => \@column_names,
            search_string => $app->{search_string}
        }
    };
    { args => $args };
}

1;
__END__
