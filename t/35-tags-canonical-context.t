#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DisableObjectCache => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use IPC::Run3;
use URI;

use MT::Test qw(:db :data);
use MT::WeblogPublisher;
my $app       = MT->instance;
my $publisher = MT::WeblogPublisher->new;

my $blog = $app->model('blog')->load(1);
my $preferred_map
    = $app->model('templatemap')
    ->load(
    { blog_id => $blog->id, archive_type => 'Individual', is_preferred => 1 }
    );
my $not_preferred_map = $app->model('templatemap')->new;
$not_preferred_map->set_values(
    {   %{ $preferred_map->column_values },
        id            => undef,
        is_preferred  => 0,
        file_template => '<mt:ArchiveDate format="%Y/%m/index2.html" />',
    }
);
$not_preferred_map->save;

$publisher->rebuild( Blog => $blog, TemplateMap => $not_preferred_map );
$publisher->start_time( time() + 1 );

my @suite = (
    { label => 'index', terms => { archive_type => 'index', }, },
    {   label => 'Individual (preferred)',
        terms => { templatemap_id => $preferred_map->id, },
    },
    {   label => 'Individual (not preferred)',
        preferred_mapping_url =>
            'http://narnia.na/nana/archives/1978/01/a-rainy-day.html',
        terms => { templatemap_id => $not_preferred_map->id, },
    },
    { label => 'Daily',    terms => { archive_type => 'Daily', }, },
    { label => 'Weekly',   terms => { archive_type => 'Weekly', }, },
    { label => 'Monthly',  terms => { archive_type => 'Monthly', }, },
    { label => 'Category', terms => { archive_type => 'Category', }, },
    { label => 'Page',     terms => { archive_type => 'Page', }, },
);

subtest 'Prepare canonical URLs before building page' => sub {
    for my $data (@suite) {
        subtest $data->{label} => sub {
            test_mapping_url($data);
        };
    }
};

sub test_mapping_url {
    my ($data) = @_;

    my $fileinfo = $app->model('fileinfo')
        ->load( { blog_id => $blog->id, %{ $data->{terms} } } );
    my $blog_uri = URI->new( $blog->site_url );

    my $ctx_module   = Test::MockModule->new('MT::Template::Context');
    my $stashed_data = {};
    $ctx_module->mock(
        'stash',
        sub {
            if ( scalar(@_) >= 3 ) {
                $stashed_data->{ $_[1] } = $_[2];
            }

            $ctx_module->original('stash')->(@_);
        }
    );
    $publisher->rebuild_from_fileinfo($fileinfo);

    is( $stashed_data->{current_mapping_url},
        exists( $data->{current_mapping_url} )
        ? $data->{current_mapping_url}
        : $blog_uri->scheme . '://' . $blog_uri->host . $fileinfo->url,
        'current_mapping_url - static'
    );
    is( $stashed_data->{preferred_mapping_url}
            && $stashed_data->{preferred_mapping_url}->(),
        exists( $data->{preferred_mapping_url} )
        ? $data->{preferred_mapping_url}
        : undef,
        'preferred_mapping_url - static'
    );

SKIP: {
        skip "Can't find executable file: php", 2 unless has_php();
        my $php_result = test_mapping_url_php( $fileinfo->id );

        is( $php_result->{current_mapping_url},
            exists( $data->{current_mapping_url} )
            ? $data->{current_mapping_url}
            : $blog_uri->scheme . '://' . $blog_uri->host . $fileinfo->url,
            'current_mapping_url - dynamic'
        );
        is( $php_result->{preferred_mapping_url},
            exists( $data->{preferred_mapping_url} )
            ? $data->{preferred_mapping_url}
            : undef,
            'preferred_mapping_url - dynamic'
        );
    }
}

sub test_mapping_url_php {
    my ($fileinfo_id) = @_;

    my $test_script = <<PHP;
<?php
\$MT_HOME     = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG   = '@{[ $app->find_config ]}';
\$blog_id     = '@{[ $blog->id ]}';
\$fileinfo_id = '$fileinfo_id';
PHP
    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance(1, $MT_CONFIG);
$mt->init_plugins();

include_once($MT_HOME . '/php/lib/class.mt_fileinfo.php');

$db = $mt->db();
$ctx =& $mt->context();

$fileinfo = new FileInfo;
$fileinfo->Load($fileinfo_id);

$entry = $fileinfo->entry();
$ctx->stash('entry', $entry);

$ctx->stash('blog_id', $blog_id);
$ctx->stash('local_blog_id', $blog_id);
$ctx->stash('current_archive_type', $fileinfo->archive_type);

$blog = $db->fetch_blog($blog_id);
$mt->set_canonical_url($ctx, $blog, $fileinfo);

print($ctx->stash('current_mapping_url') . "\n");
print($ctx->stash('preferred_mapping_url') . "\n");
PHP

    run3 ['php', '-q'],
        \$test_script, \my $php_result, undef
        or die $?;

    my $result = {};
    @$result{qw(current_mapping_url preferred_mapping_url)} = split /\n/,
        $php_result;

    $result;
}

done_testing();
