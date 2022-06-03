#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        StaticWebPath => '/cgi-bin/mt-static/',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Fixture;
my $app = MT->instance;

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare({
    author => [{
            id       => 1,
            name     => 'Abby',
            nickname => 'Abby',
            basename => 'authorce2f3',
            email    => 'abby@example.com',
            url      => 'https://example.com/~abby',
        }, {
            name     => 'Birman',
            nickname => 'Birman',
            email    => 'test@example.com',
            url      => '',
        }, {
            name     => 'foobar',
            nickname => 'Foo Bar',
            basename => 'foo-bar',
            email    => 'foobar@example.com',
            url      => 'https://example.com/~foobar',
        }, {
            name     => 'bazquux',
            nickname => 'Baz Quux',
            email    => 'bazquux@example.com',
            url      => '',
        }
    ],
    blog => [{
        name        => 'Test Site',
        site_url    => '/::/',
        archive_url => '/::/',
    }],
    image => {
        'logo/movable-type-logo.png' => {
            label   => 'Userpic',
            blog_id => 0,
        },
        'logo/movable-type-logo2.png' => {
            label   => 'Userpic',
            blog_id => 0,
        },
    },
    content_type => {
        ct => {
            fields => [
                cf_title => { type => 'single_line_text' },
            ],
        },
        ct2 => {
            fields => [
                cf_title => { type => 'single_line_text' },
            ],
        },
    },
    content_data => {
        cd => {
            content_type => 'ct',
            author       => 'Abby',
            data         => {
                cf_title => 'Title',
            },
        },
        cd2 => {
            content_type => 'ct2',
            author       => 'Birman',
            data         => {
                cf_title => 'Title2',
            },
        },
    },
    template => [{
        archive_type => 'ContentType-Author',
        name         => 'ContentType Test',
        content_type => 'ct',
        type         => 'ct_archive',
        text         => 'test',
        mapping      => [{
            file_template => 'author/%-a/%f',
            is_preferred  => 1,
        }],
    }],
});

my $blog_id = $objs->{blog_id};
my $abby    = $objs->{author}{Abby};
my $foobar  = $objs->{author}{foobar};
my $bazquux = $objs->{author}{bazquux};
my $cd = $objs->{content_data}{cd};
$cd->modified_by($foobar->id);
$cd->save;
my $cd2 = $objs->{content_data}{cd2};
$cd2->modified_by($bazquux->id);
$cd2->save;

my $userpic = $objs->{image}{'logo/movable-type-logo.png'};
$abby->userpic_asset_id($userpic->id);
$abby->save;
my $userpic2 = $objs->{image}{'logo/movable-type-logo2.png'};
$foobar->userpic_asset_id($userpic2->id);
$foobar->save;

$test_env->clear_mt_cache;

my $vars = {
    abby_id     => $objs->{author}{Abby}->id,
    foobar_id   => $objs->{author}{foobar}->id,
    userpic_id  => $userpic->id,
    userpic2_id => $userpic2->id,
};

