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
use MT::Test::Permission;

use MT;
use MT::CMS::Blog;
use MT::PublishOption;
my $app = MT->instance;

MT::Test->init_app;
$test_env->prepare_fixture('archive_type');

my $blog_id = 2;
my $website = $app->model('website')->load($blog_id) or die;

my $tmpl_main_index = MT::Test::Permission->make_template(
    blog_id    => $blog_id,
    identifier => 'main_index',
    type       => 'index',
);

sub _update_publishing_profile {
    my ($args) = @_;
    $website->custom_dynamic_templates($args);
    $website->save or die;
    MT::CMS::Blog::update_publishing_profile( $app, $website ) or die;
}

sub _get_templates {
    return sort { $a->type cmp $b->type } $app->model('template')->load(
        {   blog_id => $blog_id,
            type =>
                [qw( index archive individual page category ct ct_archive )],
        }
    );
}

sub _get_templatemaps {
    return
        sort { $a->archive_type cmp $b->archive_type }
        $app->model('templatemap')->load( { blog_id => $blog_id } );
}

subtest 'none' => sub {
    _update_publishing_profile('none');

    subtest 'template' => sub {
        for my $tmpl ( _get_templates() ) {
            is( $tmpl->build_type, MT::PublishOption::ONDEMAND(),
                $tmpl->type );
        }
    };
    subtest 'templatemap' => sub {
        for my $map ( _get_templatemaps() ) {
            is( $map->build_type, MT::PublishOption::ONDEMAND(),
                $map->archive_type );
        }
    };
};

subtest 'async_partilal' => sub {
    _update_publishing_profile('async_partial');

    subtest 'template' => sub {
        for my $tmpl ( _get_templates() ) {
            if ( ( $tmpl->identifier || '' ) =~ /^(main_index|feed_recent)$/ )
            {
                is( $tmpl->build_type, MT::PublishOption::ONDEMAND() );
            }
        }
    };
    subtest 'templatemap' => sub {
        for my $map ( _get_templatemaps() ) {
            my $expected;
            if (   $map->archive_type =~ /^(Individual|Page|ContentType)$/
                && $map->is_preferred )
            {
                $expected = MT::PublishOption::ONDEMAND();
            }
            else {
                $expected = MT::PublishOption::ASYNC();
            }
            is( $map->build_type, $expected, $map->archive_type );
        }
    };
};

subtest 'async_all' => sub {
    _update_publishing_profile('async_all');

    subtest 'template' => sub {
        for my $tmpl ( _get_templates() ) {
            is( $tmpl->build_type, MT::PublishOption::ASYNC(), $tmpl->type );
        }
    };
    subtest 'templatemap' => sub {
        for my $map ( _get_templatemaps() ) {
            is( $map->build_type, MT::PublishOption::ASYNC(),
                $map->archive_type );
        }
    };
};

subtest 'archives' => sub {
    _update_publishing_profile('archives');

    subtest 'template' => sub {
        for my $tmpl ( _get_templates() ) {
            my $expected
                = $tmpl->type ne 'index'
                ? MT::PublishOption::DYNAMIC()
                : MT::PublishOption::ONDEMAND();
            is( $tmpl->build_type, $expected, $tmpl->type );
        }
    };
    subtest 'templatemap' => sub {
        for my $map ( _get_templatemaps() ) {
            my $tmpl = $app->model('template')->load( $map->template_id || 0 )
                or die;
            my $expected
                = $tmpl->type ne 'index'
                ? MT::PublishOption::DYNAMIC()
                : MT::PublishOption::ONDEMAND();
            is( $map->build_type, $expected, $map->archive_type );
        }
    };
};

subtest 'all' => sub {
    _update_publishing_profile('all');

    subtest 'template' => sub {
        for my $tmpl ( _get_templates() ) {
            is( $tmpl->build_type, MT::PublishOption::DYNAMIC(),
                $tmpl->type );
        }
    };
    subtest 'templatemap' => sub {
        for my $map ( _get_templatemaps() ) {
            is( $map->build_type, MT::PublishOption::DYNAMIC(),
                $map->archive_type );
        }
    };
};

done_testing;

