package Crypt::URandom;

use warnings;
use strict;
use Carp();
use English qw( -no_match_vars );
use Exporter();
*import = \&Exporter::import;
our @EXPORT_OK = qw(
  urandom
);
our %EXPORT_TAGS = ( 'all' => \@EXPORT_OK, );

our $VERSION  = '0.36';
our @CARP_NOT = ('Crypt::URandom');

sub CRYPT_SILENT      { return 64; }               # hex 40
sub PROV_RSA_FULL     { return 1; }
sub VERIFY_CONTEXT    { return 4_026_531_840; }    # hex 'F0000000'
sub W2K_MAJOR_VERSION { return 5; }
sub W2K_MINOR_VERSION { return 0; }
sub SINGLE_QUOTE      { return q[']; }

sub PATH {
    my $path = '/dev/urandom';
    if ( $OSNAME eq 'freebsd' ) {
        $path = '/dev/random';    # FreeBSD's /dev/random is non-blocking
    }
    return $path;
}

my $_initialised;
my $_context;
my $_cryptgenrandom;
my $_rtlgenrand;
my $_urandom_handle;

sub _init {
    if ( $OSNAME eq 'MSWin32' ) {
        require Win32;
        require Win32::API;
        require Win32::API::Type;
        my ( $major, $minor ) = ( Win32::GetOSVersion() )[ 1, 2 ];
        my $ntorlower = ( $major < W2K_MAJOR_VERSION() ) ? 1 : 0;
        my $w2k =
          ( $major == W2K_MAJOR_VERSION() and $minor == W2K_MINOR_VERSION() )
          ? 1
          : 0;

        if ($ntorlower) {
            Carp::croak(
'No secure alternative for random number generation for Win32 versions older than W2K'
            );
        }
        elsif ($w2k) {

            my $crypt_acquire_context_a =
              Win32::API->new( 'advapi32', 'CryptAcquireContextA', 'PPPNN',
                'I' );
            if ( !defined $crypt_acquire_context_a ) {
                Carp::croak(
                    "Could not import CryptAcquireContext: $EXTENDED_OS_ERROR");
            }

            my $context = chr(0) x Win32::API::Type->sizeof('PULONG');
            my $result =
              $crypt_acquire_context_a->Call( $context, 0, 0, PROV_RSA_FULL(),
                CRYPT_SILENT() | VERIFY_CONTEXT() );
            my $pack_type = Win32::API::Type::packing('PULONG');
            $context = unpack $pack_type, $context;
            if ( !$result ) {
                Carp::croak("CryptAcquireContext failed: $EXTENDED_OS_ERROR");
            }

            my $crypt_gen_random =
              Win32::API->new( 'advapi32', 'CryptGenRandom', 'NNP', 'I' );
            if ( !defined $crypt_gen_random ) {
                Carp::croak(
                    "Could not import CryptGenRandom: $EXTENDED_OS_ERROR");
            }
            $_context        = $context;
            $_cryptgenrandom = $crypt_gen_random;
        }
        else {
            my $rtlgenrand =
              Win32::API->new( 'advapi32', <<'_RTLGENRANDOM_PROTO_');
INT SystemFunction036(
  PVOID RandomBuffer,
  ULONG RandomBufferLength
)
_RTLGENRANDOM_PROTO_
            if ( !defined $rtlgenrand ) {
                Carp::croak(
                    "Could not import SystemFunction036: $EXTENDED_OS_ERROR");
            }
            $_rtlgenrand = $rtlgenrand;
        }
    }
    else {
        require FileHandle;
        $_urandom_handle = FileHandle->new( PATH(), Fcntl::O_RDONLY() )
          or Carp::croak( 'Failed to open '
              . SINGLE_QUOTE()
              . PATH()
              . SINGLE_QUOTE()
              . " for reading:$OS_ERROR" );
        binmode $_urandom_handle;
    }
    return;
}

sub urandom {
    my ($length) = @_;

    my $length_ok;
    if ( defined $length ) {
        if ( $length =~ /^\d+$/xms ) {
            $length_ok = 1;
        }
    }
    if ( !$length_ok ) {
        Carp::croak(
            'The length argument must be supplied and must be an integer');
    }
    if ( !( ( defined $_initialised ) && ( $_initialised == $PROCESS_ID ) ) ) {
        _init();
        $_initialised = $PROCESS_ID;
    }
    if ( $OSNAME eq 'MSWin32' ) {
        my $buffer = chr(0) x $length;
        if ($_cryptgenrandom) {

            my $result = $_cryptgenrandom->Call( $_context, $length, $buffer );
            if ( !$result ) {
                Carp::croak("CryptGenRandom failed: $EXTENDED_OS_ERROR");
            }
        }
        elsif ($_rtlgenrand) {

            my $result = $_rtlgenrand->Call( $buffer, $length );
            if ( !$result ) {
                Carp::croak("RtlGenRand failed: $EXTENDED_OS_ERROR");
            }
        }
        return $buffer;
    }
    else {
        my $result = $_urandom_handle->read( my $buffer, $length );
        if ( defined $result ) {
            if ( $result == $length ) {
                return $buffer;
            }
            else {
                $_urandom_handle = undef;
                Carp::croak( "Only read $result bytes from "
                      . SINGLE_QUOTE()
                      . PATH()
                      . SINGLE_QUOTE() );
            }
        }
        else {
            my $error = $OS_ERROR;
            $_urandom_handle = undef;
            Carp::croak( 'Failed to read from '
                  . SINGLE_QUOTE()
                  . PATH()
                  . SINGLE_QUOTE()
                  . ":$error" );
        }
    }
}

1;    # Magic true value required at end of module
__END__

=head1 NAME

Crypt::URandom - Provide non blocking randomness


=head1 VERSION

This document describes Crypt::URandom version 0.36


=head1 SYNOPSIS

    use Crypt::URandom();

    my $random_string_50_bytes_long = Crypt::URandom::urandom(50);

OR
  
    use Crypt::URandom qw( urandom );

    my $random_string_50_bytes_long = urandom(50);

=head1 DESCRIPTION

This Module is intended to provide
an interface to the strongest available source of non-blocking 
randomness on the current platform.  Platforms currently supported are
anything supporting /dev/urandom and versions of Windows greater than 
or equal to Windows 2000.


=head1 SUBROUTINES/METHODS

=over

=item C<urandom>

=for stopwords cryptographic

This function accepts an integer and returns a string of the same size
filled with random data.  The first call will initialize the native 
cryptographic libraries (if necessary) and load all the required Perl libraries

=back

=head1 DIAGNOSTICS

=over

=item C<No secure alternative for random number generation for Win32 versions older than W2K>

The module cannot run on versions of Windows earlier than Windows 2000 as there is no
cryptographic functions provided by the operating system.

=item C<Could not import CryptAcquireContext>

=for stopwords CryptAcquireContextA advapi32

The module was unable to load the CryptAcquireContextA function from the 
advapi32 dynamic library.  The advapi32 library cannot probably be loaded.

=item C<CryptAcquireContext failed>

=for stopwords advapi32

The module was unable to call the CryptAcquireContextA function from the
advapi32 dynamic library.

=item C<Could not import CryptGenRandom>

=for stopwords advapi32 CryptGenRandom

The module was unable to load the CryptGenRandom function from the 
advapi32 dynamic library.

=item C<Could not import SystemFunction036>

=for stopwords SystemFunction036

The module was unable to load the SystemFunction036 function from the 
advapi32 dynamic library.

=item C<The length argument must be supplied and must be an integer>

The get method must be called with an integer argument to describe how many
random bytes are required.

=item C<CryptGenRandom failed>

The Windows 2000 CryptGenRandom method call failed to generate the required
amount of randomness

=item C<RtlGenRand failed>

=for stopwords RtlGenRand

The post Windows 2000 RtlGenRand method call failed to generate the required
amount of randomness

=item C<Only read n bytes from path>

The /dev/urandom device did not return the desired amount of random bytes

=item C<Failed to read from path>

The /dev/urandom device returned an error when being read from

=item C<Failed to open path>

The /dev/urandom device returned an error when being opened

=back

=head1 CONFIGURATION AND ENVIRONMENT

Crypt::URandom requires no configuration files or environment variables.


=head1 DEPENDENCIES

=over

=for stopwords perl

If the platform is Win32, the Win32::API module will be required.  Otherwise
no other modules other than those provided by perl will be required

=back

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-crypt-urandom@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

David Dick  C<< <ddick@cpan.org> >>

=for stopwords ACKNOWLEDGEMENTS

=head1 ACKNOWLEDGEMENTS

=for stopwords CryptoAPI Kanat-Alexander

The Win32::API code for interacting with Microsoft's CryptoAPI was stolen with extreme
gratitude from Crypt::Random::Source::Strong::Win32 by Max Kanat-Alexander

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, David Dick C<< <ddick@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.


=head1 DISCLAIMER OF WARRANTY

=for stopwords MERCHANTABILITY LICENCE

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
