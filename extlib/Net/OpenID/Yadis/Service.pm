
package Net::OpenID::Yadis::Service;

use strict;
use warnings;

sub URI { Net::OpenID::Yadis::_pack_array(shift->{'URI'}) }
sub Type { Net::OpenID::Yadis::_pack_array(shift->{'Type'}) }
sub priority { shift->{'priority'} }

sub extra_field {
    my $self = shift;
    my ($field,$xmlns) = @_;
    $xmlns and $field = "\{$xmlns\}$field";
    $self->{$field};
}

1;
__END__

=head1 NAME

Net::OpenID::Yadis::Service - Class representing an XRDS Service element

=head1 SYNOPSIS

  use Net::OpenID::Yadis;
  my $disc = Net::OpenID::Yadis->new();
  my @xrd = $disc->discover("http://id.example.com/") or Carp::croak($disc->err);

  foreach my $srv (@xrd) {         # Loop for Each Service in Yadis Resourse Descriptor
    print $srv->priority;          # Service priority (sorted)
    print $srv->Type;              # Identifier of some version of some service (scalar, array or array ref)
    print $srv->URI;               # URI that resolves to a resource providing the service (scalar, array or array ref)
    print $srv->extra_field("Delegate","http://openid.net/xmlns/1.0");
                                   # Extra field of some service
  }

=head1 DESCRIPTION

After L<Net::OpenID::Yadis> performs discovery, the result is a list
of instances of this class.

=head1 METHODS

=over 4

=item $srv->B<priority>

The priority value for the service.

=item $srv->B<Type>

The URI representing the kind of service provided at the endpoint for this record.

=item $srv->B<URI>

The URI of the service endpoint.

=item $srv->B<extra_field>( $fieldname , $namespace )

Fetch the value of extension fields not provided directly by this class.

If C<$namespace> is not specified, the default is the namespace whose name is the empty string.

=head1 COPYRIGHT, WARRANTY, AUTHOR

See L<Net::OpenID::Yadis> for author, copyrignt and licensing information.

=head1 SEE ALSO

L<Net::OpenID::Yadis>

Yadis website:  L<http://yadis.org/>
