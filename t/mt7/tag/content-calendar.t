#!/usr/bin/perl

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

use MT::Test::Tag;

plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture('db');

my @ts = MT::Util::offset_time_list( time, $blog_id );
my $this_month = sprintf "%04d%02d", $ts[5] + 1900, $ts[4] + 1;
my $next_month = sprintf "%04d%02d", $ts[5] + 1900, $ts[4] + 2;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content data',
    blog_id => $blog_id,
);
my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'date and time',
    type            => 'date_and_time',
);
my $category_set = MT::Test::Permission->make_category_set(
    blog_id => $ct->blog_id,
    name    => 'test category set',
);
my $cf_category = MT::Test::Permission->make_content_field(
    blog_id            => $ct->blog_id,
    content_type_id    => $ct->id,
    name               => 'categories',
    type               => 'categories',
    related_cat_set_id => $category_set->id,
);
my $category1 = MT::Test::Permission->make_category(
    blog_id         => $category_set->blog_id,
    category_set_id => $category_set->id,
    label           => 'category1',
);
my $category2 = MT::Test::Permission->make_category(
    blog_id         => $category_set->blog_id,
    category_set_id => $category_set->id,
    label           => 'category2',
);
my $fields = [
    {   id        => $cf_datetime->id,
        order     => 1,
        type      => $cf_datetime->type,
        options   => { label => $cf_datetime->name },
        unique_id => $cf_datetime->unique_id,
    },
    {   id      => $cf_category->id,
        order   => 2,
        type    => $cf_category->type,
        options => {
            label        => $cf_category->name,
            category_set => $category_set->id,
            multiple     => 1,
            max          => 5,
            min          => 1,
        },
    },
];
$ct->fields($fields);
$ct->save or die $ct->errstr;
my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    authored_on     => '20170602000000',
);
my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    authored_on     => '20170629000000',
    data => { $cf_category->id => [ $category2->id, $category1->id ], },
);
my $cd3 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    authored_on     => $next_month . '15000000',
    data            => { $cf_datetime->id => $this_month . '03180500', },
);

$vars->{ct_uid}  = $ct->unique_id;
$vars->{ct_name} = $ct->name;
$vars->{ct_id}   = $ct->id;

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentCalendar with content type unique_id
--- template
<mt:ContentCalendar month="201706" content_type="[% ct_uid %]">
<mt:CalendarIfNoContents><mt:CalendarDay></mt:CalendarIfNoContents></mt:ContentCalendar>
--- expected
1

3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28

30

=== MT::ContentCalendar with content type name
--- template
<mt:ContentCalendar month="201706" content_type="[% ct_name %]">
<mt:CalendarIfNoContents><mt:CalendarDay></mt:CalendarIfNoContents></mt:ContentCalendar>
--- expected
1

3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28

30

=== MT::ContentCalendar with content type id
--- template
<mt:ContentCalendar month="201706" content_type="[% ct_id %]">
<mt:CalendarIfNoContents><mt:CalendarDay></mt:CalendarIfNoContents></mt:ContentCalendar>
--- expected
1

3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28

30

=== MT::ContentCalendar with month="next"
--- template
<mt:ContentCalendar month="next" content_type="test content data">
<mt:CalendarIfContents><mt:CalendarDay></mt:CalendarIfContents></mt:ContentCalendar>
--- expected
15


=== MT::ContentCalendar with date_field
--- template
<mt:ContentCalendar date_field="date and time" content_type="test content data">
<mt:CalendarIfContents><mt:CalendarDay></mt:CalendarIfContents></mt:ContentCalendar>
--- expected
3


=== MT::ContentCalendar with category_set
--- template
<mt:ContentCalendar month="201706" content_type="test content data" category_set="test category set">
<mt:CalendarIfNoContents><mt:CalendarDay></mt:CalendarIfNoContents></mt:ContentCalendar>
--- expected
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28

30

