<?php
include_once("php/mt.php");
include_once("php/lib/MTUtil.php");
require "t/lib/JSON.php";

$cfg_file = $_SERVER['HOME'] . '/mysql-test.cfg';

$const = array(
    'CFG_FILE' => $cfg_file,
    'VERSION_ID' => VERSION,
    'CURRENT_WORKING_DIRECTORY' => '',
    'STATIC_CONSTANT' => '',
    'DYNAMIC_CONSTANT' => '1',
);

$output_results = 0;

$mt = new MT(1, $cfg_file);
$ctx =& $mt->context();

$path = $mt->config['MTDir'];
if (substr($path, strlen($path) - 1, 1) == '/')
    $path = substr($path, 1, strlen($path)-1); 
$const['CURRENT_WORKING_DIRECTORY'] = $path;

$ctx->add_global_filter('rot13', 'smarty_modifier_rot13');

$db = $mt->db();
$ctx->mt->db = &$db;
$ctx->stash('blog_id', 1);
$blog = $db->fetch_blog(1);
$ctx->stash('blog', $blog);
$ctx->stash('current_timestamp', '20040816135142');
$mt->init_plugins();

# entry we want to capture is dated: 19780131074500
#$tsdiff = time - offset_time(datetime_to_timestamp('19780131074500'), $blog);
#$daysdiff = intval($tsdiff / (60 * 60 * 24));
$daysdiff = 10240;

$const['DAYS_CONSTANT1'] = $daysdiff + 1;
$const['DAYS_CONSTANT2'] = $daysdiff - 1;

$entry = $db->fetch_entry(1);

$suite = load_tests();

$test_num = 0;
run($ctx, $suite);

function run(&$ctx, $suite) {
    global $test_num;
    global $entry;
    global $mt;
    global $tmpl;
    foreach ($suite as $test_item) {
        $mt->db->savedqueries = array();
        if (preg_match('/MT(Entry|Link)/', $test_item->t)) {
            $ctx->stash('entry', $entry);
        } else {
            $ctx->__stash['entry'] = null;
        }
        $test_num++;
        $tmpl = $test_item->t;
        $result = build($ctx, $test_item->t);
        if ($output_results) {
            echo("'".$result. "'\n");
        }
        ok($result, $test_item->e);
    }
}

function load_tests() {
    $suite = cleanup(file_get_contents('t/test-templates.dat'));
    $json = new JSON();
    global $const;
    foreach ($const as $c => $r) {
        $suite = preg_replace('/' . $c . '/', $r, $suite);
    }
    $suite = $json->decode($suite);
    return $suite;
}

function cleanup($tmpl) {
    # Translating perl array/hash structures to PHP...
    # This is not a general solution... it's custom built for our input.
    $tmpl = preg_replace('/^ *#.*$/m', '', $tmpl);
    $tmpl = preg_replace('/# *\d+ *(?:TBD.*)? *$/m', '', $tmpl);
    #$tmpl = preg_replace('/^\s*\[\s*/s', 'array(', $tmpl);
    #$tmpl = preg_replace('/\]\s*$/s', ')', $tmpl);
    #$tmpl = preg_replace('/{\s*"t"\s*:(.+?),\s*"e"\s*:(.+?)\s*}/s', 'array("t"=>\1, "e" => \2)', $tmpl);
    return $tmpl;
}

function build(&$ctx, $tmpl) {
    if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
        ob_start();
        $ctx->_eval('?>' . $_var_compiled);
        $_contents = ob_get_contents();
        ob_end_clean();
        return $_contents;
    } else {
        return $ctx->error("Error compiling template module '$module'");
    }
}

function ok($str, $that) {
    global $test_num;
    global $mt;
    global $tmpl;
    $str = trim($str);
    $that = trim($that);
    if ($str === $that) {
        #echo "test #$test_num succeeded\n";
        return true;
    } else {
        echo "test #$test_num failed\n";
        echo "\texpression: $tmpl\n";
        echo "\texpected: $that\n";
        echo "\tgot: $str\n";
        echo "\tqueries:\n";
        foreach ($mt->db->savedqueries as $q) {
            echo "$q\n";
        }
        return false;
    }
}

function smarty_modifier_rot13($s) {
    return strtr($s, 
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM'
    );
}
?>
