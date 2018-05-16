#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::App;
use MT::Object;
use MT::Entry;

MT::Test->init_time;

$test_env->prepare_fixture('db');

my $app  = MT::App->new;
my $blog = MT::Blog->load(1);
$MT::Test::CORE_TIME = Time::Local::timegm( 0, 0, 12, 19, 11, 2013 );
my $entry_revision_pkg = MT::Entry->revision_pkg;

# Clear mt_entry_rev table.
my $driver = MT::Object->driver();
my $dbh    = $driver->rw_handle;
$dbh->do("delete from mt_entry_rev");

sub create_entry {
    my $entry = MT::Entry->new;
    $entry->set_values(
        {   titme     => 'titme',
            status    => 2,
            author_id => 1,
            blog_id   => $blog->id,
        }
    );
    $entry->save or die;
    $entry->gather_changed_cols( MT::Entry->new );
    $entry->save_revision;

    my $rev_obj = $entry_revision_pkg->load( { 'entry_id' => $entry->id, } )
        or die;

    ( $entry, $rev_obj );
}

ok( MT::Entry->isa('MT::Revisable'), 'MT::Entry is a MT::Revisable' );
is( MT::Entry->properties->{audit}, 1, 'MT::Entry has some audit columns' );

my @suite = (
    {   server_offset => 0,
        timestamp     => 20131219120000,
    },
    {   server_offset => 3,
        timestamp     => 20131219150000,
    },
    {   server_offset => 9,
        timestamp     => 20131219210000,
    },
);

subtest 'audit columns' => sub {
    subtest 'entry' => sub {
        for my $d (@suite) {
            subtest 'server_offset:' . $d->{server_offset} => sub {
                $blog->server_offset( $d->{server_offset} );
                $blog->save;
                my ( $e, $rev ) = create_entry();
                is( $e->created_on, $d->{timestamp},
                    'An entry\'s created_on has been assigned correctly' );
                is( $e->modified_on, $d->{timestamp},
                    'An entry\'s modified_on has been assigned correctly' );
                is( $rev->created_on, $d->{timestamp},
                    'An revision object\'s created_on has been assigned correctly'
                );
                is( $rev->modified_on, $d->{timestamp},
                    'An revision object\'s modified_on has been assigned correctly'
                );
            };
        }
    };

    my $w;
    subtest 'website' => sub {
        subtest 'create' => sub {
            $w = MT->model('website')->new;
            $w->set_values(
                {   name          => 'test website',
                    server_offset => $suite[0]->{server_offset},
                }
            );
            $w->save or die $w->errstr;

            is( $w->created_on,
                $suite[0]->{timestamp},
                'A website\'s created_on has been assigned correctly'
            );
            is( $w->modified_on,
                $suite[0]->{timestamp},
                'A website\'s modified_on has been assigned correctly'
            );
        };

        subtest 'update' => sub {
            $w->server_offset( $suite[1]->{server_offset} );
            $w->modified_by(1);
            $w->save or die $w->errstr;

            is( $w->created_on,
                $suite[0]->{timestamp},
                'A website\'s created_on has been assigned correctly'
            );
            is( $w->modified_on,
                $suite[1]->{timestamp},
                'A website\'s modified_on has been assigned correctly'
            );
        };
    };

    subtest 'blog' => sub {
        my $b;
        subtest 'create' => sub {
            $b = MT->model('blog')->new;
            $b->set_values(
                {   name          => 'test blog',
                    parent_id     => $w->id,
                    server_offset => $suite[1]->{server_offset},
                }
            );
            $b->save or die $b->errstr;

            is( $b->created_on,
                $suite[1]->{timestamp},
                'A blog\'s created_on has been assigned correctly'
            );
            is( $b->modified_on,
                $suite[1]->{timestamp},
                'A blog\'s modified_on has been assigned correctly'
            );
        };

        subtest 'update' => sub {
            $b->server_offset( $suite[2]->{server_offset} );
            $b->modified_by(1);
            $b->save or die $b->errstr;

            is( $b->created_on,
                $suite[1]->{timestamp},
                'A blog\'s created_on has been assigned correctly'
            );
            is( $b->modified_on,
                $suite[2]->{timestamp},
                'A blog\'s modified_on has been assigned correctly'
            );
        };
    };
};

done_testing();
