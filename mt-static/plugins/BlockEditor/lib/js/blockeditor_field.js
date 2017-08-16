;(function($) {

MT.BlockEditorField = function(field) {
    this.field = field;
};
$.extend(MT.BlockEditorField.prototype, {
    class_names: [],
    set_class_name: function(val){
        var self = this;
        self.class_names = [];

        var class_names = val.split(' ');
        class_names.forEach(function(class_name){
            self.class_names.push(class_name);
        });
    },
    get_id: function(){},
    get_type: function(){},
    createButton: function(){},
    create: function(){},
    get_data: function(){},
    get_html: function(){}
});

})(jQuery);