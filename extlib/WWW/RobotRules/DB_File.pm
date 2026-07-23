package WWW::RobotRules::DB_File;
use strict;

use WWW::RobotRules ();
our @ISA     = qw(WWW::RobotRules);
our $VERSION = '6.03';

use Carp ();
use DB_File;
use Fcntl qw( O_CREAT O_RDWR );

sub new {
    my ($class, $name, $file) = @_;
    Carp::croak('WWW::RobotRules::DB_File cache file required') unless $file;

    my $self = WWW::RobotRules->new($name);
    $self = bless $self, $class;

    tie %{$self->{'rules'}}, DB_File, $file, O_CREAT | O_RDWR, 0640, $DB_HASH;

    $self;
}

sub expires {
    my ($self, $hostport, $expires) = @_;
    my $old = $self->{'rules'}{"$hostport##expires"};
    $old = 0 unless (defined $old);
    if (defined $expires) {
        $self->{'rules'}{"$hostport##expires"} = $expires;
    }
    $old;
}


sub roboturl {
    my ($self, $hostport, $url) = @_;

    $url = $url->as_string if ref($url);

    my $old = $self->{'rules'}{"$hostport##url"};
    if ($url) {
        $self->{'rules'}{"$hostport##url"} = $url;
    }
    $old;
}

sub host_count {
    my ($self, $hostport) = @_;
    $self->{'rules'}{"$hostport##count"};
}

sub last_visit {
    my ($self, $hostport) = @_;

    $self->{'rules'}{"$hostport##last"};
}

sub visit {
    my ($self, $hostport, $time) = @_;
    $time = time unless defined $time;

    $self->{'rules'}{"$hostport##last"} = $time;
    if (defined $self->{"rules##$hostport##count"}) {
        $self->{'rules'}{"$hostport##count"}++;
    }
    else {
        $self->{'rules'}{"$hostport##count"} = 1;
    }
}

sub push_rule {
    my ($self, $hostport, $rule) = @_;

    my $cnt = 0;
    foreach (keys %{$self->{'rules'}}) {
        if (/^$hostport\#\#rule\#\#\d+$/) { $cnt++; }
    }
    $self->{'rules'}{"$hostport##rule##$cnt"} = $rule;
}

sub clear_rules {
    my ($self, $hostport) = @_;

    foreach (keys %{$self->{'rules'}}) {
        if (/^($hostport\#\#rule\#\#\d+)$/) {
            delete $self->{'rules'}{$1};
        }
    }
}

sub rules {
    my ($self, $hostport) = @_;

    my @rules = [];
    foreach (keys %{$self->{'rules'}}) {
        if (/^($hostport\#\#rule\#\#\d+)$/) {
            push(@rules, $self->{'rules'}{$1});
        }
    }
    return \@rules;
}

sub hosts {
    my ($self) = @_;

    my @hosts;
    foreach (keys %{$self->{'rules'}}) {
        if (/^([^\#]+)\#\#count/) {
            push(@hosts, $1);
        }
    }
    return \@hosts;
}

1;
__END__

=head1 NAME

WWW::RobotRules::DB_File - Parse robots.txt files using a disk cache

=head1 SYNOPSIS

    require WWW::RobotRules::DB_File;
    require LWP::RobotUA;

    #Create a robot useragent that uses a disk caching RobotRules
    $ua = WWW::RobotUA->new( 'my-robot/1.0', 'me@foo.com' ,
          WWW::RobotRules::DB_File->new( 'my-robot/1.0', '/path/cachefile' ));

    #The just use $ua as usual
    $res=$ua->request($req);

=head1 DESCRIPTION

This is a subclass of L<WWW::RobotRules> that uses the DB_File package to
implement disk caching of robots.txt.

=head1 METHODS

This is a subclass of L<WWW::RobotRules>, so it implements the same methods

=over 4

=item $rules = WWW::RobotRules::DB_File->new('my-robot/1.0', /path/cachefile)

This is the constructor. The only difference from the original constructor
from L<WWW::RobotRules> is that you here has to specify a cache file as well.

=back

=head1 SEE ALSO

L<WWW::RobotRules>

=head1 AUTHOR

Hakan Ardo <hakan@munin.ub2.lu.se>

=cut
