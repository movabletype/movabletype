<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtstaticwebpath.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_function_mtsupportdirectoryurl($args, &$ctx) {
    require_once "MTUtil.php";
    $url = support_directory_url();
    return $url;
}
