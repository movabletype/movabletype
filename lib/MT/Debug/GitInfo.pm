package MT::Debug::GitInfo;
use strict;
use warnings;

sub vcs_revision {
    my $class = shift;
    my $hash  = $class->_hash;
    if ($hash) {
        my $revision = $class->_revision;
        my $branch   = $class->_branch;
        return { revision => "$revision-$hash", branch => $branch };
    }
    else {
        return undef;
    }
}

sub _revision {
    my $class    = shift;
    my $revision = `git rev-list --count HEAD`;
    if ($revision) {
        chomp $revision;
        return 'r' . $revision;
    }
    else {
        return undef;
    }
}

sub _hash {
    my $class = shift;
    my $hash  = `git rev-parse HEAD`;
    if ($hash) {
        chomp $hash;
        return substr $hash, 0, 8;
    }
    else {
        return undef;
    }
}

sub _branch {
    my $class  = shift;
    my $branch = `git symbolic-ref --short HEAD`;
    if ( defined $branch ) {
        chomp $branch;
        return $branch;
    }
    else {
        return undef;
    }
}

1;

