# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Cache::File;

use warnings;
use strict;

use File::Spec;
use MT::FileMgr;
use base qw( MT::ErrorHandler );

sub _cache_dir {
    my MT::Cache::File $self = shift;
    File::Spec->catdir( MT->config('TempDir'), 'mt_cache_file' );
}

sub _cache_file {
    my MT::Cache::File $self = shift;
    ( my $f = $_[0] ) =~ s!([^a-zA-Z0-9_.~-])!uc sprintf "%%%02x", ord($1)!eg;
    File::Spec->catfile( _cache_dir(), $f );
}

sub _file_mgr {
    my MT::Cache::File $self = shift;
    $self->{_file_mgr} ||= MT::FileMgr->new('Local');
}

sub errstr {
    my MT::Cache::File $self = shift;
    $self->_file_mgr->errstr || $self->errstr;
}

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = bless \%param, $class;
    return $self;
}

sub get {
    my MT::Cache::File $self = shift;
    my ($key) = @_;

    my $fmgr = $self->_file_mgr;
    my $path = $self->_cache_file($key);

    return undef unless $fmgr->exists($path);

    $fmgr->get_data( $path, 'upload' );
}

sub get_multi {
    my MT::Cache::File $self = shift;
    my @keys = @_;

    my %result = ();
    for my $key (@keys) {
        if ( defined( my $data = $self->get($key) ) ) {
            $result{$key} = $data;
        }
    }

    return undef if $self->_file_mgr->errstr;

    return \%result;
}

sub delete {
    my MT::Cache::File $self = shift;
    my ($key) = @_;

    my $fmgr = $self->_file_mgr;
    my $path = $self->_cache_file($key);
    $fmgr->delete($path);
}
*remove = \&delete;

sub add {
    my MT::Cache::File $self = shift;
    $self->_set(@_);
}

sub replace {
    my MT::Cache::File $self = shift;
    $self->_set(@_);
}

sub set {
    my MT::Cache::File $self = shift;
    $self->_set(@_);
}

sub _set {
    my MT::Cache::File $self = shift;
    my ( $key, $val ) = @_;

    my $fmgr = $self->_file_mgr;
    my $dir = $self->_cache_dir;
    if ( !$fmgr->exists($dir) ) {
        $fmgr->mkpath($dir)
            or return undef;
    }
    $fmgr->put_data( $val, $self->_cache_file($key), 'upload' );
}

sub purge_stale {
    my MT::Cache::File $self = shift;
    my ($ttl)                = @_;
    my $threshold            = time() - $ttl;

    my $fmgr = $self->_file_mgr;
    my $dir  = $self->_cache_dir;
    return 1 unless $fmgr->exists($dir);

    opendir( my $dh, $dir )
        or return $self->error( MT::FileMgr::Local::_syserr("$!") );
    for my $ent ( readdir $dh ) {
        my $path = File::Spec->catfile( $dir, $ent );
        next unless -f MT::FileMgr::Local::_local($path);
        next if $fmgr->file_mod_time($path) < $threshold;
        $fmgr->delete($path) or return undef;
    }

    return 1;
}

sub flush_all {
    my MT::Cache::File $self = shift;

    my $fmgr = $self->_file_mgr;
    my $dir  = $self->_cache_dir;
    return 1 unless $fmgr->exists($dir);

    opendir( my $dh, $dir )
        or return $self->error( MT::FileMgr::Local::_syserr("$!") );
    for my $ent ( readdir $dh ) {
        my $path = File::Spec->catfile( $dir, $ent );
        next unless -f MT::FileMgr::Local::_local($path);
        $fmgr->delete($path) or return undef;
    }

    return 1;
}

sub DESTROY { }

1;
__END__

=head1 NAME

MT::Cache::File - File object compatible with the MT::Cache interface.

=head1 DESCRIPTION

I<MT::Cache::File> provides interface to MT::Cache.

=head1 USAGE

See POD of I<MT::Cache::Session> for details.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
