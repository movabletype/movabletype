use strict;
use warnings;

use Test::MockModule;
use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );
use MT::Test::Permission;

use MT::ContentData;
use MT::ListProperty;

my $content_type = MT::Test::Permission->make_content_type(
    blog_id => 1,
    name    => 'test content type',
);

my $content_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single text',
    type            => 'single_line_text',
);

my $fields = [
    {   id      => $content_field->id,
        order   => 1,
        type    => $content_field->type,
        options => {
            display  => 'force',
            hint     => '',
            label    => 1,
            required => 1,
        },
    }
];
$content_type->fields($fields);
$content_type->save or die $content_type->errstr;

SKIP: {
# https://github.com/movabletype/internal-movabletype/commit/16bd412baad05da4024e3900d98eb17d4203131c
    skip
        'temporarily. The cause in this commit: 16bd412baad05da4024e3900d98eb17d4203131c',
        1;

    subtest 'make_list_props' => sub {
        my $props = MT::ContentData::make_list_props();
        ok( $props && ref $props eq 'HASH',
            'make_list_properties returns hash'
        );
        MT->registry( 'list_properties', $props )
            ;    # registry will be updated after rebooting.
    };
}

done_testing;

