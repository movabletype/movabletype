; (function ($) {
    var BEF = MT.BlockEditorField;
    BEF.Header = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Header, {
        label: trans('Heading'),
        icon_url: StaticURI + 'images/sprite.svg#ic_header',
        type: 'heading',
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock">' + this.get_icon() + this.label + '</button>');
        },
        get_icon: function(){
            return '<svg role="img" class="mt-icon"><title>' + this.label + '</title><use xlink:href="' + this.icon_url + '"></use></svg>';
        }
    });
    $.extend(BEF.Header.prototype, BEF.prototype, {
        get_id: function () {
            return this.id;
        },
        get_label: function(){
          return BEF.Header.label;
        },
        get_type: function () {
            return BEF.Header.type;
        },
        get_icon: function() {
            return BEF.Header.get_icon();
        },
        create: function (id,data) {
            var self = this;
            self.id = id;
            self.data = data;
            if(!self.data.value){
              self.data.value = '';
            }
            if(!self.data.options){
              self.data.options["elm"] = 'h1';
            }
            var html = self.get_html();
            self.view_field = $('<div class="form-group"></div>');
            self.view_field.append(html);
            return self.view_field;
        },
        get_edit_field: function(){
            var self = this;
            self.options_field = $('<div class="edit_field form-group"></div>');
            var elm_select = $('<div class="form-group"><label class="form-control-label" for="' + self.id + '-element">' + trans('Heading Level') + '</label><select class="custom-select form-control w-100" name="' + self.id + '-element"  mt:watch-change="1"></select></div>');

            var elms = ['h1','h2','h3','h4','h5','h6'];
            elms.forEach(function(elm){
                var option = $('<option></optiion>');
                option.val(elm);
                option.text(elm.toUpperCase());
                if( typeof(self.data.options) == 'object' && self.data.options["elm"] == elm){
                    option.attr('selected', true);
                }
                elm_select.find('select').append(option);
            })
            self.options_field.append(elm_select);
            self.options_field.append('<div class="form-group"><textarea name="header-text" class="form-control w-100"></textarea></div>');
            self.options_field.find('textarea').prop('placeholder', trans('Please enter the Header Text here.'));
            self.options_field.find('textarea').val(self.data.value);
            return self.options_field;
        },
        save: function(){
            var elm = this.options_field.find('select').val();
            var value = this.options_field.find('textarea').val();
            this.data.value = value;
            this.data.options['elm'] = elm;
            var html = this.get_html();
            this.view_field.empty();
            this.view_field.append(html);
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.data.options[style_name] = val;
        },
        get_data: function () {
            if(typeof(this.data.options) != 'object'){
                this.data.options = {};
            }
            if(!this.data.options["elm"]){
              this.data.options["elm"] = 'h1';
            }
            return {
                'value': this.data.value,
                'html': this.get_html(),
                'options': this.data.options,
            }
        },
        get_html: function () {
            var elm = this.data.options["elm"];
            if(!elm || elm == ''){
                elm = 'h1';
            }
            var html = $('<' + elm + '>');
            html.text(this.data.value);
            return html.prop("outerHTML");
        }
    });

    MT.BlockEditorFieldManager.register('heading', BEF.Header);

})(jQuery);
