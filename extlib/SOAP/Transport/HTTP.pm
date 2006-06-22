# ======================================================================
#
# Copyright (C) 2000-2004 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: HTTP.pm,v 1.17 2006/01/27 21:30:38 byrnereese Exp $
#
# ======================================================================

package SOAP::Transport::HTTP;

use strict;
use vars qw($VERSION);
#$VERSION = sprintf("%d.%s", map {s/_//g; $_} q$Name:  $ =~ /-(\d+)_([\d_]+)/);
$VERSION = $SOAP::Lite::VERSION;

use SOAP::Lite;
use SOAP::Packager;

# ======================================================================

package SOAP::Transport::HTTP::Client;

use vars qw(@ISA $COMPRESS $USERAGENT_CLASS);
$USERAGENT_CLASS = 'LWP::UserAgent';
@ISA = qw(SOAP::Client);
#@ISA = ("SOAP::Client",$USERAGENT_CLASS);

$COMPRESS = 'deflate';

my(%redirect, %mpost, %nocompress);

# hack for HTTP connection that returns Keep-Alive 
# miscommunication (?) between LWP::Protocol and LWP::Protocol::http
# dies after timeout, but seems like we could make it work
sub patch {
    BEGIN { local ($^W) = 0; }
    no warnings "redefine";
  { sub LWP::UserAgent::redirect_ok; *LWP::UserAgent::redirect_ok = sub {1} }
  { package LWP::Protocol;
    my $collect = \&collect; # store original
    *collect = sub {
      if (defined $_[2]->header('Connection') && $_[2]->header('Connection') eq 'Keep-Alive') {
        my $data = $_[3]->();
        my $next = SOAP::Utils::bytelength($$data) == $_[2]->header('Content-Length') ? sub { my $str = ''; \$str; } : $_[3];
        my $done = 0; $_[3] = sub { $done++ ? &$next : $data };
      } 
      goto &$collect; 
    };
  }
  *patch = sub {};
};

sub DESTROY { SOAP::Trace::objects('()') }

sub http_request {
    my $self = shift;
    if (@_) { $self->{'_http_request'} = shift; return $self }
    return $self->{'_http_request'};
}

sub http_response {
    my $self = shift;
    if (@_) { $self->{'_http_response'} = shift; return $self }
    return $self->{'_http_response'};
}

sub new {
  my $self = shift;
  return $self if ref $self;
  push @ISA,$USERAGENT_CLASS;
  eval("require $USERAGENT_CLASS") or die "Could not load UserAgent class $USERAGENT_CLASS: $@"; 
  require HTTP::Request; 
  require HTTP::Headers; 
  patch() if $SOAP::Constants::PATCH_HTTP_KEEPALIVE;
  unless (ref $self) {
    my $class = ref($self) || $self;
    my(@params, @methods);
    while (@_) { $class->can($_[0]) ? push(@methods, shift() => shift) : push(@params, shift) }
    $self = $class->SUPER::new(@params);
    die "SOAP::Transport::HTTP::Client must inherit from LWP::UserAgent, or one of its subclasses"
      if !$self->isa("LWP::UserAgent");
    $self->agent(join '/', 'SOAP::Lite', 'Perl', SOAP::Transport::HTTP->VERSION);
    $self->options({});
    $self->http_request(HTTP::Request->new);
    $self->http_request->headers(HTTP::Headers->new);
    # TODO - add application/dime
    $self->http_request->header(Accept => ['text/xml', 'multipart/*', 'application/soap']);
    while (@methods) { my($method, $params) = splice(@methods,0,2);
      $self->$method(ref $params eq 'ARRAY' ? @$params : $params) 
    }
    SOAP::Trace::objects('()');
  }
  return $self;
}

