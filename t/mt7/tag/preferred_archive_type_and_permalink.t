use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Fixture;

filters {
    template               => [qw( chomp )],
    expected               => [qw( chomp )],
    preferred_archive_type => [qw(chomp)],
};

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
        name  => 'test site',
        theme => 'classic_test_website',
    }],
    category => [qw/foo bar baz/],
    entry    => [{
        basename   => 'entry_test',
        title      => 'entry test',
        status     => 'publish',
        categories => [qw(foo)],
    }],
});

my $site = $objs->{website}{'test site'};

MT->publisher->rebuild(BlogID => $site->id);

MT::Test::Tag->run_perl_tests(
    $site->id,
    sub {
        my ($ctx, $block) = @_;
        $site->archive_type_preferred($block->preferred_archive_type) if $block->can('preferred_archive_type');
        $site->save;
        return;
    });
MT::Test::Tag->run_php_tests(
    $site->id,
    sub {
        my ($block) = @_;
        $site->archive_type_preferred($block->preferred_archive_type) if $block->can('preferred_archive_type');
        $site->save;
        return;
    });

__END__

=== mt:EntryPermalink (Individual)
--- preferred_archive_type
Individual
--- template
<mt:Entries><mt:EntryPermalink></mt:Entries>
--- expected
http://narnia.na/1978/01/entry-test.html

=== mt:EntryPermalink (Category)
--- preferred_archive_type
Category
--- template
<mt:Entries><mt:EntryPermalink></mt:Entries>
--- expected
http://narnia.na/foo/#000001
