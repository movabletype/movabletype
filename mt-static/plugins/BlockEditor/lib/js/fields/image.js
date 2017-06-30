;(function($) {
var BEF = MT.BlockEditorField;

BEF.Image = function() { BEF.apply(this, arguments) };
BEF.Image.createButton = function(){
    return $('<span class="add">Image</span>');
};
$.extend(BEF.Image.prototype, BEF.prototype, {
    get_id: function(){
        return self.id;
    },
    get_type: function(){
        return 'image';
    },
    create: function(id, data){
        var self = this;
        self.id = id;
        self.input_field = $('<div class="asset_field"><a href="' + ScriptURI + '?__mode=dialog_list_asset&amp;edit_field=' + id + '&amp;blog_id=' + jQuery('[name=blog_id]').val() + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image" class="mt-open-dialog">edit Image</a><input type="hidden" name="' + id + '" id="' + id + '" value=""></div>');
        self.input_field.find('a.mt-open-dialog').mtDialog()
        return self.input_field;

    },
    get_data: function(){
        var self = this;
        return {
            'type': self.get_type(),
            'value': self.input_field.find('#'+self.id).val(),
        };
    },
    get_html: function(){
        var self = this;
        var asset_id = self.input_field.find('#'+self.id).val();
        if(asset_id){
            // get asset url
            var url = '';
            return '<img src="' + url + '">';
        }
    }
});

MT.BlockEditorFieldManager.register('image', BEF.Image);

})(jQuery);