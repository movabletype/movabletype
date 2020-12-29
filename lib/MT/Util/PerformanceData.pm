# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::PerformanceData;

use strict;
use warnings;
use File::Spec;
use IO::File;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->init(@_);
    $self;
}

sub init {
    my $self  = shift;
    my %param = @_;
    my $file  = File::Spec->catfile( $param{path}, $param{file} );
    $self->{fh}           = IO::File->new( $file, "r" );
    $self->{system_info}  = {};
    $self->{request_data} = [];
    $self->readfile;
    undef $self->{fh};
}

sub readfile {
    my $self = shift;
    my $fh   = $self->{fh};
    my @data;
    while ( my $line = $fh->getline ) {
        chomp $line;
        if ( $line =~ /^#/ ) {
            $line =~ s/^# //;
            $self->_system_info($line);
        }
        else {
            push @data, $self->_request_data($line);
        }
    }
    $self->{request_data} = \@data;
}

sub _system_info {
    my ( $self, $line ) = @_;
    $line =~ m/^(.[^:]+): (.+)$/;
    my ( $key, $value ) = ( $1, $2 );
    $self->{system_info}->{$key} = $value;
}

sub _request_data {
    my ( $self, $line ) = @_;
    $line =~ m/^(.+): (.+)$/;
    my ( $info, $data ) = ( $1, $2 );
    my @fields = split q{, }, $data;
    $info =~ m/\[(.+)\]\s*(.[^ ]+)\s*pt-times/;
    my ( $date, $hostname ) = ( $1, $2 );
    my %request_data = (
        date     => $date,
        hostname => $hostname,
    );
    my @mt_process;

    foreach my $field (@fields) {
        $field =~ m/(.[^=]+)=(.+)/;
        my $key   = $1;
        my $value = $2;
        $value =~ s/\[(.+)\]/$1/;
        if ( $key =~ m/^MT/ or $key =~ m/^total:rebuild/ ) {
            push @mt_process, { $key => $value };
        }
        else {
            $request_data{ lc $key } = $value;
        }
    }
    $request_data{mt_process} = \@mt_process;
    \%request_data;
}

sub report {
    my $self     = shift;
    my %param    = @_;
    my $sys_info = $self->{system_info};
    my $request_data
        = $self->_sort_data( $self->{request_data}, $param{sort} );

    # temporary data dump
    use Data::Dumper;
    print Dumper($sys_info);
    print Dumper($request_data);
}

sub _sort_data {
    my $self = shift;
    my ( $data, $sort_key ) = @_;
    return $data if !$sort_key;
    my @sorted = map { $_->[0] }
        sort { $b->[1] <=> $a->[1] }    # sort data in descending order
        map { [ $_, $_->{$sort_key} ] } @$data;
    \@sorted;
}

1;
