use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $site_id = 1;
my $site    = MT::Website->load($site_id);

my $objs = MT::Test::Fixture->prepare({
    website => [{
        name => 'My Site',
    }],
    blog => [{
        name   => 'My Child Site',
        parent => 'My Site',
    }],
    template => [{
            website => 'My Site',
            type    => 'widget',
            name    => 'my_widget',
            text    => 'My local widget',
        }, {
            blog_id => 0,
            type    => 'widget',
            name    => 'my_widget',
            text    => 'My global widget',
        }, {
            blog_id    => 0,
            type       => 'widgetset',
            name       => 'global_widgetset',
            modulesets => [qw/my_widget/],
        }
    ],
});

MT::Test::Tag->run_perl_tests($site_id);
MT::Test::Tag->run_php_tests($site_id);

done_testing;

__DATA__

=== global widgetset with a widget whose name is identical to a site widget
--- template
<MTWidgetSet name="global_widgetset">
--- expected
My global widget

=== unknown widgetset
--- template
<MTWidgetSet name="unknown_widgetset">
--- expected_error
Specified WidgetSet 'unknown_widgetset' not found.