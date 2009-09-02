# $Id: Profiler.pm 288 2006-10-04 23:06:00Z mpaschal $

package Data::ObjectDriver::Profiler;
use strict;
use warnings;
use base qw( Class::Accessor::Fast );

use List::Util qw( min );

my $simpletable;
BEGIN {
    eval {
        require Text::SimpleTable;
        $simpletable = 1;
    };
}

__PACKAGE__->mk_accessors(qw( statistics query_log ));

sub new {
    my $class = shift;
    my $profiler = $class->SUPER::new(@_);
    $profiler->reset;
    return $profiler;
}

sub reset {
    my $profiler = shift;
    $profiler->statistics({});
    $profiler->query_log([]);
}

sub increment {
    my $profiler = shift;
    my($driver, $stat) = @_;
    my($type) = ref($driver) =~ /([^:]+)$/;
    $profiler->statistics->{join ':', $type, $stat}++;
}

sub _normalize {
    my($sql) = @_;
    $sql =~ s/^\s*//;
    $sql =~ s/\s*$//;
    $sql =~ s/[\r\n]/ /g;
    return $sql;
}

sub record_query {
    my $profiler = shift;
    my($driver, $sql) = @_;
    $sql = _normalize($sql);
    push @{ $profiler->query_log }, $sql;
    my($type) = $sql =~ /^\s*(\w+)/;
    $profiler->increment($driver, 'total_queries');
    $profiler->increment($driver, 'query_' . lc($type)) if $type;
}

sub query_frequency {
    my $profiler = shift;
    my $log = $profiler->query_log;
    my %freq;
    for my $sql (@$log) {
        $freq{$sql}++;
    }
    return \%freq;
}

sub total_queries { return $_[0]->statistics->{'DBI:total_queries'} || 0 }

sub report_queries_by_type {
    my $profiler = shift;
    return "Text::SimpleTable unavailable at startup, reports disabled." unless $simpletable;
    my $stats = $profiler->statistics;
    my $tbl = Text::SimpleTable->new( [ 64, 'Type' ], [ 9, 'Number' ] );
    for my $stat (keys %$stats) {
        my($type) = $stat =~ /^DBI:query_(\w+)$/
            or next;
        $tbl->row(uc $type, $stats->{$stat});
    }
    return $tbl->draw;
}

sub report_query_frequency {
    my $profiler = shift;
    return "Text::SimpleTable unavailable at startup, reports disabled." unless $simpletable;
    my $freq = $profiler->query_frequency;
    my $tbl = Text::SimpleTable->new( [ 64, 'Query' ], [ 9, 'Number' ] );
    my @sql = sort { ($freq->{$b} <=> $freq->{$a}) || ($a cmp $b) } keys %$freq;
    for my $sql (@sql[0..min($#sql, 19)]) {
        $tbl->row($sql, $freq->{$sql});
    }
    return $tbl->draw;
}

1;
__END__

=head1 NAME

Data::ObjectDriver::Profiler - Query profiling

=head1 SYNOPSIS

    my $profiler = Data::ObjectDriver->profiler;

    my $stats = $profiler->statistics;
    my $total = $stats->{'DBI:total_queries'};

    my $log = $profiler->query_log;

    $profiler->reset;

=head1 USAGE

=head2 $Data::ObjectDriver::PROFILE

To turn on profiling, set I<$Data::ObjectDriver::PROFILE> to a true value.
Alternatively, you can set the I<DOD_PROFILE> environment variable to a true
value before starting your application.

=head2 Data::ObjectDriver->profiler

Profiling is global to I<Data::ObjectDriver>, so the I<Profiler> object is
a global instance variable. To get it, call
I<Data::ObjectDriver-E<gt>profiler>, which returns a
I<Data::ObjectDriver::Profiler> object.

=head2 $profiler->statistics

Returns a hash reference of statistics about the queries that have been
executed.

=head2 $profiler->query_log

Returns a reference to an array of SQL queries as they were handed off to
DBI. This means that placeholder variables are not substituted, so you'll
end up with queries in the query log like
C<SELECT title, difficulty FROM recipe WHERE recipe_id = ?>.

=head2 $profiler->query_frequency

Returns a reference to a hash containing, as keys, all of the SQL statements
in the query log, where the value for each of the keys is a number
representing the number of times the query was executed.

=head2 $profiler->reset

Resets the statistics and the query log.

=head2 $profiler->total_queries

Returns the total number of queries currently logged in the profiler.

=head2 $profiler->report_queries_by_type

Returns a string containing a pretty report of information about the current
number of each type of query in the profiler (e.g. C<SELECT>, C<INSERT>).

=head2 $profiler->report_query_frequency

Returns a string containing a pretty report of information about the current
query frequency information in the profiler.

=cut
