/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

/*
 * mtAddEdgeClass
 *
 * Usage:
 *   jQuery.mtAddEdgeClass()
 *
 */
$.mtAddEdgeClass = function() {
    $('body *')
        .filter(':first-child').addClass('first-child')
        .end()
        .filter(':last-child').addClass('last-child');
};

/*
 * mtMenu
 *
 * Usage:
 *   jQuery.mtMenu();
 *
 */
$.mtMenu = function(options) {
    var defaults = {
        arrow_image: StaticURI+'images/arrow/arrow-toggle-big.png'
    },
    opts = $.extend(defaults, options);
    $('.top-menu > div a').after('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('.top-menu .toggle-button')
        .on('mousedown', function(event) {
            $(this).parents('li.top-menu').toggleClass('top-menu-open active');
            $(this).parents('li.top-menu').find('.sub-menu').toggle();
            return false;
        })
        .on('click', function(event) {
            return false;
        });
};


/*
 * mtSelector
 *
 * Usage:
 *   jQuery.mtSelector();
 *
 */
$.mtSelector = function(options) {
    var defaults = {
        arrow_image: StaticURI+'images/arrow/arrow-toggle-white.png'
    },
    opts = $.extend(defaults, options);
    $('#selector-nav').prepend('<a hre="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');

    $('#selector-nav .toggle-button ')
        .on('mousedown', function(event) {
            $(this).parent('#selector-nav').toggleClass('show-selector active');
            return false;
        })
        .on('click', function(event) {
            return false;
        });
    $(document).on('mousedown', function(event) {
        if ($(event.target).parents('#selector-nav').length === 0) {
            $('#selector-nav').removeClass('show-selector active');
        }
    });
    if (!$.support.style && !$.support.objectAll) {
        if ($.fn.bgiframe) $('div.selector').bgiframe();
    }
};

/*
 * mtUseSubdmain
 *
 * Usage:
 *   jQuery.mtUseSubdomain();
 *
 */
$.mtUseSubdomain = function(options) {
    var $checkboxes = $('.url-field :checkbox');
    $checkboxes.each(function() {
        if (!this.checked) {
            $(this).parents('.field-content').find('.subdomain').hide();
        }
    });
    $checkboxes.on('click', function() {
        var $subdomain, $subdomain_input;

        if (this.checked) {
            $subdomain =
                $(this).prop('checked',true).parents('.field-content').find('.subdomain').show();
        } else {
            $subdomain =
                $(this).prop('checked',false).parents('.field-content').find('.subdomain').hide();
        }

        $subdomain_input = $subdomain.find('input');
        if ($subdomain_input.val() && $subdomain_input.data('mtValidator')) {
            $subdomain_input.mtValid({ focus: false });
        }
    });
};

/*
 * mtEditSiteUrl
 *
 * Usage:
 *   jQuery.mtEditSiteUrl();
 *
 */
$.mtEditSiteUrl = function(options) {
    var defaults = {
        edit: 'Edit'
    },
    opts = $.extend(defaults, options),
    ids = ['site', 'archive'];
    $.each(ids, function() {
        var id = this,
            $subdomain = $('input#'+this+'_url_subdomain'),
            $path = $('input#'+this+'_url_path'),
            subdomain = $subdomain.val();
        if (subdomain) {
            $subdomain
                .parent('.subdomain')
                .before('<span class="'+this+'_url_subdomain-text path-text"></span>');
            $('span.'+this+'_url_subdomain-text').text($subdomain.val()+'.');
        }
        if (!$path.hasClass('show-input')) {
            $path
                .before('<span class="'+this+'_url_path-text path-text"></span>')
                .after('<button type="button" id="mt-set-'+this+'_url_path" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                .hide();
            $('span.'+this+'_url_path-text').text($path.val());
            $subdomain.parents('.field-content').find('.subdomain').hide();
            $subdomain.parents('.field-content').find('.use-subdomain').hide();
        } else {
            $subdomain.parents('.field-content').find('.subdomain').show();
            $subdomain.parents('.field-content').find('.use-subdomain').show();
        }
        if (subdomain && subdomain.match(/^http/)) {
            $subdomain.parents('.field-content').find('.use-subdomain').hide().end()
                .find('span.archive-url-domain').hide()
                .before('<span class="'+this+'_url_path-text path-text">'+$subdomain.val()+'</span>');
            if ($('button#mt-set-'+this+'_url_path').length === 0) {
                $path
                    .after('<button type="button" id="mt-set-'+this+'_url_path" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                    .hide();
            }
        }
        $('button#mt-set-'+this+'_url_path').on('click', function() {
            $(this).hide();
            $('span.'+id+'_url_subdomain-text').hide();
            var subdomain = $subdomain.val();
            if (subdomain) {
                $subdomain.parents('.field-content').find('.subdomain').show().end()
                    .find('span.archive-url-domain').show();
                if (subdomain.match(/^http/)) {
                    $subdomain.val('');
                }
            }
            $('span.'+id+'_url_path-text').hide();
            $path.show();
            $(this).parents('.field-content').find('.use-subdomain').show();
            $('p#'+id+'_url-warning').show();
            return false;
        });
    });
};

/*
 * mtUseAbsolute
 *
 * Usage:
 *   jQuery.mtUseAbsolute();
 *
 */
$.mtUseAbsolute = function() {
    var $checkboxes = $('.site-path-field :checkbox');
    $checkboxes.each(function() {
        var $obj;
        if (!this.checked) {
            $obj = $(this).parents('.field-content');
            $obj.find('.relative-site_path').show();
            $obj.find('.absolute-site_path').hide();
            $obj.find('.relative-site_path-hint').show();
            $obj.find('.absolute-site_path-hint').hide();
        } else {
            $obj = $(this).parents('.field-content');
            $obj.find('.relative-site_path').hide();
            $obj.find('.absolute-site_path').show();
            $obj.find('.relative-site_path-hint').hide();
            $obj.find('.absolute-site_path-hint').show();
        }
    });
    $checkboxes.on('click', function() {
        var $obj;
        if (this.checked) {
            $obj = $(this).prop('checked', true).parents('.field-content');
            $obj.find('.relative-site_path').hide();
            $obj.find('.absolute-site_path').show();
            $obj.find('.relative-site_path-hint').hide();
            $obj.find('.absolute-site_path-hint').show();
            $obj.find('.absolute-site_path').find(':input').removeClass('ignore-validate');
            $obj.find('.relative-site_path').find(':input').addClass('ignore-validate');
        } else {
            $obj = $(this).prop('checked', false).parents('.field-content');
            $obj.find('.relative-site_path').show();
            $obj.find('.absolute-site_path').hide();
            $obj.find('.relative-site_path-hint').show();
            $obj.find('.absolute-site_path-hint').hide();
            $obj.find('.relative-site_path').find(':input').removeClass('ignore-validate');
            $obj.find('.absolute-site_path').find(':input').addClass('ignore-validate');
        }
    });
};

/*
 * mtEditSitePath
 *
 * Usage:
 *   jQuery.mtEditSitePath();
 *
 */
$.mtEditSitePath = function(options) {
    var defaults = {
        edit: 'Edit'
    },
    opts = $.extend(defaults, options),
    ids = ['site', 'archive'];
    $.each(ids, function() {
        var id = this, $path,
            $absolute_path = $('input#'+id+'_path_absolute');
        if ( !$absolute_path.hasClass('show-input') ) {
            $absolute_path
                .before('<span class="'+id+'_path_absolute-text path-text"></span>')
                .after('<button type="button" id="mt-set-'+id+'_path_absolute" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                .hide();
            $('span.'+id+'_path_absolute-text').text($absolute_path.val());
        }

        $path = $('input#'+id+'_path');
        if ( !$path.hasClass('show-input') ) {
            $path
                .before('<span class="'+id+'_path-text path-text"></span>')
                .after('<button type="button" id="mt-set-'+id+'_path" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                .hide();
            $('span.'+id+'_path-text').text($path.val());

            $path.parents('.field-content').find('.use-absolute').hide();
        }


        $('button#mt-set-'+id+'_path_absolute').on('click', function() {
            $('span.'+id+'_path_absolute-text').hide();
            $absolute_path.addClass('show-input').show();
            $('p#'+id+'_path-warning').show();
            $(this).hide();
            $path.parents('.field-content').find('.use-absolute').show();

            if ( !$path.hasClass('show-input') ) {
                $('button#mt-set-'+id+'_path').trigger('click');
            }
            return false;
        });
        $('button#mt-set-'+id+'_path').on('click', function() {
            $('span.'+id+'_path-text').hide();
            $path.addClass('show-input').show();
            $('p#'+id+'_path-warning').show();
            $(this).hide();
            $path.parents('.field-content').find('.use-absolute').show();

            if ( !$absolute_path.hasClass('show-input') ) {
                $('button#mt-set-'+id+'_path_absolute').trigger('click');
            }
            return false;
        });
    });
};

/*
 * mtCheckbox
 *
 * Usage:
 *   jQuery.mtCheckbox();
 *
 */
$.mtCheckbox = function() {
    function verify_all_checked($table) {
        var n = $table.find('tbody input:checked').length;
        if ($table.find('tbody :checkbox').length === n) {
            $table.find('thead :checkbox, tfoot :checkbox').prop('checked', true);
        } else {
            $table.find('thead :checkbox, tfoot :checkbox').prop('checked',false);
        }
    }

    $('thead :checkbox, tfoot :checkbox').on('click', function() {
        var $checkboxes = $(this).parents('table').find(':checkbox');
        if (this.checked) {
            $checkboxes.prop('checked', true).parents('tr').addClass('selected').next('.slave').addClass('selected');
        } else {
            $checkboxes.prop('checked', false).parents('tr').removeClass('selected').next('.slave').removeClass('selected');
        }
    });

    $('tbody :checkbox').on('click', function() {
        if (this.checked) {
            $(this).parents('tr').addClass('selected').next('.slave').addClass('selected');
        } else {
            $(this).parents('tr').removeClass('selected').next('.slave').removeClass('selected');
        }
        verify_all_checked($(this).parents('table'));
    });

    $('tbody').each(function() {
        $(this).find(':checkbox').parents('tr').removeClass('selected')
            .find('input:checked').parents('tr').addClass('selected');
        verify_all_checked($(this).parents('table'));
    });
};

/*
 * mtQuickFilter
 *
 * Usage:
 *   jQuery.mtQuickFilter()
 *
 */
$.mtQuickFilter = function() {
    $('form#list-filter button').hide();
    $('select.filter-keys').on('change', function() {
        $('form#list-filter').trigger('submit');
    });
};

/*
 * mtDialog
 *
 * Usage:
 *   jQuery('a.mt-open-dialog').mtDialog();
 *
 *   <a href="mt.cgi" class="mt-open-dialog">Dialog</a>
 *
 * to use dialog directly:
 *   jQuery.fn.mtDialog.open(url);
 *
 * to close dialog from iframe:
 *   parent.jQuery.fn.mtDialog.close();
 *
 * to set close callback:
 *   parent.jQuery.fn.mtDialog.close(url, function(e) {
 *     parent.jQuery('#title').val('MT5');
 *   });
 *
 */
$.fn.mtDialog = function(options) {
    var defaults = {
        loadingimage: StaticURI+'images/indicator.gif',
        esckeyclose: true
    },
    opts = $.extend(defaults, options);
    init_dialog();
    return this.each(function() {
        $(this).on('click', function() {
            open_dialog(this.href, opts);
            return false;
        });
    });
};

function init_dialog() {
    $(window).resize(function() {
        resize_dialog();
    });
    var $dialog = $('.mt-dialog');
    if (!$dialog.length) {
        $('body').append('<div class="mt-dialog"><span>Close</span></div>');
        $('.mt-dialog').after('<div class="mt-dialog-overlay overlay"></div>');
        $(".mt-dialog > div > span").on('click', function() {
            close_dialog();
        });

        // Disable drag & drop on overlay.
        $('.mt-dialog-overlay').on('dragover drop', function(e) {
          e.preventDefault();
          e.stopPropagation();
        });
    }
}

function resize_dialog() {
    var $dialog = $('.mt-dialog'),
        height = $(window).height();
    if ($dialog.length) {
        $dialog.height(height - 60);
        $('#mt-dialog-iframe').height(height - 60);
    }
}

function open_dialog(href, opts) {
    if ( opts.form ) {
        var param = opts.param,
            form;
        $('<iframe />')
            .attr({
                id: 'mt-dialog-iframe',
                name: 'mt-dialog-iframe',
                frameborder: '0',
                width: '100%'
            })
            .on('load', function() {
                $('.mt-dialog .loading').remove();
            })
            .appendTo($('.mt-dialog'));
        resize_dialog();
        $('<img />')
            .attr({
                src: opts.loadingimage
            })
            .addClass('loading')
            .appendTo($('.mt-dialog'));
        form = $('<form />')
            .attr({
                'id': 'mt-dialog-post-form',
                'method': 'post',
                'action': href,
                'target': 'mt-dialog-iframe'
            })
            .append( $( '#' + opts.form).children().clone() )
            .appendTo($('.mt-dialog'));
        $.each( param, function( key, val ) {
            form.find('[name=' + key + ']').remove();
            $('<input />')
                .attr({
                    'type': 'hidden',
                    'name': key,
                    'value': val
                })
                .appendTo( form );
        });
        form.submit();
        form.remove();
    }
    else {
        $('<iframe />')
            .attr({
                id: 'mt-dialog-iframe',
                frameborder: '0',
                src: href+'&dialog=1',
                width: '100%'
            })
            .on('load', function() {
                $('.mt-dialog .loading').remove();
            })
            .appendTo($('.mt-dialog'));
        resize_dialog();
        $('<img />')
            .attr({
                src: opts.loadingimage
            })
            .addClass('loading')
            .appendTo($('.mt-dialog'));
    }
    if (navigator.userAgent.indexOf("Gecko/") == -1) {
        $('body').addClass('has-dialog');
    }
    $('.mt-dialog').show();
    $('.mt-dialog').on('close', function(event, fn) {
        fn(event);
    });
    $('.mt-dialog-overlay').show();
    if (opts.esckeyclose) {
        $(document).on('keyup.mt-dialog', function(event){
            if (event.keyCode == 27) {
                close_dialog();
            }
        });
    }
    // for ie6 tweaks
    if (!$.support.style && !$.support.objectAll) {
        if ($.fn.bgiframe) $('.mt-dialog-overlay').bgiframe();
        if ($.fn.exFixed) $('.mt-dialog').exFixed();
    }
}

function close_dialog(url, fn) {
    $('body').removeClass('has-dialog');
    $('.mt-dialog-overlay').hide();
    if (fn) {
        $('.mt-dialog').trigger('close', fn);
    }
    $(document).off('keyup.mt-dialog');
    $('.mt-dialog').off('close');
    $('.mt-dialog').hide();

    // Removing "iframe" in delay.
    // Because IE9 will continue to run the script after closing,
    // and raise error if removing "iframe".
    var iframe = $('#mt-dialog-iframe').
        attr('id', 'mt-dialog-iframe-removed');
    setTimeout(function() {
        iframe.remove();
    }, 2000);

    if (url) {
        window.location = url;
    }
}

$.fn.mtDialog.open = function(url, options) {
    var defaults = {
        loadingimage: StaticURI+'images/indicator.gif',
        esckeyclose: true
    },
    opts = $.extend(defaults, options);
    init_dialog();
    open_dialog(url, opts);
};

$.fn.mtDialog.close = function(url, fn) {
    close_dialog(url, fn);
    $(window).trigger('dialogDisposed');
};

$.event.special.dialogReady = {
    setup:function( data, ns ) {
        return false;
    },
    teardown:function( ns ) {
        return false;
    }
};

$.fn.mtDialogReady = function(options) {
    $(window).trigger('dialogReady');
};

/*
 * mtRebuild
 *
 * Usage:
 *   jQuery('a.mt-rebuild').mtRebuild({blog_id: 1});
 *
 *   <a href="mt.cgi" class="mt-rebuild">Rebuild</a>
 *
 */
$.fn.mtRebuild = function(options) {
    var defaults = {},
        opts = $.extend(defaults, options);
    $(this).on('click', function() {
        window.open($(this).attr('href'), 'rebuild_blog_'+opts.blog_id, 'width=400,height=400,resizable=yes');
        return false;
    });
};

/*
 * mtSetTip
 *
 * Usage:
 *   jQuery(':input').mtSetTip();
 *
 *   <input title="sample text" />
 *
 */
$.fn.mtSetTip = function(options) {
    var defaults = {
        tip_color: '#aaaaaa'
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        var text = $(this).attr('title');
        $(this).val(text).css('color', opts.tip_color);
        $(this).on('focus', function() {
            if (this.value == text) {
                $(this).val('').css('color', '#000');
            }
        });
        $(this).on('blur', function() {
            if ($(this).val() == '') {
                $(this).val(text).css('color', opts.tip_color);
            }
            if (this.value != text) {
                $(this).css('color', '#000');
            }
        });
    });
};

/*
 * mtPublishItems
 *
 */
$.fn.mtPublishItems = function(options) {
    var defaults = {
        name: null,
        args: {}
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).on('click', function() {
            doForMarkedInThisWindow($('#'+opts.id)[0], opts.singular, opts.plural, opts.name, opts.mode, opts.args, opts.phrase);
            return false;
        });
    });
};

/*
 * mtSubmitItems
 *
 */
$.fn.mtSubmitItems = function(options) {
    var defaults = {},
        opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).on('click', function() {
            $('form#'+opts.id+' > input[name=__mode]').val('save_entries');
        });
    });
};

