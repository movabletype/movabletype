# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::LogProcessor;

use strict;
use warnings;
use base qw( Class::Accessor::Fast );

use Carp qw( croak );
use Compress::Zlib;
use Data::Dumper;
use Path::Class;
use Time::HiRes qw( time );
use Time::Local;
use MT;
use DateTime;

__PACKAGE__->mk_accessors(qw( sample debug logdir day file_pattern ));

my %months = (
    Jan => 0,
    Feb => 1,
    Mar => 2,
    Apr => 3,
    May => 4,
    Jun => 5,
    Jul => 6,
    Aug => 7,
    Sep => 8,
    Oct => 9,
    Nov => 10,
    Dec => 11
);

sub range {
    my $proc = shift;
    return $proc->parse_day_arg_into_range( $proc->day );
}

sub process_log_files {
    my $proc = shift;
    my ($cb) = @_;

    my ( $start_ts, $end_ts ) = $proc->range;
    $start_ts = $start_ts->epoch;
    $end_ts   = $end_ts->epoch;

    my $log_files
        = $proc->find_log_files_covering_range( $start_ts, $end_ts );

    my $record_count = 0;
    my $sample       = $proc->{sample};
    my $process_line = sub {
        my ($line_ref) = @_;
        $record_count++;
        if ( !$sample || $record_count % $sample == 0 ) {
            my $rec = _parse_single_record($line_ref);
            if ( $rec && $rec->{ts} > $end_ts ) {
                return 0;
            }
            elsif ( $rec && $rec->{ts} >= $start_ts ) {
                $cb->($rec);
            }
        }
        return 1;
    };

    my $begin = time;
    for my $log_file (@$log_files) {
        if ( $log_file =~ /\.gz$/ ) {
            $proc->debug("Processing gzipped file $log_file");
            my $fh = gzopen( $log_file, "rb" )
                or croak "Couldn't open $log_file: $!";
            while ( $fh->gzreadline( my ($line) ) ) {
                last unless $process_line->( \$line );
            }
            $fh->gzclose;
        }
        else {
            open my $fh, "<", $log_file
                or croak "Couldn't open $log_file: $!";
            while ( my $line = <$fh> ) {
                last unless $process_line->( \$line );
            }
            close $fh;
        }
    }

    return ( $record_count, time - $begin );
}

# XXX for now
sub _parse_date {
    my ($date) = @_;
    my ( $s, $m, $h, $d, $mo, $y, $tz );
    if ( $date =~ /^\d{14}$/ ) {
        ( $y, $mo, $d, $h, $m, $s ) = unpack 'A4A2A2A2A2A2', $date;
    }
    elsif ( $date
        =~ /^(\d{4})(?:-?(\d{2})(?:-?(\d\d?)(?:T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(Z|[+-]\d{2}:\d{2})?)?)?)?/
        )
    {
        ( $y, $mo, $d, $h, $m, $s, $tz )
            = ( $1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0, $7 );
    }
    else {
        Carp::croak('Invalid date');
    }

    my $default_tz = 'UTC';
    my $dt         = DateTime->new(
        year      => $y,
        month     => $mo,
        day       => $d,
        hour      => $h || 0,
        minute    => $m || 0,
        second    => $s || 0,
        time_zone => $default_tz,
    );

    ## In case TZ flag in the string and user's timezone is different
    if ( defined $tz ) {
        my $secs
            = $tz eq 'Z' ? 0 : DateTime::TimeZone::offset_as_seconds($tz);
        my $offset = DateTime::TimeZone->new( name => $default_tz || 'UTC' )
            ->offset_for_datetime($dt);
        $dt->subtract( seconds => $secs - $offset );
    }
    return $dt;
}

# XXX for now
sub _start_end_day {
    my ($dt) = @_;
    my $start = $dt->clone;
    $start->truncate( to => 'day' );
    return $start unless wantarray;
    my $end = $start->clone;
    $end->add( days => 1 );
    $end->subtract( seconds => 1 );
    return ( $start, $end );
}

sub parse_day_arg_into_range {
    my $proc = shift;
    my ($arg_day) = @_;
    my $dt;
    if ( $arg_day eq 'today' ) {
        $dt = DateTime->now;
    }
    elsif ( $arg_day eq 'yesterday' ) {
        $dt = DateTime->now->subtract( days => 1 );
    }
    else {

        # $dt = MT::DateTime->parse_date($arg_day);
        $dt = _parse_date($arg_day);
    }
    $dt->set_time_zone('local');

    # my ( $start_ts, $end_ts ) = MT::DateTime->start_end_day();
    my ( $start_ts, $end_ts ) = _start_end_day($dt);
    $proc->debug( sprintf "For day=%s, start_ts is %s and end_ts is %s",
        $arg_day, $start_ts, $end_ts );
    return ( $start_ts, $end_ts );
}

sub debug {
    my $proc = shift;
    if ( $proc->{debug} ) {
        print STDERR @_, "\n";
    }
}

