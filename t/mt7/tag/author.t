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
use MT::Test;
use MT::Test::Permission;

use MT::ContentStatus;

my $app = MT->instance;

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
    template       => [qw( var chomp )],
    expected       => [qw( var chomp )],
    expected_error => [qw( var chomp )],
};

my $blog_id = 1;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog = MT->model('blog')->load($blog_id);

        my $melody = MT->model('author')->load( { name => 'Melody' } );
        $melody->remove;

        my $nn_author = MT::Test::Permission->make_author(
            name     => 'nn author',
            nickname => 'No Entry, No Content',
        );
        my $hn_author = MT::Test::Permission->make_author(
            name     => 'hn author',
            nickname => 'Has Entry, No Content',
        );
        my $nh_author = MT::Test::Permission->make_author(
            name     => 'nh author',
            nickname => 'No Entry, Has Content',
        );
        my $hh_author = MT::Test::Permission->make_author(
            name     => 'hh author',
            nickname => 'Has Entry, Has Content',
        );

        my $administrator = MT::Role->load(
            { name => MT->translate('Site Administrator') } );

        require MT::Association;
        MT::Association->link( $nn_author, $administrator, $blog );
        MT::Association->link( $hn_author, $administrator, $blog );
        MT::Association->link( $nh_author, $administrator, $blog );
        MT::Association->link( $hh_author, $administrator, $blog );

        my $entry01 = MT::Test::Permission->make_entry(
            blog_id   => $blog_id,
            author_id => $hn_author->id,
        );
        my $entry02 = MT::Test::Permission->make_entry(
            blog_id   => $blog_id,
            author_id => $hh_author->id,
        );

        my $ct = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type',
        );

        my $cf_single_line_text = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            name            => 'single',
            type            => 'single_line_text',
        );

        $ct->fields(
            [   {   id        => $cf_single_line_text->id,
                    order     => 1,
                    type      => $cf_single_line_text->type,
                    options   => { label => $cf_single_line_text->name },
                    unique_id => $cf_single_line_text->unique_id,
                },
            ]
        );
        $ct->save or die $ct->errstr;

        my $cd01 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            author_id       => $nh_author->id,
            label           => 'Content Data1',
            data            => { $cf_single_line_text->id => 'single', },
        );
        my $cd02 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            author_id       => $hh_author->id,
            label           => 'Content Data1',
            data            => { $cf_single_line_text->id => 'single', },
        );
    }
);

my $blog = MT::Blog->load(1);

MT::Test::Tag->run_perl_tests(
    $blog_id,
    sub {
        my ( $ctx, $block ) = @_;
        $ctx->stash( 'blog',    $blog );
        $ctx->stash( 'blog_id', $blog_id );
    }
);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT:Authors no modifier
--- template
<mt:Authors><mt:AuthorDisplayName>
</mt:Authors>
--- expected
Has Entry, No Content
Has Entry, Has Content

=== MT:Authors need_entry="0"
--- template
<mt:Authors need_entry="0"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
No Entry, No Content
Has Entry, No Content
No Entry, Has Content
Has Entry, Has Content

=== MT:Authors need_entry="1"
--- template
<mt:Authors need_entry="1"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
Has Entry, No Content
Has Entry, Has Content

=== MT:Authors need_content="0"
--- template
<mt:Authors need_content="0"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
Has Entry, No Content
Has Entry, Has Content

=== MT:Authors need_content="1"
--- template
<mt:Authors need_content="1"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
Has Entry, Has Content

=== MT:Authors need_entry="0" need_content="0"
--- template
<mt:Authors need_entry="0" need_content="0"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
No Entry, No Content
Has Entry, No Content
No Entry, Has Content
Has Entry, Has Content

=== MT:Authors need_entry="1" need_content="0"
--- template
<mt:Authors need_entry="1" need_content="0"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
Has Entry, No Content
Has Entry, Has Content

=== MT:Authors need_entry="0" need_content="1"
--- template
<mt:Authors need_entry="0" need_content="1"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
No Entry, Has Content
Has Entry, Has Content

=== MT:Authors need_entry="1" need_content="1"
--- template
<mt:Authors need_entry="1" need_content="1"><mt:AuthorDisplayName>
</mt:Authors>
--- expected
Has Entry, Has Content
