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

use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use File::Spec;
use Web::Query;
use URI;

$test_env->prepare_fixture('db');

my $site_path    = File::Spec->catdir($test_env->root, 'site');
my $archive_path = File::Spec->catdir($test_env->root, 'site/archive');

mkdir $site_path;
mkdir $archive_path;

my $tmpl = <<'TMPL';
<!doctype html>
<html lang="ja">
<head><meta charset="UTF-8"></head>
<body>
<p><mt:ArchiveTitle></p>
<ul>
<mt:ArchivePrevious>
<li><a rel="prev" id="prev" href="<$mt:ArchiveLink encode_html="1"$>"><$mt:ArchiveTitle$></a></li>
</mt:ArchivePrevious>
<mt:ArchiveNext>
<li><a rel="next" id="next" href="<$mt:ArchiveLink encode_html="1"$>"><$mt:ArchiveTitle$></a></li>
</mt:ArchiveNext>
</ul>
</body>
</html>
TMPL

my $objs = MT::Test::Fixture->prepare({
    author  => [qw/author author2 author3/],
    website => [{
        name         => 'my_site',
        theme_id     => 'mont-blanc',
        site_path    => $site_path,
        archive_path => $archive_path,
    }],
    category_set => {
        catset_type => [qw/news topic release/],
    },
    content_type => {
        ct => [
            cf_category_type => {
                type         => 'categories',
                category_set => 'catset_type',
                options      => { multiple => 1 },
            },
            cf_datetime => {
                type => 'date_and_time',
            },
            cf_text => 'single_line_text',
        ],
        ct2 => [
            cf_category_type => {
                type         => 'categories',
                category_set => 'catset_type',
                options      => { multiple => 1 },
            },
            cf_datetime => {
                type => 'date_and_time',
            },
            cf_text => 'single_line_text',
        ],
    },
    content_data => {
        first_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20200101112233',
            label        => 'first_cd',
            identifier   => 'first_cd',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/news/],
                cf_datetime      => '20220101123456',
                cf_text          => 'first cd',
            },
        },
        second_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20200201112233',
            label        => 'second_cd',
            identifier   => 'second_cd',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/news/],
                cf_datetime      => '20220201123456',
                cf_text          => 'second cd',
            },
        },
        third_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20200301112233',
            label        => 'third_cd',
            identifier   => 'third_cd',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/news/],
                cf_datetime      => '20220301123456',
                cf_text          => 'third cd',
            },
        },
        fourth_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20200401112233',
            label        => 'fourth_cd',
            identifier   => 'fourth_cd',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/news/],
                cf_datetime      => '20220401123456',
                cf_text          => 'fourth cd',
            },
        },
        fifth_cd => {
            content_type => 'ct',
            author       => 'author3',
            authored_on  => '20200501112233',
            label        => 'fifth_cd',
            identifier   => 'fifth_cd',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/news/],
                cf_datetime      => '20220501123456',
                cf_text          => 'fifth cd',
            },
        },
        first_cd2 => {
            content_type => 'ct2',
            author       => 'author2',
            authored_on  => '20100101112233',
            label        => 'first_cd2',
            identifier   => 'first_cd2',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/topic/],
                cf_datetime      => '20120101123456',
                cf_text          => 'first cd2',
            },
        },
        second_cd2 => {
            content_type => 'ct2',
            author       => 'author2',
            authored_on  => '20100201112233',
            label        => 'second_cd2',
            identifier   => 'second_cd2',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/topic/],
                cf_datetime      => '20120201123456',
                cf_text          => 'second cd2',
            },
        },
        # third_cd2 is skipped
        fourth_cd2 => {
            content_type => 'ct2',
            author       => 'author2',
            authored_on  => '20100401112233',
            label        => 'fourth_cd2',
            identifier   => 'fourth_cd2',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/topic/],
                cf_datetime      => '20120401123456',
                cf_text          => 'fourth cd',
            },
        },
        fifth_cd2 => {
            content_type => 'ct2',
            author       => 'author2',
            authored_on  => '20100501112233',
            label        => 'fifth_cd2',
            identifier   => 'fifth_cd2',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/release/],
                cf_datetime      => '20120501123456',
                cf_text          => 'fifth cd',
            },
        },
    },
    template => [{
            archive_type => 'ContentType-Category',
            name         => 'tmpl_ct_archive_cat',
            content_type => 'ct',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct/%c/%i',
                is_preferred  => 1,
                cat_field     => 'cf_category_type',
            }],
        }, {
            archive_type => 'ContentType-Category',
            name         => 'tmpl_ct_archive_cat2',
            content_type => 'ct2',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct2/%c/%i',
                is_preferred  => 1,
                cat_field     => 'cf_category_type',
            }],
        }, {
            archive_type => 'ContentType-Author',
            name         => 'tmpl_ct_archive_author',
            content_type => 'ct',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct/%a/%i',
                is_preferred  => 1,
            }],
        }, {
            archive_type => 'ContentType-Author',
            name         => 'tmpl_ct_archive_author2',
            content_type => 'ct2',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct2/%a/%i',
                is_preferred  => 1,
            }],
        }, {
            archive_type => 'ContentType-Monthly',
            name         => 'tmpl_ct_archive_monthly',
            content_type => 'ct',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct/%y/%m/%i',
                is_preferred  => 1,
                dt_field      => 'cf_datetime',
            }],
        }, {
            archive_type => 'ContentType-Monthly',
            name         => 'tmpl_ct_archive_monthly2',
            content_type => 'ct2',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct2/%y/%m/%i',
                is_preferred  => 1,
                dt_field      => 'cf_datetime',
            }],
        }, {
            archive_type => 'ContentType-Author-Monthly',
            name         => 'tmpl_ct_archive_author_monthly',
            content_type => 'ct',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct/%a/%y/%m/%i',
                is_preferred  => 1,
                dt_field      => 'cf_datetime',
            }],
        }, {
            archive_type => 'ContentType-Author-Monthly',
            name         => 'tmpl_ct_archive_author_monthly2',
            content_type => 'ct2',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct2/%a/%y/%m/%i',
                is_preferred  => 1,
                dt_field      => 'cf_datetime',
            }],
        }, {
            archive_type => 'ContentType-Category-Monthly',
            name         => 'tmpl_ct_archive_cat_monthly',
            content_type => 'ct',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct/%c/%y/%m/%i',
                is_preferred  => 1,
                dt_field      => 'cf_datetime',
                cat_field     => 'cf_category_type',
            }],
        }, {
            archive_type => 'ContentType-Category-Monthly',
            name         => 'tmpl_ct_archive_cat_monthly2',
            content_type => 'ct2',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct2/%c/%y/%m/%i',
                is_preferred  => 1,
                dt_field      => 'cf_datetime',
                cat_field     => 'cf_category_type',
            }],
        }, {
            archive_type => 'ContentType-Category',
            name         => 'tmpl_ct_archive_cat',
            content_type => 'ct',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct/%c/%i',
                is_preferred  => 1,
                cat_field     => 'cf_category_type',
            }],
        }, {
            archive_type => 'ContentType-Category',
            name         => 'tmpl_ct_archive_cat2',
            content_type => 'ct2',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct2/%c/%i',
                is_preferred  => 1,
                cat_field     => 'cf_category_type',
            }],
        }, {
            archive_type => 'ContentType',
            name         => 'tmpl_ct',
            content_type => 'ct',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct/%y/%m/%-f',
                is_preferred  => 1,
            }],
        }, {
            archive_type => 'ContentType',
            name         => 'tmpl_ct2',
            content_type => 'ct2',
            text         => $tmpl,
            mapping      => [{
                file_template => 'ct2/%y/%m/%-f',
                is_preferred  => 1,
            }],
        },
    ],
});