sub find_log_files_covering_range {
    my $proc = shift;
    my ( $start_ts, $end_ts ) = @_;

    my @start_times;
    my $dir = dir( $proc->logdir );
    my $pat = $proc->{file_pattern} or croak "No file_pattern defined";

    # $pat = quotemeta $pat;
    while ( my $file = $dir->next ) {
        if (   $file->isa('Path::Class::File')
            && $file->basename =~ /^$pat(?:\.[0-9]+(\.gz))?$/o )
        {
            my ($is_gz) = ( $1, $2 );
            $proc->debug("Log file '$file'");
            my $get_line;
            if ($is_gz) {
                my $fh = gzopen( $file, "rb" )
                    or croak "Couldn't open $file: $!";
                $get_line = sub {
                    my $line;
                    $fh->gzreadline($line);
                    return $line;
                };
            }
            else {
                my $fh = $file->openr;
                $get_line = sub {
                    return scalar <$fh>;
                };
            }
            my $rec;
            while ( !$rec ) {
                my $line = $get_line->();
                $rec = _parse_single_record( \$line );
            }
            push @start_times,
                {
                start_ts => $rec->{ts},
                filename => $file->stringify,
                };
        }
    }

    @start_times = sort { $a->{start_ts} <=> $b->{start_ts} }
        grep { defined $_ } @start_times;

    my @found_files;
    for my $i ( 0 .. $#start_times ) {
        my $candidate_file = $start_times[$i];
        if ( $candidate_file->{start_ts} < $end_ts ) {
            if ( $i == scalar(@start_times) - 1 ) {
                push @found_files, $candidate_file->{filename};
            }
            else {
                if ( $start_times[ $i + 1 ]->{start_ts} > $start_ts ) {
                    push @found_files, $candidate_file->{filename};
                }
            }
        }
    }
    $proc->debug(
        "Files in our date range are : " . Dumper( \@found_files ) );
    return \@found_files;
}

sub _parse_single_record {
    my ($line_ref) = @_;
    if ($$line_ref =~ /
        ^\[(?:\w{3})\s(\w{3})\s+
        (\d{1,2})\s
        (\d{2}):(\d{2}):(\d{2})\s(\d{4})\]\s
        (\w+)\s
        pt-times:\spid=(?:\d+),\suri=([^,]+),\s
        (.*)$
    /x
        )
    {
        my ( $mon, $mday, $h, $m, $s, $year, $server, $uri, $times )
            = ( $1, $2, $3, $4, $5, $6, $7, $8, $9 );
        my $domain = '';
        $mon = $months{$mon};
        my $rec = {
            url    => $uri,
            domain => $domain,
            server => $server,
            ts     => Time::Local::timelocal_nocheck(
                $s, $m, $h, $mday, $mon, $year
            ),
            mday   => int $mday,
            month  => $mon + 1,
            year   => $year,
            hour   => int $h,
            minute => int $m,
            second => int $s,
        };

        foreach my $time ( split q{, }, $times ) {
            $time =~ m/(.[^=]+)=(.+)/;
            my ( $key, $secs ) = ( lc $1, $2 );
            $key =~ s/^\s*//;
            $key =~ tr/ /_/;
            $rec->{ 'time_' . $key } += $secs;
        }

        return $rec;
    }
}

1;
__END__

=head1 NAME

MT::Util::LogProcessor - process timing log files

=head1 SYNOPSIS

    my $proc = MT::Util::LogProcessor->new({
        logdir          => '.',
        day             => 'yesterday',
        file_pattern    => 'atp.log',
    });

    my( $total_records, $elapsed ) = $proc->process_log_files( sub {
        my( $row ) = @_;
        ## do something with $row, which represents one log entry
    } );

=head1 DESCRIPTION

I<MT::Util::LogProcessor> parses and processes log files typically
generated through the use of I<MT::Util::ReqTimer>.

=head1 USAGE

=head2 MT::Util::LogProcessor->new( \%param )

Creates and returns a new log processing object. I<%param> can contain:

=over 4

=item * logdir

The path to the directory where log files are stored.

Required.

=item * day

The day specifying which log entries to process. The date should be either
C<today>, C<yesterday>, or a date in the form I<YYYY-MM-DD>.

Required.

=item * file_pattern

A regular expression pattern used to match the names of log files in the
directory I<logdir>.

Required.

=item * sample

If you have very large log files and only wish to process a sampling of the
log entries, you can use I<sample>, whose value should be a positive integer.

Optional; defaults to processing every line.

=item * debug

Log additional debugging information to your logfile/screen.

Optional; defaults to off.

=back

=head2 $log_processor->process_log_files( \&callback )

Processes all of the log entries described by the constructor to
I<MT::Util::LogProcessor> (represented in I<$log_processor>). For each
matching log entry, the subroutine reference I<&callback> is invoked, and is
passed a reference to a hash representing the log entry.

To some degree, the keys in this hash are dependent upon what your application
is logging. But the hash will always contain:

=over 4

=item * url

The URI that was requested and is logged.

=item * domain

The domain name in the URI.

=item * server

The name/address of the server where the request was processed.

=item * ts

The date/time of the request, in Unix epoch seconds.

=item * year, month, mday, hour, minute, second

The year, month, day of the month, hour, minute, and second at which the
request occurred.

=back

In addition to the above keys, the hash will contain multiple I<time_*> keys
corresponding to the phases of the request as marked in
I<MT::Util::ReqTimer>.

=cut
