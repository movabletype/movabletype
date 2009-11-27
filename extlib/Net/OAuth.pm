package Net::OAuth;
use warnings;
use strict;
use UNIVERSAL::require;

sub PROTOCOL_VERSION_1_0() {1}
sub PROTOCOL_VERSION_1_0A() {1.001}

sub OAUTH_VERSION() {'1.0'}

our $VERSION = '0.19';
our $SKIP_UTF8_DOUBLE_ENCODE_CHECK = 0;
our $PROTOCOL_VERSION = PROTOCOL_VERSION_1_0;

sub request {
    my $self = shift;
    my $what = shift;
    return $self->message($what . ' Request');
}

sub response {
    my $self = shift;
    my $what = shift;
    return $self->message($what . ' Response');
}

sub message {
    my $self = shift;
    my $base_class = ref $self || $self;
    my $type = camel(shift);
    my $class = $base_class . '::' . $type;
    $class->require;
    return $class;
}

sub camel {
    my @words;
    foreach (@_) {
        while (/([A-Za-z0-9]+)/g) {
            (my $word = $1) =~ s/authentication/auth/i;
            push @words, $word;
        }
    }
    my $name = join('', map("\u$_", @words));
}

=head1 NAME

Net::OAuth - OAuth protocol support

=head1 SYNOPSIS

    # Consumer sends Request Token Request

    use Net::OAuth;
    $Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;
    use HTTP::Request::Common;
    my $ua = LWP::UserAgent->new;

    my $request = Net::OAuth->request("request token")->new(
        consumer_key => 'dpf43f3p2l4k3l03',
        consumer_secret => 'kd94hf93k423kf44',
        request_url => 'https://photos.example.net/request_token',
        request_method => 'POST',
        signature_method => 'HMAC-SHA1',
        timestamp => '1191242090',
        nonce => 'hsu94j3884jdopsl',
        callback => 'http://printer.example.com/request_token_ready',
        extra_params => {
            apple => 'banana',
            kiwi => 'pear',
        }
    );

    $request->sign;

    my $res = $ua->request(POST $request->to_url); # Post message to the Service Provider

    if ($res->is_success) {
        my $response = Net::OAuth->response('request token')->from_post_body($res->content);
        print "Got Request Token ", $response->token, "\n";
        print "Got Request Token Secret ", $response->token_secret, "\n";
    }
    else {
        die "Something went wrong";
    }

    # Etc..

    # Service Provider receives Request Token Request

    use Net::OAuth;
    $Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;
    use CGI;
    my $q = new CGI;

    my $request = Net::OAuth->request("request token")->from_hash($q->Vars,
        request_url => 'https://photos.example.net/request_token',
        request_method => $q->request_method,
        consumer_secret => 'kd94hf93k423kf44',
    );

    if (!$request->verify) {
        die "Signature verification failed";
    }
    else {
        # Service Provider sends Request Token Response

        my $response = Net::OAuth->response("request token")->new( 
            token => 'abcdef',
            token_secret => '0123456',
            callback_confirmed => 'true',
        );

        print $response->to_post_body;
    }    

    # Etc..

=head1 ABSTRACT

OAuth is 

"An open protocol to allow secure API authentication in a simple and standard method from desktop and web applications."

In practical terms, OAuth is a mechanism for a Consumer to request protected resources from a Service Provider on behalf of a user.

Please refer to the OAuth spec: L<http://oauth.net/documentation/spec>

Net::OAuth provides:

=over

=item * classes that encapsulate OAuth messages (requests and responses).  

=item * message signing

=item * message serialization and parsing.

=item * 2-legged requests (aka. tokenless requests, aka. consumer requests), see L</"CONSUMER REQUESTS"> 

=back

Net::OAuth does not provide:

=over

=item * Consumer or Service Provider encapsulation  

=item * token/nonce/key storage/management

=back

=head1 DESCRIPTION

=head2 OAUTH MESSAGES

An OAuth message is a set of key-value pairs.  The following message types are supported:

Requests

=over

=item * Request Token (Net::OAuth::RequestTokenRequest)

=item * Access Token (Net::OAuth::AccessTokenRequest)

=item * User Authentication (Net::OAuth::UserAuthRequest)

=item * Protected Resource (Net::OAuth::ProtectedResourceRequest)

=item * Consumer Request (Net::OAuth::ConsumerRequest) (2-legged / token-less request)

=back

Responses

=over

=item * Request Token (Net::OAuth::RequestTokenResponse)

=item * Access Token (Net::OAuth:AccessTokenResponse)

=item * User Authentication (Net::OAuth::UserAuthResponse)

=back

Each OAuth message type has one or more required parameters, zero or more optional parameters, and most allow arbitrary parameters.

All OAuth requests must be signed by the Consumer.  Responses from the Service Provider, however, are not signed.

