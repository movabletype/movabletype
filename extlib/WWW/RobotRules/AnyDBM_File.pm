package WWW::RobotRules::AnyDBM_File;
use strict;

use WWW::RobotRules ();
our @ISA     = qw(WWW::RobotRules);
our $VERSION = '6.03';

use Carp ();
use AnyDBM_File;
use Fcntl qw( O_CREAT O_RDWR );

sub new {
    my ($class, $ua, $file) = @_;
    Carp::croak('WWW::RobotRules::AnyDBM_File filename required') unless $file;

    my $self = bless {}, $class;
    $self->{'filename'} = $file;
    tie %{$self->{'dbm'}}, 'AnyDBM_File', $file, O_CREAT | O_RDWR, 0600
        or Carp::croak("Can't open $file: $!");

    if ($ua) {
        $self->agent($ua);
    }
    else {
        # Try to obtain name from DBM file
        $ua = $self->{'dbm'}{"|ua-name|"};
        Carp::croak("No agent name specified") unless $ua;
    }

    $self;
}

sub agent {
    my ($self, $newname) = @_;
    my $old = $self->{'dbm'}{"|ua-name|"};
    if (defined $newname) {
        $newname =~ s!/?\s*\d+.\d+\s*$!!;    # loose version
        unless ($old && $old eq $newname) {

            # Old info is now stale. Clear all keys through the tied
            # interface rather than untie+tie(O_TRUNC), which is a
            # symlink-follow TOCTOU on the DBM-backing file(s).
            %{$self->{'dbm'}} = ();
            $self->{'dbm'}{"|ua-name|"} = $newname;
        }
    }
    $old;
}

sub no_visits {
    my ($self, $netloc) = @_;
    my $t = $self->{'dbm'}{"$netloc|vis"};
    return 0 unless $t;
    (split(/;\s*/, $t))[0];
}

sub last_visit {
    my ($self, $netloc) = @_;
    my $t = $self->{'dbm'}{"$netloc|vis"};
    return undef unless $t;
    (split(/;\s*/, $t))[1];
}

sub fresh_until {
    my ($self, $netloc, $fresh) = @_;
    my $old = $self->{'dbm'}{"$netloc|exp"};
    if ($old) {
        $old =~ s/;.*//;    # remove cleartext
    }
    if (defined $fresh) {
        $fresh .= "; " . localtime($fresh);
        $self->{'dbm'}{"$netloc|exp"} = $fresh;
    }
    $old;
}

sub visit {
    my ($self, $netloc, $time) = @_;
    $time ||= time;

    my $count = 0;
    my $old   = $self->{'dbm'}{"$netloc|vis"};
    if ($old) {
        my $last;
        ($count, $last) = split(/;\s*/, $old);
        $time = $last if $last > $time;
    }
    $count++;
    $self->{'dbm'}{"$netloc|vis"} = "$count; $time; " . localtime($time);
}

sub push_rules {
    my ($self, $netloc, @rules) = @_;
    my $cnt = 1;
    $cnt++ while $self->{'dbm'}{"$netloc|r$cnt"};

    foreach (@rules) {
        $self->{'dbm'}{"$netloc|r$cnt"} = $_;
        $cnt++;
    }
}

sub clear_rules {
    my ($self, $netloc) = @_;
    my $cnt = 1;
    while ($self->{'dbm'}{"$netloc|r$cnt"}) {
        delete $self->{'dbm'}{"$netloc|r$cnt"};
        $cnt++;
    }
}

sub rules {
    my ($self, $netloc) = @_;
    my @rules = ();
    my $cnt   = 1;
    while (1) {
        my $rule = $self->{'dbm'}{"$netloc|r$cnt"};
        last unless $rule;
        push(@rules, $rule);
        $cnt++;
    }
    @rules;
}

sub dump { }

1;
__END__

=head1 NAME

WWW::RobotRules::AnyDBM_File - Persistent RobotRules

=head1 SYNOPSIS

    require WWW::RobotRules::AnyDBM_File;
    require LWP::RobotUA;

    # Create a robot useragent that uses a diskcaching RobotRules
    my $rules = WWW::RobotRules::AnyDBM_File->new( 'my-robot/1.0', 'cachefile' );
    my $ua = WWW::RobotUA->new( 'my-robot/1.0', 'me@foo.com', $rules );

    # Then just use $ua as usual
    $res = $ua->request($req);

=head1 DESCRIPTION

This is a subclass of I<WWW::RobotRules> that uses the AnyDBM_File
package to implement persistent diskcaching of F<robots.txt> and host
visit information.

The constructor (the new() method) takes an extra argument specifying
the name of the DBM file to use.  If the DBM file already exists, then
you can specify undef as agent name as the name can be obtained from
the DBM database.

=head1 SECURITY CONSIDERATIONS

The caller-supplied DBM filename must reside in a directory writable
only by the same user that runs this code. The underlying
C<AnyDBM_File> backends open the file via the C C<open(2)> syscall
without C<O_NOFOLLOW>, so a symlink at the cache path (or at its
C<.dir>/C<.pag>/C<.db> siblings) will be followed and the linked
target may be overwritten with DBM page data. The cache file is
created with mode C<0600>; callers that need different permissions
can C<chmod> after construction.

=head1 SEE ALSO

L<WWW::RobotRules>, L<LWP::RobotUA>

=head1 AUTHORS

Hakan Ardo <hakan@munin.ub2.lu.se>, Gisle Aas <aas@sn.no>

=cut