/*
 * mtDeleteItems
 *
 */
$.fn.mtDeleteItems = function(options) {
    var defaults = {
        args: {}
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).on('click', function() {
            doRemoveItems($('#'+opts.id)[0], opts.singular, opts.plural, '', opts.args);
            return false;
        });
    });
};

/*
 * mtEnableUsers
 *
 */
$.fn.mtEnableUsers = function(options) {
    var defaults = {
        args: {}
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).on('click', function() {
            setObjectStatus($('#'+opts.id)[0], opts.plural, opts.phrase, 1, '', opts.args);
            return false;
        });
    });
};

/*
 * mtDisableUsers
 *
 */
$.fn.mtDisableUsers = function(options) {
    var defaults = {
        args: {}
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).on('click', function() {
            var sysadmin = $('#sysadmin')[0];
            if (sysadmin && sysadmin.checked) {
                alert(opts.message);
                sysadmin.trigger('click');
                return false;
            }
            setObjectStatus($('#'+opts.id)[0], opts.plural, opts.phrase, 0, '', opts.args);
            return false;
        });
    });
};

/*
 * mtDoPluginAction
 *
 */
$.fn.mtDoPluginAction = function(options) {
    var defaults = {
        args: {}
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).on('click', function() {
            doPluginAction($('#'+opts.id)[0], opts.plural, opts.args, opts.phrase);
            return false;
        });
    });
};

