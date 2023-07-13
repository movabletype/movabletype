use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::ContentType;
use MT::Serialize;
use JSON;

my $json = JSON->new->pretty->canonical->utf8;

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare(
    {   blog => [
            {   name     => 'my_blog',
                theme_id => 'mont-blanc',
            }
        ],
        content_type => { ct => [ cf_text => 'single_line_text' ] },
    }
);

my $ct = $objs->{content_type}{ct}{content_type};
my $cf = $objs->{content_type}{ct}{content_field}{cf_text};

my $cf2 = MT->model('content_field')->new(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    description     => 'cf_text2',
    name            => 'cf_text2',
    type            => 'single_line_text',
);
$cf2->save;

sub _cmp_field {
    my ( $field, $cf ) = @_;
    for my $key (qw/id name type unique_id/) {
        is $field->{$key} => $cf->$key, $key;
    }
}

subtest 'fields: basic' => sub {
    ok !$ct->{__cached_fields}, "no cached fields";

    # cache
    ok my $fields = $ct->fields, "get fields";

    ok $ct->{__cached_fields}, "cached fields exists";

    is_deeply $fields => $ct->{__cached_fields},
        "cached fields matches fields";

    _cmp_field( $fields->[0], $cf );

    # clear cache
    $ct->save;

    ok !$ct->{__cached_fields}, "cache is gone";
};

subtest 'fields: rename ct' => sub {
    ok !$ct->{__cached_fields}, "no cached fields";

    # cache
    ok my $fields = $ct->fields, "get fields";

    ok $ct->{__cached_fields}, "cached fields exists";

    is_deeply $fields => $ct->{__cached_fields},
        "cached fields matches fields";

    _cmp_field( $fields->[0], $cf );

    # rename (but fields is not changed)
    $ct->name('ct2');

    # still cache works
    is_deeply $fields => $ct->{__cached_fields},
        "cached fields matches fields";

    _cmp_field( $fields->[0], $cf );

    # clear cache
    $ct->save;

    ok !$ct->{__cached_fields}, "cache is gone";
};

subtest 'fields: change fields' => sub {

    # new fields
    my $new_fields = [
        {   id        => $cf2->id,
            unique_id => $cf2->unique_id,
            type      => $cf2->type,
            name      => $cf2->name,
        }
    ];

    ok !$ct->{__cached_fields}, "no cached fields";

    # cache
    ok my $fields = $ct->fields, "get fields";

    ok $ct->{__cached_fields}, "cached fields exists";

    is_deeply $fields => $ct->{__cached_fields},
        "cached fields matches fields";

    _cmp_field( $fields->[0], $cf );

    # update fields
    $ct->fields($new_fields);

    # cache does not match
    isnt $json->encode( $ct->{__cached_fields} ) =>
        $json->encode($new_fields),
        "cached fields doesn't match fields";

    # but ->fields matches new_fields
    is_deeply $ct->fields => $new_fields,
        "cached fields doesn't match fields";

    _cmp_field( $ct->fields->[0], $cf2 );

    # clear cache
    $ct->save;

    ok !$ct->{__cached_fields}, "cache is gone";
};

subtest 'fields: change fields via column' => sub {

    # new fields
    my $new_fields = [
        {   id        => $cf->id,
            unique_id => $cf->unique_id,
            type      => $cf->type,
            name      => $cf->name,
        }
    ];

    ok !$ct->{__cached_fields}, "no cached fields";

    # cache
    ok my $fields = $ct->fields, "get fields";

    ok $ct->{__cached_fields}, "cached fields exists";

    is_deeply $fields => $ct->{__cached_fields},
        "cached fields matches fields";

    _cmp_field( $fields->[0], $cf2 );

    # update fields via column
    my $serializer        = MT::Serialize->new('MT');
    my $serialized_fields = $serializer->serialize( \$new_fields );
    $ct->column( fields => $serialized_fields );

    # cache does not match
    isnt $json->encode( $ct->{__cached_fields} ) =>
        $json->encode($new_fields),
        "cached fields doesn't match fields";

    # but ->fields matches new_fields
    is_deeply $ct->fields => $new_fields,
        "cached fields doesn't match fields";

    _cmp_field( $ct->fields->[0], $cf );

    # clear cache
    $ct->save;

    ok !$ct->{__cached_fields}, "cache is gone";
};

done_testing;
