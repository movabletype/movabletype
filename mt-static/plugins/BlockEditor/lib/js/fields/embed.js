;(function($) {

var BEF = MT.BlockEditorField;

BEF.Embed = function() { BEF.apply(this, arguments) };
BEF.Embed.createButton = function(){
    return $('<span class="add">Embed</span>');
};
$.extend(BEF.Embed.prototype, BEF.prototype, {
    get_id: function(){
        return self.id;
    },
    get_type: function(){
        return 'Embed';
    },
    create: function(id, data){
        var self = this;
        self.id = id;
        self.edit_field_input = $('<textarea id="' + id + '" class="text short html5-form content-field"></textarea>');
        return self.edit_field_input;
    },
    get_data: function(){
        var self = this;
        return {
            'type': self.get_type(),
            'value': self.edit_field_input.html(),
        }
    },
    get_html: function(){
        var self = this;
        return self.edit_field_input.html();
    }
});

MT.BlockEditorFieldManager.register('Embed', BEF.Embed);

})(jQuery);