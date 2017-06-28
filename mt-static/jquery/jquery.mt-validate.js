;(function ($) {
/*
 * mtValidate
 *
 * Usage:
 *   jQuery('.input').mtValidate();
 *   jQuery('.msg').mtValidate({: true});
 *
 */

var mtValidators = {};

$.mtValidator = function ( ns, options ) {
    if ( this instanceof $.mtValidator ) {
        // called as constructor
        var obj = mtValidators[ns] || this;
        if ( !options ) {
            return obj;
        }
        $.extend( obj, options );
        obj.namespace = ns;
        return mtValidators[ns] = obj;
    }
    else {
        // called as function
        if ( typeof ns == 'object' ) {
            options = ns;
            ns = 'default';
        }
        if ( !ns ) {
            ns = 'default';
        }
        if ( !options && mtValidators[ns] ) {
            return mtValidators[ns];
        }
        return new $.mtValidator(ns, options);
    }
};

$.extend( $.mtValidator.prototype, {
    options: {},
    validateElement: function ( $elem, additionalRules ) {
        var validator  = this, rules;
        if ( undefined === additionalRules ) additionalRules = {};
        rules = $.extend( {}, $.mtValidateRules, additionalRules );
        validator.error  = false;
        validator.errstr = undefined;
        $.each ( rules, function( selector, fn ) {
            if ( $elem.is(selector) ) {
                validator.error  = false;
                validator.errstr = undefined;
                var res = fn.apply(validator, [$elem]);
                if ( validator.error || !res ) {
                    if ( !validator.errstr ) {
                        validator.raise(
                            $.mtValidateMessages['#' + $elem.attr('id') + selector]
                            || $.mtValidateMessages[selector]
                            || 'Invalid value'
                        );
                    }
                    return false;
                }
            }
        });
        return !validator.error;
    },
    raise: function (msg) {
        this.error  = true;
        this.errstr = msg || trans('Invalid value');
        return false;
    },
    validClass: 'valid',
    errorClass: 'error',
    doFocus: true,
    wrapError: function ( $target, msg ) {
        return $('<label/>')
            .attr('for', $target.attr('id') )
            .addClass('validate-error msg-error')
            .text(msg);
    },
    updateError: function( $target, $error_block, msg ) {
        $error_block.text(msg);
    },
    showError: function ( $target, $error_block ) {
        $target.after($error_block);
    },
    removeError: function( $target, $error_block ) {
        $error_block.remove();
    }
});

// Install default validators.
$.mtValidator('top', {
    wrapError: function ( $target, msg ) {
        return $('<li />').append(
            $('<label/>')
                .attr('for', $target.attr('id') )
                .text(msg)
            );
    },
    showError: function( $target, $error_block ) {
        if ( $('div#msg-block').text() == 0 ) {
            var $block = $('<div/>')
                .addClass('msg msg-error')
                .append( $('<p>').text( trans('You have an error in your input.') ) )
                .append( $('<ul />') );

            $('div#msg-block').append( $block );
        }
        $('div#msg-block ul').append($error_block);
    },
    removeError: function( $target, $error_block ) {
        $error_block.remove();
        if ( $('div#msg-block ul li').length === 0 ) {
            $('div#msg-block').text('');
        }
    },
    updateError: function( $target, $error_block, msg ) {
        $error_block.find('label').text(msg);
    }
});
$.mtValidator('simple', {
    wrapError: function ( $target, msg ) {
        $target.parent().addClass('has-error');
        return $('<div />').append(
            $('<label/>')
                .attr('for', $target.attr('id') )
                .addClass('validate-error msg-error text-danger')
                .text(msg)
            );
    },
    removeError: function ( $target, $error_block ) {
        $error_block.remove();
        $target.parent().removeClass('has-error');
    },
    updateError: function( $target, $error_block, msg ) {
        $error_block.find('label.msg-error').text(msg);
    }
});
$.mtValidator('simple-group', {
    removeError: function ( $target, $error_block ) {
        var $container = $target.parents('.group-container');
        var groupInputs = $container.find('.group').toArray();
        var invalidInputs = jQuery.grep(groupInputs, function (input) {
            if (input.getAttribute('id') === $target.attr('id')) {
                return false;
            }
            return $.data( input, 'mtValidateError' );
        });
        if ($target.is('input[type=radio],input[type=checkbox]')) {
            $container.siblings('.group-error').remove();
            invalidInputs.forEach(function (input) {
                $.data( input, 'mtValidateError', null );
                $.data( input, 'mtValidateLastError', null );
                $(input).addClass( this.validClass );
                $(input).removeClass( this.errorClass );
            });
        } else {
            if (invalidInputs.length === 0) {
                $container.siblings('.group-error').remove();
            } else {
                var error = $.data( invalidInputs[0], 'mtValidateLastError' );
                $container.siblings('.group-error')
                    .find('label.msg-error')
                    .text(error);
            }
        }
    },
    updateError: function( $target, $error_block, msg ) {
        $target.parents('.group-container')
            .siblings('.group-error')
            .find('label.msg-error')
            .text(msg);
    },
    showError: function( $target, $error_block ) {
        var $container = $target.parents('.group-container');
        if ($container.siblings('.group-error').length === 0) {
            $container.after($error_block);
        }
        if ($target.is('input[type=radio],input[type=checkbox]')) {
            var groupInputs = $container.find('.group').toArray();
            groupInputs.forEach(function (input) {
                $.data( input, 'mtValidateError', $error_block );
            });
        }
    },
    wrapError: function ( $target, msg ) {
        return $('<div />')
            .addClass('group-error')
            .append(
                $('<label/>')
                    .attr('for', $target.attr('id') )
                    .addClass('validate-error msg-error')
                    .text(msg)
            );
    }
});
$.mtValidator('simple2', {
    wrapError: function ( $target, msg ) {
        return $('<li />').append(
            $('<label/>')
                .attr('for', $target.attr('id') )
                .text(msg)
            );
    },
    showError: function( $target, $error_block ) {
        var id = $target.parents('div.field-content').first().parent().attr('id');
        var ins = true;
        if ( $('div#'+id+'-msg-block ul').length == 0 ) {
            var $block = $('<div/>')
                .addClass('validate-error msg-error')
                .append( $('<ul />') );

            $('div#'+id+'-msg-block').append( $block );
        } else {
            $('div#'+id+'-msg-block ul li').each( function() {
                var $this = $(this);
                var msg = $error_block.text();
                if ( $this.text() === msg ) ins = false;
            });

        }
        if ( ins ) {
            $('div#'+id+'-msg-block ul').append($error_block);
            $('div#'+id+'-msg-block').show();
        }
    },
    removeError: function( $target, $error_block ) {
        var id = $target.parents().find('div.field-content').first().parent().attr('id');
        $error_block.remove();
        if ( $('div#'+id+'-msg-block ul li').length == 0 ) {
            $('div#'+id+'-msg-block').hide();
        }
    },
    updateError: function( $target, $error_block, msg ) {
        var id = $target.parents().find('div.field-content').first().parent().attr('id');
        var ins = true;
        $('div#'+id+'-msg-block ul li').each( function() {
            var $this = $(this);
            if ( $this.text() === msg ) ins = false;
        });
        if ( ins ) {
            $error_block.find('label').text(msg);
            this.showError( $target, $error_block );
        }
    }
});
jQuery.mtValidator('url_path_subdomain', {
    wrapError: function ( $target, msg ) {
        $target.parent().addClass('has-error');
        return jQuery('<div />').append(
            jQuery('<label/>')
                .attr('for', $target.attr('id') )
                .addClass('validate-error msg-error text-danger')
                .text(msg)
            );
    },
    showError: function ( $target, $error_block ) {
        var $container = $target.closest('.content-path');
        if ($container.find('label.msg-error').length) {
            $error_block.hide();
        }
        $container.append($error_block);
    },
    removeError: function( $target, $error_block ) {
        $error_block.remove();
        $target.closest('.content-path')
            .find('label.msg-error:hidden:first')
            .closest('div')
            .show();
        $target.parent().removeClass('has-error');
    },
    updateError: function( $target, $error_block, msg ) {
        $error_block.find('label.msg-error').text(msg);
    }
});
$.mtValidator('default', {
    wrapError: function ( $target, msg ) {
        return $('<label style="position: absolute;" />')
            .attr('for', $target.attr('id') || '')
            .addClass('msg-error msg-balloon validate-error')
            .text(msg);
    },
    showError: function( $target, $error_block ) {
        var focus = function () { $error_block.show(); },
            blur  = function () { $error_block.hide(); };
        jQuery.data( $target.get(0), 'validate_focus', focus );
        jQuery.data( $target.get(0), 'validate_blur',  blur );
        $target
            .bind('focus', focus)
            .bind('blur', blur);
        if ( $target.get(0) === document.activeElement )
            $error_block.show();
        else
            $error_block.hide();
        try {
            if ( !$target.parent('.validate-error-wrapper').length ) {
                $target
                    .wrap('<span class="validate-error-wrapper" style="position: relative; white-space: nowrap;"></span>');
            }
        }
        catch (e) {
            // Sometimes, we get error by "$.fn.wrap" in webkit.
            // But in that error, $target is already wrapped probably.
        }
        $target.after($error_block);
        $error_block
            .css('left', $target.width() )
            .css('top',   -1 * $target.height() )
            .css('z-index', 200);
    },
    removeError: function( $target, $error_block ) {
        $error_block.remove();
        var focus = jQuery.data( $target.get(0), 'validate_focus'),
            blur  = jQuery.data( $target.get(0), 'validate_blur');
        $target
            .unbind('focus', focus)
            .unbind('blur', blur);
    },
    doFocus: false
});

$.mtValidator('dialog', {
    wrapError: function ( $target, msg ) {
        return $('<label/>')
            .attr('for', $target.attr('id') )
            .addClass('msg msg-error dialog-msg-error')
            .text(msg);
    },
    showError: function( $target, $error_block ) {
        $target.parents('div.ui-dialog').find('div.dialog-msg-block').append($error_block);
    }
});

$.mtValidateRules = {
    '.date': function ($e) {
        return !$e.val() || /^\d{4}\-\d{2}\-\d{2}$/.test($e.val());
    },
    '.time': function ($e) {
        return !$e.val() || /^\d{2}:\d{2}:\d{2}$/.test($e.val());
    },

    // RegExp code taken from http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    '.email': function ($e) {
        return !$e.val() || /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test($e.val());
    },

    // RegExp code taken from http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    '.url': function ($e) {
        return !$e.val() || /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test($e.val());
    },

    '.url-field': function ($e) {
        return !$e.val() || /^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/.test($e.val());
    },

    '.required': function ($e) {
        return $e.val().length > 0;
    },
    '.digit, .num': function ($e) {
        return !$e.val() || /^\d+$/.test($e.val());
    },
    '.number': function ($e) {
        return !$e.val() || /\d/.test($e.val()) && /^\d*\.?\d*$/.test($e.val());
    },
    '.min-length': function ($e) {
        var minLength = Number($e.data('mt-min-length')) || 0;
        if ($e.val().length >= minLength) {
            return true;
        } else {
            this.error = true;
            this.errstr = $.mtValidateMessages['.min-length'].replace(/{{min}}/, minLength);
            return false;
        }
    },
    '.multiple-select': function ($e) {
        if (!$e.attr('multiple')) {
            return true;
        }
        var max = Number($e.data('mt-max-select')) || 0;
        var min = Number($e.data('mt-min-select')) || 0;
        if (!max && !min) {
            return true;
        }
        var selectedCount = $e.children('option:selected').length;
        if (max && max < selectedCount) {
            this.error = true;
            this.errstr = trans('Options less than or equal to [_1] must be selected', max);
            return false;
        } else if (min && min > selectedCount) {
            this.error = true;
            this.errstr = trans('Options greater than or equal to [_1] must be selected', min);
            return false;
        } else {
            return true;
        }
    },
    '.checkbox': function ($e) {
        var multiple = $e.data('mt-multiple') ? true : false;
        var max = Number($e.data('mt-max-select')) || 0;
        var min = Number($e.data('mt-min-select')) || 0;
        var required = $e.data('mt-required') ? true : false;
        var checkboxName = $e.attr('name');
        var checkedCount = $e.parents('.group-container')
            .find('input[name=' + checkboxName + ']:checked').length;
        if ( required && checkedCount === 0) {
            this.error = true;
            this.errstr = trans('Please select one of these options');
            return false;
        } else if ( !multiple && checkedCount > 1 ) {
            this.error = true;
            this.errstr = trans('Only 1 option can be selected');
            return false;
        } else if ( multiple && max && max < checkedCount ) {
            this.error = true;
            this.errstr = trans('Options less than or equal to [_1] must be selected', max);
            return false;
        } else if ( multiple && min && min > checkedCount ) {
            this.error = true;
            this.errstr = trans('Options greater than or equal to [_1] must be selected', min);
            return false;
        } else {
            return true;
        }
    },
    '.category': function ($e) {
        var $input = $e.parents('.group-container').find('[id^=category-ids-]');
        var multiple = $input.data('mt-multiple') ? true : false;
        var max = Number($input.data('mt-max-select')) || 0;
        var min = Number($input.data('mt-min-select')) || 0;
        var required = $input.data('mt-required') ? true : false;
        var checkedCats = $.grep( $input.val().split(','), function (catId) {
            return catId;
        } );
        var checkedCount = checkedCats.length;
        if ( required && checkedCount === 0) {
            this.error = true;
            this.errstr = trans('Please select one of these options');
            return false;
        } else if ( !multiple && checkedCount > 1 ) {
            this.error = true;
            this.errstr = trans('Only 1 option can be selected');
            return false;
        } else if ( multiple && max && max < checkedCount ) {
            this.error = true;
            this.errstr = trans('Options less than or equal to [_1] must be selected', max);
            return false;
        } else if ( multiple && min && min > checkedCount ) {
            this.error = true;
            this.errstr = trans('Options greater than or equal to [_1] must be selected', min);
            return false;
        } else {
            return true;
        }
    },
    'div.asset-field-container': function ($e) {
        var multiple = $e.data('mt-multiple') ? true : false;
        var max = Number($e.data('mt-max-select')) || 0;
        var min = Number($e.data('mt-min-select')) || 0;
        var required = $e.data('mt-required') ? true : false;
        var selectedCount = $e.find('li:not(.empty-asset-list)').length;
        if ( multiple && max && max < selectedCount ) {
            this.error = true;
            this.errstr = trans('Assets less than or equal to [_1] must be selected', max);
            return false;
        }
        if ( multiple && min && min > selectedCount ) {
            this.error = true;
            this.errstr = trans('Assets greater than or equal to [_1] must be selected', min);
            return false;
        }
        if ( !multiple && selectedCount > 1 ) {
            this.error = true;
            this.errstr = trans('Only 1 asset can be selected');
            return false;
        }
        if ( required && selectedCount === 0 ) {
            this.error = true;
            this.errstr = trans('This field is required');
            return false;
        }
        return true;
    },
    'div.content-type-field-container': function ($e) {
        var contentTypeName = $e.data('mt-content-type-name');
        var multiple = $e.data('mt-multiple') ? true : false;
        var max = Number($e.data('mt-max-select')) || 0;
        var min = Number($e.data('mt-min-select')) || 0;
        var required = $e.data('mt-required') ? true : false;
        var selectedCount = $e.find('li:not(.empty-content-data-list)').length;
        if ( multiple && max && max < selectedCount ) {
            this.error = true;
            this.errstr = trans('[_1] less than or equal to [_2] must be selected', contentTypeName, max);
            return false;
        }
        if ( multiple && min && min > selectedCount ) {
            this.error = true;
            this.errstr = trans('[_1] greater than or equal to [_2] must be selected', contentTypeName, min);
            return false;
        }
        if ( !multiple && selectedCount > 1 ) {
            this.error = true;
            this.errstr = trans('Only 1 [_1] can be selected', contentTypeName);
            return false;
        }
        if ( required && selectedCount === 0 ) {
            this.error = true;
            this.errstr = trans('This field is required');
            return false;
        }
        return true;
    },
    '.html5-form': function ($e) {
        if ($e.get(0).checkValidity()) {
            return true;
        } else {
            this.error = true;
            this.errstr = $e.get(0).validationMessage;
            return false;
        }
    },
    '.ss-validator': function ($e) {
        var contentFieldId = $e.data('mtContentFieldId');
        if (!contentFieldId) {
            return true;
        }
        if (window.ssValidateError && window.ssValidateError[contentFieldId]) {
            this.error = true;
            this.errstr = window.ssValidateError[contentFieldId];
            return false;
        } else {
            return true;
        }
    }
};

