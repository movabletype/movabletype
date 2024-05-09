# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::Checksums;

use strict;
use warnings;
use File::Find;
use File::Spec;
use MT::Util::Digest::MD5 qw(md5_hex);
use ExtUtils::Manifest ();

my $HasGit;

sub checksum_file {
    my $home = $ENV{MT_TEST_ROOT} || $ENV{MT_HOME} || '.';
    File::Spec->catfile($home, 'CHECKSUMS');
}

sub load_checksums {
    my $file = checksum_file();
    return unless -f $file;
    open my $fh, '<', $file or die "$!: $file";
    my %map;
    while(<$fh>) {
        chomp;
        next if /^#/ or /^\s*$/;
        my ($md5, $name) = split /\t/, $_;
        $map{$name} = $md5;
    }
    \%map;
}

sub update_checksums {
    my $file = checksum_file();
    my @files;
    my $manifested;
    if (-e './MANIFEST') {
        @files = keys %{ ExtUtils::Manifest::maniread() };
        $manifested = 1;
    } elsif (-d '.git' && _has_git()) {
        my $skip = ExtUtils::Manifest::maniskip();
        @files = grep { !$skip->($_) } split /\n/, `git ls-tree -r --name-only HEAD`;
    }
    open my $out, '>', $file or die "$!: $file";
    for my $file (sort @files) {
        next if $file eq 'CHECKSUMS';    # ignore myself
        next if $file =~ /\.exists$/;    # ignore .exists as well
        print $out generate_checksum($file), "\t", $file, "\n";
    }
    close $out;
    ExtUtils::Manifest::mkmanifest() if $manifested;
}

sub generate_checksum {
    my $file = shift;
    my $body = do { local $/; open my $fh, '<:raw', $file; <$fh> };
    md5_hex($body);
}

sub test_checksums {
    my $dir = shift || '.';

    my $home = $ENV{MT_TEST_ROOT} || $ENV{MT_HOME} || '.';

    my $checksums = load_checksums() or return;
    my (@modified, @untracked);
    my $skip = ExtUtils::Manifest::maniskip();
    File::Find::find({
        wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            my $rel = File::Spec->abs2rel($file, $home);
            return if $rel eq 'CHECKSUMS';
            return if $rel =~ /\.exists$/;
            $rel =~ s!\\!/!g if $^O eq 'MSWin32';

            if ($checksums->{$rel}) {
                my $checksum = generate_checksum($file);
                push @modified, $rel if $checksum ne $checksums->{$rel};
            } else {
                push @untracked, $rel unless $skip->($rel);
            }
        },
        no_chdir => 1,
    }, $dir);
    return if !@modified && !@untracked;

    return +{
        modified  => [sort @modified],
        untracked => [sort @untracked],
    };
}

sub _has_git {
    return $HasGit if defined $HasGit;
    $HasGit = `git --version` =~ /^git version/s ? 1 : 0;
}

1;

