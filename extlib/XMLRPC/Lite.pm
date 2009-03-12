# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: Lite.pm 254 2008-06-05 18:43:57Z kutterma $
#
# ======================================================================

package XMLRPC::Lite;

use SOAP::Lite;
use strict;
use vars qw($VERSION);
use version; $VERSION = qv('0.710.06');

# ======================================================================

package XMLRPC::Constants;

BEGIN {
    no strict 'refs';
    for (qw(
        FAULT_CLIENT FAULT_SERVER
        HTTP_ON_SUCCESS_CODE HTTP_ON_FAULT_CODE
        DO_NOT_USE_XML_PARSER DO_NOT_USE_CHARSET
        DO_NOT_USE_LWP_LENGTH_HACK DO_NOT_CHECK_CONTENT_TYPE
    )) {
        *$_ = \${'SOAP::Constants::' . $_}
    }
    # XML-RPC spec requires content-type to be "text/xml"
    $XMLRPC::Constants::DO_NOT_USE_CHARSET = 1;
}

# ======================================================================

package XMLRPC::Data;

@XMLRPC::Data::ISA = qw(SOAP::Data);

# ======================================================================

package XMLRPC::Serializer;

@XMLRPC::Serializer::ISA = qw(SOAP::Serializer);

sub new {
    my $class = shift;

    return $class if ref $class;

    return $class->SUPER::new(
        typelookup => {
            base64 => [10, sub {$_[0] =~ /[^\x09\x0a\x0d\x20-\x7f]/}, 'as_base64'],
            int    => [20, sub {$_[0] =~ /^[+-]?\d+$/}, 'as_int'],
            double => [30, sub {$_[0] =~ /^(-?(?:\d+(?:\.\d*)?|\.\d+)|([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?)$/}, 'as_double'],
            dateTime => [35, sub {$_[0] =~ /^\d{8}T\d\d:\d\d:\d\d$/}, 'as_dateTime'],
            string => [40, sub {1}, 'as_string'],
        },
        attr => {},
        namespaces => {},
        @_,
    );
}

sub envelope {
    my $self = shift;
    $self = $self->new() if not ref $self;  # serves a method call if object
    my $type = shift;

    my $body;
    if ($type eq 'response') {
        # shift off method name to make XMLRPT happy
        my $method = shift
            or die "Unspecified method for XMLRPC call\n";
        $body = XMLRPC::Data->name( methodResponse => \XMLRPC::Data->value(
                XMLRPC::Data->type(params => [@_])
            )
        );
    }
    elsif ($type eq 'method') {
        # shift off method name to make XMLRPT happy
        my $method = shift
            or die "Unspecified method for XMLRPC call\n";
        $body = XMLRPC::Data->name( methodCall => \XMLRPC::Data->value(
                    XMLRPC::Data->type(
                        methodName => UNIVERSAL::isa($method => 'XMLRPC::Data')
                            ? $method->name
                            : $method
                    ),
                    XMLRPC::Data->type(params => [@_])
                ));
    }
    elsif ($type eq 'fault') {
        $body = XMLRPC::Data->name(methodResponse =>
            \XMLRPC::Data->type(fault => {faultCode => $_[0], faultString => $_[1]}),
        );
    }
    else {
        die "Wrong type of envelope ($type) for XMLRPC call\n";
    }

    # SOAP::Lite keeps track of objects for XML aliasing and multiref
    # encoding.
    # Set/reset seen() hashref before/after encode_object avoids a
    # memory leak
    $self->seen({});    # initialize multiref table
    my $envelope = $self->xmlize($self->encode_object($body));
    $self->seen({});    # delete multi-ref table - avoids a memory hole...
    return $envelope;
}


sub encode_object {
    my $self = shift;
    my @encoded = $self->SUPER::encode_object(@_);

    return $encoded[0]->[0] =~ /^(?:array|struct|i4|int|boolean|string|double|dateTime\.iso8601|base64)$/o
        ? ['value', {}, [@encoded]]
        : @encoded;
}

sub encode_scalar {
    my $self = shift;
    return ['value', {}] unless defined $_[0];
    return $self->SUPER::encode_scalar(@_);
}

sub encode_array {
    my ($self, $array) = @_;

    return ['array', {}, [
        ['data', {}, [ map {$self->encode_object($_)} @{ $array } ] ]
    ]];
}

sub encode_hash {
    my ($self, $hash) = @_;

    return ['struct', {}, [
        map {
            ['member', {}, [['name', {}, $_], $self->encode_object($hash->{$_})]]
        } keys %{ $hash }
    ]];
}

sub as_methodName {
    my ($self, $value, $name, $type, $attr) = @_;
    return [ 'methodName', $attr, $value ];
}

sub as_params {
    my ($self, $params, $name, $type, $attr) = @_;
    return ['params', $attr, [
        map {
            ['param', {}, [ $self->encode_object($_) ] ]
        } @$params
    ]];
}

sub as_fault {
    my ($self, $fault) = @_;
    return ['fault', {}, [ $self->encode_object($fault) ] ];
}

sub BEGIN {
    no strict 'refs';
    for my $type (qw(double i4 int)) {
        my $method = 'as_' . $type;
        *$method = sub {
            my($self, $value) = @_;
            return [ $type, {}, $value ];
        }
    }
}

sub as_base64 {
    my ($self, $value) = @_;
    require MIME::Base64;
    return ['base64', {}, MIME::Base64::encode_base64($value,'')];
}

sub as_string {
    my ($self, $value) = @_;
    return ['string', {}, SOAP::Utils::encode_data($value)];
}

sub as_dateTime {
    my ($self, $value) = @_;
    return ['dateTime.iso8601', {}, $value];
}

sub as_boolean {
    my ($self, $value) = @_;
    return ['boolean', {}, $value ? 1 : 0];
}

sub typecast {
    my ($self, $value, $name, $type, $attr) = @_;

    die "Wrong/unsupported datatype '$type' specified\n" if defined $type;

    $self->SUPER::typecast(@_);
}

# ======================================================================

package XMLRPC::SOM;

@XMLRPC::SOM::ISA = qw(SOAP::SOM);

sub BEGIN {
    no strict 'refs';
    my %path = (
        root  => '/',
        envelope => '/[1]',
        method => '/methodCall/methodName',
        fault => '/methodResponse/fault',
    );

    for my $method (keys %path) {
        *$method = sub {
            my $self = shift;
            ref $self or return $path{$method};
            Carp::croak "Method '$method' is readonly and doesn't accept any parameters" if @_;
            $self->valueof($path{$method});
        };
    }

    my %fault = (
        faultcode => 'faultCode',
        faultstring => 'faultString',
    );

    for my $method (keys %fault) {
        *$method = sub {
            my $self = shift;
            ref $self or Carp::croak "Method '$method' doesn't have shortcut";
            Carp::croak "Method '$method' is readonly and doesn't accept any parameters" if @_;
            defined $self->fault ? $self->fault->{$fault{$method}} : undef;
        };
    }

    my %results = (
        result    => '/methodResponse/params/[1]',
        paramsin  => '/methodCall/params/param',
        paramsall => '/methodResponse/params/param',
    );

    for my $method (keys %results) {
        *$method = sub {
            my $self = shift;
            ref $self or return $results{$method};
            Carp::croak "Method '$method' is readonly and doesn't accept any parameters" if @_;
            defined $self->fault()
                ? undef
                : $self->valueof($results{$method});
        };
    }
}

# ======================================================================

package XMLRPC::Deserializer;

@XMLRPC::Deserializer::ISA = qw(SOAP::Deserializer);

BEGIN {
    no strict 'refs';
    for my $method (qw(o_child o_qname o_chars)) { # import from SOAP::Utils
        *$method = \&{'SOAP::Utils::'.$method};
    }
}

sub deserialize {
    # just deserialize with SOAP::Lite's deserializer, and re-bless as
    # XMLRPC::SOM
    bless shift->SUPER::deserialize(@_) => 'XMLRPC::SOM';
}

sub decode_value {
    my $self = shift;
    my $ref = shift;
    my($name, $attrs, $children, $value) = @$ref;

    if ($name eq 'value') {
        $children ? scalar(($self->decode_object($children->[0]))[1]) : $value;
    }
    elsif ($name eq 'array') {
        return [map {scalar(($self->decode_object($_))[1])} @{o_child($children->[0]) || []}];
    }
    elsif ($name eq 'struct') {
        return {
            map {
                my %hash = map { o_qname($_) => $_ } @{o_child($_) || []};
                                        # v----- scalar is required here, because 5.005 evaluates 'undef' in list context as empty array
                (o_chars($hash{name}) => scalar(($self->decode_object($hash{value}))[1]));
            } @{$children || []}};
    }
    elsif ($name eq 'base64') {
        require MIME::Base64;
        MIME::Base64::decode_base64($value);
    }
    elsif ($name =~ /^(?:int|i4|boolean|string|double|dateTime\.iso8601|methodName)$/) {
        return $value;
    }
    elsif ($name =~ /^(?:params)$/) {
        return [map {scalar(($self->decode_object($_))[1])} @{$children || []}];
    }
    elsif ($name =~ /^(?:methodResponse|methodCall)$/) {
        return +{map {$self->decode_object($_)} @{$children || []}};
    }
    elsif ($name =~ /^(?:param|fault)$/) {
        return scalar(($self->decode_object($children->[0]))[1]);
    }
    else {
        die "wrong element '$name'\n";
    }
}

# ======================================================================

package XMLRPC::Server;

@XMLRPC::Server::ISA = qw(SOAP::Server);

sub initialize {
    return (
        deserializer => XMLRPC::Deserializer->new,
        serializer => XMLRPC::Serializer->new,
        on_action => sub {},
        on_dispatch => sub { return map {s!\.!/!g; $_} shift->method =~ /^(?:(.*)\.)?(\w+)$/ },
    );
}

# ======================================================================

package XMLRPC::Server::Parameters;

@XMLRPC::Server::Parameters::ISA = qw(SOAP::Server::Parameters);

# ======================================================================

package XMLRPC;

@XMLRPC::ISA = qw(SOAP);

# ======================================================================

package XMLRPC::Lite;

@XMLRPC::Lite::ISA = qw(SOAP::Lite);

sub new {
    my $class = shift;

    return $class if ref $class;

    return $class->SUPER::new(
        serializer => XMLRPC::Serializer->new,
        deserializer => XMLRPC::Deserializer->new,
        on_action => sub {return},
        uri => 'http://unspecified/',
        @_
    );
}

# ======================================================================

1;

__END__

=head1 NAME

XMLRPC::Lite - client and server implementation of XML-RPC protocol

=head1 SYNOPSIS

=over 4

=item Client

  use XMLRPC::Lite;
  print XMLRPC::Lite
      -> proxy('http://betty.userland.com/RPC2')
      -> call('examples.getStateStruct', {state1 => 12, state2 => 28})
      -> result;

=item CGI server

  use XMLRPC::Transport::HTTP;

  my $server = XMLRPC::Transport::HTTP::CGI
    -> dispatch_to('methodName')
    -> handle
  ;

=item Daemon server

  use XMLRPC::Transport::HTTP;

  my $daemon = XMLRPC::Transport::HTTP::Daemon
    -> new (LocalPort => 80)
    -> dispatch_to('methodName')
  ;
  print "Contact to XMLRPC server at ", $daemon->url, "\n";
  $daemon->handle;

=back

=head1 DESCRIPTION

XMLRPC::Lite is a Perl modules which provides a simple nterface to the
XML-RPC protocol both on client and server side. Based on SOAP::Lite module,
it gives you access to all features and transports available in that module.

See F<t/26-xmlrpc.t> for client examples and F<examples/XMLRPC/*> for server
implementations.

=head1 DEPENDENCIES

 SOAP::Lite

=head1 SEE ALSO

 SOAP::Lite

=head1 CREDITS

The B<XML-RPC> standard is Copyright (c) 1998-2001, UserLand Software, Inc.
See <http://www.xmlrpc.com> for more information about the B<XML-RPC>
specification.

=head1 COPYRIGHT

Copyright (C) 2000-2001 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

=cut
