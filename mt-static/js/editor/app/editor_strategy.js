/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
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
    save: function(app) {},
    remove: function(app, id) {}
});

})(jQuery);
