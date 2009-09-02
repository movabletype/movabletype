<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: modifier.encode_sha1.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_modifier_encode_sha1($text) {
    return sha1($text);
}
?>
