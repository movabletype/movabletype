;(function($) {


MT.BlockEditorFieldManager = function() { this.init.apply(this, arguments); };
// Class method
$.extend(MT.BlockEditorFieldManager, {
    fields: {},


    register: function(id, field) {
        this.fields[id] = field;
    }
});
// Instance method
$.extend(MT.BlockEditorFieldManager.prototype, {
    field_instances: {},
    edit_id: "",
    init: function(id){
        this.editor_id = id;
        return this;
    },
    get_fields: function(){
        return MT.BlockEditorFieldManager.fields;
    },
    create_button: function(callback){
        var buttons = [];
        var self = this;
        var fields = self.get_fields();
        var data = {};
        Object.keys(fields).forEach(function(field_type){
            var id = generate_unique_id();
            var button = fields[field_type].createButton();
            button.on('click', function(){
                var field_class = fields[field_type];
                callback(self.editor_id, self.create_field.apply(self, [field_class, id, data]));
            });
            buttons.push(button);
        })
        return buttons;
    },
    create_field: function(field_class, id, data){
        var self = this;
        var field_instance = new field_class();
        self.field_instances[id] = field_instance;
        var edit_field_input = field_instance.create.apply(field_instance, [id, data]);
        var edit_field_class = this.editor_id + '_addfield';
        var label = $('<div class="field-header ui-sortable-handle first-child"><label class="' + edit_field_class + '_label icon-delete icon-right">' + field_instance.get_type() + '</label></div>');
        label.on('click', '.icon-delete', function(){
          label.parent('.field').remove();
        });
        var count = $('.' + edit_field_class).length;
        var edit_field = $('<div id="' + id + '-wrapper" class="field field-top-label sort-enabled"></div>');
        edit_field.append(label);
        edit_field.append(edit_field_input);;
        var field_content = $('<div class="field-content"></div>');
        field_content.append(edit_field);
        return field_content;
    },
    get_data: function(){
        var self = this;
        var datas = {};
        Object.keys(self.field_instances).forEach(function(field_id){
            var field = self.field_instances[field_id];
            datas[field_id] = field.get_data();
        });
        return datas;
    },
    set_data: function(data){
        var self = this;
        var fields = self.get_fields();
        var field_contens = [];
        Object.keys(data).forEach(function(field_id){
            var field_type = data[field_id].type;
            var field_order = data[field_id].order;
            var field_class = fields[field_type];
            field_contens[field_order-1] = self.create_field(field_class, field_id, data[field_id]);
        });
        return field_contens;
    },
    get_html: function(){
        var self = this;
        var htmls = [];
        Object.keys(self.field_instances).forEach(function(field_id){
            var field = self.field_instances[field_id];
            htmls.push(field.get_html());
        });
        return htmls;
    },
});



})(jQuery);
