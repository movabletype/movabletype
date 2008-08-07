# $Id$

package XML::Atom::Category;
use strict;
use base qw( XML::Atom::Base );

use XML::Atom;

__PACKAGE__->mk_attr_accessors(qw( term scheme label ));

sub element_name { 'category' }

## Maintain backwards compatibility with the old Link->set method.
sub set { shift->set_attr(@_) }

1;
