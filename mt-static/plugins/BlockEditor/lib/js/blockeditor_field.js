;(function($) {

MT.BlockEditorField = function(field) {
    this.field = field;
};
$.extend(MT.BlockEditorField.prototype, {
    get_id: function(){},
    get_type: function(){},
    createButton: function(){},
    create: function(){},
    get_data: function(){},
    get_html: function(){}
});

})(jQuery);