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
use MT::Util::Encode;

sub _local {
    ## TBD: does it needed to escape backslashs?
    return $^O eq 'MSWin32' ? MT::Util::Encode::encode( 'cp932', $_[0] ) : $_[0];
}

sub _syserr {
    if ( $^O eq 'MSWin32' ) {
        return MT::Util::Encode::decode_unless_flagged( 'cp932', $_[0] );
    }
    else {
        return MT::Util::Encode::decode_utf8_unless_flagged( $_[0] );
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
        $data = MT::Util::Encode::decode_utf8_unless_flagged($data);
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
    sysopen my $FH, $to, O_RDWR | O_CREAT | O_TRUNC,
        oct $perms
        or return $fmgr->error(
        MT->translate(
            "Opening local file '[_1]' failed: [_2]",
            $to, _syserr("$!")
        )
        );
    if ( $type && $type eq 'upload' ) {
        binmode($FH);
        binmode($from) if $fmgr->is_handle($from);
    }
    ## Lock file unless NoLocking specified.
    flock $FH, LOCK_EX unless $cfg->NoLocking;
    seek $FH, 0, 0;
    truncate $FH, 0;
    my $bytes = 0;
    if ( $fmgr->is_handle($from) ) {
        while ( my $len = read $from, my ($block), 8192 ) {
            print $FH $block;
            $bytes += $len;
        }
    }
    else {
        my $enc = $cfg->PublishCharset || 'utf8';
        $from = MT::Util::Encode::encode_if_flagged( $enc, $from );
        print $FH $from;
        $bytes = length($from);
    }
    close $FH;
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
        my $data = $$content;
        MT::Util::Encode::_utf8_off($data);
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
