# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::UniqueID;

use strict;
use warnings;
use Crypt::URandom        ();
use UUID::URandom         ();
use MT::Util::Digest::SHA ();
use MT::Util::Digest::MD5 ();
use Exporter qw/import/;

use constant {
    MT_CONTENT_TYPE_NS  => 'b00eedad-1360-4e36-afa9-337cd764e611',
    MT_CONTENT_FIELD_NS => 'f9db3d31-12d7-465b-b354-a36f396f6ab6',
    MT_CONTENT_DATA_NS  => 'e1ed48bb-26f9-4728-b373-cf43d116fdce',
    MT_MAGIC_TOKEN_NS   => 'fed9a282-57d5-456b-9eb5-defae08e03f2',
    MT_SESSION_NS       => 'fb57b748-6a3d-4702-bb16-1fc196474cbf',
    MT_SITE_SECRET_NS   => '253cf8e5-7f6e-49f3-adf6-856031564b88',
};

our @EXPORT_OK = qw(
    create_uuid create_sha1_id create_md5_id
    create_magic_token create_session_id
    MT_CONTENT_TYPE_NS
    MT_CONTENT_FIELD_NS
    MT_CONTENT_DATA_NS
    MT_MAGIC_TOKEN_NS
    MT_SESSION_NS
    MT_SITE_SECRET_NS
);

sub create_uuid {
    my $uuid = eval { UUID::URandom::create_uuid_string(); };
    if ($@) {
        ( my $error = $@ ) =~ s/ at .+ line \d+.*//s;
        warn "UUID ERROR: $error\n";
        $uuid = _create_uuid_pp();
    }
    $uuid;
}

sub _create_uuid_pp {
    my $uuid = substr( _psuedo_random_bytes(), 0, 16 );
    vec( $uuid, 13, 4 ) = 0x4;
    vec( $uuid, 35, 2 ) = 0x2;
    $uuid = join "-", unpack( "H8H4H4H4H12", $uuid );
}

sub _random_bytes {
    eval { Crypt::URandom::urandom(40) } || _pseudo_random_bytes();
}

sub _pseudo_random_bytes {
    require Math::Random::MT::Perl;
    require Time::HiRes;
    my $rand = Math::Random::MT::Perl::rand();
    MT::Util::Digest::SHA::sha1( $rand . Time::HiRes::time() . $$ );
}

sub _random_bytes_with_namespaces {
    my @namespaces = @_;
    return join ';', @namespaces, _random_bytes();
}

sub create_md5_id {    ## 32
    MT::Util::Digest::MD5::md5_hex( _random_bytes_with_namespaces(@_) );
}

sub create_sha1_id {    ## 40
    MT::Util::Digest::SHA::sha1_hex( _random_bytes_with_namespaces(@_) );
}

sub create_sha256_id {    ## 64
    MT::Util::Digest::SHA::sha256_hex( _random_bytes_with_namespaces(@_) );
}

sub create_sha512_id {    ## 128
    MT::Util::Digest::SHA::sha512_hex( _random_bytes_with_namespaces(@_) );
}

sub create_magic_token {
    create_sha1_id( MT_MAGIC_TOKEN_NS(), @_ );
}

sub create_session_id {
    create_sha1_id( MT_SESSION_NS(), @_ );
}

1;
