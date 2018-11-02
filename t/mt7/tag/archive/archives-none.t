#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
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
    archive_type => [qw(chomp)],
    template     => [qw(chomp)],
    expected     => [qw(chomp)],
};

$test_env->prepare_fixture('db');

my @archive_types = sort { $a cmp $b } MT->publisher->archive_types;
my $archive_types = join ',', @archive_types;

my $blog = MT::Blog->load($blog_id);

# Run Perl Tests

MT::Test::Tag->run_perl_tests(
    $blog_id,
    sub {
        my ( $ctx, $block ) = @_;
        my $site = $ctx->stash('blog');
        $site->archive_type(
            defined $block->archive_type
            ? $block->archive_type
            : $archive_types
        );
    }
);

# Run PHP Tests

MT::Test::Tag->run_php_tests(
    $blog_id,
    sub {
        my ($block) = @_;
        my $archive_type
            = defined $block->archive_type
            ? $block->archive_type
            : $archive_types;
        return <<"PHP";
\$site = \$db->fetch_blog(\$blog_id);
\$site->archive_type = "$archive_type";
\$site->save();
PHP
    }
);

__END__

=== No modifier and $blog->archive_type('')
--- archive_type

--- template
<mt:Archives><mt:ArchiveType>
</mt:Archives>
--- expected

=== No modifier and $blog->archive_type('None')
--- archive_type
None
--- template
<mt:Archives><mt:ArchiveType>
</mt:Archives>
--- expected

=== No modifier and $blog->archive_type('Some ArchiveType')
--- template
<mt:Archives><mt:ArchiveType>
</mt:Archives>
--- expected
Author
Author-Daily
Author-Monthly
Author-Weekly
Author-Yearly
Category
Category-Daily
Category-Monthly
Category-Weekly
Category-Yearly
ContentType
ContentType-Author
ContentType-Author-Daily
ContentType-Author-Monthly
ContentType-Author-Weekly
ContentType-Author-Yearly
ContentType-Category
ContentType-Category-Daily
ContentType-Category-Monthly
ContentType-Category-Weekly
ContentType-Category-Yearly
ContentType-Daily
ContentType-Monthly
ContentType-Weekly
ContentType-Yearly
Daily
Individual
Monthly
Page
Weekly
Yearly
