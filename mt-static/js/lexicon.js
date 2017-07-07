window.Lexicon = {};

function trans(str) {
    if (Lexicon && Lexicon[str])
        str = Lexicon[str];
    if (arguments.length > 1)
        for (var i = 1; i <= arguments.length; i++) {
            /* This matches [_#] or [_#:comment] */
            str = str.replace(new RegExp('\\[_' + i + '(?:\:[^\\]]+)?\\]', 'g'), arguments[i]);
            var re = new RegExp('\\[quant,_' + i + ',(.+?)(?:,(.+?))?(?:\:[^\\]]+)?\\]');
            var matches;
            while (matches = str.match(re)) {
                if (arguments[i] != 1)
                    str = str.replace(re, arguments[i] + ' ' +
                        ((typeof(matches[2]) != 'undefined') ? matches[2]
                                                               : matches[1]
                                                                 + 's'));
                else
                    str = str.replace(re, arguments[i] + ' ' + matches[1]);
            }
        }
    return str;
}

