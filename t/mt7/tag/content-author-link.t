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

use utf8;

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
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content type',
            blog_id => $blog_id,
        );
        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
        );
        my $author = $cd->author;
        $author->set_values(
            {   nickname => 'Abby',
                url      => 'https://example.com/~abby',
            }
        );
        $author->save or die $author->errstr;

        # Content Type 2
        my $ct2 = MT::Test::Permission->make_content_type(
            name    => 'test content type 2',
            blog_id => $blog_id,
        );
        my $author2 = MT::Test::Permission->make_author();
        $author2->set_values(
            {   nickname => 'Birman',
                url      => '',
                email    => 'test@example.com',
            }
        );
        $author2->save or die $author->errstr;
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct2->id,
            author_id       => $author2->id,
        );

        # Mapping
        my $template = MT::Test::Permission->make_template(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            name            => 'ContentType Test',
            type            => 'ct',
            text            => 'test',
        );
        my $map_01 = MT::Test::Permission->make_templatemap(
            template_id   => $template->id,
            blog_id       => $blog_id,
            archive_type  => 'ContentType-Author',
            file_template => 'author/%-a/%f',
            is_preferred  => 1,
        );
    }
);

my $blog = MT::Blog->load($blog_id);
$blog->archive_path(join "/", $test_env->root, "site/archive");
$blog->save;

require MT::ContentPublisher;
my $publisher = MT::ContentPublisher->new;
$publisher->rebuild(
    BlogID => $blog_id,
    ArchiveType => 'ContentType-Author',
);

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentAuthorLink
--- template
<mt:Contents content_type="test content type"><mt:ContentAuthorLink></mt:Contents>
--- expected
<a href="https://example.com/~abby">Abby</a>

=== MT::ContentAuthorLink with new_window="1"
--- template
<mt:Contents content_type="test content type"><mt:ContentAuthorLink new_window="1"></mt:Contents>
--- expected
<a href="https://example.com/~abby" target="_blank">Abby</a>

=== MT::ContentAuthorLink with show_url="1"
--- template
<mt:Contents content_type="test content type"><mt:ContentAuthorLink show_url="0"></mt:Contents>
--- expected
Abby

=== MT::ContentAuthorLink with show_email="1"
--- template
<mt:Contents content_type="test content type 2"><mt:ContentAuthorLink show_email="1"></mt:Contents>
--- expected
<a href="mailto:test@example.com">Birman</a>

=== MT::ContentAuthorLink with spam_protect="1"
--- template
<mt:Contents content_type="test content type 2"><mt:ContentAuthorLink show_email="1" spam_protect="1"></mt:Contents>
--- expected
<a href="mailto&#58;test&#64;example&#46;com">Birman</a>

=== MT::ContentAuthorLink with type="url"
--- template
<mt:Contents content_type="test content type"><mt:ContentAuthorLink type="url"></mt:Contents>
--- expected
<a href="https://example.com/~abby">Abby</a>

=== MT::ContentAuthorLink with type="email"
--- template
<mt:Contents content_type="test content type 2"><mt:ContentAuthorLink type="email"></mt:Contents>
--- expected
<a href="mailto:test@example.com">Birman</a>

=== MT::ContentAuthorLink with type="archive"
--- template
<mt:Contents content_type="test content type"><mt:ContentAuthorLink type="archive"></mt:Contents>
--- expected
<a href="/author/authorce2f3/">Abby</a>

=== MT::ContentAuthorLink with show_hcard="1"
--- template
<mt:Contents content_type="test content type"><mt:ContentAuthorLink show_hcard="1"></mt:Contents>
--- expected
<a class="fn url" href="https://example.com/~abby">Abby</a>

