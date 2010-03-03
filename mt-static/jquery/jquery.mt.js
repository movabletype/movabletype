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
        arrow_image: StaticURI+'images/menu-arrow-down.gif'
    };
    var opts = $.extend(defaults, options);
    $('.top-menu > div a').after('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('.top-menu .toggle-button').click(function(event) {
        $(this).parents('li.top-menu').toggleClass('top-menu-open');
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
        arrow_image: StaticURI+'images/arrow-down-gray.gif'
    };
    var opts = $.extend(defaults, options);
    $('#system-overview > em').prepend('<a hre="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('#user-dashboard > em').prepend('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
    $('#current-website > em').prepend('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');

    $('#selector-nav-list li .toggle-button ').click(function(event) {
        $(this).parent('em').parents('#selector-nav').toggleClass('show-selector');
        event.preventDefault();
    });
    $(document).click(function(event) {
        if ($(event.target).parents('#selector-nav').length == 0) {
            $('#selector-nav').removeClass('show-selector');
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
                .before('<span class="'+this+'_url_subdomain-text"></span>');
            $('span.'+this+'_url_subdomain-text').text($subdomain.val()+'.');
        }
        $subdomain.parents('.field-content').find('.subdomain').hide();
        $subdomain.parents('.field-content').find('.use-subdomain').hide();
        if (!$path.hasClass('show-input')) {
            $path
                .before('<span class="'+this+'_url_path-text"></span>')
                .after('<button id="mt-set-'+this+'_url_path" class="mt-edit-field-button">'+opts.edit+'</button>')
                .hide();
            $('span.'+this+'_url_path-text').text($path.val());
        }
        if (subdomain && subdomain.match(/^http/)) {
            $subdomain.parents('.field-content').find('.use-subdomain').hide().end()
                .find('span.archive-url-domain').hide()
                .before('<span class="'+this+'_url_path-text">'+$subdomain.val()+'</span>');
            if ($('button#mt-set-'+this+'_url_path').length == 0) {
                $path
                    .after('<button id="mt-set-'+this+'_url_path" class="mt-edit-field-button">'+opts.edit+'</button>')
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
 * mtEditSitePath
 *
 * Usage:
 *   jQuery.mtEditSitePath();
 *
 */
$.mtEditSitePath = function() {
    var re = /^(\/|\\\\|[a-zA-Z]:(\\|\/))/;
    $('.blog-path-text').each(function() {
        var text = $(this).val();
        if (text.match(re)) {
            $(this).removeClass('extra-path')
                .parents('.site-path-field').find('span.website-path').hide();
        }
    });
    $('.blog-path-text').keyup(function() {
        var text = $(this).val();
        if (text.match(re)) {
            $(this).removeClass('extra-path')
                .parents('.site-path-field').find('span.website-path').hide();
        } else {
            $(this).addClass('extra-path')
                .parents('.site-path-field').find('span.website-path').show();
        }
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
 * mtDisplayOptions
 *
 * Usage:
 *   jQuery.mtDisplayOptions();
 *
 */
$.mtDisplayOptions = function() {
    $('div#display-options-widget').css('position', 'absolute').hide();
    // for ie6 tweaks
    if (!$.support.style && !$.support.objectAll) {
        if ($.fn.bgiframe) $('div#display-options-widget').bgiframe();
    }

    $('a.display-options-link').click(function() {
        $('a.display-options-link').toggleClass('display-options-link-open');
        $('div#display-options-widget').toggle();
        return false;
    });

    $('button.close-display-options').click(function(event) {
        $('a.display-options-link').removeClass('display-options-link-open');
        $('div#display-options-widget').hide();
        return false;
    });

    $(document).click(function(event) {
        if ($(event.target).parents('#display-options-widget').length == 0) {
            $('a.display-options-link').removeClass('display-options-link-open');
            $('div#display-options-widget').hide();
        }
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
        $('.mt-dialog').after('<div class="mt-dialog-overlay"></div>');
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
        $input.parent('span.basename').after('<button id="mt-set-basename" class="mt-edit-field-button">'+opts.edit+'</button>');
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
                .after('<button id="mt-set-'+id+'" class="mt-edit-field-button">'+opts.edit+'</button>')
                .hide();
            $('span.'+id+'-text').text($input.val());
        }
        if (!$input.val() && $input.hasClass('hide-input')) {
            $input
                .before('<span class="'+id+'-text"></span>')
                .after('<button id="mt-set-'+id+'" class="mt-edit-field-button">'+opts.edit+'</button>')
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
 * mtToggleNext
 *
 * Usage:
 *   jQuery('.msg').mtToggleNext();
 *
 */
$.fn.mtToggleNext = function(options) {
    var defaults = {
        click_class: 'detail-link',
        detail_class: 'detail'
    };
    var opts = $.extend(defaults, options);
    return this.each(function() {
        var $parent = $(this);
        $('.'+opts.detail_class).hide();
        $parent.find('.'+opts.click_class).click(function(event) {
            $parent.toggleClass('active').find('.'+opts.detail_class).toggle();
            event.preventDefault();
        });
    });
};

})(jQuery);
