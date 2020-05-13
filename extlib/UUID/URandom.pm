use 5.008;
use strict;
use warnings;

package UUID::URandom;
# ABSTRACT: UUIDs based on /dev/urandom or the Windows Crypto API

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;
use Crypt::URandom 0.36 ();

our @EXPORT_OK = qw(
  create_uuid
  create_uuid_hex
  create_uuid_string
);

#pod =func create_uuid
#pod
#pod     my $uuid = create_uuid();
#pod
#pod     # "\x95\x5a\xe4\x96\x8b\xb2\x45\x0b\x9c\x7e\x99\xf5\x01\xdf\x90\xfe"
#pod
#pod This returns a new UUID as a 16 byte 'binary' string.
#pod
#pod =cut

sub create_uuid {
    my $uuid = Crypt::URandom::urandom(16);
    vec( $uuid, 13, 4 ) = 0x4; # set UUID version
    vec( $uuid, 35, 2 ) = 0x2; # set UUID variant
    return $uuid;
}

#pod =func create_uuid_hex
#pod
#pod     my $uuid = create_uuid_hex();
#pod
#pod     # "955ae4968bb2450b9c7e99f501df90fe"
#pod
#pod This returns a new UUID as a 32-byte hexadecimal string.
#pod
#pod =cut

sub create_uuid_hex {
    return unpack( "H*", create_uuid() );
}

#pod =func create_uuid_string
#pod
#pod     my $uuid = create_uuid_string();
#pod
#pod     # "955ae496-8bb2-450b-9c7e-99f501df90fe"
#pod
#pod This returns a new UUID in the 36-byte RFC-4122 canonical string
#pod representation.  (N.B. The canonical representation is lower-case.)
#pod
#pod =cut

sub create_uuid_string {
    return join "-", unpack( "H8H4H4H4H12", create_uuid() );
}

1;


# vim: ts=4 sts=4 sw=4 et tw=75:

__END__

=pod

=encoding UTF-8

=head1 NAME

UUID::URandom - UUIDs based on /dev/urandom or the Windows Crypto API

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    use UUID::URandom qw/create_uuid/;

    my $uuid = create_uuid();

=head1 DESCRIPTION

This module provides a portable, secure generator of
L<RFC-4122|https://tools.ietf.org/html/rfc4122> version 4
(random) UUIDs.  It is a thin wrapper around L<Crypt::URandom> to set
the UUID version and variant bits required by the RFC.

=head1 USAGE

No functions are exported by default.

=head1 FUNCTIONS

=head2 create_uuid

    my $uuid = create_uuid();

    # "\x95\x5a\xe4\x96\x8b\xb2\x45\x0b\x9c\x7e\x99\xf5\x01\xdf\x90\xfe"

This returns a new UUID as a 16 byte 'binary' string.

=head2 create_uuid_hex

    my $uuid = create_uuid_hex();

    # "955ae4968bb2450b9c7e99f501df90fe"

This returns a new UUID as a 32-byte hexadecimal string.

=head2 create_uuid_string

    my $uuid = create_uuid_string();

    # "955ae496-8bb2-450b-9c7e-99f501df90fe"

This returns a new UUID in the 36-byte RFC-4122 canonical string
representation.  (N.B. The canonical representation is lower-case.)

=begin Pod::Coverage




=end Pod::Coverage

=head1 FORK AND THREAD SAFETY

The underlying L<Crypt::URandom> is believed to be fork and thread safe.

=head1 SEE ALSO

There are a number of other modules that provide version 4 UUIDs.  Many
rely on insecure or non-crypto-strength random number generators.

=over 4

=item *

L<Data::GUID::Any>

=item *

L<Data::UUID::LibUUID>

=item *

L<UUID>

=item *

L<UUID::Tiny>

=item *

L<Data::UUID::MT>

=back

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/dagolden/UUID-URandom/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/dagolden/UUID-URandom>

  git clone https://github.com/dagolden/UUID-URandom.git

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