sub send_receive {
  my ($self, %parameters) = @_;
  my ($context, $envelope, $endpoint, $action, $encoding, $parts) =
    @parameters{qw(context envelope endpoint action encoding parts)};
  $endpoint ||= $self->endpoint;

  my $method = 'POST';
  $COMPRESS = 'gzip';

  $self->options->{is_compress}
    ||= exists $self->options->{compress_threshold}
      && eval { require Compress::Zlib };

  # Initialize the basic about the HTTP Request object
  $self->http_request->method($method);
  $self->http_request->url($endpoint);

  no strict 'refs';
  if ($parts) {
    my $packager = $context->packager;
    $envelope = $packager->package($envelope,$context);    
    foreach my $hname (keys %{$packager->headers_http}) {
      $self->http_request->headers->header($hname => $packager->headers_http->{$hname});
    }
    # TODO - DIME support
  }

 COMPRESS: {
    my $compressed
      = !exists $nocompress{$endpoint} &&
	$self->options->{is_compress} &&
	  ($self->options->{compress_threshold} || 0) < length $envelope;
    $envelope = Compress::Zlib::memGzip($envelope) if $compressed;
    my $original_encoding = $self->http_request->content_encoding;

    while (1) {
      # check cache for redirect
      $endpoint = $redirect{$endpoint} if exists $redirect{$endpoint};
      # check cache for M-POST
      $method = 'M-POST' if exists $mpost{$endpoint};

      # what's this all about?
      # unfortunately combination of LWP and Perl 5.6.1 and later has bug
      # in sending multibyte characters. LWP uses length() to calculate
      # content-length header and starting 5.6.1 length() calculates chars
      # instead of bytes. 'use bytes' in THIS file doesn't work, because
      # it's lexically scoped. Unfortunately, content-length we calculate
      # here doesn't work either, because LWP overwrites it with
      # content-length it calculates (which is wrong) AND uses length()
      # during syswrite/sysread, so we are in a bad shape anyway.

      # what to do? we calculate proper content-length (using
      # bytelength() function from SOAP::Utils) and then drop utf8 mark
      # from string (doing pack with 'C0A*' modifier) if length and
      # bytelength are not the same
      my $bytelength = SOAP::Utils::bytelength($envelope);
      $envelope = pack('C0A*', $envelope) 
        if !$SOAP::Constants::DO_NOT_USE_LWP_LENGTH_HACK && length($envelope) != $bytelength;

      $self->http_request->content($envelope);
      $self->http_request->protocol('HTTP/1.1');

      $self->http_request->proxy_authorization_basic($ENV{'HTTP_proxy_user'},
						     $ENV{'HTTP_proxy_pass'})
	if ($ENV{'HTTP_proxy_user'} && $ENV{'HTTP_proxy_pass'});
      # by Murray Nesbitt

      if ($method eq 'M-POST') {
	my $prefix = sprintf '%04d', int(rand(1000));
	$self->http_request->header(Man => qq!"$SOAP::Constants::NS_ENV"; ns=$prefix!);
	$self->http_request->header("$prefix-SOAPAction" => $action) if defined $action;
      } else {
	$self->http_request->header(SOAPAction => $action) if defined $action;
      }


      # allow compress if present and let server know we could handle it
      $self->http_request->header('Accept-Encoding' => 
		   [$SOAP::Transport::HTTP::Client::COMPRESS])
	if $self->options->{is_compress};
      $self->http_request->content_encoding($SOAP::Transport::HTTP::Client::COMPRESS)
	if $compressed;

      if(!$self->http_request->content_type){
	$self->http_request->content_type(join '; ',
			   $SOAP::Constants::DEFAULT_HTTP_CONTENT_TYPE,
			   !$SOAP::Constants::DO_NOT_USE_CHARSET && $encoding ?
			   'charset=' . lc($encoding) : ());
      } elsif (!$SOAP::Constants::DO_NOT_USE_CHARSET && $encoding ){
	my $tmpType = $self->http_request->headers->header('Content-type');
#	$self->http_request->content_type($tmpType.'; charset=' . lc($encoding));
        my $addition = '; charset=' . lc($encoding);
        $self->http_request->content_type($tmpType.$addition) if ($tmpType !~ /$addition/);
      }

      $self->http_request->content_length($bytelength);
      SOAP::Trace::transport($self->http_request);
      SOAP::Trace::debug($self->http_request->as_string);

      $self->SUPER::env_proxy if $ENV{'HTTP_proxy'};

      $self->http_response($self->SUPER::request($self->http_request));
      SOAP::Trace::transport($self->http_response);
      SOAP::Trace::debug($self->http_response->as_string);

      # 100 OK, continue to read?
      if (($self->http_response->code == 510 || $self->http_response->code == 501) && $method ne 'M-POST') {
	$mpost{$endpoint} = 1;
      } elsif ($self->http_response->code == 415 && $compressed) { 
	# 415 Unsupported Media Type
	$nocompress{$endpoint} = 1;
	$envelope = Compress::Zlib::memGunzip($envelope);
#	$self->http_request->content_encoding($original_encoding);
	$self->http_request->headers->remove_header('Content-Encoding');
	redo COMPRESS; # try again without compression
      } else {
	last;
      }
    }
  }

  $redirect{$endpoint} = $self->http_response->request->url
    if $self->http_response->previous && $self->http_response->previous->is_redirect;

  $self->code($self->http_response->code);
  $self->message($self->http_response->message);
  $self->is_success($self->http_response->is_success);
  $self->status($self->http_response->status_line);

  my $content =
    ($self->http_response->content_encoding || '') 
      =~ /\b$SOAP::Transport::HTTP::Client::COMPRESS\b/o &&
	$self->options->{is_compress} ? 
	  Compress::Zlib::memGunzip($self->http_response->content)
	      : ($self->http_response->content_encoding || '') =~ /\S/
		? die "Can't understand returned Content-Encoding (@{[$self->http_response->content_encoding]})\n"
		  : $self->http_response->content;
  $self->http_response->content_type =~ m!^multipart/!i ?
    join("\n", $self->http_response->headers_as_string, $content) 
      : $content;
}

