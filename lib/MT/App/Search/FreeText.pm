# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Search::FreeText;

use strict;
use base qw( MT::App::Search );
use MT::ObjectDriver::SQL qw( :constants );

sub id { 'new_search' }

sub query_parse {
    my $app = shift;
    my ( $columns ) = @_;

    my $args = {
      'freetext' => {
        columns       => $columns,
        search_string => $app->{search_string}
      }
    };
    { args => $args };
}

1;
__END__
