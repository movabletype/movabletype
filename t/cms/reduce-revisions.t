use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::Deep qw/cmp_bag/;
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    author => [{
        name         => 'admin',
        password     => 'pass',
        is_superuser => 1,
    }],
    blog => [
        { id => 1, name => 'my_blog1', },
        { id => 2, name => 'my_blog2', },
    ],
    entry        => [{ blog_id => 2, basename => "entry1", }],
    content_type => { ct => { blog_id => 2, fields => [cf_title => 'single_line_text'] } },
    content_data => {
        cd => {
            blog_id      => 2,
            content_type => 'ct',
            label        => 'cd1',
            data         => {},
        },
    },
    template => [{
            blog_id => 2,
            name    => 'template1',
            text    => 'test',
        }, {
            blog_id => 0,
            name    => 'global_template',
            text    => 'test',
        },
    ],
});

my $ds_spec = {
    entry => {
        fixture => 'entry',
        field   => 'status',
    },
    cd => {
        fixture => 'content_data',
        field   => 'status',
    },
    template => {
        fixture => 'template',
        field   => 'text',
    },
};

my $site1 = $objs->{blog}{my_blog1};
my $site2 = $objs->{blog}{my_blog2};


my $admin = MT->model('author')->load(1);

subtest 'Load reduce revisions' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'start_reduce_revisions',
        blog_id => 0,
    });
};

_create_revisions($site2);