sub var {
    for my $line (@_) {
        for my $key (keys %{$vars}) {
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

MT->publisher->rebuild(BlogID => $blog_id);

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentAuthorDisplayName
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorDisplayName></mt:Contents>
--- expected
Abby

=== MT::ContentAuthorEmail
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorEmail></mt:Contents>
--- expected
abby@example.com

=== MT::ContentAuthorEmail with span_protect="1"
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorEmail spam_protect="1"></mt:Contents>
--- expected
abby&#64;example&#46;com

=== MT::ContentAuthorID
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorID></mt:Contents>
--- expected
[% abby_id %]

=== MT::ContentAuthorLink
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorLink></mt:Contents>
--- expected
<a href="https://example.com/~abby">Abby</a>

=== MT::ContentAuthorLink with new_window="1"
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorLink new_window="1"></mt:Contents>
--- expected
<a href="https://example.com/~abby" target="_blank">Abby</a>

=== MT::ContentAuthorLink with show_url="1"
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorLink show_url="0"></mt:Contents>
--- expected
Abby

=== MT::ContentAuthorLink with show_email="1"
--- template
<mt:Contents content_type="ct2"><mt:ContentAuthorLink show_email="1"></mt:Contents>
--- expected
<a href="mailto:test@example.com">Birman</a>

=== MT::ContentAuthorLink with spam_protect="1"
--- template
<mt:Contents content_type="ct2"><mt:ContentAuthorLink show_email="1" spam_protect="1"></mt:Contents>
--- expected
<a href="mailto&#58;test&#64;example&#46;com">Birman</a>

=== MT::ContentAuthorLink with type="url"
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorLink type="url"></mt:Contents>
--- expected
<a href="https://example.com/~abby">Abby</a>

=== MT::ContentAuthorLink with type="email"
--- template
<mt:Contents content_type="ct2"><mt:ContentAuthorLink type="email"></mt:Contents>
--- expected
<a href="mailto:test@example.com">Birman</a>

=== MT::ContentAuthorLink with type="archive"
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorLink type="archive"></mt:Contents>
--- expected
<a href="/author/authorce2f3/">Abby</a>

=== MT::ContentAuthorLink with show_hcard="1"
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorLink show_hcard="1"></mt:Contents>
--- expected
<a class="fn url" href="https://example.com/~abby">Abby</a>

=== MT::ContentAuthorURL
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorURL></mt:Contents>
--- expected
https://example.com/~abby

=== MT::ContentAuthorUsername
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorUsername></mt:Contents>
--- expected
Abby

=== MT::ContentAuthorUserpicAsset
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorUserpicAsset><mt:AssetID></mt:ContentAuthorUserpicAsset></mt:Contents>
--- expected
[% userpic_id %]

=== MT::ContentAuthorUserpicURL
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorUserpicURL></mt:Contents>
--- expected
/cgi-bin/mt-static/support/assets_c/userpics/userpic-1-100x100.png

=== MT::ContentAuthorUserpicURL
--- template
<mt:Contents content_type="ct"><mt:ContentAuthorUserpicURL></mt:Contents>
--- expected
/cgi-bin/mt-static/support/assets_c/userpics/userpic-1-100x100.png


=== MT::ContentModifiedAuthorDisplayName
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorDisplayName></mt:Contents>
--- expected
Foo Bar

=== MT::ContentModifiedAuthorEmail
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorEmail></mt:Contents>
--- expected
foobar@example.com

=== MT::ContentModifiedAuthorEmail with span_protect="1"
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorEmail spam_protect="1"></mt:Contents>
--- expected
foobar&#64;example&#46;com

=== MT::ContentModifiedAuthorID
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorID></mt:Contents>
--- expected
[% foobar_id %]

=== MT::ContentModifiedAuthorLink
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorLink></mt:Contents>
--- expected
<a href="https://example.com/~foobar">Foo Bar</a>

=== MT::ContentModifiedAuthorLink with new_window="1"
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorLink new_window="1"></mt:Contents>
--- expected
<a href="https://example.com/~foobar" target="_blank">Foo Bar</a>

=== MT::ContentModifiedAuthorLink with show_url="1"
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorLink show_url="0"></mt:Contents>
--- expected
Foo Bar

=== MT::ContentModifiedAuthorLink with show_email="1"
--- template
<mt:Contents content_type="ct2"><mt:ContentModifiedAuthorLink show_email="1"></mt:Contents>
--- expected
<a href="mailto:bazquux@example.com">Baz Quux</a>

=== MT::ContentModifiedAuthorLink with spam_protect="1"
--- template
<mt:Contents content_type="ct2"><mt:ContentModifiedAuthorLink show_email="1" spam_protect="1"></mt:Contents>
--- expected
<a href="mailto&#58;bazquux&#64;example&#46;com">Baz Quux</a>

=== MT::ContentModifiedAuthorLink with type="url"
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorLink type="url"></mt:Contents>
--- expected
<a href="https://example.com/~foobar">Foo Bar</a>

=== MT::ContentModifiedAuthorLink with type="email"
--- template
<mt:Contents content_type="ct2"><mt:ContentModifiedAuthorLink type="email"></mt:Contents>
--- expected
<a href="mailto:bazquux@example.com">Baz Quux</a>

=== MT::ContentModifiedAuthorLink with type="archive"
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorLink type="archive"></mt:Contents>
--- expected
<a href="/author/foo-bar/">Foo Bar</a>
--- expected_php_todo

=== MT::ContentModifiedAuthorLink with show_hcard="1"
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorLink show_hcard="1"></mt:Contents>
--- expected
<a class="fn url" href="https://example.com/~foobar">Foo Bar</a>

=== MT::ContentModifiedAuthorURL
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorURL></mt:Contents>
--- expected
https://example.com/~foobar

=== MT::ContentModifiedAuthorUsername
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorUsername></mt:Contents>
--- expected
foobar

=== MT::ContentModifiedAuthorUserpicAsset
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorUserpicAsset><mt:AssetID></mt:ContentModifiedAuthorUserpicAsset></mt:Contents>
--- expected
[% userpic2_id %]

=== MT::ContentModifiedAuthorUserpic
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorUserpic></mt:Contents>
--- expected
<img src="/cgi-bin/mt-static/support/assets_c/userpics/userpic-[% foobar_id %]-100x100.png?2" width="100" height="100" alt="Userpic" loading="lazy" decoding="async" />

=== MT::ContentModifiedAuthorUserpicURL
--- template
<mt:Contents content_type="ct"><mt:ContentModifiedAuthorUserpicURL></mt:Contents>
--- expected
/cgi-bin/mt-static/support/assets_c/userpics/userpic-[% foobar_id %]-100x100.png

