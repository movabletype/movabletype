;(function($) {
var BEF = MT.BlockEditorField;

BEF.Image = function() { BEF.apply(this, arguments) };
BEF.Image.createButton = function(){
    return $('<span class="add">Image</span>');
};
$.extend(BEF.Image.prototype, BEF.prototype, {
    id: '',
    input_field: '',

    get_id: function(){
        return self.id;
    },
    get_type: function(){
        return 'image';
    },
    create: function(id, data){
        var self = this;
        self.id = id;
        self.input_field = $('<div class="asset_field"><a href="' + ScriptURI + '?__mode=dialog_list_asset&amp;edit_field=' + id + '&amp;blog_id=' + $('[name=blog_id]').val() + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image&amp;no_insert=1&amp;next_mode=block_editor_asset" class="mt-open-dialog">edit Image</a><input type="hidden" name="' + id + '" id="' + id + '" value=""><img src=""></div>');
        self.input_field.find('#'+id).val(data.value);
        self.input_field.find('a.mt-open-dialog').mtDialog();
        return self.input_field;
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
            'value': self.input_field.find('#'+self.id).val(),
            'html': self.get_html(),
        };
    },
    get_html: function(){
        var self = this;
        var asset_id = self.input_field.find('#'+self.id).val();
        if(asset_id){
            // get asset url
            var url = '';
            return '<img src="' + url + '" class="' + this.class_names.join(' ') + '">';
        }
    }
});

MT.BlockEditorFieldManager.register('image', BEF.Image);

})(jQuery);