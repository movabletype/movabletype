#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $mt = MT->instance;

# Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $b = $mt->model('blog')->new;
    $b->set_values( { id => 1, } );
    $b->save or die $b->errstr;

    my $cat = MT::Test::Permission->make_category( blog_id => $b->id, );

    my $folder = MT::Test::Permission->make_category( blog_id => $b->id, );

    my @dates = (
        {   authored_on  => '20131201000000',
            modified_on  => '20130901000000',
            has_category => 0
        },
        {   authored_on  => '20131101000000',
            modified_on  => '20131001000000',
            has_category => 1
        },
        {   authored_on  => '20131001000000',
            modified_on  => '20131101000000',
            has_category => 1
        },
        {   authored_on  => '20130901000000',
            modified_on  => '20131201000000',
            has_category => 1
        },
    );
    foreach (@dates) {
        my %values = (
            blog_id     => 1,
            author_id   => 1,
            status      => MT::Entry::RELEASE(),
            authored_on => $_->{authored_on},
            modified_on => $_->{modified_on},
            created_on  => $_->{modified_on},
        );

        # page
        my $p = $mt->model('page')->new;
        $p->set_values( \%values );
        $p->save or die $p->errstr;

        # entry
        my $e = $mt->model('entry')->new;
        $e->set_values( \%values );
        $e->save or die $e->errstr;

        next unless $_->{has_category};

        # associate with category/folder
        my $p_place = $mt->model('placement')->new;
        $p_place->set_values(
            {   blog_id     => $b->id,
                category_id => $folder->id,
                entry_id    => $p->id,
                is_primary  => 1,
            }
        );
        $p_place->save or die $p_place->errstr;

        my $e_place = $mt->model('placement')->new;
        $e_place->set_values(
            {   blog_id     => $b->id,
                category_id => $cat->id,
                entry_id    => $e->id,
                is_primary  => 1,
            }
        );
        $e_place->save or die $e_place->errstr;
    }
});

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:PageNext
--- template
<MTPages><MTPageNext><MTPageID></MTPageNext></MTPages>
--- expected
357

=== mt:PagePrevious
--- template
<MTPages><MTPagePrevious><MTPageID></MTPagePrevious></MTPages>
--- expected
135

=== mt:EntryNext
--- template
<MTEntries><MTEntryNext><MTEntryID></MTEntryNext></MTEntries>
--- expected
246

=== mt:EntryPrevious
--- template
<MTEntries><MTEntryPrevious><MTEntryID></MTEntryPrevious></MTEntries>
--- expected
468

=== mt:PageNext (by_category="1")
--- template
<MTPages><MTPageNext by_category="1"><MTPageID></MTPageNext></MTPages>
--- expected
57

=== mt:PagePrevious (by_category="1")
--- template
<MTPages><MTPagePrevious by_category="1"><MTPageID></MTPagePrevious></MTPages>
--- expected
35

=== mt:EntryNext (by_category="1")
--- template
<MTEntries><MTEntryNext by_category="1"><MTEntryID></MTEntryNext></MTEntries>
--- expected
46

=== mt:EntryPrevious (by_category="1")
--- template
<MTEntries><MTEntryPrevious by_category="1"><MTEntryID></MTEntryPrevious></MTEntries>
--- expected
68

=== mt:PageNext (by_folder="1")
--- template
<MTPages><MTPageNext by_folder="1"><MTPageID></MTPageNext></MTPages>
--- expected
57

=== mt:PagePrevious (by_folder="1")
--- template
<MTPages><MTPagePrevious by_folder="1"><MTPageID></MTPagePrevious></MTPages>
--- expected
35

=== mt:EntryNext (by_folder="1")
--- template
<MTEntries><MTEntryNext by_folder="1"><MTEntryID></MTEntryNext></MTEntries>
--- expected
46

=== mt:EntryPrevious (by_folder="1")
--- template
<MTEntries><MTEntryPrevious by_folder="1"><MTEntryID></MTEntryPrevious></MTEntries>
--- expected
68
