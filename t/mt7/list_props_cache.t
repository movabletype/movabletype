use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file("plugins/MyPlugin/MyPlugin.pl", <<'PLUGIN' );
package MyPlugin;
require MT;
require MT::Plugin;
our ($flag2, $flag3);
MT->add_plugin(MT::Plugin->new({
    id => 'my_plugin',
    name => 'MyPlugin',
    version => 1,
    registry => {
        list_properties => {
            entry => {
                my_plugin_field1 => {base => '__virtual.integer'},
                my_plugin_field2 => {base => '__virtual.integer', condition => sub { $flag2 }},
                my_plugin_field3 => {base => '__virtual.integer', condition => sub { $flag3 }},
            },
        },
    },
}));
PLUGIN
}

use MT::Test;
use MT::Test::Permission;
use MT::ListProperty;

$test_env->prepare_fixture('db');

my $site       = MT->model('website')->load(1);
my $child_site = MT::Test::Permission->make_blog(parent_id => $site->id);
my $app        = MT->instance;

my @tags;
for my $name ('foo', 'bar', 'baz') {
    my $tag = MT::Test::Permission->make_tag(name => $name);
    push @tags, $tag;
}

my (@cts, @cds);
for my $ct_id (1 .. 2) {
    my $content_type = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type ' . $ct_id,
    );

    my $tags_field = MT::Test::Permission->make_content_field(
        blog_id         => $site->id,
        content_type_id => $content_type->id,
        type            => 'tags',
    );

    my $content_field = MT::Test::Permission->make_content_field(
        blog_id         => $site->id,
        content_type_id => $content_type->id,
        name            => 'single text',
        type            => 'single_line_text',
    );

    my $fields = [{
            id      => $content_field->id,
            order   => 1,
            type    => $content_field->type,
            options => {
                display  => 'force',
                hint     => '',
                label    => 1,
                required => 1,
            },
        },
        {
            id      => $tags_field->id,
            order   => 1,
            type    => $tags_field->type,
            options => {
                label    => $tags_field->name,
                multiple => 1,
            },
            unique_id => $tags_field->unique_id,
        },
    ];

    $content_type->fields($fields);
    $content_type->save or die $content_type->errstr;
    push @cts, $content_type;

    push @cds, MT::Test::Permission->make_content_data(
        blog_id         => $site->id,
        author_id       => 1,
        content_type_id => $content_type->id,
        data            => {
            $content_field->id => 'test',
            $tags_field->id    => [map { $_->id } @tags],
        },
    );
}

MT::CMS::ContentType::init_content_type(undef, MT->instance);

subtest 'content_data' => sub {

    for my $context_site ($site, $child_site) {
        subtest 'site_id:' . $context_site->id => sub {
            $app->blog($context_site);
            for my $ct (@cts) {
                subtest 'content_type_id:' . $ct->id => sub {
                    my $prop_class = 'content_data.content_data_' . $ct->id;
                    subtest 'child site context' => sub {
                        my $prop = MT::ListProperty->list_properties($prop_class);
                        ok exists $prop->{__id};
                        ok exists $prop->{blog_name};          # does not have condition
                        ok exists $prop->{current_context};    # does not have condition
                        ok exists $prop->{current_user};
                    };
                    ok(exists $MT::ListProperty::CachedListProperties{$prop_class},            'cache is stored');
                    ok(exists $MT::ListProperty::CachedListProperties{$prop_class}{blog_name}, 'cache is stored');
                };
            }
        };
    }

    %MT::ListProperty::CachedListProperties = ();
};

subtest 'blog_name in entry class' => sub {

    subtest 'site context' => sub {
        $app->blog($site);
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{blog_name};
        ok(exists $MT::ListProperty::CachedListProperties{entry},            'cache is stored');
        ok(exists $MT::ListProperty::CachedListProperties{entry}{blog_name}, 'cache is stored');
    };

    subtest 'child site context' => sub {
        $app->blog($child_site);
        my $prop = MT::ListProperty->list_properties('entry');
        ok !exists $prop->{blog_name};
        ok(exists $MT::ListProperty::CachedListProperties{entry},            'cache is stored');
        ok(exists $MT::ListProperty::CachedListProperties{entry}{blog_name}, 'cache is stored');
    };

    %MT::ListProperty::CachedListProperties = ();
};

subtest 'member' => sub {

    subtest 'site context' => sub {
        MT->config->SingleCommunity(1);
        my $prop = MT::ListProperty->list_properties('member');
        ok !exists $prop->{type};
        ok(exists $MT::ListProperty::CachedListProperties{member},       'cache is stored');
        ok(exists $MT::ListProperty::CachedListProperties{member}{type}, 'cache is stored');
    };

    subtest 'child site context' => sub {
        MT->config->SingleCommunity(0);
        my $prop = MT::ListProperty->list_properties('member');
        ok exists $prop->{type};
        ok(exists $MT::ListProperty::CachedListProperties{member},       'cache is stored');
        ok(exists $MT::ListProperty::CachedListProperties{member}{type}, 'cache is stored');
    };

    %MT::ListProperty::CachedListProperties = ();
};

subtest 'tag_list_prop_count' => sub {

    my @prop_names = (
        sprintf('site_%d_id_%d_count', $site->id, $cts[0]->id),
        sprintf('for_site_%d_id_%d',   $site->id, $cts[0]->id),
    );

    for my $name (@prop_names) {
        subtest 'site context' => sub {
            $app->blog($site);
            my $prop = MT::ListProperty->list_properties('tag');
            ok exists $prop->{$name};
            ok(exists $MT::ListProperty::CachedListProperties{tag},        'cache is stored');
            ok(exists $MT::ListProperty::CachedListProperties{tag}{$name}, 'cache is stored');
        };

        subtest 'child site context' => sub {
            $app->blog($child_site);
            my $prop = MT::ListProperty->list_properties('tag');
            ok !exists $prop->{$name};
            ok(exists $MT::ListProperty::CachedListProperties{tag},        'cache is stored');
            ok(exists $MT::ListProperty::CachedListProperties{tag}{$name}, 'cache is stored');
        };
    }

    %MT::ListProperty::CachedListProperties = ();
};

subtest 'plugin field in entry class' => sub {

    subtest 'case 1' => sub {
        $MyPlugin::flag2 = 0;
        $MyPlugin::flag3 = 0;
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{my_plugin_field1};
        ok !exists $prop->{my_plugin_field2};
        ok !exists $prop->{my_plugin_field3};
    };

    is(keys %MT::ListProperty::CachedListProperties, 1, 'cache is stored');

    subtest 'case 2' => sub {
        $MyPlugin::flag2 = 1;
        $MyPlugin::flag3 = 1;
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{my_plugin_field1};
        ok exists $prop->{my_plugin_field2};
        ok exists $prop->{my_plugin_field3};
    };

    subtest 'case 3' => sub {
        $MyPlugin::flag2 = 0;
        $MyPlugin::flag3 = 1;
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{my_plugin_field1};
        ok !exists $prop->{my_plugin_field2};
        ok exists $prop->{my_plugin_field3};
    };

    ok(exists $MT::ListProperty::CachedListProperties{entry},                   'cache is stored');
    ok(exists $MT::ListProperty::CachedListProperties{entry}{my_plugin_field1}, 'cache is stored');
    ok(exists $MT::ListProperty::CachedListProperties{entry}{my_plugin_field2}, 'cache is stored');
    ok(exists $MT::ListProperty::CachedListProperties{entry}{my_plugin_field3}, 'cache is stored');
    %MT::ListProperty::CachedListProperties = ();
};

done_testing;
