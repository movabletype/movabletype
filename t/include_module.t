use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Template;
use MT::Template::Context;

$test_env->prepare_fixture('db');

my $blog1 = MT->model('blog')->new();
$blog1->set_values({ id => 2, parent_id => 1, name => 'child1' });
$blog1->save();

my $blog2 = MT->model('website')->new();
$blog2->set_values({ id => 3, name => 'Aunt' });
$blog2->save();

my $blog3 = MT->model('website')->new();
$blog3->set_values({ id => 4, parent_id => 3, name => 'Cousin' });
$blog3->save();

create_include_template([0, 1, 2, 3, 4], 'Module');
create_include_template([0],             'Module Global');
create_include_template([1],             'Module Parent');
create_include_template([2],             'Module Me');
create_include_template([3],             'Module Aunt');
create_include_template([4],             'Module Cousin');
create_include_template([0, 1],          'Module Global And Parent');
create_include_template([0, 3],          'Module Global and Aunt');
create_include_template([0, 1, 3],       'Module Global, Parent and Aunt');

subtest 'simple (2 > 2)' => sub {
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module"> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:2}, 'right blog');
};

subtest 'fallback from child for parent module (2 > X)' => sub {    #TODO suspicious spec
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Parent"> bye));
    ok !defined $out, 'error occurs';
    like $tmpl->errstr, qr/Cannot find included template/, 'right error message';
    #diag($tmpl->errstr) if !defined $out;
    #like($out, qr{blog_id:1}, 'right blog');
};

subtest 'fallback from child for parent module (2 > 0)' => sub {    # TODO suspicious spec
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Global And Parent"> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
};

subtest 'fallback from child for global module (2 > 0)' => sub {
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Global"> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
};

subtest 'blog_id simple (2 > *)' => sub {

    for my $blog_id (0, 1, 2, 3, 4) {
        my ($out, $tmpl) = build(2, sprintf(q{hi <mt:include module="Module" blog_id=%d> bye}, $blog_id));
        diag($tmpl->errstr) if !defined $out;
        like($out, qr{blog_id:$blog_id}, 'right blog');
    }
};

subtest 'fallback via non-ancestors with blog_id (2 > * > 0)' => sub {

    for my $blog_id (3, 4) {
        my ($out, $tmpl) = build(2, sprintf(q{hi <mt:include module="Module Global" blog_id=%d> bye}, $blog_id));
        diag($tmpl->errstr) if !defined $out;
        like($out, qr{blog_id:0}, 'right blog');
    }
};

subtest 'fallback via non-ancestors with blog_id (2 > 4 > 0)' => sub {    #TODO suspicious spec
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Global, Parent and Aunt" blog_id=4> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
    #like($out, qr{blog_id:3}, 'right blog'); # or blog_id:4
};

subtest 'fallback via non-ancestors with blog_id (2 > 4 > 0)' => sub {    #TODO suspicious spec
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Global and Aunt" blog_id=4> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
    #like($out, qr{blog_id:3}, 'right blog');
};

subtest 'parent=1 on child (2 > 1)' => sub {
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module" parent=1> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:1}, 'right blog');
};

subtest 'parent=1 on child for global (2 > X)' => sub {    #TODO suspicious spec
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Global" parent=1> bye));
    ok !defined $out, 'error occurs';
    like $tmpl->errstr, qr/Cannot find included template/, 'right error message';
    #diag($tmpl->errstr) if !defined $out;
    #like($out, qr{blog_id:0}, 'right blog');
};

subtest 'parent=1 on parent itself (1 > 1)' => sub {    #TODO suspicious spec
    my ($out, $tmpl) = build(1, q(hi <mt:include module="Module" parent=1> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:1}, 'right blog');
};

subtest 'parent=1 on parent itself (1 > 1)' => sub {    #TODO suspicious spec
    my ($out, $tmpl) = build(1, q(hi <mt:include module="Module Global" parent=1> bye));
    like $tmpl->errstr, qr/Cannot find included template/, 'right error message';
    #diag($tmpl->errstr) if !defined $out;
    #like($out, qr{blog_id:0}, 'right blog');
};

subtest 'global=1 on child (2 > 0)' => sub {
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module" global=1> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
};

