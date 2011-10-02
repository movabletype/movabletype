<?php
# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtpasswordvalidation($args, &$ctx) {
    $app =  $ctx->mt;

    $constrains = $app->config('UserPasswordValidation');
    $min_length = $app->config('UserPasswordMinLength');

    $vs = "\n";
    $vs .= <<< JSCRIPT
        function verify_password(username, passwd) {
          if (passwd.length < $min_length) {
            return "<__trans phrase="Password should be longer then [_1] characters" params="$min_length">";
          }
          if (passwd.indexOf(username) > -1) {
            return "<__trans phrase="Password should not include your user name">";
          }
JSCRIPT;

    if (strpos($constrains, "letternumber") === false) {
        $vs .= <<< JSCRIPT
            if ((passwd.search(/[a-zA-Z]/) == -1) || (passwd.search(/\d/) == -1)) {
              return "<__trans phrase="Password should include letters and numbers">";
            }
JSCRIPT;

    }
    if (strpos($constrains,  "upperlower") === false) {
        $vs .= <<< JSCRIPT
            if (( passwd.search(/[a-z]/) == -1) || (passwd.search(/[A-Z]/) == -1)) {
              return "<__trans phrase="Password should include lower and upper letters">";
            }
JSCRIPT;

    }
    if (strpos($constrains, "symbol") === false) {
        $vs .= <<< JSCRIPT
            if ( passwd.search(/[!"#$%&'\(\|\)\*\+,-\.\/\\:;<=>\?@\[\]^_`{}~]/) == -1 ) {
              return "<__trans phrase="Password should contain symbols like $!([{}])#">";
            }
JSCRIPT;

    }
    $vs .= <<< JSCRIPT
          return "";
        }
JSCRIPT;

    $vs .= <<< JSCRIPT
        function verify_form_password(eventObject) {
            var form = document.forms["$form_id"];
            var passwd = form["$pass_field"].value;
            if (passwd == null || passwd == "") {
                return true;
            }
            var username = form["$user_field"].value;
            var error = verify_password(username, passwd);
            if (error == "") {
                return true;
            }
            alert(error);
            if (eventObject.preventDefault) {
              eventObject.preventDefault();
            } else if (window.event) /* for ie */ {
              window.event.returnValue = false;
            }
            return false;
        }
        function verify_password_install() {
            var form = document.forms["$form_id"];
            if (form.addEventListener){                 
                    form.addEventListener('submit', verify_form_password, false); 
            } else if (form.attachEvent){                       
                    form.attachEvent('onsubmit', verify_form_password);
            }
        }
        if (window.addEventListener){   
            window.addEventListener('load', verify_password_install, false); 
        } else if (window.attachEvent){ 
            window.attachEvent('onload', verify_password_install );
        }
JSCRIPT;

    return $vs;

}

?>