/*
 * mtSetObjectStatus
 *
 */
$.fn.mtSetObjectStatus = function(options) {
    var defaults = {
        args: {}
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).on('click', function() {
            setObjectStatus($('#'+opts.id)[0], opts.singular, opts.plural, opts.status, '', opts.args);
            return false;
        });
    });
};

/*
 * mtRebasename
 *
 */
$.fn.mtRebasename = function(options) {
    var defaults = {
        text: '...'
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        var $input = $('input#basename'),
            dirify_text = $input.hide().val();
        $input.hide().before('<span class="basename-text"></span>');
        $input.parent('span.basename').after('<button type="button" id="mt-set-basename" class="btn btn-default mt-edit-field-button button">'+opts.edit+'</button>');
        if (opts.basename) {
            $('span.basename-text').text(opts.basename);
        } else {
            $('span.basename-text').text(dirify_text || opts.text);
        }
        $(this).on('keyup', function() {
            if (!opts.basename) {
                dirify_text = dirify($(this).val());
                if (opts.limit) {
                    dirify_text = dirify_text.substring(0, opts.limit);
                }
                $('span.basename-text').text(dirify_text || opts.text);
                $input.val(dirify_text);
            }
        });
        $('button#mt-set-basename').on('click', function() {
            $(this).hide();
            $('span.basename-text').hide();
            $('input#basename').show();
            toggleFile();
            return false;
        });
    });
};