subtest 'Detect reduce revisions' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'start_reduce_revisions',
        blog_id => 0,
    });

    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';

    # response data for detect_reduce_revisions via xhr like below
    #   $VAR1 = {
    #     'error' => undef,
    #     'result' => [
    #       {
    #         'ds' => 'cd',
    #         'max' => 20,
    #         'dsLabel' => 'Content Data',
    #         'blogName' => 'my_blog1',
    #         'blogId' => '1',
    #         'result' => []
    #       }
    #     ]
    #   };
    subtest 'entry datastore for all websites' => sub {
        my $res = $app->get_ok({
            __mode                => 'detect_reduce_revisions',
            reduce_revisions_what => '',
            target_entry          => 1,
            filter_date           => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        is $json->{result}[0]->{ds}, 'entry';
        is $json->{result}[0]->{dsLabel}, 'Entry';
        is $json->{result}[0]->{max}, 20;
        my @objs = grep { $_->{ds} eq 'entry' } @{$json->{result}};
        is scalar(@objs), 2, 'right number of tests processed';
        cmp_bag(['my_blog1', 'my_blog2'], [map { $_->{blogName} } @objs]);
        my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
        my ($detected)    = grep { $_->{blogName} eq 'my_blog2' } @objs;
        is scalar(@{$no_detected->{result}}), 0, 'no detected';
        is scalar(@{$detected->{result}}), 1, 'detected';
    };

    subtest 'entry datastore for blog_id=1' => sub {
        my $res = $app->get_ok({
            __mode                => 'detect_reduce_revisions',
            reduce_revisions_what => '1',
            target_entry          => 1,
            filter_date           => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        my @objs = grep { $_->{ds} eq 'entry' } @{$json->{result}};
        is scalar(@objs), 1, 'right number of tests processed';
        my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
        is scalar(@{$no_detected->{result}}), 0, 'no detected';
    };

    subtest 'cd datastore for all websites' => sub {
        my $res = $app->get_ok({
            __mode                => 'detect_reduce_revisions',
            reduce_revisions_what => '',
            target_cd             => 1,
            filter_date           => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        is $json->{result}[0]->{ds}, 'cd';
        is $json->{result}[0]->{dsLabel}, 'Content Data';
        is $json->{result}[0]->{max}, 20;
        my @objs = grep { $_->{ds} eq 'cd' } @{$json->{result}};
        is scalar(@objs), 2, 'right number of tests processed';
        cmp_bag(['my_blog1', 'my_blog2'], [map { $_->{blogName} } @objs]);
        my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
        my ($detected)    = grep { $_->{blogName} eq 'my_blog2' } @objs;
        is scalar(@{$no_detected->{result}}), 0, 'no detected';
        is scalar(@{$detected->{result}}), 1, 'detected';
    };

    subtest 'cd datastore for blog_id=1' => sub {
        my $res = $app->get_ok({
            __mode                => 'detect_reduce_revisions',
            reduce_revisions_what => '1',
            target_cd             => 1,
            filter_date           => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        my @objs = grep { $_->{ds} eq 'cd' } @{$json->{result}};
        is scalar(@objs), 1, 'right number of tests processed';
        cmp_bag(['my_blog1'], [map { $_->{blogName} } @objs]);
        my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
        is scalar(@{$no_detected->{result}}), 0, 'no detected';
    };

    subtest 'template datastore for all websites' => sub {
        my $res = $app->get_ok({
            __mode                => 'detect_reduce_revisions',
            reduce_revisions_what => '',
            target_template       => 1,
            filter_date           => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        is $json->{result}[0]->{ds}, 'template';
        is $json->{result}[0]->{dsLabel}, 'Template';
        is $json->{result}[0]->{max}, 20;
        my @objs = grep { $_->{ds} eq 'template' } @{$json->{result}};
        is scalar(@objs), 2, 'right number of tests processed';
        cmp_bag(['my_blog1', 'my_blog2'], [map { $_->{blogName} } @objs]);
        my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
        my ($detected)    = grep { $_->{blogName} eq 'my_blog2' } @objs;
        is scalar(@{$no_detected->{result}}), 0, 'no detected';
        is scalar(@{$detected->{result}}), 1, 'detected';
    };

    subtest 'template datastore for blog_id=1' => sub {
        my $res = $app->get_ok({
            __mode                => 'detect_reduce_revisions',
            reduce_revisions_what => '1',
            target_template       => 1,
            filter_date           => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        my @objs = grep { $_->{ds} eq 'template' } @{$json->{result}};
        is scalar(@objs), 1, 'right number of tests processed';
        cmp_bag(['my_blog1'], [map { $_->{blogName} } @objs]);
        my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
        is scalar(@{$no_detected->{result}}), 0, 'no detected';
    };

    subtest 'global template' => sub {
        my $res = $app->get_ok({
            __mode                 => 'detect_reduce_revisions',
            reduce_revisions_what  => '',
            target_global_template => 1,
            filter_date            => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        is $json->{result}[0]->{ds}, 'template';
        is $json->{result}[0]->{dsLabel}, 'Global Template';
        is $json->{result}[0]->{max}, 20;
        my @objs = grep { $_->{ds} eq 'template' && $_->{blogId} == 0 } @{$json->{result}};
        is scalar(@objs), 1, 'right number of tests processed';
        cmp_bag(['system'], [map { $_->{blogName} } @objs]);
        is scalar(@{$json->{result}[0]->{result}}), 1, 'detected';
    };

    subtest 'all datastores for all websites' => sub {
        my $res = $app->get_ok({
            __mode                 => 'detect_reduce_revisions',
            reduce_revisions_what  => '',
            target_entry           => 1,
            target_cd              => 1,
            target_template        => 1,
            target_global_template => 1,
            filter_date            => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            

        for my $ds (qw/entry cd template/) {
            my @objs;
            if ($ds eq 'template') {
                @objs = grep { $_->{ds} eq $ds && $_->{blogId} != 0 } @{$json->{result}};
            } else {
                @objs = grep { $_->{ds} eq $ds } @{$json->{result}};
            }
            is scalar(@objs), 2, $ds;
            cmp_bag(['my_blog1', 'my_blog2'], [map { $_->{blogName} } @objs]);
            my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
            my ($detected)    = grep { $_->{blogName} eq 'my_blog2' } @objs;
            is scalar(@{$no_detected->{result}}), 0, 'no detected';
            is scalar(@{$detected->{result}}), 1, 'detected';
        }
        my @global_templates = grep { $_->{ds} eq 'template' && $_->{blogId} == 0 } @{$json->{result}};
        is scalar(@global_templates), 1, 'global template';
        cmp_bag(['system'], [map { $_->{blogName} } @global_templates]);
        my ($detected) = grep { $_->{blogName} eq 'system' } @global_templates;
        is scalar(@{$detected->{result}}), 1, 'detected';
    };

    subtest 'all datastores for blog_id=1' => sub {
        my $res = $app->get_ok({
            __mode                 => 'detect_reduce_revisions',
            reduce_revisions_what  => '1',
            target_entry           => 1,
            target_cd              => 1,
            target_template        => 1,
            target_global_template => 1,
            filter_date            => '',
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            

        for my $ds (qw/entry cd template/) {
            my @objs;
            if ($ds eq 'template') {
                @objs = grep { $_->{ds} eq $ds && $_->{blogId} != 0 } @{$json->{result}};
            } else {
                @objs = grep { $_->{ds} eq $ds } @{$json->{result}};
            }
            is scalar(@objs), 1, $ds;
            cmp_bag(['my_blog1'], [map { $_->{blogName} } @objs]);
            my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
            is scalar(@{$no_detected->{result}}), 0, 'no detected';
        }
        my @global_templates = grep { $_->{ds} eq 'template' && $_->{blogId} == 0 } @{$json->{result}};
        is scalar(@global_templates), 1, 'global template';
        cmp_bag(['system'], [map { $_->{blogName} } @global_templates]);
        my ($detected) = grep { $_->{blogName} eq 'system' } @global_templates; 
        is scalar(@{$detected->{result}}), 1, 'detected';
    };

    subtest 'filter revisions by date for all websites' => sub {
        my $res = $app->get_ok({
            __mode                 => 'detect_reduce_revisions',
            reduce_revisions_what  => '',
            target_entry           => 1,
            target_cd              => 1,
            target_template        => 1,
            target_global_template => 1,
            use_filter_date        => '1',
            filter_date            => '2024-01-02', # created_on of all revisions are 2024-01-01 generated by _create_revisions method
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        for my $ds (qw/entry cd template/) {
            my @objs;
            if ($ds eq 'template') {
                @objs = grep { $_->{ds} eq $ds && $_->{blogId} != 0 } @{$json->{result}};
            } else {
                @objs = grep { $_->{ds} eq $ds } @{$json->{result}};
            }
            is scalar(@objs), 2, $ds;
            cmp_bag(['my_blog1', 'my_blog2'], [map { $_->{blogName} } @objs]);
            my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
            my ($detected)    = grep { $_->{blogName} eq 'my_blog2' } @objs;
            is scalar(@{$no_detected->{result}}), 0, 'no detected';
            is scalar(@{$detected->{result}}), 1, 'detected';
        }
        my @global_templates = grep { $_->{ds} eq 'template' && $_->{blogId} == 0 } @{$json->{result}};
        is scalar(@global_templates), 1, 'global template';
        cmp_bag(['system'], [map { $_->{blogName} } @global_templates]);
        my ($detected) = grep { $_->{blogName} eq 'system' } @global_templates;
        is scalar(@{$detected->{result}}), 1, 'detected';
    };

    subtest 'filter revisions by date for blog_id=1' => sub {
        my $res = $app->get_ok({
            __mode                 => 'detect_reduce_revisions',
            reduce_revisions_what  => '1',
            target_entry           => 1,
            target_cd              => 1,
            target_template        => 1,
            target_global_template => 1,
            use_filter_date        => '1',
            filter_date            => '2024-01-02', # created_on of all revisions are 2024-01-01 generated by _create_revisions method
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        for my $ds (qw/entry cd template/) {
            my @objs;
            if ($ds eq 'template') {
                @objs = grep { $_->{ds} eq $ds && $_->{blogId} != 0 } @{$json->{result}};
            } else {
                @objs = grep { $_->{ds} eq $ds } @{$json->{result}};
            }
            is scalar(@objs), 1, $ds;
            cmp_bag(['my_blog1'], [map { $_->{blogName} } @objs]);
            my ($no_detected) = grep { $_->{blogName} eq 'my_blog1' } @objs; 
            is scalar(@{$no_detected->{result}}), 0, 'no detected';
        }
        my @global_templates = grep { $_->{ds} eq 'template' && $_->{blogId} == 0 } @{$json->{result}};
        is scalar(@global_templates), 1, 'global template';
        cmp_bag(['system'], [map { $_->{blogName} } @global_templates]);
        my ($detected) = grep { $_->{blogName} eq 'system' } @global_templates; 
        is scalar(@{$detected->{result}}), 1, 'detected';
    };
};

subtest 'Delete revisions' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'start_reduce_revisions',
        blog_id => 0,
    });

    subtest 'Delete revisions for blog_id=1 without global template' => sub {
        # blog_id=1 does not have any revisions 
        $app->post_ok({
            __mode                => 'reduce_revisions',
            reduce_revisions_what => '1',
            target_entry          => 1,
            target_cd             => 1,
            target_template       => 1,
        });

        my @jobs  = _load_jobs();
        is scalar(@jobs), 0, 'no jobs';
    };

    subtest 'Delete revisions for blog_id=1 with global template' => sub {
        $app->post_ok({
            __mode                 => 'reduce_revisions',
            reduce_revisions_what  => '1',
            target_entry           => 1,
            target_cd              => 1,
            target_template        => 1,
            target_global_template => 1,
        });

        my @jobs  = _load_jobs();
        is scalar(@jobs), 1;

        require JSON;
        my $arg = JSON::decode_json($jobs[0]->arg);
        is $arg->{ds_label}, 'Global Template';
        is $arg->{ds}, 'template';
        is $arg->{blog_id}, 0;
        is $arg->{max}, 20;
        is scalar(@{$arg->{result}}), 1;

        my $count = MT->model('template:revision')->count({}, {
            join => MT->model('template')->join_on(undef, {
                id      => \'= template_rev_template_id',
                blog_id => 0,
            })
        });
        is $count, 21;

        _run_rpt();

        @jobs  = _load_jobs();
        is scalar(@jobs), 0, 'ran jobs';

        $count = MT->model('template:revision')->count({}, {
            join => MT->model('template')->join_on(undef, {
                id      => \'= template_rev_template_id',
                blog_id => 0,
            })
        });
        is $count, 20, 'global template: removed';

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        my $res = $app->get_ok({
            __mode                 => 'detect_reduce_revisions',
            reduce_revisions_what  => '',
            target_global_template => 1,
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            
        my @global_templates = grep { $_->{ds} eq 'template' && $_->{blogId} == 0 } @{$json->{result}};
        is scalar(@{$global_templates[0]->{result}}), 0, 'global template revisions removed';

    };

    subtest 'Delete revisions for blog_id=2' => sub {
        # blog_id=2 has many revisions generated by _create_revisions method
        $app->post_ok({
            __mode                 => 'reduce_revisions',
            reduce_revisions_what  => '2',
            target_entry           => 1,
            target_cd              => 1,
            target_template        => 1,
        });

        my @jobs  = _load_jobs();
        is scalar(@jobs), 3, 'no jobs';

        require JSON;
        cmp_bag(['entry', 'cd', 'template'], [map { my $arg = JSON::decode_json($_->arg); $arg->{ds} } @jobs]);
        cmp_bag(['Entry', 'Content Data', 'Template'], [map { my $arg = JSON::decode_json($_->arg); $arg->{ds_label} } @jobs]);
        cmp_bag([2, 2, 2], [map { my $arg = JSON::decode_json($_->arg); $arg->{blog_id} } @jobs]);

        my %count;
        for my $ds (qw/entry cd template/) {
            $count{$ds} = MT->model("${ds}:revision")->count({}, {
                join => MT->model($ds)->join_on(undef, {
                    id      => \"= ${ds}_rev_${ds}_id",
                    blog_id => $site2->id,
                })
            });
            is $count{$ds}, 21;
        }

        _run_rpt();

        @jobs  = _load_jobs();
        is scalar(@jobs), 0, 'ran jobs';

        for my $ds (qw/entry cd template/) {
            $count{$ds} = MT->model("${ds}:revision")->count({}, {
                join => MT->model($ds)->join_on(undef, {
                    id      => \"= ${ds}_rev_${ds}_id",
                    blog_id => $site2->id,
                })
            });
            is $count{$ds}, 20, "${ds}: removed";
        }

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        my $res = $app->get_ok({
            __mode                 => 'detect_reduce_revisions',
            reduce_revisions_what  => '2',
            target_entry           => 1,
            target_cd              => 1,
            target_template        => 1,
        });
        my $json = MT::Util::from_json($res->decoded_content);                                                                                                            

        for my $ds (qw/entry cd template/) {
            my @objs;
            if ($ds eq 'template') {
                @objs = grep { $_->{ds} eq $ds && $_->{blogId} != 0 } @{$json->{result}};
            } else {
                @objs = grep { $_->{ds} eq $ds } @{$json->{result}};
            }
            is scalar(@{$objs[0]->{result}}), 0, "${ds} revisions removed";
        }
    };
};

sub _create_revisions {
    my ($site) = @_;

    for my $ds ('template', 'cd', 'entry') {
        my $col = 'max_revisions_' . $ds;
        is $site->$col, undef, 'revision_max is undef for brandnew sites';
    
        my $obj;
        if ($ds eq 'template') {
            $obj = $objs->{ $ds_spec->{$ds}->{fixture} }{$site->id}{ $ds . '1' };
        } else {
            $obj = $objs->{ $ds_spec->{$ds}->{fixture} }{ $ds . '1' };
        }
    
        for (1 .. 21) {
            my $rev_obj = $obj->clone();
            $rev_obj->{changed_revisioned_cols} = [$ds_spec->{$ds}->{field}];
            $rev_obj->save_revision('test');
        }
    
        my @revisions = MT->model($ds . ':revision')->load({ $ds . '_id' => $obj->id });
        is scalar(@revisions), 21, "$ds: excessive";

        # Update created_on for testing filter_date
        for my $revision (@revisions) {
            $revision->created_on('20240101000000');
            $revision->save;
        }
    }

    my $obj = $objs->{'template'}{0}{'global_template'};
    for (1 .. 21) {
        my $rev_obj = $obj->clone();
        $rev_obj->{changed_revisioned_cols} = ['text'];
        $rev_obj->save_revision('test');
    }
    my @revisions = MT->model('template:revision')->load({ 'template_id' => $obj->id });
    is scalar(@revisions), 21, "global template: excessive";

    # Update created_on for testing filter_date
    for my $revision (@revisions) {
        $revision->created_on('20240101000000');
        $revision->save;
    }
}

sub _load_jobs {
    my $funcmap = MT->model('ts_funcmap')->load({funcname => 'MT::Worker::ReduceRevisions'}) or return;
    MT->model('ts_job')->load({funcid => $funcmap->funcid});
}

done_testing;
