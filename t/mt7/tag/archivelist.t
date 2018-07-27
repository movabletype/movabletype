#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
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
use MT::Test qw(:db);
use MT::Test::Permission;

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
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

my $blog
    = MT::Test::Permission->make_blog( parent_id => 0, name => 'test blog' );
$blog->archive_type('ContentType-Author,ContentType-Category');
$blog->save;

my $content_type_01 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'test content type 01',
);

my $content_type_02 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'test content type 02',
);

my $author_01 = MT::Test::Permission->make_author(
    name     => 'yishikawa',
    nickname => 'Yuki Ishikawa',
);

my $author_02 = MT::Test::Permission->make_author(
    name     => 'myanagida',
    nickname => 'Masahiro Yanagida',
);

my $content_data_01 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_01->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtarchivelist-test-data 01',
    author_id       => $author_01->id,
);

my $content_data_02 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_01->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtarchivelist-test-data 02',
    author_id       => $author_02->id,
);

my $content_data_03 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_02->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtarchivelist-test-data 02',
    author_id       => $author_02->id,
);

$vars->{content_type_01_unique_id} = $content_type_01->unique_id;
$vars->{content_type_02_unique_id} = $content_type_02->unique_id;
$vars->{content_type_01_name}      = $content_type_01->unique_id;
$vars->{content_type_02_name}      = $content_type_02->unique_id;
$vars->{content_type_01_id}        = $content_type_01->id;
$vars->{content_type_02_id}        = $content_type_02->id;

MT::Test::Tag->run_perl_tests( $blog->id );

MT::Test::Tag->run_php_tests( $blog->id );

__END__

=== mt:ArchiveList label="No content_type"
--- template
<mt:ArchiveList type="ContentType-Author"><mt:ArchiveCount></mt:ArchiveList>
--- expected
21

=== mt:ArchiveList unique_id 01
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
11

=== mt:ArchiveList unique_id 02
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_02_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

=== mt:ArchiveList name 01
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_name %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
11

=== mt:ArchiveList name 02
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_02_name %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

=== mt:ArchiveList id 01
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
11

=== mt:ArchiveList id 02
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_02_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