subtest 'global=1 on parent (1 > 0)' => sub {
    my ($out, $tmpl) = build(1, q(hi <mt:include module="Module" global=1> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
};

subtest 'local=1 on child with nonexistent (2 > X)' => sub {    # TODO suspicious spec
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Non-Exists Anyware" local=1> bye));
    ok !defined $out, 'error occurs';
    like $tmpl->errstr, qr/Cannot find included template/, 'right error message';
    #diag($tmpl->errstr) if !defined $out;
    #like($out, qr{bye}, 'right blog');
};

subtest 'local=1 on child with nonexistent but global has (2 > 0)' => sub {    # TODO suspicious spec
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Global And Parent" local=1> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
};

subtest 'parent vs global' => sub {
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module Global And Parent" parent=1 global=1> bye));
    ok !defined $out, 'error occurs';
};

subtest 'local vs global' => sub {
    my ($out, $tmpl) = build(2, q(hi <mt:include module="Module" local=1 global=1> bye));
    diag($tmpl->errstr) if !defined $out;
    like($out, qr{blog_id:0}, 'right blog');
};

subtest 'nested inclusion' => sub {
    my ($middle) = create_include_template([2], 'Middle Module');

    subtest 'nested inclusion (2 > 2 > 2)' => sub {
        MT::Request->instance->reset;
        $middle->text('hi <mt:include module="Module"> bye');
        $middle->save();
        my ($out, $tmpl) = build(2, q(hi <mt:include module="Middle Module"> bye));
        diag($tmpl->errstr) if !defined $out;
        like($out, qr{blog_id:2}, 'right blog');
    };

    subtest 'nested inclusion (2 > 2 > 0)' => sub {
        MT::Request->instance->reset;
        $middle->text('hi <mt:include module="Module Global"> bye');
        $middle->save();
        my ($out, $tmpl) = build(2, q(hi <mt:include module="Middle Module"> bye));
        diag($tmpl->errstr) if !defined $out;
        like($out, qr{blog_id:0}, 'right blog');
    };

    subtest 'nested inclusion (2 > 2 > 1)' => sub {    #TODO suspicious spec
        MT::Request->instance->reset;
        $middle->text('hi <mt:include module="Module Parent"> bye');
        $middle->save();
        my ($out, $tmpl) = build(2, q(hi <mt:include module="Middle Module"> bye));
        ok !defined $out, 'error occurs';
        like $tmpl->errstr, qr/Cannot find included template/, 'right error message';
        #diag($tmpl->errstr) if !defined $out;
        #like($out, qr{blog_id:1}, 'right blog');
    };
};

subtest 'nested inclusion' => sub {
    my ($middle) = create_include_template([4], 'Middle Module');

    subtest 'nested inclusion (2 > 4 > 2)' => sub {
        MT::Request->instance->reset;
        $middle->text('hi <mt:include module="Module"> bye');
        $middle->save();
        my ($out, $tmpl) = build(2, q(hi <mt:include module="Middle Module" blog_id=4> bye));
        diag($tmpl->errstr) if !defined $out;
        like($out, qr{blog_id:2}, 'right blog');
    };

    subtest 'nested inclusion (2 > 4 > 1)' => sub {
        MT::Request->instance->reset;
        $middle->text('hi <mt:include module="Module" parent=1> bye');
        $middle->save();
        my ($out, $tmpl) = build(2, q(hi <mt:include module="Middle Module" blog_id=4> bye));
        diag($tmpl->errstr) if !defined $out;
        like($out, qr{blog_id:1}, 'right blog');
    };

    subtest 'nested inclusion (2 > 4 > 0)' => sub {
        MT::Request->instance->reset;
        $middle->text('hi <mt:include module="Module Global and Aunt"> bye');
        $middle->save();
        my ($out, $tmpl) = build(2, q(hi <mt:include module="Middle Module" blog_id=4> bye));
        diag($tmpl->errstr) if !defined $out;
        like($out, qr{blog_id:0}, 'right blog');
    };
};

sub create_include_template {
    my ($blog_ids, $name) = @_;
    my @ret;
    for my $blog_id (@$blog_ids) {
        my $include = MT->model('template')->new;
        $include->blog_id($blog_id);
        $include->name($name);
        $include->type('custom');
        $include->text('blog_id:' . $blog_id);
        $include->save;
        push @ret, $include;
    }
    return @ret;
}

sub build {
    my ($blog_id, $str) = @_;
    MT::Request->instance->reset;
    my $tmpl = MT->model('template')->new;
    $tmpl->blog_id($blog_id);
    $tmpl->text($str);
    my $out = $tmpl->build(MT::Template::Context->new, {});
    return $out, $tmpl;
}

done_testing;
