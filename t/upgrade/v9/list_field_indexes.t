use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

# create test data
my $ct      = MT::Test::Permission->make_content_type;
my $cf_list = MT::Test::Permission->make_content_field(
    content_type_id => $ct->id,
    type            => 'list',
    description     => '',        # empty string
);
$ct->fields([{
    id      => $cf_list->id,
    options => {
        description => '',               # empty string
        display     => 'default',
        label       => $cf_list->name,
        required    => '0',
    },
    order      => '1',
    type       => 'list',
    type_label => 'List',
    unique_id  => $cf_list->unique_id,
}]);
$ct->save or die $ct->errstr;

my @list_field_data = ('foo', 'bar', 'baz', 'a' x 256);

my $cd = MT::Test::Permission->make_content_data(
    content_type_id => $ct->id,
    label           => 'content data',
);
$cd->data({ $cf_list->id => \@list_field_data });
$cd->save or die $cd->errstr;

my %check_target_data = map { $_ => 1 } @list_field_data;
my @cf_idx_list       = MT->model('content_field_index')->load({
    content_data_id => $cd->id,
});
die unless scalar @cf_idx_list == scalar @list_field_data;    # check data count

# restore data before migrated
for my $cf_idx (@cf_idx_list) {
    die unless $cf_idx->value_text && !defined $cf_idx->value_varchar;    # check migrated data
    die unless $check_target_data{ $cf_idx->value_text }--;               # check target data

    if ($cf_idx->value_text eq 'a' x 256) {
        $cf_idx->value_varchar('a' x 255);
    } else {
        $cf_idx->value_varchar($cf_idx->value_text);
    }
    $cf_idx->value_text(undef);
    $cf_idx->save or die $cf_idx->errstr;
}
die if grep { $_ } values %check_target_data;    # check restored all data

subtest 'Migrate list field indexes' => sub {
    MT::Test::Upgrade->upgrade(from => 8.9993);

    %check_target_data = map { $_ => 1 } @list_field_data;
    my @cf_idx_migrated = MT->model('content_field_index')->load({
        content_data_id => $cd->id,
    });
    for my $cf_idx (@cf_idx_migrated) {
        ok $check_target_data{ $cf_idx->value_text }--, 'migrated list field index data: ' . $cf_idx->value_text;
        is $cf_idx->value_varchar, undef, 'removed old data in value_vachar';
    }
    ok !(grep { $_ } values %check_target_data), 'migrated all list field index data';
};

done_testing;
