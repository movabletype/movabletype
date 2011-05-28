jQuery(function($) {
    module('Utilities in jquery.mt.js');

    test('mtAddEdgeClass', function() {
        $('.first-child').removeClass('first-child');
        $('.last-child').removeClass('last-child');

        $.mtAddEdgeClass();

        ok($('body *:first-child').hasClass('first-child'));
        ok($('body *:last-child').hasClass('last-child'));
    });
});
