;(function($) {
var BEF = MT.BlockEditorField;

BEF.Horizon = function() { BEF.apply(this, arguments) };
BEF.Horizon.createButton = function(){
    return $('<span class="add">Horizon</span>');
};
$.extend(BEF.Horizon.prototype, BEF.prototype, {
    id: '',
    input_field: '',
    options: [],

    get_id: function(){
        return self.id;
    },
    get_type: function(){
        return 'horizon';
    },
    create: function(id, data){
        this.id = id;
        this.input_field = $('<div class="hr_field"><hr><input type="hidden" name="' + id + '" id="' + id + '" value="hr"></div>');
        return this.input_field;
    },
    get_field_options: function(field_options){
        var self = this;
        var option_color = $('<label>color<input type="color" name="field_option_background-color"></label>');

        var callback = function(){
            return function(){
                var name = $(this).attr('name');
                var val = $(this).val();
                self.set_option.call(self,name,val);
            };
        }();
        var options = $('<div class="options"></div>');
        options.append(option_color);
        options.on('change', 'input', callback);
        return field_options.append(options);
    },
    set_option: function(name, val){
        var style_name = name.replace('field_option_', '');
        this.options[style_name] = val;
    },
    set_class_name: function(val){
        var self = this;
        var class_names = val.split(' ');
        self.class_names = [];
        class_names.forEach(function(class_name){
            self.class_names.push(class_name);
        });
    },
    get_data: function(){
        var self = this;
        return {
            'class_name': self.class_names.join(' '),
            'type': self.get_type(),
            'value': '',
            'html': self.get_html(),
        };
    },
    get_html: function(){
        var html = '<hr';
        if(this.class_names.length > 0){
            html += ' class="' + this.class_names.join(' ') + '"';
        }
        html += '>';
        return html;
    }
});

MT.BlockEditorFieldManager.register('horizon', BEF.Horizon);

})(jQuery);