;(function (globalWindow, $) {
    $.fn.mtFavoriteBlogsWidget = function (initialTab) {
        if (initialTab !== 'website') {
            $(this).find('a[href=#favorite-blog]').tab('show');
        }

        var currentTab = initialTab;
        var updateTimeout;
        function updateTab() {
            var $form = $('#favorite_blogs').find('form');
            $form.find('input[name=tab]').val(currentTab);
            $.ajax({
                url: $form.get(0).action,
                data: $form.serialize() + '&json=1',
                type: 'POST',
                cache: false
            });
        }

        $(this).find('a[data-toggle=tab]').on('shown.bs.tab', function () {
            currentTab = $(this).attr('href').match(/blog/) ? 'blog' : 'website';
            if (updateTimeout) {
                globalWindow.clearTimeout(updateTimeout);
            }
            updateTimeout = globalWindow.setTimeout(updateTab, 1000);
        });
    };
})(window, jQuery);

