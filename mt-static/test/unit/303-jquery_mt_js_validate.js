jQuery(function($) {
    module('mtValidate');

    (function() {
        // mtValidate

        var data = {
            'date': {
                '2011-01-01': true,
                '2011-1-1': false,
                '2011-40-40': true,
                '': true
            },
            'email': {
                'info@example.com': true,
                'info+info@example.com': true,
                'info@example': false,
                'info@example.co.jp': true,
                'info@example.unknown': true,
                '': true
            },
            'url': {
                'http://www.example.com/': true,
                'https://www.example.com/': true,
                'ftp://www.example.com/': true,
                'http://www.example/': true,
                'http://example/': false,
                'example': false,
                'gopher://www.example.com/': false,
                '': true
            },
            'digit': {
                '1': true,
                '12': true,
                '12.3': false,
                '': false
            },
            'num': {
                '1': true,
                '12': true,
                '12.3': false,
                '': false
            },
            'number': {
                '1': true,
                '12': true,
                '12.3': true,
                '.3': true,
                '1.': true,
                '': false
            },
            'required': {
                'a': true,
                '0': true,
                '': false
            },
            'date required': {
                '2011-01-01': true,
                '2011-1-1': false,
                '2011-40-40': true,
                '': false
            }
        }

        var $validate = $('#validate');
        var validate  = $validate.get(0);

        $.each(data, function(class_name, values) {
            $.each(values, function(value, result) {
                test('mtValidate: ' + class_name + ': ' + value, function() {
                    validate.className = class_name;
                    validate.value = value;
                    equal($validate.mtValidate(), result);
                });
            });
        });

    })();


    (function() {
        // mtValidate with namespace

        var $validate = $('#validate_with_namespace');
        var validate  = $validate.get(0);

        var error_message_buffer = '';
        $.mtValidator('a_custom_validator', {
            wrapError: function ( $target, msg ) {
                return $('<div />').text(msg);
            },
            showError: function( $target, $error_block ) {
                error_message_buffer = $error_block.text();
            }
        });

        test('mtValidate with namespace', function() {
            validate.className = 'date';
            validate.value = 'an invalid date value';
            equal($validate.mtValidate('a_custom_validator'), false);
            equal(error_message_buffer, $.mtValidateMessages['.date']);
        });
    })();


    (function() {
        // mtValidateAddRules and mtValidateAddMessages

        var $validate = $('#validate');
        var validate  = $validate.get(0);

        test('mtValidateAddRules', function() {
            var str  = 'test_string';
            var name = 'test_rule';
            var rule = {};
            rule['.' + name] = function($e) {
                return $e.val() == str;
            };

            $.mtValidateAddRules(rule);


            validate.className = name;
            validate.value = str;
            equal($validate.mtValidate(), true);


            validate.className = name;
            validate.value = str + '_invalid';
            equal($validate.mtValidate(), false);
        });

        test('mtValidateAddMessages', function() {
            var messages = {'.date': 'custom error message'};
            $.mtValidateAddMessages(messages);

            validate.className = 'date';
            validate.value = 'an invalid date value';
            equal($validate.mtValidate(), false);
            equal($validate.mtValidator().errstr, messages['.date']);
        });
    })();

});
