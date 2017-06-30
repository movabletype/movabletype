;(function($) {
var BEF = MT.BlockEditorField;

BEF.Horizon = function() { BEF.apply(this, arguments) };
BEF.Horizon.createButton = function(){
    return $('<span class="add">Horizon</span>');
};
$.extend(BEF.Horizon.prototype, BEF.prototype, {
    get_id: function(){
        return self.id;
    },
    get_type: function(){
        return 'horizon';
    },
    create: function(id, data){
        this.id = id;
        return $('<div class="hr_field"><hr><input type="hidden" name="' + id + '" id="' + id + '" value="hr"></div>');
    },
    get_data: function(){
        var self = this;
        return {
            'type': self.get_type(),
            'value': '',
        };
    },
    get_html: function(){
        return '<hr>';
    }
});

MT.BlockEditorFieldManager.register('horizon', BEF.Horizon);

})(jQuery);