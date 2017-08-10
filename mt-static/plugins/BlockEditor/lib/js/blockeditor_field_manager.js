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
    editor_id: "",
    field_instances: {},
    init: function(id){
        this.editor_id = id;
        this.field_instances = {};
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
                callback(self.editor_id, self.create_field.call(self, field_class, id, data));
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
        var label = $('<div class="field-header ui-sortable-handle first-child"><label>' + field_instance.get_type() + '</label><label class="' + edit_field_class + '_label icon-delete icon-right"></label><label class="' + edit_field_class + '_label icon-settings icon-right"></label><div>');
        label.on('click', '.icon-delete', function(){
            var id = $(this).parents('.field').attr('id').replace('-wrapper','');
            label.parents('.field-content').remove();
            delete　self.field_instances[id];
        });
        label.on('click', '.icon-settings', function(){
          $(this).parents('.field-content').find('.field_options').toggle();
        });
        var count = $('.' + edit_field_class).length;
        var edit_field = $('<div id="' + id + '-wrapper" class="field field-top-label sort-enabled"></div>');
        edit_field.append(label);
        var field_options = $('<div class="field_options" style="display: none;"><label>class<input type="text name="field_class" class="field_class"></label></div>');
        field_options.on('change', '.field_class', function(){
            field_instance.set_class_name($(this).val());
        });
        if(data["class_name"] && data["class_name"] != ''){
            field_instance.set_class_name(data["class_name"]);
            field_options.find('.field_class').val(data["class_name"]);
        }
        if ('get_field_options' in field_instance) {
            field_options = field_instance.get_field_options(field_options);
        }
        edit_field.append(field_options);
        edit_field.append(edit_field_input);
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
            field_contens[field_order-1] = self.create_field.call(self, field_class, field_id, data[field_id]);
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
