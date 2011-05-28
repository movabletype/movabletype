jQuery(function($) {
    module('Utilities in mt.js');


    var count_marked_data = [
        [ 'not_checked_0', 0 ],
        [ 'not_checked_1', 0 ],
        [ 'not_checked_2', 0 ],
        [ 'checked_1', 1 ],
        [ 'checked_2', 2 ],
        [ 'hidden_1', 1 ],
        [ 'hidden_2', 2 ],
        [ 'name_restrict', 1, 'entry_id' ]
    ];
    $.each(count_marked_data, function() {
        var id     = this[0],
            count  = this[1],
            name   = this[2];

        test('countMarked: ' + id, function() {
            if (name) {
                equal(countMarked(document.getElementById(id), name), count);
            }
            else {
                equal(countMarked(document.getElementById(id)), count);
            }
        });
    });


    test('closeDialog', function() {
        $('#dialog-container').show();
        closeDialog();
        equal($('#dialog-container:visible').length, 0);
    });


    test('getByID', function() {
        equal(getByID('dialog-container'), $('#dialog-container').get(0));
    });


    test('showReply', function() {
        var $reply = $('#reply')
        $reply.css({'visibility': 'hidden'});
        showReply('reply', document);
        equal($reply.get(0).style.visibility, 'visible');
    });


    test('hideReply', function() {
        var $reply = $('#reply')
        $reply.css({'visibility': 'visible'});
        hideReply('reply', document);
        equal($reply.get(0).style.visibility, 'hidden');
    });


    (function() {
        var $checkbox = $('#toggleSubPrefs input:checkbox');
        var checkbox  = $checkbox.get(0);
        var $prefs    = $('#' + checkbox.name + '-prefs');
        test('toggleSubPrefs: checkbox_checked', function() {
            $prefs.addClass('hidden');
            $checkbox.attr('checked', 'checked');
            toggleSubPrefs(checkbox);
            ok(! $prefs.hasClass('hidden'));
        });

        test('toggleSubPrefs: checkbox_not_checked', function() {
            $prefs.removeClass('hidden');
            $checkbox.attr('checked', '');
            toggleSubPrefs(checkbox);
            ok($prefs.hasClass('hidden'));
        });
    })();
    (function() {
        var $text  = $('#toggleSubPrefs input:text');
        var text   = $text.get(0);
        var $prefs = $('#' + text.name + '-prefs');
        test('text_has_value', function() {
            $prefs.addClass('hidden');
            $text.val('On');
            toggleSubPrefs(text);
            ok(! $prefs.hasClass('hidden'));
        });

        test('text_has_not_value', function() {
            $prefs.removeClass('hidden');
            $text.val('');
            toggleSubPrefs(text);
            ok($prefs.hasClass('hidden'));
        });
    })();
    (function() {
        var $span  = $('#toggleSubPrefs span');
        var span   = $span.get(0);
        var $prefs = $('#' + span.id + '-prefs');
        test('prefs_displayed', function() {
            $prefs.addClass('hidden').css('display', 'block');
            toggleSubPrefs(span);
            ok($prefs.hasClass('hidden'));
        });

        test('prefs_not_displayed', function() {
            $prefs.removeClass('hidden').css('display', 'none');
            toggleSubPrefs(span);
            ok(! $prefs.hasClass('hidden'));
        });
    })();


    var dirify_data = [
        ['DIR', 'dir'],
        ['&nbsp;', ''],
        ['&&amp;amp;', 'amp'],
        ['!"#$%&\'()=~^|\\`@{[}]*:+;_/?', ''],
        ['dir  dir', 'dir_dir'],
        ['dir__', 'dir'],
        ['dir__dir', 'dir_dir'],
        [ "\u00C0", 'a']
    ];
    $.each(dirify_data, function() {
        var from = this[0],
            to   = this[1];

        test('dirify: ' + from, function() {
            equal(dirify(from), to);
        });
    });


    test('setElementValue', function() {
        $('#setElementValue').val('');
        setElementValue('setElementValue', 'test');
        equal($('#setElementValue').val(), 'test');
    });


    (function() {
        var $container = $('#container-inner');
        test('setBarPosition: bottom', function() {
            setBarPosition('bottom');
            ok(! $container.hasClass('show-actions-bar-top'));
            ok($container.hasClass('show-actions-bar-bottom'));
        });
        test('setBarPosition: both', function() {
            setBarPosition('both');
            ok($container.hasClass('show-actions-bar-top'));
            ok($container.hasClass('show-actions-bar-bottom'));
        });
        test('setBarPosition: top', function() {
            setBarPosition('top');
            ok($container.hasClass('show-actions-bar-top'));
            ok(! $container.hasClass('show-actions-bar-bottom'));
        });
    })();

});
