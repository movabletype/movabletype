use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
use Carp::Always;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::App::CMS;
use MT::Test::BackupRestore;

MT::App::CMS->instance;

subtest 'backup and restore using .tar.gz (with reset)' => sub {
    my $self = MT::Test::BackupRestore->new;
    my $objs = $self->prepare;
    my $files = $self->backup(format => 'tgz');
    $self->reset;
    $self->restore(files => $files);
    $self->test_with($objs);
};

subtest 'backup and restore using .zip (with reset)' => sub {
    my $self = MT::Test::BackupRestore->new;
    my $objs = $self->prepare;
    my $files = $self->backup(format => 'zip');
    $self->reset;
    $self->restore(files => $files);
    $self->test_with($objs);
};

subtest 'backup and restore using manifest (with reset)' => sub {
    my $self = MT::Test::BackupRestore->new;
    my $objs = $self->prepare;
    my $files = $self->backup();
    $self->reset;
    $self->restore(files => $files);
    $self->test_with($objs);
};

done_testing;

