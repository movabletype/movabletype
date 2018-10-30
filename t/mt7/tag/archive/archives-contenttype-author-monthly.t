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

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    archive_type => [qw( var chomp )],
    template     => [qw( var chomp )],
    expected     => [qw( var chomp )],
};

$test_env->prepare_fixture('db');

my $archive_types
    = 'Individual,Page,Daily,Weekly,Monthly,Yearly,Author,Author-Daily,Author-Weekly,Author-Monthly,Author-Yearly,Category,Category-Daily,Category-Weekly,Category-Monthly,Category-Yearly,ContentType,ContentType-Daily,ContentType-Weekly,ContentType-Monthly,ContentType-Yearly,ContentType-Author,ContentType-Author-Daily,ContentType-Author-Weekly,ContentType-Author-Monthly,ContentType-Author-Yearly,ContentType-Category,ContentType-Category-Daily,ContentType-Category-Weekly,ContentType-Category-Monthly,ContentType-Category-Yearly';

my $blog = MT::Blog->load($blog_id);

$vars->{archive_type}    = 'ContentType-Author-Monthly';
$vars->{template_params} = <<'PARAMS';
archive_class: contenttype-author-monthly-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_monthly_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
chomp( $vars->{template_params} );

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

=== Empty with type
--- todo
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type

--- template
<mt:Archives type="[% archive_type %]">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
[% archive_type %]
***
[% template_params %]

=== Empty with archive_type
--- todo
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type

--- template
<mt:Archives archive_type="[% archive_type %]">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
[% archive_type %]
***
[% template_params %]

=== None with type
--- todo
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type
None
--- template
<mt:Archives type="[% archive_type %]">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
[% archive_type %]
***
[% template_params %]

=== None with archive_type
--- todo
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type
None
--- template
<mt:Archives archive_type="[% archive_type %]">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
[% archive_type %]
***
[% template_params %]

=== Some ArchiveTypes with type
--- template
<mt:Archives type="[% archive_type %]">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
[% archive_type %]
***
[% template_params %]

=== Some ArchiveTypes with archive_type
--- template
<mt:Archives archive_type="[% archive_type %]">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
[% archive_type %]
***
[% template_params %]