$.mtValidateAddRules = function ( rules ) {
    $.mtValidateRules = $.extend( $.mtValidateRules, rules );
};

$.mtValidateAddMessages = function ( rules ) {
    $.mtValidateMessages = $.extend( $.mtValidateMessages, rules );
};

$.mtValidateMessages = {
    '.date':        trans('Invalid date format'),
    '.time':        trans('Invalid time format'),
    '.email':       trans('Invalid email address'),
    '.url':         trans('Invalid URL'),
    '.url-field':   trans('Invalid URL'),
    '.required':    trans('This field is required'),
    '.digit, .num': trans('This field must be an integer'),
    '.number':      trans('This field must be a number'),
    '.min-length':  trans('Please input [_1] characters or more', '{{min}}')
};

$.fn.extend({
    mtValidate: function( ns, rules ) {
        if ( undefined === rules ) rules = {};
        this.each( function () {
            $.data( this, 'mtValidator', ns || 'default' );
            $.data( this, 'mtValidateRules', rules );
        });
        return this.mtValid();
    },
    mtValidator: function() {
        var ns = $.data( this.get(0), 'mtValidator' );
        return $.mtValidator(ns);
    },
    mtValid: function(opts) {
        var errors = 0,
            error_elements = [],
            successes = 0,
            defaults = { focus: true };
        opts = $.extend( defaults, opts );
        this.each( function () {
            var $this = $(this),
                validator = $this.mtValidator(),
                $current_error,rules,res,msg,last_error,$error_block;
            if ( !validator ) return true;
            if ( typeof $this.attr('data-showing-placeholder') !== 'undefined' ) {
                $this.val('');
            }
            var rules = $.data( this, 'mtValidateRules' );
            var res = validator.validateElement($this, rules);
            if ( res ) {
                var $current_error = $.data( this, 'mtValidateError' );
                successes++;
                if ( $current_error ) {
                    validator.removeError( $this, $current_error );
                }
                $.data( this, 'mtValidateError', null );
                $.data( this, 'mtValidateLastError', null );
                $this.addClass( validator.validClass );
                $this.removeClass( validator.errorClass );
            }
            else {
                var $current_error = $.data( this, 'mtValidateError' );
                errors++;
                if ( validator.doFocus ) {
                    error_elements.push($this);
                }
                msg = validator.errstr;
                if ( $current_error ) {
                    validator.updateError( $this, $current_error, msg );
                }
                else {
                    $error_block = validator.wrapError( $this, msg );
                    validator.showError( $this, $error_block );
                    $.data( this, 'mtValidateError', $error_block );
                    $.data( this, 'mtValidateLastError', msg );
                }
                $.data( this, 'mtValidateLastError', msg );
                $this.addClass( validator.errorClass );
                $this.removeClass( validator.validClass );
            }
        });
        if ( opts.focus && error_elements.length ) {
            error_elements[0].focus();
        }
        return errors == 0;
    },
    mtUnvalidate: function() {
        this.each( function () {
            var validator = $(this).mtValidator(),
                $current_error;
            if ( validator ) {
                $current_error = $.data( this, 'mtValidateError' );
                if ( $current_error ) {
                    validator.removeError( $(this), $current_error );
                }
                $.data( this, 'mtValidator', null );
                $.data( this, 'mtValidateError', null );
                $.data( this, 'mtValidateLastError', null );
                $(this).removeClass( validator.errorClass );
                $(this).removeClass( validator.validClass );
            }
        });
        return this;
    }
});

$(document).on('keyup change input', 'input, textarea', function () {
    var ns = $.data( this, 'mtValidator' );
    if ( !ns ) return true;
    $(this).mtValid({ focus: false });
});

$(document).on('focusin focusout','input:not([type=radio]):not(.group), textarea',function () {
    var ns = $.data( this, 'mtValidator' );
    if ( !ns ) return true;
    $(this).mtValid({ focus: false });
});

$(document).on('change','select',function () {
    var ns = $.data( this, 'mtValidator' );
    if ( !ns ) return true;
    $(this).mtValid({ focus: false });
});
})(jQuery);
