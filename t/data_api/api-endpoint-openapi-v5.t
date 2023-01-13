#!/usr/bin/perl

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

use MT::Test::DataAPI;

$test_env->prepare_fixture('db');

# This test can't force api version
local $ENV{MT_TEST_FORCE_DATAAPI_VERSION};

my %json;
test_data_api({
        path     => "/v4/",
        method   => 'GET',
        code     => 200,
        complete => sub {
            my ($data, $body, $headers) = @_;
            $json{v4} = MT::Util::from_json($body);
        },
    },
);

test_data_api({
        path     => "/v5/",
        method   => 'GET',
        code     => 200,
        complete => sub {
            my ($data, $body, $headers) = @_;
            $json{v5} = MT::Util::from_json($body);
        },
    },
);

for my $name (qw/asset blog cf content_type group log permission tag template templatemap user website/) {
    is($json{v4}{components}{schemas}{$name}{properties}{id}{type}, 'string', "$name id is string type in v4");
    is($json{v5}{components}{schemas}{$name}{properties}{id}{type}, 'integer', "$name id is integer type in v5");
}

for my $prop (qw/assets categories/) {
    is_deeply(
        $json{v5}{components}{schemas}{entry_updatable}{properties}{$prop},
        {
            type  => 'array',
            items => {
                type       => 'object',
                properties => {
                    id => { type => 'integer' },
                },
            },
        },
        "entry_updatable has $prop property"
    );
    ok(!exists $json{v5}{components}{schemas}{page_updatable}{properties}{$prop}, "page_updatable does not have $prop property");
}

# asset
is($json{v4}{components}{schemas}{asset}{properties}{parent}{type}, 'string', "asset parent is string type in v4");
is($json{v5}{components}{schemas}{asset}{properties}{parent}{type}, 'object', "asset parent is object type in v5");

# association
for my $prop (qw/user role/) {
    is($json{v4}{components}{schemas}{association}{properties}{$prop}{properties}{id}{type}, 'string', "association $prop/id is string type in v4");
    is($json{v5}{components}{schemas}{association}{properties}{$prop}{properties}{id}{type}, 'integer', "association $prop/id is integer type in v5");
}

# blog / website
for my $component (qw/blog website/) {
    for my $prop (qw/basenameLimit junkFolderExpiry listOnIndex maxRevisionsEntry maxRevisionsTemplate smartReplace wordsInExcerpt/) {
        is($json{v4}{components}{schemas}{$component}{properties}{$prop}{type}, 'string', "$component $prop is string type in v4");
        is($json{v5}{components}{schemas}{$component}{properties}{$prop}{type}, 'integer', "$component $prop is integer type in v5");
    }
    is($json{v4}{components}{schemas}{$component}{properties}{junkScoreThreshold}{type}, 'string', "$component junkScoreThreshold is string type in v4");
    is($json{v5}{components}{schemas}{$component}{properties}{junkScoreThreshold}{type}, 'number', "$component junkScoreThreshold is number type in v5");
    is($json{v5}{components}{schemas}{$component}{properties}{junkScoreThreshold}{format}, 'float', "$component junkScoreThreshold is float format in v5");
    is($json{v4}{components}{schemas}{$component}{properties}{parent}{properties}{id}{type}, 'string', "$component parent/id is string type in v4");
    is($json{v5}{components}{schemas}{$component}{properties}{parent}{properties}{id}{type}, 'integer', "$component parent/id is integer type in v5");
}

# entry / page
for my $component (qw/entry page/) {
    is($json{v4}{components}{schemas}{$component}{properties}{author}{properties}{id}{type}, 'string', "$component author/id is string type in v4");
    is($json{v5}{components}{schemas}{$component}{properties}{author}{properties}{id}{type}, 'integer', "$component author/id is integer type in v5");
}

# category / folder
for my $component (qw/category folder/) {
    is($json{v4}{components}{schemas}{$component}{properties}{parent}{type}, 'string', "$component parent is string type in v4");
    is($json{v5}{components}{schemas}{$component}{properties}{parent}{type}, 'integer', "$component parent is integer type in v5");
}

# category_set
is($json{v4}{components}{schemas}{category_set}{properties}{categories}{items}{properties}{parent}{type}, 'string', "category_set categories/items/parent/id is string type in v4");
is($json{v5}{components}{schemas}{category_set}{properties}{categories}{items}{properties}{parent}{type}, 'integer', "category_set categories/items/parent/id is integer type in v5");

# content_data
is($json{v4}{components}{schemas}{cd}{properties}{data}{properties}{id}{type}, 'string', "cd data/id is string type in v4");
is($json{v5}{components}{schemas}{cd}{properties}{data}{items}{properties}{id}{type}, 'integer', "cd data/id is integer type in v5");
is($json{v4}{components}{schemas}{cd}{properties}{author}{properties}{id}{type}, 'string', "cd author/id is string type in v4");
is($json{v5}{components}{schemas}{cd}{properties}{author}{properties}{id}{type}, 'integer', "cd author/id is integer type in v5");

# content_type
is($json{v4}{components}{schemas}{content_type}{properties}{contentFields}{items}{properties}{id}{type}, 'string', "content_type contentFields/items/id is string type in v4");
is($json{v5}{components}{schemas}{content_type}{properties}{contentFields}{items}{properties}{id}{type}, 'integer', "content_type contentFields/items/id is integer type in v5");

# group
for my $prop (qw/memberCount permissionCount/) {
    is($json{v4}{components}{schemas}{group}{properties}{$prop}{type}, 'string', "group $prop is string type in v4");
    is($json{v5}{components}{schemas}{group}{properties}{$prop}{type}, 'integer', "group $prop is integer type in v5");
}

# log
is($json{v4}{components}{schemas}{log}{properties}{by}{properties}{id}{type}, 'string', "log by/id is string type in v4");
is($json{v5}{components}{schemas}{log}{properties}{by}{properties}{id}{type}, 'integer', "log by/id is integer type in v5");

# permission
for my $prop (qw/user roles/) {
    is($json{v4}{components}{schemas}{permission}{properties}{$prop}{properties}{id}{type}, 'string', "permission $prop/id is string type in v4");
    is($json{v5}{components}{schemas}{permission}{properties}{$prop}{properties}{id}{type}, 'integer', "permission $prop/id is integer type in v5");
}

# tag
for my $prop (qw/assetCount entryCount pageCount/) {
    is($json{v4}{components}{schemas}{tag}{properties}{$prop}{type}, 'string', "tag $prop is string type in v4");
    is($json{v5}{components}{schemas}{tag}{properties}{$prop}{type}, 'integer', "tag $prop is integer type in v5");
}

# template
is($json{v4}{components}{schemas}{template}{properties}{contentType}{properties}{id}{type}, 'string', "template contentType/id is string type in v4");
is($json{v5}{components}{schemas}{template}{properties}{contentType}{properties}{id}{type}, 'integer', "template contentType/id is integer type in v5");

done_testing;
