use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use Test::Deep qw(cmp_bag);

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare({
    website => [
        { name => 'my website' },
        { name => 'second website' },
    ],
    author => [{
            name => 'superuser',
        }, {
            name        => 'system manager',
            permissions => [qw(manage_content_data)],
        }, {
            name  => 'site manager',
            roles => [{ role => [qw(system_manage_content_data)], website => ['my website', 'second website'] }],
        }, {
            name  => 'content manager',
            roles => [{ role => [qw(manage_content_data)], website => ['my website'] }],
        }, {
            name  => 'content creater',
            roles => [{ role => [qw(create_content_data)], website => ['my website'] }],
        }, {
            name  => 'content editor',
            roles => [{ role => [qw(edit_all_content_data)], website => ['my website'] }],
        }, {
            name  => 'content publisher',
            roles => [{ role => [qw(publish_content_data)], website => 'my website' }],
        }, {
            name  => 'entry editor',
            roles => [{ role => [qw(edit_all_posts)], website => ['my website', 'second website'] }],
        }
    ],
    role => {
        system_manage_content_data => [qw(manage_content_data)],
        manage_content_data => [{
            permissions  => [qw(manage_content_data)],
            content_type => 'ct',
        }],
        create_content_data => [{
            permissions  => [qw(create_content_data)],
            content_type => 'ct',
        }],
        edit_all_content_data => [{
            permissions  => [qw(edit_all_content_data)],
            content_type => 'ct',
        }],
        publish_content_data => [{
            permissions  => [qw(publish_content_data)],
            content_type => 'ct',
        }],
        edit_all_posts => [{
            permissions => [qw(edit_all_posts)],
        }],
    },
    content_type => {
        ct => {
            name    => 'ct',
            website => 'my website',
            fields  => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
            ],
        },
        ct2 => {
            name    => 'ct2',
            website => 'second website',
            fields  => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
            ],
        },
    },
    content_data => {
        cd => {
            content_type => 'ct',
            author       => 'superuser',
            website      => 'my website',
            data         => {
                cf_single_line_text => 'test single line text',
            },
        },
        cd2 => {
            content_type => 'ct2',
            author       => 'superuser',
            website      => 'second website',
            data         => {
                cf_single_line_text => 'test single line text',
            },
        },
    },
});

my $first_site  = $objs->{website}{'my website'};
my $second_site = $objs->{website}{'second website'};

#die explain [MT::Permission->load({author_id => $objs->{author}{'content publisher'}->id})];

subtest 'first site search: content data: privilege users' => sub {
    my $app = MT::Test::App->new;
    # everyone but entry editor
    my @names = grep !/entry editor/, keys %{$objs->{author}};
    for my $name (@names) {
        my $user = $objs->{author}{$name};
        $app->login($user);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $first_site->id,
        });
        $app->has_no_permission_error("search:content_data by $name");
        my @search_tabs = _find_search_tabs($app);
        ok grep(/Content Data/, @search_tabs), "$name has 'Content Data' tab" or next;
        my @search_fields = _find_search_field_options($app);
        cmp_bag \@search_fields => [qw(ct)], "$name has only 'ct' field";
    }
};

subtest 'first site search: content data: non privilege users' => sub {
    my $app = MT::Test::App->new;
    for my $name ('entry editor') {
        my $user = $objs->{author}{$name};
        $app->login($user);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $first_site->id,
        });
        $app->has_no_permission_error("search:content_data by $name");
        my @search_tabs = _find_search_tabs($app);
        ok !grep(/Content Data/, @search_tabs), "$name has no 'Content Data' tab" or next;
    }
};

subtest 'second site search: content data: privilege users' => sub {
    my $app = MT::Test::App->new;
    for my $name ('superuser', 'system manager', 'site manager') {
        my $user = $objs->{author}{$name};
        $app->login($user);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $second_site->id,
        });
        $app->has_no_permission_error("search:content_data by $name");
        my @search_tabs = _find_search_tabs($app);
        ok grep(/Content Data/, @search_tabs), "$name has 'Content Data' tab" or next;
        my @search_fields = _find_search_field_options($app);
        cmp_bag \@search_fields => [qw(ct2)], "$name has only 'ct2' field";
    }
};

subtest 'second site search: content data: non privilege users' => sub {
    my $app = MT::Test::App->new;
    my @names = grep !/(?:superuser|system manager|site manager)/, keys %{$objs->{author}};
    for my $name (@names) {
        my $user = $objs->{author}{$name};
        $app->login($user);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $second_site->id,
        });
        if ($name eq 'entry editor') {
            $app->has_no_permission_error("search:content_data by $name");
            my @search_tabs = _find_search_tabs($app);
            ok !grep(/Content Data/, @search_tabs), "$name has no 'Content Data' tab" or next;
        } else {
            $app->has_permission_error("search:content_data by $name");
        }
    }
};

subtest 'system search: content data: privilege users' => sub {
    my $app = MT::Test::App->new;
    # only those who have system permissions
    for my $name ('superuser', 'system manager') {
        my $user = $objs->{author}{$name};
        $app->login($user);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => 0,
        });
        $app->has_no_permission_error("search:content_data by $name");
        my @search_tabs = _find_search_tabs($app);
        ok grep(/Content Data/, @search_tabs), "$name has 'Content Data' tab" or next;
        my @search_fields = _find_search_field_options($app);
        cmp_bag \@search_fields => [], "content type selector is not available";
    }
};

subtest 'system search: content data: non privilege users' => sub {
    my $app = MT::Test::App->new;
    my @names = grep !/(?:superuser|system manager)/, keys %{$objs->{author}};
    for my $name (@names) {
        my $user = $objs->{author}{$name};
        $app->login($user);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => 0,
        });
        $app->has_permission_error("search:content_data by $name");
    }
};

done_testing;

sub _find_search_tabs {
    my $app = shift;
    my @names;
    $app->wq_find('#search-tabs-list li span')->each(sub {
        my $name = $_->text;
        $name =~ s/^\s+|\s+$//sg;
        push @names, $name;
    });
    @names;
}

sub _find_search_field_options {
    my $app = shift;
    my @names;
    $app->wq_find('#content-type-field select option')->each(sub {
        my $name = $_->text;
        $name =~ s/^\s+|\s+$//sg;
        push @names, $name;
    });
    @names;
}
