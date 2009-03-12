# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: Test.pm 249 2008-05-05 20:35:05Z kutterma $
#
# ======================================================================

package XMLRPC::Test;

use 5.004;
use vars qw($VERSION $TIMEOUT);
use version; $VERSION = qv('0.710.05');

$TIMEOUT = 5;

# ======================================================================

package My::PingPong; # we'll use this package in our tests

sub new {
  my $self = shift;
  my $class = ref($self) || $self;
  bless {_num=>shift} => $class;
}

sub next {
  my $self = shift;
  $self->{_num}++;
}

sub value {
  my $self = shift;
  $self->{_num};
}

# ======================================================================

package XMLRPC::Test::Server;

use strict;
use Test;
use XMLRPC::Lite;

sub run_for {
  my $proxy = shift or die "Proxy/endpoint is not specified";

  # ------------------------------------------------------
  my $s = XMLRPC::Lite->proxy($proxy)->on_fault(sub{});
  eval { $s->transport->timeout($XMLRPC::Test::TIMEOUT) };
  my $r = $s->test_connection;

  unless (defined $r && defined $r->envelope) {
    print "1..0 # Skip: ", $s->transport->status, "\n";
    exit;
  }
  # ------------------------------------------------------

  plan tests => 17;

  eval q!use XMLRPC::Lite on_fault => sub{ref $_[1] ? $_[1] : new XMLRPC::SOM}; 1! or die;

  print "Perl XMLRPC server test(s)...\n";

  $s = XMLRPC::Lite
    -> proxy($proxy)
  ;

  ok($s->call('My.Examples.getStateName', 1)->result eq 'Alabama');
  ok($s->call('My.Examples.getStateNames', 1,4,6,13)->result =~ /^Alabama\s+Arkansas\s+Colorado\s+Illinois\s*$/);

  $r = $s->call('My.Examples.getStateList', [1,2,3,4])->result;
  ok(ref $r && $r->[0] eq 'Alabama');

  $r = $s->call('My.Examples.getStateStruct', {item1 => 1, item2 => 4})->result;
  ok(ref $r && $r->{item2} eq 'Arkansas');

  print "dispatch_from test(s)...\n";
  eval "use XMLRPC::Lite
    dispatch_from => ['A', 'B'],
    proxy => '$proxy',
  ; 1" or die;

  eval { C->c };
  ok($@ =~ /Can't locate object method "c"/);

  print "Object autobinding and XMLRPC:: prefix test(s)...\n";

  eval "use XMLRPC::Lite +autodispatch =>
    proxy => '$proxy'; 1" or die;

  ok(XMLRPC::Lite->autodispatched);

  # forget everything
  XMLRPC::Lite->self(undef);

  {
    my $on_fault_was_called = 0;
    print "Die in server method test(s)...\n";
    my $s = XMLRPC::Lite
      -> proxy($proxy)
      -> on_fault(sub{$on_fault_was_called++;return})
    ;
    ok($s->call('My.Parameters.die_simply')->faultstring =~ /Something bad/);
    ok($on_fault_was_called > 0);

    # get Fault as hash of subelements
    my $fault = $s->call('My.Parameters.die_with_fault');
    ok($fault->faultcode =~ 'Server\.Custom');
    ok($fault->faultstring eq 'Died in server method');
  }

  print "Number of parameters test(s)...\n";

  $s = XMLRPC::Lite
    -> proxy($proxy)
  ;
  { my @all = $s->call('My.Parameters.echo')->paramsall; ok(@all == 0) }
  { my @all = $s->call('My.Parameters.echo', 1)->paramsall; ok(@all == 1) }
  { my @all = $s->call('My.Parameters.echo', (1) x 10)->paramsall; ok(@all == 10) }

  print "Memory refresh test(s)...\n";

  # Funny test.
  # Let's forget about ALL settings we did before with 'use XMLRPC::Lite...'
  XMLRPC::Lite->self(undef);
  ok(!defined XMLRPC::Lite->self);

  eval "use XMLRPC::Lite
    proxy => '$proxy'; 1" or die;

  print "Global settings test(s)...\n";
  $s = new XMLRPC::Lite;

  ok($s->call('My.Examples.getStateName', 1)->result eq 'Alabama');

  SOAP::Trace->import(transport =>
    sub {$_[0]->content_type('something/wrong') if UNIVERSAL::isa($_[0] => 'HTTP::Request')}
  );

  if ($proxy =~ /^tcp:/) {
    skip('No Content-Type checks for tcp: protocol on server side' => undef);
  } else {
    ok($s->call('My.Examples.getStateName', 1)->faultstring =~ /Content-Type must be/);
  }

  # check status for fault messages
  if ($proxy =~ /^http/) {
    ok($s->transport->status =~ /^200/);
  } else {
    skip('No Status checks for non http protocols on server side' => undef);
  }
}

# ======================================================================

1;

__END__

=head1 NAME

XMLRPC::Test - Test framework for XMLRPC::Lite

=head1 SYNOPSIS

  use XMLRPC::Test;

  XMLRPC::Test::Server::run_for('http://localhost/cgi-bin/XMLRPC.cgi');

=head1 DESCRIPTION

XMLRPC::Test provides simple framework for testing server implementations.
Specify your address (endpoint) and run provided tests against your server.
See t/1*.t for examples.

=head1 COPYRIGHT

Copyright (C) 2000-2001 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

=cut
