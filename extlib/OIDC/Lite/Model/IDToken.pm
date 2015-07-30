package OIDC::Lite::Model::IDToken;
use strict;
use warnings;
use base 'Class::Accessor::Fast';

use MIME::Base64 qw/encode_base64url decode_base64url/;
use JSON::WebToken qw/encode_jwt decode_jwt/;
use Params::Validate;
use Digest::SHA qw/sha256 sha384 sha512/;
use OIDC::Lite::Util::JWT;

use constant HALF_BITS_DENOMINATOR => 2 * 8;
use constant ALG_LEN => 2;
use constant BITS_LEN => 3;


=head1 NAME

OIDC::Lite::Model::IDToken - model class that represents ID token

=head1 ACCESSORS

=head2 header

JWT Header

=head2 payload

JWT Payload

=head2 key

Key for JWT Signature

=cut

__PACKAGE__->mk_accessors(qw(
    header
    payload
    key
    token_string
    alg
));

=head1 METHODS

=head2 new( \%header, \%payload, $key )

Constructor

    my $id_token = OIDC::Lite::Model::IDToken->new();
    ...
    my $id_token = OIDC::Lite::Model::IDToken->new(
        header  => \%header,
        payload => \%payload,
        key     => $key,
        alg     => $alg,
    );

=cut

sub new {
    my $class = shift;
    my @args = @_ == 1 ? %{$_[0]} : @_;
    my %params = Params::Validate::validate_with(
        params => \@args, 
        spec => {
            header      => { optional => 1 },
            payload     => { optional => 1 },
            key         => { optional => 1 },
            alg         => { optional => 1 },
        },
        allow_extra => 0,
    );

    my $self = bless \%params, $class;
    unless($self->header){
        my %header=();
        $self->header(\%header);
    }
    unless($self->payload){
        my %payload=();
        $self->payload(\%payload);
    }
 
    return $self;
}

=head2 get_token_string()

generate signature and return ID Token string.

    my $id_token_string = $id_token->get_token_string();

=cut

sub get_token_string {
    my ($self) = @_;

    $self->header->{typ} = q{JWT}
        unless($self->header->{typ});
    $self->header->{alg} = q{none}
        unless($self->header->{alg});

    # generate token string
    my $jwt = encode_jwt($self->payload, $self->key, $self->header->{alg}, $self->header);
    $self->token_string($jwt);
    return $jwt;
}

=head2 access_token_hash()

generate signature and return ID Token string.

    $id_token->code_hash($access_token);

=cut

sub access_token_hash {
    my ($self, $access_token_string) = @_;

    if($self->header->{alg} && $self->header->{alg} ne 'none')
    {
        my $bit = substr($self->header->{alg}, ALG_LEN, BITS_LEN);
        my $len = $bit/HALF_BITS_DENOMINATOR;
        my $sha = Digest::SHA->new($bit);
        $sha->add($access_token_string);
        $self->payload->{at_hash} = encode_base64url(substr($sha->digest, 0, $len));
    }
}

=head2 code_hash()

Set Authorization Code Hash to ID Token.

    $id_token->code_hash($authorization_code);

=cut

sub code_hash {
    my ($self, $authorization_code) = @_;

    if($self->header->{alg} && $self->header->{alg} ne 'none')
    {
        my $bit = substr($self->header->{alg}, ALG_LEN, BITS_LEN);
        my $len = $bit/HALF_BITS_DENOMINATOR;
        my $sha = Digest::SHA->new($bit);
        $sha->add($authorization_code);
        $self->payload->{c_hash} = encode_base64url(substr($sha->digest, 0, $len));
    }
}

=head2 load($token_string)

load ID Token object from token string

    my $token_string = 'eyJhbGciOiJub25lIiwidHlwIjoiSldTIn0.eyJmb28iOiJiYXIifQ.';
    my $id_token = OIDC::Lite::Model::IDToken->load($token_string);

=cut

sub load {
    my ($self, $token_string, $key, $alg) = @_;
        return unless($token_string);

    my $header  = OIDC::Lite::Util::JWT::header($token_string);
    my $payload = OIDC::Lite::Util::JWT::payload($token_string);
    return unless ( $header and $payload );

    my $id_token =  OIDC::Lite::Model::IDToken->new(
                       header   => $header, 
                       payload  => $payload,
                       key      => $key,
                       alg      => $alg,
                    );
    $id_token->token_string($token_string);
    return $id_token;
}

=head2 verify()

verify token signature.

    my $token_string = '...';
    my $alg = 'HS256';
    my $key = 'shared_secret_key';

    my $id_token = OIDC::Lite::Model::IDToken->load($token_string, $key, $alg);
    unless($id_token->verify()){
        # validation failed
    }

=cut

sub verify {
    my ($self) = @_;
    return 0
        unless($self->token_string);

    $self->key('')
        unless($self->key);

    unless ($self->alg) {
        if ($self->header->{alg}) {
            $self->alg($self->header->{alg});
        } else {
            $self->alg('none');
        }
    }

    my $payload = undef;
    eval{
        $payload = decode_jwt($self->token_string, $self->key, 1, [$self->alg]);
    };
    if($@){
        return 0;
    }
    return (defined($payload));
}

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Ryo Ito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
