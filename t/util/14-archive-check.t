use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    eval { require File::Which; 1 } or plan skip_all => 'requires File::Which';
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
        BinTarPath      => File::Which::which('tar')   || '',
        BinZipPath      => File::Which::which('zip')   || '',
        BinUnzipPath    => File::Which::which('unzip') || '',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Archive::Tar;
use Archive::Zip;
use File::Basename;
use File::Find;
use File::Path;
use File::Spec;
use File::Temp qw/tempdir/;

use constant BROKEN_ARCHIVE_ZIP => ($Archive::Zip::VERSION > 1.65 ? 1 : 0);

my %conf = (
    tgz    => { method => 'prefix',   class => 'MT::Util::Archive::Tgz' },
    zip    => { method => 'fileName', class => 'MT::Util::Archive::Zip' },
    bintgz => { method => 'prefix',   class => 'MT::Util::Archive::BinTgz' },
    binzip => { method => 'fileName', class => 'MT::Util::Archive::BinZip' },
);

my $TEST_DIR = tempdir(DIR => $test_env->root, CLEANUP => 1);

sub _create_dir {
    my $name = shift;

    my $dir = File::Spec->catdir($TEST_DIR, $name);

    rmtree($dir) if -d $dir;
    mkpath($dir);
    $dir;
}

sub _create_archive {
    my ($type, $dir, $callback) = @_;
    if ($type =~ /tgz/) {
        _create_tgz($dir, $callback);
    } elsif ($type =~ /zip/) {
        _create_zip($dir, $callback);
    }
}

sub _create_tgz {
    my ($dir, $callback) = @_;

    my @parts    = File::Spec->splitdir($dir);
    my $basename = pop @parts;
    my $parent   = File::Spec->catdir(@parts);

    my $archive = File::Spec->catfile($TEST_DIR, "$basename.tgz");

    my @files;
    find { wanted => sub { push @files, $File::Find::name }, no_chdir => 1 }, $dir;

    my $archiver = Archive::Tar->new;
    $archiver->add_files(@files);
    for ($archiver->get_files) {
        my $prefix = $_->prefix;
        if ($prefix =~ s!^.+?/$basename/!$basename/!) {
            $_->prefix($prefix);
        } else {
            $_->prefix("$basename/");
        }
        $callback->($_) if $callback;
    }

    local $Archive::Tar::DO_NOT_USE_PREFIX = 1;
    $archiver->write($archive, COMPRESS_GZIP);

    $archive;
}

sub _create_zip {
    my ($dir, $callback) = @_;

    my @parts    = File::Spec->splitdir($dir);
    my $basename = pop @parts;
    my $parent   = File::Spec->catdir(@parts);

    my $archive = File::Spec->catfile($TEST_DIR, "$basename.zip");

    my @files;
    find { wanted => sub { push @files, $File::Find::name }, no_chdir => 1 }, $dir;

    my $archiver = Archive::Zip->new;
    $archiver->storeSymbolicLink(1);    # for testing
    $archiver->addFileOrDirectory($_) for @files;
    for ($archiver->members) {
        my $relpath = File::Spec->abs2rel($_->fileName, $parent);
        $_->fileName($relpath);
        $callback->($_) if $callback;
    }

    $archiver->writeToFileNamed($archive);

    $archive;
}

subtest 'symlink' => sub {
    plan skip_all => 'symlink is not implemented' if $^O eq 'MSWin32';

    my $tempdir = tempdir(CLEANUP => 1, TMPDIR => 1);

    my $file = File::Spec->catfile($tempdir, 'file');
    open my $fh, '>', $file or die $!;
    print $fh "test\n";
    close $fh;

    my $subdir = File::Spec->catdir($tempdir, 'subdir');
    mkpath($subdir);

    my $link = File::Spec->catfile($subdir, 'link');
    symlink $file, $link;
    ok -l $link, "$link is a symbolic link";

    for my $type (sort keys %conf) {
        next if $type eq 'zip' && BROKEN_ARCHIVE_ZIP;
        my $archive = _create_archive($type, $tempdir);

        my $class = $conf{$type}{class};
        eval "require $class; 1" or do { note $@; next; };
        my $util = $class->new($type, $archive) or do { note $class->errstr; next; };
        ok !$util->is_safe_to_extract;
        like $util->errstr => qr/is not a regular file/,
            "$type: the warning looks correct";
        unlink $archive;
    }
};

subtest 'absolute path' => sub {
    my $tempdir = tempdir(CLEANUP => 1, TMPDIR => 1);

    my $file = File::Spec->catfile($tempdir, 'file');
    open my $fh, '>', $file or die $!;
    print $fh "test\n";
    close $fh;

    my $subdir = File::Spec->catdir($tempdir, 'subdir');
    mkpath($subdir);

    my $file2 = File::Spec->catfile($subdir, 'file2');
    open my $fh2, '>', $file2 or die $!;
    print $fh2 "test2\n";
    close $fh2;

    for my $type (sort keys %conf) {
        next if $type eq 'zip' && BROKEN_ARCHIVE_ZIP;
        my $method  = $conf{$type}{method};
        my $archive = _create_archive(
            $type, $tempdir,
            sub {
                my $member  = shift;
                my $abspath = File::Spec->catdir($tempdir, $member->$method);
                $member->$method($abspath);
            },
        );

        my $class = $conf{$type}{class};
        eval "require $class; 1" or do { note $@; next; };
        my $util = $class->new($type, $archive) or do { note $class->errstr; next; };
        ok !$util->is_safe_to_extract;
        like $util->errstr => qr/is an absolute path/,
            "$type: the warning looks correct";
        unlink $archive;
    }
};

subtest 'upwards' => sub {
    my $tempdir = tempdir(CLEANUP => 1, TMPDIR => 1);

    my $file = File::Spec->catfile($tempdir, 'file');
    open my $fh, '>', $file or die $!;
    print $fh "test\n";
    close $fh;

    my $subdir = File::Spec->catdir($tempdir, 'subdir');
    mkpath($subdir);

    my $file2 = File::Spec->catfile($subdir, 'file2');
    open my $fh2, '>', $file2 or die $!;
    print $fh2 "test2\n";
    close $fh2;

    for my $type (sort keys %conf) {
        next if $type eq 'zip' && BROKEN_ARCHIVE_ZIP;
        my $method  = $conf{$type}{method};
        my $archive = _create_archive(
            $type, $tempdir,
            sub {
                my $member = shift;

                # Avoid File::Spec->catdir() here because
                # File::Spec::Win32::catdir calls _canon_cat()
                # and removes .. silently
                $member->$method($member->$method . '/..');
            },
        );

        my $class = $conf{$type}{class};
        eval "require $class; 1" or do { note $@; next; };
        my $util = $class->new($type, $archive) or do { note $class->errstr; next; };
        ok !$util->is_safe_to_extract;
        like $util->errstr => qr/contains \.\./, "$type: the warning looks correct";
        unlink $archive;
    }
};

done_testing;
