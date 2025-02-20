<?php

use PHPUnit\Framework\TestCase;

require_once('captcha_lib.php');
require_once('Mockdata.php');

class MTViewTest extends TestCase {

    public function testSmartyForComparison() {
        // for understanding raw smarty tag behavior
        $ctx = new Smarty();
        $ctx->setLeftDelimiter('{{');
        $ctx->setRightDelimiter('}}');
        $tpl = $ctx->createTemplate('eval:{{assign var=foo value="hello" nocache}}{{assign var=bar value="{{$foo}}" nocache}}{{$bar}}');
        $this->assertEquals("hello", $ctx->fetch($tpl));
        $tpl = $ctx->createTemplate('eval:{{assign var=foo value="{{ldelim}}hello{{rdelim}}" nocache}}{{$foo}}');
        $this->assertEquals("{{hello}}", $ctx->fetch($tpl));
    }

    public function testIntermediateCode() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $template = '<mt:SetVar name="foo" value="bar"><mt:Var name="foo">';

        $expected = <<<'EOF'
{{push_ctx_stack mttag="mtsetvar" name="foo" value="bar"}}
{{mtsetvar name="foo" value="bar"}}
{{pop_ctx_stack}}
{{push_ctx_stack mttag="mtvar" name="foo"}}
{{mtvar name="foo"}}
{{pop_ctx_stack}}
EOF;
        $this->assertEquals($this->normaliseTemplate($expected), 
                                            $this->normaliseTemplate(smarty_prefilter_mt_to_smarty($template, $ctx)));

        $compiled = $ctx->fetch('eval:'. $template);
        $this->assertEquals("bar", $compiled);
    }

    public function testSmartyTags() {
        
        $mt = MT::get_instance();
        $ctx = $mt->context();
        $template = 'left:{{assign "foo" "bar"}}:middle:{{$foo}}:right';

        $mt->config('DynamicTemplateAllowSmartyTags', 1);
        $this->assertEquals($template, smarty_prefilter_mt_to_smarty($template, $ctx));

        $mt->config('DynamicTemplateAllowSmartyTags', 0);
        $this->assertEquals('left:{{ldelim}}assign "foo" "bar"{{rdelim}}:middle:{{ldelim}}$foo{{rdelim}}:right',
                                                                        smarty_prefilter_mt_to_smarty($template, $ctx));
    }

    public function testUnexceptedDelimiters() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $template = 'foo{{bar';

        $mt->config('DynamicTemplateAllowSmartyTags', 1);
        $this->assertEquals($template, smarty_prefilter_mt_to_smarty($template, $ctx));

        try {
            $compiled = $ctx->fetch('eval:'. $template);
        } catch (Exception $e) {
            $this->assertTrue(preg_match('/Unexpected /', $e->getMessage()) === 1);
        }

        $mt->config('DynamicTemplateAllowSmartyTags', 0);
        $this->assertEquals('foo{{ldelim}}bar', smarty_prefilter_mt_to_smarty($template, $ctx));
        $compiled = $ctx->fetch('eval:'. $template);
        $this->assertEquals($template, $compiled);
    }

    public function testDelimitersAreEscapedInModifierValues() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $template = 'left:<mt:SetVar name="foo" value="{{foo}}">:middle:<mt:Var name="foo">:right';

        foreach ([0, 1] as $config) {
            $mt->config('DynamicTemplateAllowSmartyTags', $config);
            $this->assertTrue(preg_match('/value="\{\{ldelim\}\}foo\{\{rdelim\}\}"/', 
                                                                    smarty_prefilter_mt_to_smarty($template, $ctx)) === 1);
            $compiled = $ctx->fetch('eval:'. $template);
            $this->assertEquals("left::middle:{{foo}}:right", $compiled);
        }
    }

    public function testIlligalDefun() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $template = <<<'EOF'
{{defun name="x x"}}{{/defun}}
EOF;

        $mt->config('DynamicTemplateAllowSmartyTags', 1);
        $this->assertEquals($template, smarty_prefilter_mt_to_smarty($template, $ctx));

        try {
            $compiled = $ctx->fetch('eval:'. $template);
        } catch (Exception $e) {
            $this->assertTrue(preg_match('/Illigal name for/', $e->getMessage()) === 1);
        }

        $mt->config('DynamicTemplateAllowSmartyTags', 0);
        $compiled = $ctx->fetch('eval:'. $template);
        $this->assertEquals($template, $compiled);
    }

    private function normaliseTemplate($template) {
        $template = preg_replace("/\r\n|\r|\n/", '', $template);
        $template = preg_replace("/\s\s+/", ' ', $template);
        return $template;
    }
}
