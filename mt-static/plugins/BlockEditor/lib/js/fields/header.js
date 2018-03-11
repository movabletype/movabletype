; (function ($) {

    var BEF = MT.BlockEditorField;
    var label = trans('header');

    BEF.Header = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Header, {
        label: trans('header'),
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock"><svg title="' + label + '" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_header"></use></svg>' + label + '</button>');
        },
    });
    $.extend(BEF.Header.prototype, BEF.prototype, {
        options: {},
        get_id: function () {
            return self.id;
        },
        get_type: function () {
            return 'header';
        },
        get_svg_name: function() {
            return 'ic_header';
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            self.edit_field = $('<div class="row no-gutters py-2"><div class="col"></div></div>');
            self.edit_field_input = $('<div class="form-group"><textarea id="' + id + '" name="' + id + '" class="form-control w-100" mt:watch-change="1"></textarea></div>');
            self.edit_field_input.find('textarea').val(data["value"]);
            self.select_header = $('<div class="form-group"><label class="form-control-label" for="' + id + '-element">' + trans('a rank') + '</label><select class="custom-select form-control w-100" name="' + id + '-element"  mt:watch-change="1"><option value="h1">H1</option><option value="h2">H2</option><option value="h3">H3</option></select></div>');
            if (data["elem"]) {
                self.select_header.find('select').val(data["elem"]);
            }
            self.edit_field.find('.col').append(self.select_header);
            self.edit_field.find('.col').append(self.edit_field_input);
            return self.edit_field;
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.options[style_name] = val;
        },
        get_data: function () {
            var self = this;
            return {
                'value': self.edit_field_input.find('textarea').val(),
                'elem': self.select_header.find('select').val(),
                'html': self.get_html(),
                'options': self.options,
            }
        },
        get_html: function () {
            var self = this;
            var elm = self.select_header.find('select').val();
            var html = '<' + elm;
            Object.keys(self.options).forEach(function(key){
                html += ' ' + key + '="' + self.options[key] + '"';
            })
            html += '>' + self.edit_field_input.find('textarea').val() + '</' + elm + '>';
            return html;
        }
    });

    MT.BlockEditorFieldManager.register('header', BEF.Header);

})(jQuery);
