# $Id$

package XML::Atom::Link;
use strict;
use base qw( XML::Atom::Base );

use XML::Atom;

__PACKAGE__->mk_attr_accessors(qw( rel href hreflang title type length ));

sub element_name { 'link' }

## Maintain backwards compatibility with the old Link->set method.
sub set { shift->set_attr(@_) }

1;