# ======================================================================

package SOAP::Transport::HTTP::Server;

use vars qw(@ISA $COMPRESS);
@ISA = qw(SOAP::Server);

use URI;

$COMPRESS = 'deflate';

sub DESTROY { SOAP::Trace::objects('()') }

sub new { require LWP::UserAgent;
  my $self = shift;

  unless (ref $self) {
    my $class = ref($self) || $self;
    $self = $class->SUPER::new(@_);
    $self->{'_on_action'} = sub {
      (my $action = shift || '') =~ s/^(\"?)(.*)\1$/$2/;
      die "SOAPAction shall match 'uri#method' if present (got '$action', expected '@{[join('#', @_)]}'\n"
        if $action && $action ne join('#', @_) 
                   && $action ne join('/', @_)
                   && (substr($_[0], -1, 1) ne '/' || $action ne join('', @_));
    };
    SOAP::Trace::objects('()');
  }
  return $self;
}

sub BEGIN {
  no strict 'refs';
  for my $method (qw(request response)) {
    my $field = '_' . $method;
    *$method = sub {
      my $self = shift->new;
      @_ ? ($self->{$field} = shift, return $self) : return $self->{$field};
    }
  }
}

sub handle {
  my $self = shift->new;

  if ($self->request->method eq 'POST') {
    $self->action($self->request->header('SOAPAction') || undef);
  } elsif ($self->request->method eq 'M-POST') {
    return $self->response(HTTP::Response->new(510, # NOT EXTENDED
           "Expected Mandatory header with $SOAP::Constants::NS_ENV as unique URI")) 
      if $self->request->header('Man') !~ /^"$SOAP::Constants::NS_ENV";\s*ns\s*=\s*(\d+)/;
    $self->action($self->request->header("$1-SOAPAction") || undef);
  } else {
    return $self->response(HTTP::Response->new(405)) # METHOD NOT ALLOWED
  }

  my $compressed = ($self->request->content_encoding || '') =~ /\b$COMPRESS\b/;
  $self->options->{is_compress} ||= $compressed && eval { require Compress::Zlib };

  # signal error if content-encoding is 'deflate', but we don't want it OR
  # something else, so we don't understand it
  return $self->response(HTTP::Response->new(415)) # UNSUPPORTED MEDIA TYPE
    if $compressed && !$self->options->{is_compress} ||
       !$compressed && ($self->request->content_encoding || '') =~ /\S/;

  my $content_type = $self->request->content_type || '';
  # in some environments (PerlEx?) content_type could be empty, so allow it also
  # anyway it'll blow up inside ::Server::handle if something wrong with message
  # TBD: but what to do with MIME encoded messages in THOSE environments?
  return $self->make_fault($SOAP::Constants::FAULT_CLIENT, "Content-Type must be 'text/xml,' 'multipart/*,' or 'application/dime' instead of '$content_type'")
    if $content_type && 
       $content_type ne 'text/xml' && 
       $content_type ne 'application/dime' && 
       $content_type !~ m!^multipart/!;

  # TODO - Handle the Expect: 100-Continue HTTP/1.1 Header
  if ($self->request->header("Expect") eq "100-Continue") {
      
  }


  # TODO - this should query SOAP::Packager to see what types it supports, I don't
  #        like how this is hardcoded here.
  my $content = $compressed ? 
    Compress::Zlib::uncompress($self->request->content) 
      : $self->request->content;
  my $response = $self->SUPER::handle(
    $self->request->content_type =~ m!^multipart/! ?
      join("\n", $self->request->headers_as_string, $content) 
        : $content
  ) or return;

  $self->make_response($SOAP::Constants::HTTP_ON_SUCCESS_CODE, $response);
}

sub make_fault {
  my $self = shift;
  $self->make_response($SOAP::Constants::HTTP_ON_FAULT_CODE => $self->SUPER::make_fault(@_));
  return;
}

sub make_response {
  my $self = shift;
  my($code, $response) = @_;

  my $encoding = $1
    if $response =~ /^<\?xml(?: version="1.0"| encoding="([^\"]+)")+\?>/;
  $response =~ s!(\?>)!$1<?xml-stylesheet type="text/css"?>!
    if $self->request->content_type eq 'multipart/form-data';

  $self->options->{is_compress} ||=
    exists $self->options->{compress_threshold} && eval { require Compress::Zlib };

  my $compressed = $self->options->{is_compress} &&
    grep(/\b($COMPRESS|\*)\b/, $self->request->header('Accept-Encoding')) &&
      ($self->options->{compress_threshold} || 0) < SOAP::Utils::bytelength $response;
  $response = Compress::Zlib::compress($response) if $compressed;
  # this next line does not look like a good test to see if something is multipart
  # perhaps a /content-type:.*multipart\//gi is a better regex?
  my ($is_multipart) = ($response =~ /content-type:.* boundary="([^\"]*)"/im);
  $self->response(HTTP::Response->new(
     $code => undef,
     HTTP::Headers->new(
			'SOAPServer' => $self->product_tokens,
			$compressed ? ('Content-Encoding' => $COMPRESS) : (),
			'Content-Type' => join('; ', 'text/xml',
					       !$SOAP::Constants::DO_NOT_USE_CHARSET &&
					       $encoding ? 'charset=' . lc($encoding) : ()),
			'Content-Length' => SOAP::Utils::bytelength $response),
     $response,
  ));
  $self->response->headers->header('Content-Type' => 'Multipart/Related; type="text/xml"; start="<main_envelope>"; boundary="'.$is_multipart.'"') if $is_multipart;
}

sub product_tokens { join '/', 'SOAP::Lite', 'Perl', SOAP::Transport::HTTP->VERSION }

# ======================================================================

package SOAP::Transport::HTTP::CGI;

use vars qw(@ISA);
@ISA = qw(SOAP::Transport::HTTP::Server);

sub DESTROY { SOAP::Trace::objects('()') }

sub new { 
  my $self = shift;
  unless (ref $self) {
    my $class = ref($self) || $self;
    $self = $class->SUPER::new(@_);
    SOAP::Trace::objects('()');
  }
  return $self;
}

sub make_response {
  my $self = shift;
  $self->SUPER::make_response(@_);
}

sub handle {
  my $self = shift->new;

  my $length = $ENV{'CONTENT_LENGTH'} || 0;

  if (!$length) {     
    $self->response(HTTP::Response->new(411)) # LENGTH REQUIRED
  } elsif (defined $SOAP::Constants::MAX_CONTENT_SIZE && $length > $SOAP::Constants::MAX_CONTENT_SIZE) {
    $self->response(HTTP::Response->new(413)) # REQUEST ENTITY TOO LARGE
  } else {
    if ($ENV{EXPECT} =~ /\b100-Continue\b/i) {
      print "HTTP/1.1 100 Continue\r\n\r\n";
    }
    my $content; 
    binmode(STDIN); 
    read(STDIN,$content,$length);
    $self->request(HTTP::Request->new( 
      $ENV{'REQUEST_METHOD'} || '' => $ENV{'SCRIPT_NAME'},
#      HTTP::Headers->new(map {(/^HTTP_(.+)/i ? $1 : $_) => $ENV{$_}} keys %ENV),
      HTTP::Headers->new(map {(/^HTTP_(.+)/i ? ($1=~m/SOAPACTION/) ?('SOAPAction'):($1) : $_) => $ENV{$_}} keys %ENV),
      $content,
    ));
    $self->SUPER::handle;
  }

  # imitate nph- cgi for IIS (pointed by Murray Nesbitt)
  my $status = defined($ENV{'SERVER_SOFTWARE'}) && $ENV{'SERVER_SOFTWARE'}=~/IIS/
    ? $ENV{SERVER_PROTOCOL} || 'HTTP/1.0' : 'Status:';
  my $code = $self->response->code;
  binmode(STDOUT); print STDOUT 
    "$status $code ", HTTP::Status::status_message($code), 
    "\015\012", $self->response->headers_as_string("\015\012"), 
    "\015\012", $self->response->content;
}


# ======================================================================

package SOAP::Transport::HTTP::Daemon;

use Carp ();
use vars qw($AUTOLOAD @ISA);
@ISA = qw(SOAP::Transport::HTTP::Server);

sub DESTROY { SOAP::Trace::objects('()') }

#sub new { require HTTP::Daemon; 
sub new {
  my $self = shift;
  unless (ref $self) {
    my $class = ref($self) || $self;

    my(@params, @methods);
    while (@_) { $class->can($_[0]) ? push(@methods, shift() => shift) : push(@params, shift) }
    $self = $class->SUPER::new;

    # Added in 0.65 - Thanks to Nils Sowen
    # use SSL if there is any parameter with SSL_* in the name
    $self->SSL(1) if !$self->SSL && grep /^SSL_/, @params;
    my $http_daemon = $self->http_daemon_class;
    eval "require $http_daemon" or Carp::croak $@ unless
      UNIVERSAL::can($http_daemon => 'new');
    $self->{_daemon} = $http_daemon->new(@params) or Carp::croak "Can't create daemon: $!";
    # End SSL patch
    # $self->{_daemon} = HTTP::Daemon->new(@params) or Carp::croak "Can't create daemon: $!";
    $self->myuri(URI->new($self->url)->canonical->as_string);
    while (@methods) { my($method, $params) = splice(@methods,0,2);
      $self->$method(ref $params eq 'ARRAY' ? @$params : $params) 
    }
    SOAP::Trace::objects('()');
  }
  return $self;
}

sub SSL {
  my $self = shift->new;                                     
  @_ ? ($self->{_SSL} = shift, return $self) : return
  $self->{_SSL};        
}                                                            

sub http_daemon_class { shift->SSL ? 'HTTP::Daemon::SSL' : 'HTTP::Daemon' }

sub AUTOLOAD {
  my $method = substr($AUTOLOAD, rindex($AUTOLOAD, '::') + 2);
  return if $method eq 'DESTROY';

  no strict 'refs';
  *$AUTOLOAD = sub { shift->{_daemon}->$method(@_) };
  goto &$AUTOLOAD;
}

sub handle {
  my $self = shift->new;
  while (my $c = $self->accept) {
    while (my $r = $c->get_request) {
      $self->request($r);
      $self->SUPER::handle;
      $c->send_response($self->response)
    }
    # replaced ->close, thanks to Sean Meisner <Sean.Meisner@VerizonWireless.com>
    # shutdown() doesn't work on AIX. close() is used in this case. Thanks to Jos Clijmans <jos.clijmans@recyfin.be>
    UNIVERSAL::isa($c, 'shutdown') ? $c->shutdown(2) : $c->close(); 
    $c->close;
  }
}

# ======================================================================

package SOAP::Transport::HTTP::Apache;

use vars qw(@ISA);
@ISA = qw(SOAP::Transport::HTTP::Server);

sub DESTROY { SOAP::Trace::objects('()') }

sub new {
  my $self = shift;
  unless (ref $self) {
    my $class = ref($self) || $self;
    $self = $class->SUPER::new(@_);
    SOAP::Trace::objects('()');
  }
  die "Could not find or load mod_perl"
      unless (eval "require mod_perl");
  die "Could not detect your version of mod_perl"
      if (!defined($mod_perl::VERSION));
  if ($mod_perl::VERSION < 1.99) {
      require Apache;
      require Apache::Constants;
      Apache::Constants->import('OK');
      $self->{'MOD_PERL_VERSION'} = 1;
  } elsif ($mod_perl::VERSION < 3) {
      require Apache::RequestRec;
      require Apache::RequestIO;
      require Apache::Const;
      Apache::Const->import(-compile => 'OK');
      $self->{'MOD_PERL_VERSION'} = 2;
  } else {
      die "Unsupported version of mod_perl";
  }
  return $self;
}

sub handler { 
  my $self = shift->new; 
  my $r = shift;
  $r = Apache->request if (!$r && $self->{'MOD_PERL_VERSION'} == 1);

  if ($r->header_in('Expect') =~ /\b100-Continue\b/i) {
      $r->print("HTTP/1.1 100 Continue\r\n\r\n");
  }

  $self->request(HTTP::Request->new( 
    $r->method() => $r->uri,
    HTTP::Headers->new($r->headers_in),
    do { 
	my ($c,$buf); 
	while ($r->read($buf,$r->header_in('Content-length'))) { 
	    $c.=$buf; 
	} 
	$c; 
    }
  ));
  $self->SUPER::handle;

  # we will specify status manually for Apache, because
  # if we do it as it has to be done, returning SERVER_ERROR,
  # Apache will modify our content_type to 'text/html; ....'
  # which is not what we want.
  # will emulate normal response, but with custom status code 
  # which could also be 500.
  $r->status($self->response->code);
  $self->response->headers->scan(sub { $r->header_out(@_) });
  $r->send_http_header(join '; ', $self->response->content_type);
  $r->print($self->response->content);
  return $self->{'MOD_PERL_VERSION'} == 2 ? &Apache::OK : &Apache::Constants::OK;
}

sub configure {
  my $self = shift->new;
  my $config = shift->dir_config;
  foreach (%$config) {
    $config->{$_} =~ /=>/
      ? $self->$_({split /\s*(?:=>|,)\s*/, $config->{$_}})
      : ref $self->$_() ? () # hm, nothing can be done here
                        : $self->$_(split /\s+|\s*,\s*/, $config->{$_})
      if $self->can($_);
  }
  $self;
}

{ sub handle; *handle = \&handler } # just create alias

# ======================================================================
#
# Copyright (C) 2001 Single Source oy (marko.asplund@kronodoc.fi)
# a FastCGI transport class for SOAP::Lite.
#
# ======================================================================

package SOAP::Transport::HTTP::FCGI;

use vars qw(@ISA);
@ISA = qw(SOAP::Transport::HTTP::CGI);

sub DESTROY { SOAP::Trace::objects('()') }

sub new { require FCGI; Exporter::require_version('FCGI' => 0.47); # requires thread-safe interface
  my $self = shift;

  if (!ref($self)) {
    my $class = ref($self) || $self;
    $self = $class->SUPER::new(@_);
    $self->{_fcgirq} = FCGI::Request(\*STDIN, \*STDOUT, \*STDERR);
    SOAP::Trace::objects('()');
  }
  return $self;
}

sub handle {
  my $self = shift->new;

  my ($r1, $r2);
  my $fcgirq = $self->{_fcgirq};

  while (($r1 = $fcgirq->Accept()) >= 0) {
    $r2 = $self->SUPER::handle;
  }

  return undef;
}

# ======================================================================

1;