To create a message, the easiest way is to use the factory methods (Net::OAuth->request, Net::OAuth->response, Net::OAuth->message).  The following method invocations are all equivalent:

 $request = Net::OAuth->request('user authentication')->new(%params);
 $request = Net::OAuth->request('user_auth')->new(%params);
 $request = Net::OAuth->request('UserAuth')->new(%params);
 $request = Net::OAuth->message('UserAuthRequest')->new(%params);

The more verbose way is to use the class directly:

 use Net::OAuth::UserAuthRequest; 
 $request = Net::OAuth::UserAuthRequest->new(%params);

You can also create a message by deserializing it from a Authorization header, URL, query hash, or POST body

 $request = Net::OAuth->request('protected resource')->from_authorization_header($header, %api_params);
 $request = Net::OAuth->request('protected resource')->from_url($url, %api_params);
 $request = Net::OAuth->request('protected resource')->from_hash($q->Vars, %api_params); # CGI
 $request = Net::OAuth->request('protected resource')->from_hash($c->request->params, %api_params); # Catalyst
 $response = Net::OAuth->response('request token')->from_post_body($response_content, %api_params);

Note that the deserialization methods (as opposed to new()) expect OAuth protocol parameters to be prefixed with 'oauth_', as you would expect in a valid OAuth message.

Before sending a request, the Consumer must first sign it:

 $request->sign;

When receiving a request, the Service Provider should first verify the signature:

 die "Signature verification failed" unless $request->verify;

When sending a message the last step is to serialize it and send it to wherever it needs to go.  The following serialization methods are available:

 $response->to_post_body # a application/x-www-form-urlencoded POST body

 $request->to_url # the query string of a URL

 $request->to_authorization_header # the value of an HTTP Authorization header

 $request->to_hash # a hash that could be used for some other serialization

=head2 API PARAMETERS vs MESSAGE PARAMETERS

Net::OAuth defines 'message parameters' as parameters that are part of the transmitted OAuth message.  These include any protocol parameter (prefixed with 'oauth_' in the message), and any additional message parameters (the extra_params hash).

'API parameters' are parameters required to build a message object that are not transmitted with the message, e.g. consumer_secret, token_secret, request_url, request_method.

There are various methods to inspect a message class to see what parameters are defined:

 $request->required_message_params;
 $request->optional_message_params;
 $request->all_message_params;
 $request->required_api_params;
 $request->optional_api_params;
 $request->all_api_params;
 $request->all_params;

E.g.

 use Net::OAuth;
 use Data::Dumper;
 print Dumper(Net::OAuth->request("protected resource")->required_message_params);

 $VAR1 = [
          'consumer_key',
          'signature_method',
          'timestamp',
          'nonce',
          'token'
        ];

=head2 ACCESSING PARAMETERS

All parameters can be get/set using accessor methods. E.g.

 my $consumer_key = $request->consumer_key;
 $request->request_method('POST');

=head2 THE REQUEST_URL PARAMETER

Any query parameters in the request_url are removed and added to the extra_params hash when generating the signature.

E.g. the following requests are pretty much equivalent:

 my $request = Net::OAuth->request('Request Token')->new(
  %params,
  request_url => 'https://photos.example.net/request_token',
  extra_params => {
   foo => 'bar'
  },
);

 my $request = Net::OAuth->request('Request Token')->new(
  %params,
  request_url => 'https://photos.example.net/request_token?foo=bar',
 );

Calling $request->request_url will still return whatever you set it to originally. If you want to get the request_url with the query parameters removed, you can do:

    my $url = $request->normalized_request_url;

=head2 SIGNATURE METHODS

The following signature methods are supported:

=over

=item * PLAINTEXT

=item * HMAC-SHA1

=item * RSA-SHA1

=back

The signature method is determined by the value of the signature_method parameter that is passed to the message constructor.

If an unknown signature method is specified, the signing/verification will throw an exception.

=head3 PLAINTEXT SIGNATURES

This method is a trivial signature which adds no security.  Not recommended.

=head3 HMAC-SHA1 SIGNATURES

This method is available if you have Digest::HMAC_SHA1 installed.  This is by far the most commonly used method.

=head3 RSA-SHA1 SIGNATURES

To use RSA-SHA1 signatures, pass in a Crypt::OpenSSL::RSA object (or any object that can do $o->sign($str) and/or $o->verify($str, $sig))

E.g.

Consumer:

 use Crypt::OpenSSL::RSA;
 use File::Slurp;
 $keystring = read_file('private_key.pem');
 $private_key = Crypt::OpenSSL::RSA->new_private_key($keystring);
 $request = Net::OAuth->request('request token')->new(%params);
 $request->sign($private_key);
 
