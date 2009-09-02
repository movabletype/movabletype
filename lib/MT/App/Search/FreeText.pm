# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: FreeText.pm 3531 2009-03-12 09:11:52Z fumiakiy $

package MT::App::Search::FreeText;

use strict;
use base qw( MT::App::Search );
use MT::ObjectDriver::SQL qw( :constants );

sub id { 'new_search' }

sub query_parse {
    my $app = shift;
    my ( %columns ) = @_;

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
