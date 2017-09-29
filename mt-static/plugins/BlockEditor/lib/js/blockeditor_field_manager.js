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
                var button = fields[field_type].create_button();
                button.on('click', function(){
                    var field_class = fields[field_type];
                    callback(self.editor_id, self.create_field.call(self, field_class, id, data));
                });

                buttons.push(button);
            });
            return buttons;
        },
        create_field: function(field_class, id, data){
            var self = this;
            var field_instance = new field_class();
            self.field_instances[id] = field_instance;
            var delete_clallback = function(){
                var self = this;
                return function(id){
                    delete self.field_instances[id];
                };
            };
            if(data.options && Object.keys(data.options).length > 0){
                field_instance.options = data.options;
            }
            return field_instance.create_field(field_instance, id, data, delete_clallback.call(self));
        },
        get_data: function(){
            var self = this;
            var data = {};
            Object.keys(self.field_instances).forEach(function(field_id){
                var field = self.field_instances[field_id];
                data[field_id] = field.get_field_data(field_id);
            });
            return data;
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
