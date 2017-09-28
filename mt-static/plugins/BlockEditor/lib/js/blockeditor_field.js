;(function($) {

    var BEF = MT.BlockEditorField = function(field) {
        this.field = field;
    };
    $.extend(MT.BlockEditorField.prototype, {
        get_id: function(){},
        get_type: function(){},
        get_svg_name: function(){
            return 'ic_plugin';
        },
        createButton: function(){},
        create: function(){},
        get_data: function(){},
        get_html: function(){},
        get_trash_field: function() {
            return $('<div class="col-auto trash"><svg title="削除" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_trash"></use></svg><div>');
        },
        get_move_field: function() {
            return $('<div class="col-auto mt-ic_move "><svg title="' + trans('can move') + '" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_move"></use></svg></div>');
        },
        get_label_field: function() {
            return $('<div class="col"><div class="mt-icon--contentblock">' + this.get_svg() + '</div><label>' + this.get_type() + '</label></div>');
        },
        get_svg: function() {
            return '<svg title="' + this.get_type() + '" role="img" class="mt-icon mt-icon--sm"><use xlink:href="' + StaticURI + 'images/sprite.svg#' + this.get_svg_name() + '" /></svg>';
        },
        create_label_field: function() {
            var label_field = $('<div class="row no-gutters py-2"></div>');
            label_field.append(this.get_move_field());
            label_field.append(this.get_label_field());
            label_field.append(this.get_trash_field());
            return label_field;
        },
        create_field: function(field_instance, id, data, delete_clallback) {
            var self = this;
            var field_content = $('<div class="mt-collapse__block field-content sort-enabled"></div>');
            field_content.attr('id', id + '-wrapper');

            var label_field = self.create_label_field.apply(self);
            label_field.on('click', '.trash', function(){
                $('#' + id + '-wrapper').remove();
                delete_clallback(id);
            })
            field_content.append(label_field);

            var edit_field_input = field_instance.create.apply(self, [id, data]);
            field_content.append(edit_field_input);

            var option_callback = function () {
                return function () {
                    var name = $(this).attr('name');
                    var val = $(this).val();
                    field_instance.set_option.call(self, name, val);
                };
            }();

            var option_id_field = $('<div class="field_options row no-gutters py-2"><div class="col"><div class="form-group"><label class="form-control-label" for="' + id + '_option_class">id</label><input type="text" name="field_option_id" class="field_option_id form-control w-25" id="' + id + '_option_class"></div></div>');
            option_id_field.on('change', '.field_option_id', option_callback);
            field_content.append(option_id_field);

            var option_class_field = $('<div class="field_options row no-gutters py-2"><div class="col"><div class="form-group"><label class="form-control-label" for="' + id + '_option_class">class</label><input type="text" name="field_option_class" class="field_option_class form-control w-25" id="' + id + '_option_class"></div></div></div>');
            option_class_field.on('change', '.field_option_class', option_callback);
            field_content.append(option_class_field);

            if(data.options ){
                if(data.options.id){
                    option_id_field.find('.field_option_id').val(data.options.id);
                }
                if(data.options.class){
                    option_class_field.find('.field_option_class').val(data.options.class);
                }
            }
            if ('get_field_options' in self) {
                field_content.append($('<div class="field_options row no-gutters py-2"></div>').append(self.get_field_options( $('<div class="col"></div>'))));
            }
            return field_content;

        },
        get_field_data: function(id){
            var self = this;
            var data = self.get_data();
            data.type = self.get_type();

            return data;
        },

    });

})(jQuery);
