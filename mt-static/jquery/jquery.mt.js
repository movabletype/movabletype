/*
 * Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id:$
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
    };
    var opts = $.extend(defaults, options);
    $('.top-menu > div a').after('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('.top-menu .toggle-button').click(function(event) {
        $(this).parents('li.top-menu').toggleClass('top-menu-open active');
        $(this).parents('li.top-menu').find('.sub-menu').toggle();
        event.preventDefault();
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
        arrow_image: StaticURI+'images/arrow/arrow-toggle.png'
    };
    var opts = $.extend(defaults, options);
    $('#system-overview > em').prepend('<a hre="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('#user-dashboard > em').prepend('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('#current-website > em').prepend('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');

    $('#selector-nav-list li .toggle-button ').click(function(event) {
        $(this).parent('em').parents('#selector-nav').toggleClass('show-selector active');
        event.preventDefault();
    });
    $(document).click(function(event) {
        if ($(event.target).parents('#selector-nav').length == 0) {
            $('#selector-nav').removeClass('show-selector active');
        }
    });
    if (!$.support.style && !$.support.objectAll) {
        if ($.fn.bgiframe) $('div.selector').bgiframe();
    }
};

/*
 * mtFavActions
 *
 * Usage:
 *   jQuery.mtFavActions();
 *
 */
$.mtFavActions = function(options) {
    var defaults = {
        arrow_image: StaticURI+'images/arrow-down-gray.gif'
    };
    var opts = $.extend(defaults, options);
    $('.fav-actions-nav li > em').append('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('.fav-actions-nav .toggle-button').click(function(event) {
        $(this).parents('li').toggleClass('active').find('.fav-actions').toggleClass('hidden');
        event.preventDefault();
    });
    $(document).click(function(event) {
        if ($(event.target).parents('.fav-actions-nav').length == 0) {
            $('.fav-actions').addClass('hidden').parent('li').removeClass('active');
        }
    });
    if (!$.support.style && !$.support.objectAll) {
        if ($.fn.bgiframe) $('.fav-action').bgiframe();
    }
};

/*
 * mtCMSSearch
 *
 * Usage:
 *   jQuery.mtCMSSearch();
 *
 */