$test_env->clear_mt_cache;

my $admin = MT::Author->load(1);
my $site  = $objs->{website}{my_site};

MT->publisher->rebuild(BlogID => $site->id);

subtest 'with dt_field' => sub {
    subtest 'with author' => sub {
        subtest 'second archive for ct (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/author/2022/02/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct/author/2022/01/', 'prev points to 2022/01');
            href_is_ok($next => 'http://narnia.na/ct/author/2022/03/', 'next points to 2022/03');
        };

        subtest 'second archive for ct2 (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/author2/2012/02/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct2/author2/2012/01/', 'prev points to 2012/01, not 2022/01');
            href_is_ok($next => 'http://narnia.na/ct2/author2/2012/04/', 'next points to 2012/04, not 2022/03');
        };

        subtest 'fourth archive for ct (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/author/2022/04/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct/author/2022/03/', 'prev points to 2022/03');
            ok !$next->as_html, 'next is empty' or note $next->attr('href');
        };

        subtest 'fourth archive for ct2 (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/author2/2012/04/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct2/author2/2012/02/', 'prev points to 2012/02, not 2022/03');
            href_is_ok($next => 'http://narnia.na/ct2/author2/2012/05/', 'next points to 2012/05, not 2022/05');
        };
    };

    subtest 'with category' => sub {
        subtest 'second archive for ct (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/news/2022/02/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct/news/2022/01/', 'prev points to 2022/01');
            href_is_ok($next => 'http://narnia.na/ct/news/2022/03/', 'next points to 2022/03');
        };

        subtest 'second archive for ct2 (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/topic/2012/02/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct2/topic/2012/01/', 'prev points to 2012/01, not 2022/01');
            href_is_ok($next => 'http://narnia.na/ct2/topic/2012/04/', 'next points to 2012/04, not 2022/03');
        };

        subtest 'fourth archive for ct (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/news/2022/04/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct/news/2022/03/', 'prev points to 2022/03');
            href_is_ok($next => 'http://narnia.na/ct/news/2022/05/', 'next points to 2022/05');
        };

        subtest 'fourth archive for ct2 (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/topic/2012/04/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct2/topic/2012/02/', 'prev points to 2012/02, not 2022/03');
            ok !$next->as_html, 'next is empty' or note $next->attr('href');
        };
    };

    subtest 'without author nor category' => sub {
        subtest 'second archive for ct (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/2022/02/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct/2022/01/', 'prev points to 2022/01');
            href_is_ok($next => 'http://narnia.na/ct/2022/03/', 'next points to 2022/03');
        };

        subtest 'second archive for ct2 (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/2012/02/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct2/2012/01/', 'prev points to 2012/01, not 2022/01');
            href_is_ok($next => 'http://narnia.na/ct2/2012/04/', 'next points to 2012/04, not 2022/03');
        };

        subtest 'fourth archive for ct (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/2022/04/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct/2022/03/', 'prev points to 2022/03');
            href_is_ok($next => 'http://narnia.na/ct/2022/05/', 'next points to 2022/05');
        };

        subtest 'fourth archive for ct2 (dt_field)' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/2012/04/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct2/2012/02/', 'prev points to 2012/02, not 2022/03');
            href_is_ok($next => 'http://narnia.na/ct2/2012/05/', 'next points to 2012/05, not 2022/05');
        };
    };

};

