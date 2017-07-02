;(function($) {

var BEF = MT.BlockEditorField;

BEF.Header = function() { BEF.apply(this, arguments) };
BEF.Header.createButton = function(){
    return $('<span class="add">H</span>');
};
$.extend(BEF.Header.prototype, BEF.prototype, {
    get_id: function(){
        return self.id;
    },
    get_type: function(){
        return 'header';
    },
    create: function(id, data){
        var self = this;
        self.id = id;
        self.edit_field_input = $('<textarea id="' + id + '" class="text short html5-form content-field"></textarea>');
        self.edit_field_input.val(data["value"]);
        self.select_header = $('<select name="' + id + '-element"><option value="h1">H1</option><option value="h2">H2</option><option value="h3">H3</option></select>');
        self.select_header.find(data["elem"]);
        return $.merge(self.select_header, self.edit_field_input);
    },
    get_data: function(){
        var self = this;
        return {
            'type': self.get_type(),
            'value': self.edit_field_input.val(),
            'elem': self.select_header.val(),
        }
    },
    get_html: function(){
        var self = this;
        var elm = self.select_header.val();
        return $(elm).append(self.edit_field_input.val()).html();
    }
});

MT.BlockEditorFieldManager.register('header', BEF.Header);

})(jQuery);