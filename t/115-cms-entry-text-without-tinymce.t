#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-without-tinymce-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';
use MT::Test qw( :app :db :data );
use Test::More;

my $app  = MT->instance;
my $user = $app->model('author')->load(1);
my $blog = $app->model('blog')->load(1);

my $mock_app = Test::MockModule->new('MT::App');
$mock_app->mock( 'validate_magic', 0 );

{
    my $entry = $app->model('entry')->load(1);
    $entry->text('Some Entry Text With IMG Tag <img src="src_via_entry" />');
    $entry->save or die;
}

my @suite = (
    {
        param => {
            text => 'Archetype Editor is used',
        },
        like => qr{/js/archetype_editor\.js},
    },
    {
        param => {
            id => 1,
        },
        like => qr{Some Entry Text With IMG Tag &lt;img src=&quot;src_via_entry&quot; /&gt;},
    },
    {
        param => {
            text => 'Set the text via param',
        },
        like => qr/Set the text via param/,
    },
    {
        param => {
            text_more => 'Set the text more via param',
        },
        like => qr/Set the text more via param/,
    },
    {
        param => {
            text => 'Set the text via param <img src="src_via_param" />',
        },
        like => qr/Set the text via param/,
        unlike => qr/src_via_param/,
    },
    {
        param => {
            text_more => 'Set the text more via param <img src="src_via_param" />',
        },
        like => qr/Set the text more via param/,
        unlike => qr/src_via_param/,
    },
    {
        param => {
            text => 'Set the text via param <img src="src_via_param" />',
        },
        config => {
            GlobalSanitizeSpec => 'img src',
        },
        like => qr{Set the text via param &lt;img src=&quot;src_via_param&quot; /&gt;},
    },
    {
        param => {
            text_more => 'Set the text more via param <img src="src_via_param" />',
        },
        config => {
            GlobalSanitizeSpec => 'img src',
        },
        like => qr{Set the text more via param &lt;img src=&quot;src_via_param&quot; /&gt;},
    },
    {
        param => {
            text => 'Set the text via param <img src="src_via_param" />',
        },
        config => {
            GlobalSanitizeSpec => '0',
        },
        like => qr{Set the text via param &lt;img src=&quot;src_via_param&quot; /&gt;},
    },
    {
        param => {
            text_more => 'Set the text more via param <img src="src_via_param" />',
        },
        config => {
            GlobalSanitizeSpec => '0',
        },
        like => qr{Set the text more via param &lt;img src=&quot;src_via_param&quot; /&gt;},
    },
);

for my $type (qw(entry page)) {
    subtest '_type:' . $type => sub {
        for my $data (@suite) {
            my $p = MT::Util::to_json(
                {   param => $data->{param},
                    ( $data->{config} ? ( config => $data->{config} ) : () )
                }
            );
            subtest $p => sub {
                local $app->config->{__var}{ lc('GlobalSanitizeSpec') }
                    = $data->{config}{GlobalSanitizeSpec}
                    if exists $data->{config}
                    && exists $data->{config}{GlobalSanitizeSpec};

                my $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user => $user,
                        __mode      => 'view',
                        blog_id     => $blog->id,
                        _type       => 'entry',
                        %{ $data->{param} },
                    }
                );

                my $out = delete $app->{__test_output};
                if ( $data->{like} ) {
                    like( $out, $data->{like}, 'contains' );
                }
                if ( $data->{unlike} ) {
                    unlike( $out, $data->{unlike}, 'not contains' );
                }

                done_testing();
            };
        }

        done_testing();
    };
}

done_testing();
