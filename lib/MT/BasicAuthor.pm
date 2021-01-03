# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::BasicAuthor;

# fake out the require for this package since we're
# declaring it inline...

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'       => 'integer not null auto_increment',
            'name'     => 'string(50) not null',
            'password' => 'string(124) not null',
            'email'    => 'string(75)',
            'hint'     => 'string(75)',
        },
        indexes => {
            name  => 1,
            email => 1,
        },
        datasource  => 'author',
        primary_key => 'id',
    }
);

sub nickname {
    my $author = shift;
    $author->name;
}

sub is_valid_password {
    my $author = shift;
    my ( $pass, $crypted, $error_ref ) = @_;
    $pass ||= '';

    require MT::Auth;
    return MT::Auth->is_valid_password( $author, $pass, $crypted,
        $error_ref );
}

sub set_password {
    my $auth   = shift;
    my ($pass) = @_;
    my @alpha  = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
    my $salt   = join '', map $alpha[ rand @alpha ], 1 .. 16;
    my $crypt_sha;

    if ( eval { require MT::Util::Digest::SHA } ) {

        # Can use SHA512
        $crypt_sha
            = '$6$'
            . $salt . '$'
            . MT::Util::Digest::SHA::sha512_base64( $salt . $pass );
    }
    else {

        # Use SHA-1 algorism
        $crypt_sha
            = '{SHA}'
            . $salt . '$'
            . MT::Util::perl_sha1_digest_hex( $salt . $pass );
    }

    $auth->column( 'password', $crypt_sha );
}

sub magic_token {
    my $auth = shift;
    require MT::Util;
    my $pw = $auth->column('password');
    if ( $pw eq '(none)' ) {
        $pw
            = $auth->id . ';'
            . $auth->name . ';'
            . ( $auth->email || '' ) . ';'
            . ( $auth->hint  || '' );
    }
    require MT::Util;
    MT::Util::perl_sha1_digest_hex($pw);
}

# trans('authors');

1;
__END__

=head1 NAME

MT::BasicAuthor

=head1 METHODS

=head2 $author->is_valid_password($pass, $crypted, $error_ref)

Return the value of L<MT::Auth/is_valid_password>

=head2 $author->set_password

Set the I<$author> password with the perl C<crypt> function.

=head2 $author->magic_token()

Return the value of L<MT::Util/perl_sha1_digest_hex> for the I<password> column.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
