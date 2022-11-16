# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::FileMgr::Local;
use strict;
use warnings;

use MT::FileMgr;
@MT::FileMgr::Local::ISA = qw( MT::FileMgr );

use Symbol;
use Fcntl qw( :DEFAULT :flock );

sub _local {
    ## TBD: does it needed to escape backslashs?
    return $^O eq 'MSWin32' ? Encode::encode( 'cp932', $_[0] ) : $_[0];
}

sub _syserr {
    if ( $^O eq 'MSWin32' ) {
        return Encode::is_utf8( $_[0] )
            ? $_[0]
            : Encode::decode( 'cp932', $_[0] );
    }
    else {
        return Encode::is_utf8( $_[0] )
            ? $_[0]
            : Encode::decode_utf8( $_[0] );
    }
}

sub get_data {
    my $fmgr = shift;
    my ( $from, $type ) = @_;
    my ($fh);
    my $is_handle = $fmgr->is_handle($from);
    if ( !$is_handle ) {
        $fh = gensym();
        open $fh, "<",
            _local($from)
            or return $fmgr->error(
            MT->translate(
                "Opening local file '[_1]' failed: [_2]", $from,
                _syserr("$!")
            )
            );
    }
    else {
        $fh = $from;
    }
    if ( $type && $type eq 'upload' ) {
        binmode($fh);
    }
    my ($data);
    { local $/; $data = <$fh>; }
    close $fh if !$is_handle;
    if ( !$type || $type ne 'upload' ) {
        require Encode;
        $data = Encode::decode_utf8($data)
            unless Encode::is_utf8($data);
    }
    $data;
}

## $type is either 'upload' or 'output'
sub put {
    my $fmgr = shift;
    my ( $from, $to, $type ) = @_;
    my $rv;
    if ( !$fmgr->is_handle($from) ) {
        my $fh = gensym();
        open $fh, "<",
            $from
            or return $fmgr->error(
            MT->translate(
                "Opening local file '[_1]' failed: [_2]", $from,
                _syserr("$!")
            )
            );
        $rv = _write_file( $fmgr, $fh, $to, $type );
        close $fh;
    }
    else {
        $rv = _write_file( $fmgr, $from, $to, $type );
    }
    $rv;
}

*put_data = \&_write_file;

sub _write_file {
    my $fmgr = shift;
    my ( $from, $to, $type ) = @_;
    local *FH;
    my ( $umask, $perms );
    my $cfg = MT->config;
    if ( $type && $type eq 'upload' ) {
        $umask = $cfg->UploadUmask;
        $perms = $cfg->UploadPerms;
    }
    else {
        $umask = $cfg->HTMLUmask;
        $perms = $cfg->HTMLPerms;
    }

    $to = _local($to);

    my $old = umask( oct $umask );
    sysopen FH, $to, O_RDWR | O_CREAT | O_TRUNC,
        oct $perms
        or return $fmgr->error(
        MT->translate(
            "Opening local file '[_1]' failed: [_2]",
            $to, _syserr("$!")
        )
        );
    if ( $type && $type eq 'upload' ) {
        binmode(FH);
        binmode($from) if $fmgr->is_handle($from);
    }
    ## Lock file unless NoLocking specified.
    flock FH, LOCK_EX unless $cfg->NoLocking;
    seek FH, 0, 0;
    truncate FH, 0;
    my $bytes = 0;
    if ( $fmgr->is_handle($from) ) {
        while ( my $len = read $from, my ($block), 8192 ) {
            print FH $block;
            $bytes += $len;
        }
    }
    else {
        my $enc = $cfg->PublishCharset || 'utf8';
        $from = Encode::encode( $enc, $from ) if Encode::is_utf8($from);
        print FH $from;
        $bytes = length($from);
    }
    close FH;
    umask($old);
    $bytes;
}

sub exists { -e _local( $_[1] ) }

sub can_write { -w _local( $_[1] ) }

sub mkpath {
    my $fmgr = shift;
    my ($path) = @_;
    $path = _local($path);
    require File::Path;
    my $umask = oct MT->config->DirUmask;
    my $old   = umask($umask);
    eval { File::Path::mkpath( [$path], 0, 0777 ) };
    return $fmgr->error( _syserr($@) ) if $@;
    umask($old);
    1;
}

sub rename {
    my $fmgr = shift;
    my ( $from, $to ) = @_;

    # If same file provided, do nothing
    return if $from eq $to;

    $from = _local($from);
    $to   = _local($to);

    #First, remove existing file
    if ( $fmgr->exists($to) ) {
        $fmgr->delete($to) or return;
    }
    rename $from,
        $to
        or return $fmgr->error(
        MT->translate(
            "Renaming '[_1]' to '[_2]' failed: [_3]", $from,
            $to,                                      _syserr("$!")
        )
        );
    1;
}

sub file_mod_time {
    my $fmgr = shift;
    my ($file) = @_;
    $file = _local($file);
    if ( -e $file ) {
        return ( stat($file) )[9];    # modification timestamp
    }
    return undef;
}

sub file_size {
    my $fmgr = shift;
    my ($file) = @_;
    $file = _local($file);
    if ( -e $file ) {
        return ( stat($file) )[7];    # filesize
    }
    return undef;
}

sub content_is_updated {
    my $fmgr = shift;
    my ( $file, $content ) = @_;
    $file = _local($file);
    return 1 unless -e $file;
    ## If the system has Digest::MD5, compare MD5 hashes; otherwise
    ## read in the file and compare the strings.
    my $fh = gensym();
    open $fh, "<", $file or return 1;
    if ( eval { require MT::Util::Digest::MD5; 1 } ) {
        my $ctx = MT::Util::Digest::MD5->new;
        $ctx->addfile($fh);
        close $fh;
        my $data;
        if ( $] >= 5.007003 ) {
            require Encode;
            $data = $$content;
            Encode::_utf8_off($data);
        }
        elsif ( $] >= 5.006001 ) {
            $data = pack 'C0A*', $$content;
        }
        else {
            $data = $$content;
        }
        return $ctx->digest ne MT::Util::Digest::MD5::md5($data);
    }
    else {
        my $data;
        binmode $fh;
        while ( read $fh, my ($chunk), 8192 ) {
            $data .= $chunk;
        }
        close $fh;
        return $$content ne $data;
    }
}

sub delete {
    my $fmgr = shift;
    my ($file) = @_;
    $file = _local($file);
    return 1 unless -e $file or -l $file;
    unlink $file
        or return $fmgr->error(
        MT->translate( "Deleting '[_1]' failed: [_2]", $file, _syserr("$!") )
        );
    1;
}

sub rmdir {
    my $fmgr = shift;
    my ($dir) = @_;
    return 1 unless -d $dir && !-l $dir;
    rmdir $dir
        or return $fmgr->error( "Deleting '[_1]' directory failed: [_2]",
        $dir, _syserr("$!") );
    1;
}

1;
__END__

=head1 NAME

MT::FileMgr::Local

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
