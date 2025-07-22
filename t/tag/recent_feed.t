use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    plan skip_all => 'requires XML::LibXML' unless eval { require XML::LibXML; 1 };

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Fixture;

my @themes = ([qw(eigerwand eigerwand)]);
if (-d "themes/eiger") {
    push @themes, [qw(eiger eiger)];
}
if (-d "themes/rainier") {
    push @themes, [qw(rainier rainier)];
}

for my $theme (@themes) {
    my ($website_theme, $blog_theme) = @$theme;

    $test_env->prepare_fixture('db');

    my $website_name = 'My <First> Site';
    my $blog_name    = 'My <First> Child Site';

    my $objs = MT::Test::Fixture->prepare({
        website => [{
            name        => $website_name,
            description => 'Descripiton for my <first> site',
            theme_id    => $website_theme,
            site_path   => 'TEST_ROOT/site',
        }],
        blog => [{
            name        => $blog_name,
            description => 'Descripiton for my <first> child site',
            theme_id    => $blog_theme,
            site_path   => 'TEST_ROOT/site/child',
            parent      => $website_name,
        }],
        category => [{
                label   => '<foo>',
                website => $website_name,
            }, {
                label => '<foo>',
                blog  => $blog_name,
            }
        ],
        tag   => ['<tag>'],
        entry => [{
                title      => 'First <entry> title',
                text       => 'Hello <b>world</b>',
                text_more  => '<i>More</i> stuff',
                categories => ['<foo>'],
                tags       => ['<tag>'],
                website    => 'My <First> Site',
            }, {
                title      => 'First <entry> title for child site',
                text       => 'Hello <b>world</b>',
                text_more  => '<i>More</i> stuff',
                categories => ['<foo>'],
                tags       => ['<tag>'],
                blog       => 'My <First> Child Site',
            }
        ],
    });

    my $website = $objs->{website}{'My <First> Site'};
    my $blog    = $objs->{blog}{'My <First> Child Site'};

    for my $site ($website, $blog) {
        note "CURRENT THEME: " . $site->theme->id;
        my $tmpl = MT::Template->load({ identifier => 'feed_recent', blog_id => $site->id });

        my $feed = $tmpl->output;
        note $feed;

        eval {
            my $xml = XML::LibXML->new;
            $xml->load_ext_dtd(0);
            $xml->validation(1);
            $xml->parse_string($feed);
        };
        ok !$@, $site->name . ': feed is valid';
        note $@ if $@;
    }

}

done_testing;
