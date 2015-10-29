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

        // Hide extra path textbox.
        jQuery('.upload-extra-path').addClass('hidden');

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
        '.upload-destination': function($e) {
            return /^%(s|a)/.test($e.val());
        }
    });
    jQuery.mtValidateAddMessages({
        '.upload-destination': trans('You must set a string starting %s or %a.')
    });
});