$.mtCMSSearch = function(options) {
    $('#cms-search > a').click(function(event) {
        $('#cms-search').toggleClass('active').find('#search-form').toggleClass('hidden');
        event.preventDefault();
    });
    $(document).click(function(event) {
        if ($(event.target).parents('#cms-search').length == 0) {
            $('#search-form').addClass('hidden').parent('#cms-search').removeClass('active');
        }
    });
    if (!$.support.style && !$.support.objectAll) {
        if ($.fn.bgiframe) $('.fav-action').bgiframe();
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
    $checkboxes.click(function() {
        if (this.checked) {
            $(this).attr('checked', true).parents('.field-content').find('.subdomain').show();
        } else {
            $(this).removeAttr('checked').parents('.field-content').find('.subdomain').hide();
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
    };
    var opts = $.extend(defaults, options);
    var ids = ['site', 'archive'];
    $.each(ids, function() {
        var id = this;
        var $subdomain = $('input#'+this+'_url_subdomain');
        var $path = $('input#'+this+'_url_path');
        var subdomain = $subdomain.val();
        if (subdomain) {
            $subdomain
                .parent('.subdomain')
                .before('<span class="'+this+'_url_subdomain-text path-text"></span>');
            $('span.'+this+'_url_subdomain-text').text($subdomain.val()+'.');
        }
        if (!$path.hasClass('show-input')) {
            $path
                .before('<span class="'+this+'_url_path-text path-text"></span>')
                .after('<button id="mt-set-'+this+'_url_path" class="button mt-edit-field-button">'+opts.edit+'</button>')
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
            if ($('button#mt-set-'+this+'_url_path').length == 0) {
                $path
                    .after('<button id="mt-set-'+this+'_url_path" class="button mt-edit-field-button">'+opts.edit+'</button>')
                    .hide();
            }
        }
        $('button#mt-set-'+this+'_url_path').click(function() {
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
        if (!this.checked) {
            var $obj = $(this).parents('.field-content');
            $obj.find('.relative-site_path').show();
            $obj.find('.absolute-site_path').hide();
            $obj.find('.relative-site_path-hint').show();
            $obj.find('.absolute-site_path-hint').hide();
        } else {
            var $obj = $(this).parents('.field-content');
            $obj.find('.relative-site_path').hide();
            $obj.find('.absolute-site_path').show();
            $obj.find('.relative-site_path-hint').hide();
            $obj.find('.absolute-site_path-hint').show();
        }
    });
    $checkboxes.click(function() {
        jQuery('#'+$(this).parents().find('form').attr('id')).validate().resetForm();
        if (this.checked) {
            var $obj = $(this).attr('checked', true).parents('.field-content');
            $obj.find('.relative-site_path').hide();
            $obj.find('.absolute-site_path').show();
            $obj.find('.relative-site_path-hint').hide();
            $obj.find('.absolute-site_path-hint').show();
            $obj.find('.absolute-site_path').find(':input').removeClass('ignore-validate');
            $obj.find('.relative-site_path').find(':input').addClass('ignore-validate');
        } else {
            var $obj = $(this).removeAttr('checked').parents('.field-content');
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
    };

    var opts = $.extend(defaults, options);
    var ids = ['site', 'archive'];
    $.each(ids, function() {
        var id = this;

        var $absolute_path = $('input#'+id+'_path_absolute');
        if ( !$absolute_path.hasClass('show-input') ) {
            $absolute_path
                .before('<span class="'+id+'_path_absolute-text path-text"></span>')
                .after('<button id="mt-set-'+id+'_path_absolute" class="button mt-edit-field-button">'+opts.edit+'</button>')
                .hide();
            $('span.'+id+'_path_absolute-text').text($absolute_path.val());
        }

        var $path = $('input#'+id+'_path');
        if ( !$path.hasClass('show-input') ) {
            $path
                .before('<span class="'+id+'_path-text path-text"></span>')
                .after('<button id="mt-set-'+id+'_path" class="button mt-edit-field-button">'+opts.edit+'</button>')
                .hide();
            $('span.'+id+'_path-text').text($path.val());

            $path.parents('.field-content').find('.use-absolute').hide();
        }


        $('button#mt-set-'+id+'_path_absolute').click(function() {
            $('span.'+id+'_path_absolute-text').hide();
            $absolute_path.addClass('show-input').show();
            $('p#'+id+'_path-warning').show();
            $(this).hide();
            $path.parents('.field-content').find('.use-absolute').show();

            if ( !$path.hasClass('show-input') ) {
                $('button#mt-set-'+id+'_path').click();
            }
            return false;
        });
        $('button#mt-set-'+id+'_path').click(function() {
            $('span.'+id+'_path-text').hide();
            $path.addClass('show-input').show();
            $('p#'+id+'_path-warning').show();
            $(this).hide();
            $path.parents('.field-content').find('.use-absolute').show();

            if ( !$absolute_path.hasClass('show-input') ) {
                $('button#mt-set-'+id+'_path_absolute').click();
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
            $table.find('thead :checkbox, tfoot :checkbox').attr('checked', true);
        } else {
            $table.find('thead :checkbox, tfoot :checkbox').removeAttr('checked');
        }
    }

    $('thead :checkbox, tfoot :checkbox').click(function() {
        var $checkboxes = $(this).parents('table').find(':checkbox');
        if (this.checked) {
            $checkboxes.attr('checked', true).parents('tr').addClass('selected').next('.slave').addClass('selected');
        } else {
            $checkboxes.removeAttr('checked').parents('tr').removeClass('selected').next('.slave').removeClass('selected');
        }
    });

    $('tbody :checkbox').click(function() {
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
    $('select.filter-keys').change(function() {
        $('form#list-filter').submit();
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
    };
    var opts = $.extend(defaults, options);
    init_dialog();
    return this.each(function() {
        $(this).click(function() {
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
        $(".mt-dialog > div > span").click(function() {
            close_dialog();
        });
    }
};

function resize_dialog() {
    var $dialog = $('.mt-dialog');
    var height = $(window).height();
    if ($dialog.length) {
        $dialog.height(height - 60);
        $('#mt-dialog-iframe').height(height - 60);
    }
};

function open_dialog(href, opts) {
    if ( opts.form ) {
        var param = opts.param;
        $('<iframe />')
            .attr({
                id: 'mt-dialog-iframe',
                name: 'mt-dialog-iframe',
                frameborder: '0',
                width: '100%'
            })
            .load(function() {
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
        var form = $('<form />')
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
                .appendTo( form )
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
            .load(function() {
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
    $('body').addClass('has-dialog');
    $('.mt-dialog').show();
    $('.mt-dialog').bind('close', function(event, fn) {
        fn(event);
    });
    $('.mt-dialog-overlay').show();
    if (opts.esckeyclose) {
        $(document).keyup(function(event){
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
};

function close_dialog(url, fn) {
    $('body').removeClass('has-dialog');
    $('.mt-dialog-overlay').hide();
    if (fn) {
        $('.mt-dialog').trigger('close', fn);
    }
    $('.mt-dialog').unbind('close');
    $('.mt-dialog').hide();
    $('#mt-dialog-iframe').remove();
    if (url) {
        window.location = url;
    }
};

$.fn.mtDialog.open = function(url, options) {
    var defaults = {
        loadingimage: StaticURI+'images/indicator.gif',
        esckeyclose: true
    };
    var opts = $.extend(defaults, options);
    init_dialog();
    open_dialog(url, opts);
};

$.fn.mtDialog.close = function(url, fn) {
    close_dialog(url, fn);
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
    var defaults = {};
    var opts = $.extend(defaults, options);
    $(this).click(function() {
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        var text = $(this).attr('title');
        $(this).val(text).css('color', opts.tip_color);
        $(this).focus(function() {
            if (this.value == text) {
                $(this).val('').css('color', '#000');
            }
        });
        $(this).blur(function() {
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).click(function() {
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
    var defaults = {};
    var opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).click(function() {
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).click(function() {
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).click(function() {
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).click(function() {
            var sysadmin = $('#sysadmin')[0];
            if (sysadmin && sysadmin.checked) {
                alert(opts.message);
                sysadmin.click();
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).click(function() {
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        $(this).click(function() {
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        var $input = $('input#basename');
        var dirify_text = $input.hide().val();
        $input.hide().before('<span class="basename-text"></span>');
        $input.parent('span.basename').after('<button id="mt-set-basename" class="mt-edit-field-button button">'+opts.edit+'</button>');
        if (opts.basename) {
            $('span.basename-text').text(opts.basename);
        } else {
            $('span.basename-text').text(dirify_text || opts.text);
        }
        $(this).keyup(function() {
            if (!opts.basename) {
                dirify_text = dirify($(this).val());
                if (opts.limit) {
                    dirify_text = dirify_text.substring(0, opts.limit);
                }
                $('span.basename-text').text(dirify_text || opts.text);
                $input.val(dirify_text);
            }
        });
        $('button#mt-set-basename').click(function() {
            $(this).hide();
            $('span.basename-text').hide();
            $('input#basename').show();
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
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        var id = $(this).attr('id');
        var $input = $('input#'+id);
        if ($input.val() && !$input.hasClass('show-input')) {
            $input
                .before('<span class="'+id+'-text"></span>')
                .after('<button id="mt-set-'+id+'" class="mt-edit-field-button button">'+opts.edit+'</button>')
                .hide();
            $('span.'+id+'-text').text($input.val());
        }
        if (!$input.val() && $input.hasClass('hide-input')) {
            $input
                .before('<span class="'+id+'-text"></span>')
                .after('<button id="mt-set-'+id+'" class="mt-edit-field-button button">'+opts.edit+'</button>')
                .hide();
        }
        $('button#mt-set-'+id).click(function() {
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
        var $checkbox = $(this).find(':checkbox');
        var id = $checkbox.attr('id');
        if (!$checkbox.attr('checked')) {
            $('div#'+id+'-option').hide();
        }
        $checkbox.click(function() {
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
 */
$.fn.mtToggleField = function(options) {
    var defaults = {
        click_class: 'detail-link',
        detail_class: 'detail',
        hide_clicked: false,
        default_hide: true
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        var $field = $(this);
        if (opts.default_hide)
            $field.find('.'+opts.detail_class).hide();
        $field.find('.'+opts.click_class).click(function(event) {
            $field.toggleClass('active').find('.'+opts.detail_class).toggle();
            event.preventDefault();
        });

        if (opts.hide_clicked) {
            $(document).click(function(event) {
                if ($(event.target).parents('.active').length == 0) {
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

$.mtValidator = function ( options, ns ) {
    $.extend( this, options );
    this.namespace = ns;
};

$.extend( $.mtValidator, {
    prototype: {
        options: {},
        validateElement: function ( $elem, val ) {
            var validator  = this;
            var rules = $.mtValidateRules;
            validator.error  = false;
            validator.errstr = undefined;
            $.each ( rules, function( selector, fn ) {
                if ( $elem.is(selector) ) {
                    var fn = rules[selector];
                    validator.error  = false;
                    validator.errstr = undefined;
                    validator.test   = fn;
                    var res = validator.test($elem);
                    if ( validator.error || !res ) {
                        if ( !validator.errstr ) {
                            validator.raise(
                                $.mtValidateMessages[selector]
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
            this.errstr = this.trans(msg || 'Invalid value');
            return false;
        },
        trans: function (msg) {
            return ( 'function' == typeof window.trans ) ? trans(msg) : msg;
        },
        validClass: 'valid',
        errorClass: 'error',
        wrapError: function ( $target, msg ) {
            return $('<label/>')
                .attr('for', $target.attr('id') )
                .addClass('msg-error')
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
    }
});

$.mtValidators = [];
$.mtValidateRules = {
    '.date': function ($e) {
        return !$e.val() || /^\d{4}\-\d{2}\-\d{2}$/.test($e.val());
    },

    // RegExp code taken from http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    '.email': function ($e) {
        return !$e.val() || /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test($e.val());
    },

    // RegExp code taken from http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    '.url': function ($e) {
        return !$e.val() || /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test($e.val());
    },

    '.required': function ($e) {
        return $e.val().length > 0;
    },
    '.digit, .num': function ($e) {
        return /^\d+$/.test($e.val());
    },
    '.number': function ($e) {
        return /\d/.test($e.val()) && /^\d*\.?\d*$/.test($e.val());
    },
};

$.mtValidateMessages = {
    '.date':        'Invalid date format',
    '.email':       'Invalid mail address',
    '.url':         'Invalid URL',
    '.required':    'This field is required',
    '.digit, .num': 'This field must be integer',
    '.number':      'This field must be number',
};

$.fn.mtValidate = function( options ) {
    options = $.extend({}, options);
    var ns = options.namespace || 'default';
    var validator = $.mtValidators[ns];
    if ( !validator ) {
        validator = $.mtValidators[ns] = new $.mtValidator(options, ns);
    }
    this.each( function () {
//        validator.elements;
        $.data( this, 'mtValidator', ns );
    });
    return this.mtValid();
};

$.fn.mtValidator = function() {
    var ns = $.data( this.get(0), 'mtValidator' );
    return $.mtValidators[ns];
}

$.fn.mtValid = function() {
    var errors = 0;
    var successes = 0;
    this.each( function () {
        var $this = $(this);
        var validator = $this.mtValidator();
        if ( !validator ) return true;
        var $current_error = $.data( this, 'mtValidateError' );
        var res = validator.validateElement($this);
        if ( res ) {
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
            errors++;
            var msg = validator.errstr;
            if ( $current_error ) {
                var last_error = $.data( this, 'mtValidateLastError' );
                if ( last_error != msg ) {
                    validator.updateError( $this, $current_error, msg );
                }
            }
            else {
                var $error_block = validator.wrapError( $this, msg );
                validator.showError( $this, $error_block );
                $.data( this, 'mtValidateError', $error_block );
                $.data( this, 'mtValidateLastError', msg );
            }
            $.data( this, 'mtValidateLastError', msg );
            $this.addClass( validator.errorClass );
            $this.removeClass( validator.validClass );
        }
    });
    return errors == 0;
}

$.fn.mtUnvalidate = function() {
    this.each( function () { 
        var validator = $(this).mtValidator();
        if ( validator ) {
            var $current_error = $.data( this, 'mtValidateError' );
            if ( $current_error ) {
                validator.removeError( $(this), $current_error );
            }
            $.data( this, 'mtValidator', null );
            $.data( this, 'mtValidateError', null );
            $.data( this, 'mtValidateLastError', null );
            $(this).removeClass( validator.errorClass );            
            $(this).removeClass( validator.validClass );            
        }
    })
};

$('input, textarea').live('keyup focusin focusout', function () {
    var ns = $.data( this, 'mtValidator' );
    if ( !ns ) return true;
    $(this).mtValid();
});

})(jQuery);
