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
    init: function(id){
        this.editor_id = id;
        this.block_editor_data = [];
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
        Object.keys(fields).forEach(function(key){
            var id = generate_unique_id();
            var button = fields[key].createButton();
            button.on('click', function(){
                var field = new fields[key]();
                self.field_instances[id] = field;
                callback(self.editor_id, self.create_field.apply(self, [field, id, data]));
            });
            buttons.push(button);
        })
        return buttons;
    },
    create_field: function(field_instance, id, data){
        var edit_field_input = field_instance.create.apply(field_instance, [id, data]);
        var edit_field_class = this.editor_id + '_addfield';
        var label = jQuery('<div class="field-header ui-sortable-handle first-child"><label class="' + edit_field_class + '_label icon-delete icon-right">' + field_instance.get_type() + '</label></div>');
        label.on('click', '.icon-delete', function(){
          label.parent('.field').remove();
        });
        var count = jQuery('.' + edit_field_class).length;
        var edit_field = jQuery('<div id="' + id + '-wrapper" class="field field-top-label sort-enabled"></div>');
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
    set_data: function(){

    },
});



})(jQuery);