subtest 'without dt_field' => sub {
    for my $name (sort keys %{ $objs->{templatemap} }) {
        for my $map (@{ $objs->{templatemap}{$name} }) {
            $map->dt_field_id(undef);
            $map->save;
        }
    }

    $test_env->clear_mt_cache;

    MT->publisher->rebuild(BlogID => $site->id);

    subtest 'without dt_field' => sub {
        subtest 'with author' => sub {
            subtest 'second archive for ct' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct/author/2020/02/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct/author/2020/01/', 'prev points to 2020/01');
                href_is_ok($next => 'http://narnia.na/ct/author/2020/03/', 'next points to 2020/03');
            };

            subtest 'second archive for ct2' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct2/author2/2010/02/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct2/author2/2010/01/', 'prev points to 2010/01, not 2020/01');
                href_is_ok($next => 'http://narnia.na/ct2/author2/2010/04/', 'next points to 2010/04, not 2020/03');
            };

            subtest 'fourth archive for ct' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct/author/2020/04/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct/author/2020/03/', 'prev points to 2020/03');
                ok !$next->as_html, 'next is empty' or note $next->attr('href');
            };

            subtest 'fourth archive for ct2' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct2/author2/2010/04/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct2/author2/2010/02/', 'prev points to 2010/02, not 2020/03');
                href_is_ok($next => 'http://narnia.na/ct2/author2/2010/05/', 'next points to 2010/05, not 2020/05');
            };
        };

        subtest 'with category' => sub {
            subtest 'second archive for ct' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct/news/2020/02/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct/news/2020/01/', 'prev points to 2020/01');
                href_is_ok($next => 'http://narnia.na/ct/news/2020/03/', 'next points to 2020/03');
            };

            subtest 'second archive for ct2' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct2/topic/2010/02/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct2/topic/2010/01/', 'prev points to 2010/01, not 2020/01');
                href_is_ok($next => 'http://narnia.na/ct2/topic/2010/04/', 'next points to 2010/04, not 2020/03');
            };

            subtest 'fourth archive for ct' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct/news/2020/04/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct/news/2020/03/', 'prev points to 2020/03');
                href_is_ok($next => 'http://narnia.na/ct/news/2020/05/', 'next points to 2020/05');
            };

            subtest 'fourth archive for ct2' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct2/topic/2010/04/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct2/topic/2010/02/', 'prev points to 2010/02, not 2020/03');
                ok !$next->as_html, 'next is empty' or note $next->attr('href');
            };
        };

        subtest 'without author nor category' => sub {
            subtest 'second archive for ct' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct/2020/02/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct/2020/01/', 'prev points to 2020/01');
                href_is_ok($next => 'http://narnia.na/ct/2020/03/', 'next points to 2020/03');
            };

            subtest 'second archive for ct2' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct2/2010/02/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct2/2010/01/', 'prev points to 2010/01, not 2020/01');
                href_is_ok($next => 'http://narnia.na/ct2/2010/04/', 'next points to 2010/04, not 2020/03');
            };

            subtest 'fourth archive for ct' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct/2020/04/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct/2020/03/', 'prev points to 2020/03');
                href_is_ok($next => 'http://narnia.na/ct/2020/05/', 'next points to 2020/05');
            };

            subtest 'fourth archive for ct2' => sub {
                my $html = $test_env->slurp($test_env->path('site/archive/ct2/2010/04/index.html'));
                my $prev = Web::Query->new($html)->find('#prev');
                my $next = Web::Query->new($html)->find('#next');
                href_is_ok($prev => 'http://narnia.na/ct2/2010/02/', 'prev points to 2010/02, not 2020/03');
                href_is_ok($next => 'http://narnia.na/ct2/2010/05/', 'next points to 2010/05, not 2020/05');
            };
        };

    };
};

