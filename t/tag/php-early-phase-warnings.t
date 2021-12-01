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

$ENV{EXTENDED_TESTING} or plan skip_all => 'set EXTENDED_TESTING=1 to enable this test';

use MT::Test::PHP;

$test_env->prepare_fixture('db');

subtest 'no warnings on early phase' => sub {
    my $blog_id   = 1;
    my $mt_home   = $ENV{MT_HOME} ? $ENV{MT_HOME} : '.';
    my $mt_config = MT->instance->find_config;
    my $php  = <<EOF;
    <?php
    \$MT_HOME   = '$mt_home';
    \$MT_CONFIG = '$mt_config';
    \$blog_id   = '$blog_id';
EOF
    $php .= <<'EOF';
    include_once($MT_HOME . '/php/mt.php');
    include_once($MT_HOME . '/php/lib/MTUtil.php');
    $prev = set_error_handler(function($errno, $errstr, $errfile, $errline, $errorvars = null) {
        if (preg_match('/include_once/', $errstr)) {
            return false;
        }
        $stderr = fopen('php://stderr', 'w');
        fwrite($stderr, "no:$errno error:$errstr file:$errfile line:$errline\n");
        return true;
    });
    $mt = MT::get_instance($blog_id, $MT_CONFIG);
    $mt->init_plugins();
    $db = $mt->db();
    $ctx =& $mt->context();
    $blog = $db->fetch_blog($blog_id);
    $ctx->stash('blog', $blog);
EOF

    my $ret = MT::Test::PHP->run($php, \my $error_log);

    is $error_log, '', 'no warnings';
};

done_testing;
