package DateTime::TimeZone::Local;

use strict;

use File::Spec;

sub local_time_zone
{
    my $tz;

    foreach ( qw( env
                  etc_localtime
                  etc_timezone
                  etc_sysconfig_clock
                ) )
    {
        my $meth = "_from_$_";
	$tz = __PACKAGE__->$meth();

	return $tz if $tz;
    }

    die "Cannot determine local time zone\n";
}

sub _from_env
{
    # names with '$' are for VMS
    foreach my $k ( qw( TZ SYS$TIMEZONE_RULE SYS$TIMEZONE_NAME UCX$TZ TCPIP$TZ ) )
    {
	if ( _could_be_valid_time_zone( $ENV{$k} ) )
	{
	    return eval { DateTime::TimeZone->new( name => $ENV{$k} ) };
	}
    }
}

sub _from_etc_localtime
{
    return unless -r '/etc/localtime';

    my $real_name;
    if ( -l '/etc/localtime' )
    {
	# called like this so test suite can test this functionality
	$real_name = _readlink( '/etc/localtime' );
    }
    else
    {
        $real_name = _find_matching_zoneinfo_file( '/etc/localtime' );
    }

    if ( defined $real_name )
    {
	my ($vol, $dirs, $file) = File::Spec->splitpath( $real_name );

	my @parts =
	    grep { defined && length } File::Spec->splitdir( $dirs ), $file;

        foreach my $x ( reverse 0..$#parts )
        {
            my $name =
                ( $x < $#parts ?
                  join '/', @parts[$x..$#parts] :
                  $parts[$x]
                );

            my $tz;
            $tz = eval { DateTime::TimeZone->new( name => $name ) };
            return $tz if $tz;
        }
    }

    undef;
}

sub _readlink { readlink $_[0] }

sub _from_etc_timezone
{
    my $tz_file;
    foreach ( qw( /etc/timezone /etc/TIMEZONE ) )
    {
	if ( -f && -r _ )
	{
	    $tz_file = $_;
	    last
	}
    }
    return unless $tz_file;

    local *TZ;
    open TZ, "<$tz_file"
        or die "Cannot read $tz_file: $!";
    my $name = join '', <TZ>;
    close TZ;

    $name =~ s/^\s+|\s+$//g;

    return eval { DateTime::TimeZone->new( name => $name ) };
}

# for systems where /etc/localtime is a copy of a zoneinfo file
sub _find_matching_zoneinfo_file
{
    my $file_to_match = shift;

    return unless -d '/usr/share/zoneinfo';

    require File::Find;
    require File::Compare;

    my $size = -s $file_to_match;

    my $real_name;

    local $_;
    eval
    {
        File::Find::find
            ( { wanted =>
                sub
                {
                    if ( ! defined $real_name
                         && -f $_
                         && $size == -s $_
                         && File::Compare::compare( $_, $file_to_match ) == 0
                       )
                    {
                        $real_name = $_;

                        # File::Find has no mechanism for bailing in the
                        # middle of a scan
                        die { found => 1 };
                    }
                },
                no_chdir => 1,
              },
              '/usr/share/zoneinfo',
            );
    };

    if ($@)
    {
        return $real_name if ref $@ && $@->{found};
        die $@;
    }
}

# RedHat uses this
sub _from_etc_sysconfig_clock
{
    return unless -r "/etc/sysconfig/clock" && -f _;

    my $name = _read_etc_sysconfig_clock();

    if ( _could_be_valid_time_zone($name) )
    {
        return eval { DateTime::TimeZone->new( name => $name ) };
    }
}

# this is a sparate function so that it can be overridden in the test
# suite
sub _read_etc_sysconfig_clock
{
    local *CLOCK;
    local $_;
    open CLOCK, '</etc/sysconfig/clock'
        or die "Cannot read /etc/sysconfig/clock: $!";

    while (<CLOCK>)
    {
        return $1 if /^(?:TIME)?ZONE="([^"]+)"/;
    }
}

sub _could_be_valid_time_zone
{
    return 0 unless defined $_[0];
    return 0 if $_[0] eq 'local';

    return $_[0] =~ m,^[\w/]+$, ? 1 : 0;
}


1;

__END__

=head1 NAME

DateTime::TimeZone::Local - Code to determine the system's local time zone

=head1 SYNOPSIS

  my $tz = DateTime::TimeZone->new( name => 'local' );

=head1 DESCRIPTION

This package is used to try to figure out what the local time zone is,
in a variety of ways.  See the
L<DateTime::TimeZone|DateTime::TimeZone> docs for more details.

=cut
