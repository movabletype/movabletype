<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtpasswordvalidation($args, &$ctx) {
    $app =  $ctx->mt;

    if (!isset($args['form'])) {
        return $ctx->error($ctx->mt->translate('You used an [_1] tag without a valid [_2] attribute.', array( "<MTPasswordValidation>", "form") ));
    }
    if (!isset($args['password'])) {
        return $ctx->error($ctx->mt->translate('You used an [_1] tag without a valid [_2] attribute.', array( "<MTPasswordValidation>", "password")));
    }
    if (!isset($args['username'])) {
        $args['username'] = "";
    }


    $form_id    = $args['form'];
    $pass_field = $args['password'];
    $user_field = $args['username'];

    $constrains = $app->config('UserPasswordValidation');
    $min_length = $app->config('UserPasswordMinLength');
    if (preg_match("/\D/", $min_length) || ($min_length < 1) ) {
        $min_length = 8;
    }

    isset($constrains)
         or $constrains = array();

    $vs = "\n";
    $vs .= <<< JSCRIPT
        function verify_password(username, passwd) {
          if (passwd.length < $min_length) {
              return "<__trans phrase="Password should be longer than [_1] characters" params="$min_length">";
          }
          if (username && (passwd.toLowerCase().indexOf(username.toLowerCase()) > -1)) {
              return "<__trans phrase="Password should not include your Username">";
          }
JSCRIPT;

    if (array_search("letternumber", $constrains) !== false) {
        $vs .= <<< JSCRIPT
            if ((passwd.search(/[a-zA-Z]/) == -1) || (passwd.search(/\d/) == -1)) {
                return "<__trans phrase="Password should include letters and numbers">";
            }
JSCRIPT;

    }
    if (array_search("upperlower", $constrains) !== false) {
        $vs .= <<< JSCRIPT
            if (( passwd.search(/[a-z]/) == -1) || (passwd.search(/[A-Z]/) == -1)) {
                return "<__trans phrase="Password should include lowercase and uppercase letters">";
            }
JSCRIPT;

    }
    if (array_search("symbol", $constrains) !== false) {
        $vs .= <<< JSCRIPT
            if ( passwd.search(/[!"#$%&'\(\|\)\*\+,-\.\/\\:;<=>\?@\[\]^_`{}~]/) == -1 ) {
                return "<__trans phrase="Password should contain symbols such as #!$%">";
            }
JSCRIPT;

    }
    $vs .= <<< JSCRIPT
          return "";
        }
JSCRIPT;

    $vs .= <<< JSCRIPT
        jQuery(document).ready(function() {
            jQuery("form#$form_id").on('submit', function(e){
                var form = jQuery(this);
                var passwd = form.find("input[name=$pass_field]").val();
                if (passwd == null || passwd == "") {
                    return true;
                }
                var username = "$user_field" ? form.find("input[name=$user_field]").val() : "";
                var error = verify_password(username, passwd);
                if (error == "") {
                    return true;
                }
                alert(error);
                e.preventDefault();
                return false;
            });
        });
JSCRIPT;

    return $vs;

}

?>
