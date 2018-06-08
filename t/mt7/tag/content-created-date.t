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

use utf8;

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_id,
        );
        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            created_on      => '20170530183000',
        );
    }
);

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentCreatedDate
--- template
<mt:Contents content_type="test content data"><mt:ContentCreatedDate></mt:Contents>
--- expected
May 30, 2017  6:30 PM

=== MT::ContentCreatedDate with date formats
--- template
<mt:Contents content_type="test content data">
<mt:ContentCreatedDate format="%Y">
<mt:ContentCreatedDate format="%y">
<mt:ContentCreatedDate format="%b">
<mt:ContentCreatedDate format="%B">
<mt:ContentCreatedDate format="%m">
<mt:ContentCreatedDate format="%d">
<mt:ContentCreatedDate format="%e">
<mt:ContentCreatedDate format="%j">
<mt:ContentCreatedDate format="%H">
<mt:ContentCreatedDate format="%k">
<mt:ContentCreatedDate format="%I">
<mt:ContentCreatedDate format="%l">
<mt:ContentCreatedDate format="%M">
<mt:ContentCreatedDate format="%S">
<mt:ContentCreatedDate format="%p">
<mt:ContentCreatedDate format="%a">
<mt:ContentCreatedDate format="%A">
<mt:ContentCreatedDate format="%w">
<mt:ContentCreatedDate format="%x">
<mt:ContentCreatedDate format="%X">
<mt:ContentCreatedDate format_name="iso8601">
<mt:ContentCreatedDate format_name="rfc822">
<mt:ContentCreatedDate language="cz">
<mt:ContentCreatedDate language="dk">
<mt:ContentCreatedDate language="nl">
<mt:ContentCreatedDate language="en">
<mt:ContentCreatedDate language="fr">
<mt:ContentCreatedDate language="de">
<mt:ContentCreatedDate language="is">
<mt:ContentCreatedDate language="ja">
<mt:ContentCreatedDate language="it">
<mt:ContentCreatedDate language="no">
<mt:ContentCreatedDate language="pl">
<mt:ContentCreatedDate language="pt">
<mt:ContentCreatedDate language="si">
<mt:ContentCreatedDate language="es">
<mt:ContentCreatedDate language="fi">
<mt:ContentCreatedDate language="se">
<mt:ContentCreatedDate utc="1">
</mt:Contents>
--- expected
2017
17
May
May
05
30
30
150
18
18
06
 6
30
00
PM
Tue
Tuesday
2
May 30, 2017
 6:30 PM
2017-05-30T18:30:00+00:00
Tue, 30 May 2017 18:30:00 +0000
30. Kv&#283;ten 2017 18:30
30.05.2017 18:30
30 mei 2017 18:30
May 30, 2017  6:30 PM
30 mai 2017 18h30
30.05.17 18:30
30.05.17 18:30
2017年5月30日 18:30
30.05.17 18:30
Mai 30, 2017  6:30 EM
30 maja 2017 18:30
maio 30, 2017  6:30 PM
30.05.17 18:30
30 de Mayo 2017 a las 06:30 PM
30.05.17 18:30
maj 30, 2017  6:30 EM
May 30, 2017  6:30 PM

