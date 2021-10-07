use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        CaptchaSourceImageBase => $ENV{MT_TEST_ROOT} || '/tmp',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

$test_env->prepare_fixture('db');

my $blog = MT::Blog->load(1);
$blog->captcha_provider('mt_default');
$blog->save;

MT::Test::Tag->run_perl_tests(1);
MT::Test::Tag->run_php_tests(1);

done_testing;

__DATA__

=== test 1
--- template
<mt:CaptchaFields>
--- expected regexp
<input type="hidden" name="token" value="[^"]{40}" />
