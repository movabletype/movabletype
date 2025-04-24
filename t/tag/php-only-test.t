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

use MT::Test::PHP;
use MT::Test::Tag;

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

subtest 'php only tag tests' => sub {
    MT::Test::Tag->run_php_tests(1);
};

done_testing;

__DATA__

=== raw smarty tag allowed
--- mt_config
{DynamicTemplateAllowPHP => 1, DynamicTemplateAllowSmartyTags => 1}
--- template
left:{{textformat}}123{{/textformat}}:right
--- expected
left:123:right

=== raw smarty php allowed
--- mt_config
{DynamicTemplateAllowPHP => 1}
--- template
left:{{php}} echo 'a'. 'b'{{/php}}:right
--- expected
left:ab:right

=== raw php tag allowed
--- mt_config
{DynamicTemplateAllowPHP => 1}
--- template
left:<?php echo 'a'. 'b'?>:right
--- expected
left:ab:right

=== test modifier in MTIf with AllowTestModifier=1
--- mt_config
{DynamicTemplateAllowPHP => 1, AllowTestModifier => 1}
--- template
[<mt:SetVar name="foo" value="1"><mt:If name="foo" test="1">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="0"><mt:If name="foo" test="1">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="1"><mt:If name="foo" test="0">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="0"><mt:If name="foo" test="0">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="5"><mt:If name="foo" test='$foo > 4'>true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="5"><mt:If name="foo" test='$foo < 4'>true<mt:else>false</mt:If>]
--- expected
[true][true][false][false][true][false]

=== test modifier with AllowTestModifier=0
--- mt_config
{DynamicTemplateAllowPHP => 1, AllowTestModifier => 0}
--- template
[<mt:SetVar name="foo" value="1"><mt:If name="foo" test="1">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="0"><mt:If name="foo" test="1">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="1"><mt:If name="foo" test="0">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="0"><mt:If name="foo" test="0">true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="5"><mt:If name="foo" test='$foo > 4'>true<mt:else>false</mt:If>]
[<mt:SetVar name="foo" value="5"><mt:If name="foo" test='$foo < 4'>true<mt:else>false</mt:If>]
--- expected
[true][false][true][false][true][true]

=== test modifier in MTElse with AllowTestModifier=1
--- mt_config
{DynamicTemplateAllowPHP => 1, AllowTestModifier => 1}
--- template
[<mt:SetVar name="foo" value="1"><mt:Unless name="foo" test="1">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="0"><mt:Unless name="foo" test="1">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="1"><mt:Unless name="foo" test="0">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="0"><mt:Unless name="foo" test="0">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="5"><mt:Unless name="foo" test='$foo > 4'>true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="5"><mt:Unless name="foo" test='$foo < 4'>true<mt:else>false</mt:Unless>]
--- expected
[false][false][true][true][false][true]

=== test modifier with AllowTestModifier=0
--- mt_config
{DynamicTemplateAllowPHP => 1, AllowTestModifier => 0}
--- template
[<mt:SetVar name="foo" value="1"><mt:Unless name="foo" test="1">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="0"><mt:Unless name="foo" test="1">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="1"><mt:Unless name="foo" test="0">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="0"><mt:Unless name="foo" test="0">true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="5"><mt:Unless name="foo" test='$foo > 4'>true<mt:else>false</mt:Unless>]
[<mt:SetVar name="foo" value="5"><mt:Unless name="foo" test='$foo < 4'>true<mt:else>false</mt:Unless>]
--- expected
[false][true][false][true][false][false]

=== legal smarty delimiters
--- mt_config
{DynamicTemplateAllowPHP => 1, DynamicTemplateAllowSmartyTags => 1}
--- template
<mt:SetVar name="foo" value="{{foo}}"><mt:Var name="foo">
--- expected
{{foo}}

=== legal smarty delimiters
--- mt_config
{DynamicTemplateAllowPHP => 1, DynamicTemplateAllowSmartyTags => 0}
--- template
{{}}<mt:SetVar name="foo" value="{{foo}}"><mt:Var name="foo">
--- expected
{{}}{{foo}}