/*
 * mtEditInput
 *
 * Usage:
 *   jQuery('input.mt-edit-field').mtEditInput({ edit: '<__trans phrase="Edit">'});
 *
 *   <input name="test" class="mt-edit-field" />
 *
 */
$.fn.mtEditInput = function(options) {
    var defaults = {
        save: 'Save'
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        var id = $(this).attr('id'),
            $input = $('input#'+id);
        if ($input.val() && !$input.hasClass('show-input')) {
            $input
                .before('<span class="'+id+'-text text-wrap mr-3"></span>')
                .after('<button type="button" id="mt-set-'+id+'" class="btn btn-default mt-edit-field-button button">'+opts.edit+'</button>')
                .hide();
            $('span.'+id+'-text').text($input.val());
        }
        if (!$input.val() && $input.hasClass('hide-input')) {
            $input
                .before('<span class="'+id+'-text text-wrap mr-3"></span>')
                .after('<button type="button" id="mt-set-'+id+'" class="btn btn-default mt-edit-field-button button">'+opts.edit+'</button>')
                .hide();
        }
        $('button#mt-set-'+id).on('click', function() {
            $(this).hide();
            $('span.'+id+'-text').hide();
            $('input#'+id).show();
            $('p#'+id+'-warning').show();
            return false;
        });
    });
};