subtest 'unrelated to datetime' => sub {

    subtest 'with author' => sub {
        subtest 'author for ct' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/author/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            ok !$prev->as_html, 'prev is empty' or note $prev->attr('href');
            href_is_ok($next => 'http://narnia.na/ct/author3/', 'next points to author3');
        };

        subtest 'author3 for ct' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/author3/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct/author/', 'prev points to author');
            ok !$next->as_html, 'next is empty' or note $next->attr('href');
        };

        subtest 'author2 for ct2' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/author2/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            ok !$prev->as_html, 'prev is empty' or note $prev->attr('href');
            ok !$next->as_html, 'next is empty' or note $next->attr('href');
        };
    };

    subtest 'with category' => sub {
        subtest 'news archive for ct' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct/news/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            ok !$prev->as_html, 'prev is empty' or note $prev->attr('href');
            ok !$next->as_html, 'next is empty' or note $next->attr('href');
        };

        subtest 'topic archive for ct2' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/topic/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            href_is_ok($prev => 'http://narnia.na/ct2/release/', 'prev points to release');
            ok !$next->as_html, 'next is empty' or note $next->attr('href');
        };

        subtest 'release archive for ct2' => sub {
            my $html = $test_env->slurp($test_env->path('site/archive/ct2/release/index.html'));
            my $prev = Web::Query->new($html)->find('#prev');
            my $next = Web::Query->new($html)->find('#next');
            ok !$prev->as_html, 'prev is empty' or note $prev->attr('href');
            href_is_ok($next => 'http://narnia.na/ct2/topic/', 'next points to topic');
        };
    };
};

sub href_is_ok {
    my ($elem, $expected, $message) = @_;
    my $url = URI->new($elem->attr('href'));
    is $url => $expected, $message || "href is expected";
    my $file = $test_env->path(File::Spec->catfile("site/archive", $url->path, "index.html"));
    ok -f $file, "$file exists" or $test_env->ls;
}

done_testing;
