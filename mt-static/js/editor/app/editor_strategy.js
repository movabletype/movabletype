/*
 * Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

MT.App.EditorStrategy = function() {};
$.extend(MT.App.EditorStrategy, {
    newInstance: function(name) {
        name = name.slice(0,1).toUpperCase() + name.slice(1).toLowerCase();
        var c = this[name];
        return new c();
    }
});
$.extend(MT.App.EditorStrategy.prototype, {
    create: function(app, ids, format) {},
    set: function(app, id) {},
    save: function(app) {}
});

})(jQuery);
