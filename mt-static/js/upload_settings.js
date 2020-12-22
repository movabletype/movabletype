function is_valid_path(path_, custom){
    if (!path_.match(/^[^<>#"\{\}\|\^\[\]\`\;\?\:\@\&\=\+\$\,\*]*$/)) {
        return false;
    }
    if (!path_.match(/^[^%]*$/)) {
        if (custom) {
            if (path_.match(/.*%$/)) {
                return false;
            }
            var matches = path_.match(/%./g);
            var invalid_variable = 0;
            jQuery.each(matches, function(index, variable) {
                if (!variable.match(/%s|%a|%u|%y|%m|%d/)) {
                    invalid_variable++;
                } else if (variable.match(/%s|%a/) && index > 0) {
                    invalid_variable++;
                }
            });
            if (invalid_variable) {
                return false;
            }
        } else {
            return false;
        }
    }
    var dir_separator = jQuery('input[name=dir_separator]').val();
    if (dir_separator === "/" && !path_.match(/^[^\\]*$/)) {
        return false;
    }
    var str = path_.replace(/[ "%<>\[\\\]\^`{\|}~$\+,\/:;=\?@]/g, "");
    str = encodeURIComponent(str);
    if (str.indexOf('%') != -1) {
        return false;
    }
    if (str.match(/\.\./)) {
        return false;
    }
    return true;
}

function uploadDestinationSelect(sel) {
    var edit = MT.Util.getByID('upload_destination_custom');
    var map  = sel.options[sel.selectedIndex].value;
    if (map == '') {
        // Hide and disable Upload Destination selectbox.
        jQuery(sel).hide();
        sel.setAttribute('disabled', 'disabled');

        // Show and enable custom Upload Destination textbox.
        jQuery(edit).show();
        edit.removeAttribute('disabled');
        edit.focus();

        // Set first option's value to custom Upload Destination textbox.
        jQuery(edit).val(
            jQuery(sel).children(':first').val()
        );

        // Hide extra path textbox.
        jQuery('.upload-extra-path').hide();

        // Add slash and the value in extra path textbox to custom Upload Destination textbox
        // if extra path textbox has value.
        var $input_extra_path = jQuery('.upload-extra-path input');
        if ($input_extra_path.val() !== '') {
            jQuery(edit).val(
                jQuery(edit).val() + '/' + $input_extra_path.val()
            );
            // Remove the value in extra path textbox.
            $input_extra_path.val('');
        }
    }
}

jQuery(function() {
    jQuery.mtValidateAddRules({
        '.valid-path': function($e) {
            return is_valid_path($e.val());
        },
        '.valid-custom-path': function($e) {
            return is_valid_path($e.val(), 1);
        },
        '.upload-destination': function($e) {
            return /^%(s|a)/.test($e.val());
        }
    });
    jQuery.mtValidateAddMessages({
        '.valid-path': trans('You must set a valid path.'),
        '.valid-custom-path': trans('You must set a valid path.'),
        '.upload-destination': trans('You must set a path beginning with %s or %a.')
    });
});
