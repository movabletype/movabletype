package Net::OAuth;
use warnings;
use strict;
use UNIVERSAL::require;

our $VERSION = '0.11';

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
    my $type = camel(shift);
    my $class = 'Net::OAuth::' . $type;
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

 $request->verify;

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

=head1 DEMO

There is a demo Consumer CGI in this package, also available online at L<http://oauth.kg23.com/>

=head1 SEE ALSO

L<http://oauth.net>

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;