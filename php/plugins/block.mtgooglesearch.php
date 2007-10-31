<?php
function smarty_block_mtgooglesearch($args, $content, &$ctx, &$repeat) {
    $localvars = array('google_result_item', 'google_results', '_result_count');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $counter = 0;
    }else{
        $counter = $ctx->stash('_result_count');
    }

    $google_results = $ctx->stash('google_results');
    if (!isset($google_results)){
        # required: SOAP/Client package
        require_once("SOAP" . DIRECTORY_SEPARATOR . "Client.php");

        $entry = $ctx->stash('entry');
        $blog = $ctx->stash('blog');

        // Google search query
        if ($args['related']) {
            $url = $args['related'];
            $query = 'related:'.($url == '1' ? $blog->site_url : $url);
        } elseif ($args['title']) {
            $query = $entry['entry_title'];
        } elseif ($args['excerpt']) {
            $query = smarty_function_mtentryexcerpt(array(), $ctx);
        } elseif ($args['keywords']) {
            $query = $entry['entry_keywords'];
        } elseif ($args['tags']) {
            $query = "";
            $tags = $ctx->mt->db->fetch_entry_tags(array('entry_id' => $entry['entry_id'], 'blog_id' => $blog->id));
            if (isset($tags)) {
                foreach($tags as $tag) {
                    $query .= '"'.$tag['tag_name'].'" ';
                }
            }
        } else {
            $query = $args['query'];
        }

        if ($query == '') {
            $query = $entry['entry_title'];
        }

        global $mt;
        $lang = $mt->config('DefaultLanguage');
        if ($lang == 'ja') {
            $charset = $mt->config('PublishCharset');
            $query = mb_convert_encoding($query, 'utf-8', $charset);
        }

        $max = $args['results'] ? $args['results'] : 10;
        $lang = $args['lang'];
        if (!isset($lang)){
            $lang ='lang_en';
        }

        // Your google license key
        $key = $blog['blog_google_api_key'];
        if (!$key) {
            $config = $ctx->mt->db->fetch_plugin_config('Google Search');
            if ($config) {
                $key = $config['google_api_key'];
            }
            else {
                return $ctx->error('You need a Google API key to use &lt;mtgooglesearch>');
            }
        }

        $wsdl = new SOAP_WSDL($mt->config('PHPDir').DIRECTORY_SEPARATOR."plugins".DIRECTORY_SEPARATOR."GoogleSearch.wsdl");
        $proxy = $wsdl->getProxy();
        $result = $proxy->doGoogleSearch(
                    $key,
                    $query,
                    0,
                    intval($max),
                    false,
                    "",
                    false,
                    $lang,
                    "utf-8",
                    "utf-8"
                    );

        // Is result a PEAR_Error?
        if (get_class($result) == 'pear_error' || get_class($result) == 'soap_fault') {
            $message = $result->message;
            $output = "An error occured: $message<p>";
            print('error:'.$output);
        } else {
            // We have proper search results
            if ($result->resultElements) {
                foreach ($result->resultElements as $index => $item) {
                    $summary = $item->summary;
                    $url = $item->URL;
                    $snippet = $item->snippet;
                    $title = $item->title;
                
                    $set = array(
                        'summary' => $summary,
                        'URL' => $url,
                        'snippet' => $snippet,
                        'title' => $title
                    );
                
                    $google_results[] = $set;
                }
            }
            $ctx->stash('google_results', $google_results);
        }
    }
    
    if ($counter < count($google_results)){
        $google_result_item = $google_results[$counter];
        $ctx->stash('google_result_item', $google_result_item);
        $ctx->stash('_result_count', $counter + 1);
        $repeat = true;
    }else{
        $ctx->restore($localvars);
        $repeat = false;
    }

    return $content;
}
?>
