;(function($) {
    $.fn.mtRemoveWidget = function () {
        $(this).on('click', function () {
            var $form = $(this).parents('div.panel').find('form');
            $form.children('input[name=widget_action]').val('remove');
            $form.submit();
        });
    };
})(jQuery);

