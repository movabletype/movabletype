function is_valid_path(path_){
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

function cancelCustom() {
    // Show Upload Destination selectbox and select first option.
    var $select = jQuery('select#destination, select#upload_destination');
    $select
        .removeAttr('disabled')
        .removeClass('hidden')
        .val(
            $select.children(':first').val()
        );

    // Hide custom Upload Destination textbox and remove its value.
    jQuery('input#upload_destination_custom')
        .attr('disabled', 'disabled')
        .addClass('hidden')
        .val('');

    // Hide cancel button.
    jQuery('button#cancel_custom')
        .attr('disabled', 'disabled')
        .addClass('hidden');

    // Show extra path textbox.
    jQuery('.upload-extra-path')
        .removeAttr('disabled')
        .removeClass('hidden');
}

function uploadDestinationSelect(sel) {
    var edit = getByID('upload_destination_custom');
    var map  = sel.options[sel.selectedIndex].value;
    if (map == '') {
        // Hide and disable Upload Destination selectbox.
        DOM.addClassName(sel, 'hidden');
        sel.setAttribute('disabled', 'disabled');

        // Show and enable custom Upload Destination textbox.
        DOM.removeClassName(edit, 'hidden');
        edit.removeAttribute('disabled');
        edit.focus();

        // Set first option's value to custom Upload Destination textbox.
        jQuery(edit).val(
            jQuery(sel).children(':first').val()
        );

        // Show cancel button.
        jQuery(edit).after(
            jQuery('button#cancel_custom')
                .removeClass('hidden')
                .removeAttr('disabled')
        );

        // Hide extra path textbox.
        jQuery('.upload-extra-path')
            .attr('disabled', 'disabled')
            .addClass('hidden');

        // Add slash and the value in extra path textbox to custom Upload Destination textbox
        // if extra path textbox has value.
        var $input_extra_path = jQuery('.upload-extra-path > input');
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
        '.upload-destination': function($e) {
            return /^%(s|a)/.test($e.val());
        }
    });
    jQuery.mtValidateAddMessages({
        '.valid-path': trans('You must set a valid path.'),
        '.upload-destination': trans('You must set a path begining with %s or %a.')
    });
});