Service Provider:

 use Crypt::OpenSSL::RSA;
 use File::Slurp;
 $keystring = read_file('public_key.pem');
 $public_key = Crypt::OpenSSL::RSA->new_public_key($keystring);
 $request = Net::OAuth->request('request token')->new(%params);
 if (!$request->verify($public_key)) {
 	die "Signature verification failed";
 }

Note that you can pass the key in as a parameter called 'signature_key' to the message constructor, rather than passing it to the sign/verify method, if you like.

=head2 CONSUMER REQUESTS

To send a request without including a token, use a Consumer Request:

    my $request = Net::OAuth->request('consumer')->new(
            consumer_key => 'dpf43f3p2l4k3l03',
            consumer_secret => 'kd94hf93k423kf44',
            request_url => 'http://provider.example.net/profile',
            request_method => 'GET',
            signature_method => 'HMAC-SHA1',
            timestamp => '1191242096',
            nonce => 'kllo9940pd9333jh',
    );

    $request->sign;

See L<Net::OAuth::ConsumerRequest>

=head2 I18N

Per the OAuth spec, when making the signature Net::OAuth first encodes parameters to UTF-8. This means that any parameters you pass to Net::OAuth, if they are outside of ASCII character set, should be run through Encode::decode() (or an equivalent PerlIO layer) first to decode them to Perl's internal character sructure.

There is a check in Net::OAuth's parameter encoding function that guesses if the data you are passing in looks like it is already UTF-8 and warns that you should decode it first. This accidental double-encoding of UTF-8 may be a source of headaches - if you find that the signature check is failing when you send non-ASCII data, that is a likely cause. 

You can silence this warning by setting:

    $Net::OAuth::SKIP_UTF8_DOUBLE_ENCODE_CHECK = 1;

Following is an example of decoding some UTF-8 form data before sending it in an OAuth messaage (from the Twitter demo included in the Net::OAuth package):

    my $request = Net::OAuth->request("protected resource")->new(
        $self->_default_request_params,
        request_url => 'http://twitter.com/statuses/update.xml',
        token => $self->session->param('token'),
        token_secret => $self->session->param('token_secret'),
        request_method => 'POST',
        extra_params => {status => decode_utf8($self->query->param('status'))}
    );

=head2 OAUTH 1.0A

Background:

L<http://mojodna.net/2009/05/20/an-idiots-guide-to-oauth-10a.html>

L<http://oauth.googlecode.com/svn/spec/core/1.0a/drafts/3/oauth-core-1_0a.html>

Net::OAuth defaults to OAuth 1.0 spec compliance, and supports OAuth 1.0 Rev A with an optional switch:

 use Net::OAuth
 $Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;

It is recommended that any new projects use this switch if possible, and existing projects move to supporting this switch as soon as possible.  Probably the easiest way for existing projects to do this is to turn on the switch and run your test suite.  The Net::OAuth constructor will throw an exception where the new protocol parameters (callback, callback_confirmed, verifier) are missing.

Internally, the Net::OAuth::Message constructor checks $Net::OAuth::PROTOCOL_VERSION and attempts to load the equivalent subclass in the Net::OAuth::V1_0A:: namespace.  So if you instantiate a Net::OAuth::RequestTokenRequest object, you will end up with a Net::OAuth::V1_0A::RequestTokenRequest (a subclass of Net::OAuth::RequestTokenRequest) if the protocol version is set to PROTOCOL_VERSION_1_0A.  You can also select a 1.0a subclass on a per-message basis by passing 
    
    protocol_version => Net::OAuth::PROTOCOL_VERSION_1_0A

in the API parameters hash.

If you are not sure whether the entity you are communicating with is 1.0A compliant, you can try instantiating a 1.0A message first and then fall back to 1.0 if that fails:

    use Net::OAuth
    $Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;
    my $is_oauth_1_0 = 0;
    my $response = eval{Net::OAuth->response('request token')->from_post_body($res->content)};
    if ($@) {
        if ($@ =~ /Missing required parameter 'callback_confirmed'/) {
            # fall back to OAuth 1.0
            $response = Net::OAuth->response('request token')->from_post_body(
                $res->content, 
                protocol_version => Net::OAuth::PROTOCOL_VERSION_1_0
            );
            $is_oauth_1_0 = 1; # from now on treat the server as OAuth 1.0 compliant
        }
        else {
            die $@;
        }
    }

At some point in the future, Net::OAuth will default to Net::OAuth::PROTOCOL_VERSION_1_0A.

=head1 DEMO

There is a demo Consumer CGI in this package, also available online at L<http://oauth.kg23.com/>

=head1 SEE ALSO

L<http://oauth.net>

Check out L<Net::OAuth::Simple> - it has a simpler API that may be more to your liking

Check out L<Net::Twitter::OAuth> for a Twitter-specific OAuth API

Check out L<WWW::Netflix::API> for a Netflix-specific OAuth API

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;