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

$test_env->prepare_fixture('db_data');

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

for my $name (qw/asset blog cf content_type group log permission template templatemap user website/) {
    is($json{v4}{components}{schemas}{$name}{properties}{id}{type}, 'string', "$name id is string type in v4");
    is($json{v5}{components}{schemas}{$name}{properties}{id}{type}, 'integer', "$name id is integer type in v5");
}

# asset
is($json{v4}{components}{schemas}{asset}{properties}{parent}{type}, 'string', "asset parent is string type in v4");
is($json{v5}{components}{schemas}{asset}{properties}{parent}{type}, 'integer', "asset parent is integer type in v5");

# association
for my $prop (qw/user role/) {
    is($json{v4}{components}{schemas}{association}{properties}{$prop}{properties}{id}{type}, 'string', "association $prop/id is string type in v4");
    is($json{v5}{components}{schemas}{association}{properties}{$prop}{properties}{id}{type}, 'integer', "association $prop/id is integer type in v5");
}

# blog / website
for my $component (qw/blog website/) {
    for my $prop (qw/basenameLimit junkFolderExpiry junkScoreThreshold listOnIndex maxRevisionsEntry maxRevisionsTemplate smartReplace wordsInExcerpt/) {
        is($json{v4}{components}{schemas}{$component}{properties}{$prop}{type}, 'string', "$component $prop is string type in v4");
        is($json{v5}{components}{schemas}{$component}{properties}{$prop}{type}, 'integer', "$component $prop is integer type in v5");
    }
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
for my $prop (qw/author data/) {
    is($json{v4}{components}{schemas}{cd}{properties}{$prop}{properties}{id}{type}, 'string', "cd $prop/id is string type in v4");
    is($json{v5}{components}{schemas}{cd}{properties}{$prop}{properties}{id}{type}, 'integer', "cd $prop/id is integer type in v5");
}

# content_type
is($json{v4}{components}{schemas}{content_type}{properties}{contentFields}{items}{properties}{id}{type}, 'string', "content_type contentFields/items/id is string type in v4");
is($json{v5}{components}{schemas}{content_type}{properties}{contentFields}{items}{properties}{id}{type}, 'integer', "content_type contentFields/items/id is integer type in v5");

# group
for my $prop (qw/memberCount permissionCount/) {
    is($json{v4}{components}{schemas}{group}{properties}{$prop}{type}, 'string', "group $prop is string type in v4");
    is($json{v5}{components}{schemas}{group}{properties}{$prop}{type}, 'integer', "group $prop is integer type in v5");
}

done_testing;
