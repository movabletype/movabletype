<?php

ini_set("memory_limit", "-1");

$opts = getopt('', ['port:', 'mt_home:', 'mt_config:', 'log:', 'init_blog_id:', 'ignore_php_dynamic_properties_warnings:']);

$socket = stream_socket_server("tcp://127.0.0.1:". $opts['port']);

include_once($opts['mt_home'] . '/php/mt.php');
include_once($opts['mt_home'] . '/php/lib/MTUtil.php');
include_once($opts['mt_home'] . '/t/lib/MT/Test/Tag/error_handler.php');

$error_handler = new MT_Test_Error_Handler();
set_error_handler([$error_handler, 'handler']);
$error_handler->log = $opts['log'];
$error_handler->ignore_php_dynamic_properties_warnings = $opts['ignore_php_dynamic_properties_warnings'];

# fix following tests by using first blog_id for init.
# - t/tag/35-tags-assets.t
# - t/mt7/tag/archive/archive-type-label.t
$mt = MT::get_instance($opts['init_blog_id'], $opts['mt_config']);

$mt->init_plugins();
$db = $mt->db();
if (is_a($db, 'MTDatabaseoracle')) {
    $db->execute("ALTER SESSION SET TIME_ZONE = '+00:00'");
} else {
    $db->execute("SET time_zone = '+00:00'");
}
$ctx = $mt->context();

while ($remote = stream_socket_accept($socket)) {
    
    $stream = stream_get_contents($remote);
    if (!$stream) continue;

    // $mt->cache_driver()->flush_all();

    # fix t/mt7/tag/preferred_archive_type_and_permalink.t
    $db->flush_cache();

    # fix memcache test(t/tag/include-module-cache.t)
    $mt->clear_cache_driver();
    $_REQUEST = [];

    # fix tests with local config
    $mt->configure_from_db();

    list($blog_id, $tmpl, $extra, $log) = json_decode($stream);
    $error_handler->log = $log;
    $blog = $db->fetch_blog($blog_id);
    $ctx->stash('blog', $blog);
    $ctx->stash('blog_id', $blog_id);
    $ctx->stash('local_blog_id', $blog_id);
    $ctx->stash('index_archive', true);

    if (!empty($extra)) {
        try {
            eval($extra);
        } catch (Throwable $e) {
            fwrite($remote, $e->getMessage());
        }
    }

    try {
        $ctx->_compile_source('evaluated template', $tmpl, $_var_compiled);
        fwrite($remote, $_var_compiled);
    } catch (Throwable $e) {
        trigger_error("Error: ". $e->getMessage() ."\n" . $e->getTraceAsString());
    }

    fclose($remote);
}

fclose($socket);
