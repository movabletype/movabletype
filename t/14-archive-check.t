use strict;
use warnings;
use FindBin;
use Test::More;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';

use MT::Util::Archive::Tgz;
use MT::Util::Archive::Zip;
use Archive::Tar;
use Archive::Zip;
use File::Basename;
use File::Find;
use File::Path;
use File::Spec;
use File::Temp qw/tempdir/;
use MT;

my %conf = (
    tgz => { method => 'prefix',   class => 'MT::Util::Archive::Tgz' },
    zip => { method => 'fileName', class => 'MT::Util::Archive::Zip' },
);

my $TEST_DIR = tempdir( TMPDIR => 1, CLEANUP => 1 );

sub _create_dir {
    my $name = shift;

    my $dir = File::Spec->catdir( $TEST_DIR, $name );

    rmtree($dir) if -d $dir;
    mkpath($dir);
    $dir;
}

sub _create_archive {
    my ( $type, $dir, $callback ) = @_;
    if ( $type eq 'tgz' ) {
        _create_tgz( $dir, $callback );
    }
    elsif ( $type eq 'zip' ) {
        _create_zip( $dir, $callback );
    }
}

sub _create_tgz {
    my ( $dir, $callback ) = @_;

    my @parts    = File::Spec->splitdir($dir);
    my $basename = pop @parts;
    my $parent   = File::Spec->catdir(@parts);

    my $archive = File::Spec->catfile( $TEST_DIR, "$basename.tgz" );

    my @files;
    find { wanted => sub { push @files, $File::Find::name }, no_chdir => 1 },
        $dir;

    my $archiver = Archive::Tar->new;
    $archiver->add_files(@files);
    for ( $archiver->get_files ) {
        my $prefix = $_->prefix;
        if ( $prefix =~ s!^.+?/$basename/!$basename/! ) {
            $_->prefix($prefix);
        }
        else {
            $_->prefix("$basename/");
        }
        $callback->($_) if $callback;
    }

    local $Archive::Tar::DO_NOT_USE_PREFIX = 1;
    $archiver->write( $archive, COMPRESS_GZIP );

    $archive;
}

sub _create_zip {
    my ( $dir, $callback ) = @_;

    my @parts    = File::Spec->splitdir($dir);
    my $basename = pop @parts;
    my $parent   = File::Spec->catdir(@parts);

    my $archive = File::Spec->catfile( $TEST_DIR, "$basename.zip" );

    my @files;
    find { wanted => sub { push @files, $File::Find::name }, no_chdir => 1 },
        $dir;

    my $archiver = Archive::Zip->new;
    $archiver->storeSymbolicLink(1);    # for testing
    $archiver->addFileOrDirectory($_) for @files;
    for ( $archiver->members ) {
        my $relpath = File::Spec->abs2rel( $_->fileName, $parent );
        $_->fileName($relpath);
        $callback->($_) if $callback;
    }

    $archiver->writeToFileNamed($archive);

    $archive;
}

subtest 'symlink' => sub {
    plan skip_all => 'symlink is not implemented' if $^O eq 'MSWin32';

    my $tempdir = tempdir( CLEANUP => 1, TMPDIR => 1 );

    my $file = File::Spec->catfile( $tempdir, 'file' );
    open my $fh, '>', $file or die $!;
    print $fh "test\n";
    close $fh;

    my $subdir = File::Spec->catdir( $tempdir, 'subdir' );
    mkpath($subdir);

    my $link = File::Spec->catfile( $subdir, 'link' );
    symlink $file, $link;
    ok -l $link, "$link is a symbolic link";

    for my $type (qw/ tgz zip /) {
        my $archive = _create_archive( $type, $tempdir );

        my $util = $conf{$type}{class}->new( $type, $archive );
        ok !$util->is_safe_to_extract;
        like $util->errstr => qr/is not a regular file/,
            "the warning looks correct";
        unlink $archive;
    }
};

subtest 'absolute path' => sub {
    my $tempdir = tempdir( CLEANUP => 1, TMPDIR => 1 );

    my $file = File::Spec->catfile( $tempdir, 'file' );
    open my $fh, '>', $file or die $!;
    print $fh "test\n";
    close $fh;

    my $subdir = File::Spec->catdir( $tempdir, 'subdir' );
    mkpath($subdir);

    my $file2 = File::Spec->catfile( $subdir, 'file2' );
    open my $fh2, '>', $file2 or die $!;
    print $fh2 "test2\n";
    close $fh2;

    for my $type (qw/ tgz zip /) {
        my $method  = $conf{$type}{method};
        my $archive = _create_archive(
            $type, $tempdir,
            sub {
                my $member = shift;
                my $abspath
                    = File::Spec->catdir( $tempdir, $member->$method );
                $member->$method($abspath);
            }
        );

        my $util = $conf{$type}{class}->new( $type, $archive );
        ok !$util->is_safe_to_extract;
        like $util->errstr => qr/is an absolute path/,
            "the warning looks correct";
        unlink $archive;
    }
};

subtest 'upwards' => sub {
    my $tempdir = tempdir( CLEANUP => 1, TMPDIR => 1 );

    my $file = File::Spec->catfile( $tempdir, 'file' );
    open my $fh, '>', $file or die $!;
    print $fh "test\n";
    close $fh;

    my $subdir = File::Spec->catdir( $tempdir, 'subdir' );
    mkpath($subdir);

    my $file2 = File::Spec->catfile( $subdir, 'file2' );
    open my $fh2, '>', $file2 or die $!;
    print $fh2 "test2\n";
    close $fh2;

    for my $type (qw/tgz zip/) {
        my $method  = $conf{$type}{method};
        my $archive = _create_archive(
            $type, $tempdir,
            sub {
                my $member = shift;
                $member->$method(
                    File::Spec->catdir( $member->$method, '..' ) );
            }
        );

        my $util = $conf{$type}{class}->new( $type, $archive );
        ok !$util->is_safe_to_extract;
        like $util->errstr => qr/contains \.\./, "the warning looks correct";
        unlink $archive;
    }
};

done_testing;