/*
 * mtCheckboxOption
 *
 * Usage:
 *   jQuery('div.has-option').mtCheckboxOption();
 *
 */
$.fn.mtCheckboxOption = function() {
    return this.each(function() {
        var $checkbox = $(this).find(':checkbox'),
            id = $checkbox.attr('id');
        if (!$checkbox.prop('checked')) {
            $('div#'+id+'-option').hide();
        }
        $checkbox.on('click', function() {
            $('div#'+id+'-option').toggle();
        });
    });
};

/*
 * mtToggleField
 *
 * Usage:
 *   jQuery('.msg').mtToggleField();
 *   jQuery('.msg').mtToggleField({hide_clicked: true});
 *
 * to set open callback:
 *   jQuery('.msg').mtToggleField({}, function(){ // do anything});
 */
$.fn.mtToggleField = function(options, openCallback) {
    var defaults = {
        click_class: 'detail-link',
        detail_class: 'detail',
        hide_clicked: false,
        default_hide: true
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
        var $field = $(this);
        if (opts.default_hide)
            $field.find('.'+opts.detail_class).hide();
        $field.find('.'+opts.click_class)
            .on('mousedown', function(event) {
                $field.toggleClass('active').find('.'+opts.detail_class).toggle();
                if ($field.hasClass('active') && openCallback) {
                    openCallback();
                }
                return false;
            })
            .on('click', function(event) {
                return false;
            });

        if (opts.hide_clicked) {
            $(document).on('mousedown', function(event) {
                if ($(event.target).parents('.active').length === 0) {
                    $field.removeClass('active').find('.'+opts.detail_class).hide();
                }
            });
        }
    });
};

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
    validClass: 'is-valid',
    errorClass: 'is-invalid',
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
                .addClass('alert alert-danger')
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
                    .addClass('validate-error msg-error text-danger')
                    .text(msg)
            );
    }
});
$.mtValidator('simple2', {
    wrapError: function ( $target, msg ) {
        $target.parent().addClass('has-error');
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
                .addClass('text-danger validate-error msg-error')
                .append( $('<ul class="list-unstyled" />') );

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
        $target.parent().removeClass('has-error');
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
            .addClass('msg-error msg-balloon validate-error label label-default')
            .text(msg);
    },
    showError: function( $target, $error_block ) {
        var focus = function () { $error_block.show(); },
            blur  = function () { $error_block.hide(); };
        jQuery.data( $target.get(0), 'validate_focus', focus );
        jQuery.data( $target.get(0), 'validate_blur',  blur );
        $target
            .on('focus', focus)
            .on('blur', blur);
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
    },
    removeError: function( $target, $error_block ) {
        $error_block.remove();
        var focus = jQuery.data( $target.get(0), 'validate_focus'),
            blur  = jQuery.data( $target.get(0), 'validate_blur');
        $target
            .off('focus', focus)
            .off('blur', blur);
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
    '.signed-digit': function ($e) {
        return !$e.val() || /^-?\d+$/.test($e.val());
    },
    '.number': function ($e) {
        return !$e.val() || /\d/.test($e.val()) && /^\d*\.?\d*$/.test($e.val());
    },
    '.signed-number': function ($e) {
        return !$e.val() || /\d/.test($e.val()) && /^(-?\d+)?\.?\d*$/.test($e.val());
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
    '.html5-form': function ($e) {
        if (!$e.get(0).checkValidity || $e.get(0).checkValidity()) {
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
    '.date':          trans('Invalid date format'),
    '.time':          trans('Invalid time format'),
    '.email':         trans('Invalid email address'),
    '.url':           trans('Invalid URL'),
    '.url-field':     trans('Invalid URL'),
    '.required':      trans('This field is required'),
    '.digit, .num':   trans('This field must be an integer'),
    '.signed-digit':  trans('This field must be a signed integer'),
    '.number':        trans('This field must be a number'),
    '.signed-number': trans('This field must be a signed number'),
    '.min-length':    trans('Please input [_1] characters or more', '{{min}}')
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
            defaults = { focus: true, afterTrigger: true };
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
            error_elements[0].trigger('focus');
        }
        if ( opts.afterTrigger ) {
            this.trigger('after-mt-valid');
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

/*
 * mtPlaceholder
 *
 * Usage:
 *   jQuery('[placeholder]').mtPlaceholder()
 *
 */

$.fn.mtPlaceholder = function() {
    if ( 'placeholder' in $('<input />').get(0) ) return this;
    this.each( function () {
        var that = this,
            $that = $(that),
            placeholder_text = $that.attr('placeholder');
        if ( 1 > $that.val().length ) {
            $that
                .val(placeholder_text)
                .css('color', 'GrayText')
                .attr('data-showing-placeholder', 'showing');
        }
        $that
            .on('focus', function () {
                if ( $that.attr('data-showing-placeholder') ) {
                    $that
                        .val('')
                        .css('color', '#2b2b2b')
                        .removeAttr('data-showing-placeholder');
                }
            })
            .on('blur', function () {
                if ( 1 > $that.val().length) {
                    $that.val(placeholder_text)
                        .css('color', 'GrayText')
                        .attr('data-showing-placeholder', 'showing');
                }
            })
            .parents('form').on('submit', function () {
                if ( $that.attr('data-showing-placeholder') ) {
                    $that.removeAttr('data-showing-placeholder');
                    $that.val('');
                }
            });
    });
    return this;
};

/*
 * mtEditInputBlock
 *
 */
$.fn.mtEditInputBlock = function(options) {
    var defaults = {
        edit: 'Edit',
        text: 'Not specified'
    },
    opts = $.extend(defaults, options);
    return this.each(function() {
      var id    = $(this).attr('id'),
          $div  = $('div#'+id),
          $date = $('input#'+id),
          $time = $('input#'+id);
      if (!$div.hasClass('show-input')) {
          $div
              .before('<span class="'+id+'-text mr-2"></span>')
              .after('<button type="button" id="mt-edit-'+id+'" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
              .hide();
          $('span.'+id+'-text').text(opts.text);
          $div.hide();
      } else {
          $div.show();
      }
      $('button#mt-edit-'+id).on('click', function() {
          $(this).hide();
          $('span.'+id+'-text').hide();
          $div.show();
          return false;
      });
    });
};

/*
 * mtModal
 *
 */
$.fn.mtModal = function (options) {
  var defaults = {
      loadingimage: StaticURI + 'images/indicator.gif',
      esckeyclose: true
  };
  var opts = $.extend(defaults, options);
  initModal();
  return this.each(function() {
      var eachOpts;
      if (this.dataset.hasOwnProperty('mtModalLarge')) {
        eachOpts = $.extend({ large: true }, opts);
      } else {
        eachOpts = opts;
      }
      $(this).on('click', function() {
        openModal(this.href, eachOpts);
        return false;
      });
  });
};

$.fn.mtModalClose = function () {
  return this.each(function () {
    var url = window.top.jQuery(this).data().mtModalClose;
    $(this).on('click', function () {
      return window.top.jQuery.fn.mtModal.close(url);
    });
  });
};

$.fn.mtModal.open = function (url, options) {
  var defaults = {
      loadingimage: StaticURI + 'images/indicator.gif',
      esckeyclose: true
  };
  var opts = $.extend(defaults, options);
  initModal();
  openModal(url, opts);
};

$.fn.mtModal.close = function (url) {
  var $modal = window.top.jQuery('.mt-modal');
  $modal.modal('hide');
  if (url) window.top.location = url;
  return false;
};

function getModalHtml() {
  return '<style>iframe.embed-response-item:not(:last-child) { display: none; }</style>'
    + '<div class="modal fade mt-modal" data-backdrop="static">'
    + '<div class="modal-dialog">'
    + '<div class="modal-content embed-responsive">'
    + '</div>'
    + '</div>'
    + '</div>';
}

function initModal() {
  var $modal = window.top.jQuery('.mt-modal');
  if ($modal.length > 0) return;

  window.top.jQuery(window.top.document.body).append(getModalHtml());
  $modal = window.top.jQuery('.mt-modal');

  // Disable drag & drop on overlay.
  $modal.on('dragover drop', function (e) {
    e.preventDefault();
    e.stopPropagation();
  });

  $modal.on('hide.bs.modal', function (e) {
    var $m = window.top.jQuery('.mt-modal');
    var iframeCountBeforeRemove = $m.find('iframe').length;
    var $iframe = $m.find('iframe:last-child');
    var iframeWindow = $iframe.get(0).contentWindow;
    var iframeBeforeunloadEvent = iframeWindow.onbeforeunload;

    if (iframeBeforeunloadEvent && !iframeBeforeunloadEvent.call(iframeWindow)) {
      e.preventDefault();
      e.stopImmediatePropagation();
      return false;
    }

    if (iframeCountBeforeRemove <= 1) {
      return true;
    } else {
      e.preventDefault();
      e.stopImmediatePropagation();
      $iframe.remove();
      return false;
    }
  });

  $modal.on('hidden.bs.modal', function (e) {
    var $iframe = window.top.jQuery('.mt-modal iframe:last-child');
    $iframe.remove();
  });

  window.top.jQuery(window.top).on('resize scroll', function () {
    setTimeout(resizeModal, 100);
  });
}

function openModal(href, opts) {
  if (!href.match(/[\?&]dialog=1/)) {
    href += '&dialog=1';
  }

  if (opts.form) {
    openModalWithForm(href, opts);
  } else {
    openModalWithoutForm(href, opts);
  }

  var $modal = window.top.jQuery('.mt-modal');

  if (opts.full) {
    $modal.find('.modal-dialog').css('width', '100%');
  } else {
    $modal.find('.modal-dialog').css('width', '');
  }

  if (opts.large) {
    $modal.find('.modal').addClass('bs-example-modal-lg');
    $modal.find('.modal-dialog').addClass('modal-lg');
  } else {
    $modal.find('.modal').removeClass('bs-example-modal-lg');
    $modal.find('.modal-dialog').removeClass('modal-lg');
  }

  var $iframe = getIframe();
  $iframe.attr('src', href);
  $modal.find('.modal-content').append($iframe);

  $modal.modal(getModalOptions(opts));
}

function getNextIframeId() {
  var id = 0;
  var $lastIframe = window.top.jQuery('.mt-modal iframe:last-child');
  if ($lastIframe.length > 0) {
    var lastName = $lastIframe.attr('name');
    var lastId = lastName.replace(/modal-(\d)+/, "$1");
    id = Number(lastId) + 1;
  }
  return id;
}

function getIframe() {
  var id = getNextIframeId();
  var html = '<iframe id="mt-dialog-iframe" class="embed-responsive-item" name="modal-'+id+'"></iframe>';
  var $iframe = window.top.jQuery(html);
  $iframe.on('load', resizeModal);
  return $iframe;
}

function getModalOptions(opts) {
  var modalOptions = {};

  var modalOptionKeys = [
    'backdrop',
    'keyboard',
    'focus',
    'show'
  ];
  modalOptionKeys.forEach(function (key) {
    if (opts.hasOwnProperty(key)) {
      modalOptions[key] = opts[key];
    }
  });
  if (!modalOptions.hasOwnProperty('keyboard') && opts.hasOwnProperty('esckeyclose')) {
    modalOptions.keyboard = opts.esckeyclose;
  }

  return modalOptions;
}

function openModalWithForm(href, opts) {

}

function openModalWithoutForm(href, opts) {

}

function resizeModal() {
  var modalHeight;
  var modalBodyHeight;
  var $iframeContents = window.top.jQuery('iframe.embed-responsive-item:visible').contents();
  var $modalBody = $iframeContents.find('body .modal-body');
  if ( MT.Util.isMobileView() ) {
    var mobileScreenHeight = window.top.jQuery(window.top).height();
    if (top.jQuery(top).width() < top.jQuery(top).height()) {
      modalHeight = mobileScreenHeight - 10;
    } else {
      if (MT.Util.isIos()) {
        modalHeight = mobileScreenHeight;
      } else {
        modalHeight = mobileScreenHeight + 50;
      }
    }
    modalBodyHeight = (modalHeight - 130) + 'px';
  } else {
    if ($modalBody.length > 0) {
      modalHeight = $iframeContents.find('body').outerHeight(true);
    } else {
      modalHeight = $iframeContents.find('body > *:first').outerHeight(true);
    }
    if ( modalHeight < 500 ) {
      modalHeight = 500;
    }
    modalBodyHeight = '34rem';
  }
  $('.mt-modal .modal-content').css('padding-bottom', modalHeight);
  $modalBody.css('max-height', modalBodyHeight);
}

var previousView;
jQuery.setViewTrigger = function () {
  jQuery(window).on('resize', function () {
    if (MT.Util.isMobileView()) {
      if (previousView && previousView == 'mobile') {
        return;
      }
      if (previousView) {
        jQuery(window).trigger('change_to_mobile_view');
      }
      previousView = 'mobile';
    } else {
      if (previousView && previousView == 'pc') {
        return;
      }
      if (previousView) {
        jQuery(window).trigger('change_to_pc_view');
      }
      previousView = 'pc';
    }
  });
};

})(jQuery);
