;(function (globalWindow, $) {
    $.fn.mtRebuild = function(options) {
        var defaults = {},
            opts = $.extend(defaults, options);
        $(this).click(function() {
            globalWindow.open($(this).attr('href'), 'rebuild_blog_'+opts.blog_id, 'width=400,height=400,resizable=yes');
            return false;
        });
    };
})(window, jQuery);

