;(function($) {

    var BEF = MT.BlockEditorField = function(id, data) {
        this.id = id;
        this.data = data;
        this.label = '';
        this.icon_class = '';
        this.type = '';
        this.create_button = function () {
          return $('<button type="button" class="btn btn-contentblock" data-is_options="1"><svg role="img" class="mt-icon"><title>' + this.label + '</title><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_header"></use></svg>' + this.label + '</button>');
      };
    };
    $.extend(MT.BlockEditorField.prototype, {
        data: {
            'value': '',
            'options': {},
            'type': '',
        },
        get_id: function () {
            return this.id;
        },
        get_type: function () {
            return this.type;
        },
        create: function(){},
        get_data: function(){},
        _get_html: function(){},
        create_field: function(field_instance, id, data, delete_clallback) {
            var self = this;
            if(typeof(self.data) != 'object'){
                self.data = data;
            }
            if(typeof(self.data.options) != 'object'){
                self.data.options = {};
            }
            var edit_field_input = field_instance.create.apply(field_instance, [id, self.data]);

            var class_name = 'mt-contentblock__block';
            if (edit_field_input.find('.mt-contentblock__embed').length > 0){
                class_name = 'mt-contentblock__block w-100'
            }
            var field_content = $('<div data-toggle="popover"' + self.id + '"></div>');
            field_content.addClass(class_name);
            field_content.attr('id', 'contentblock-' + id + '-wrapper');
            field_content.append(edit_field_input);

            var popover_content = '<ul class="mt-contentblock__popover"><li><a href="#" class="remove_field">' + trans('Delete') + '</a>';
            if(field_instance.get_edit_field){
                popover_content += '<li><a href="#" class="edit_field">' + trans('Edit') + '</a></li>';
            }
            popover_content += '</ul>';


            field_content.popover({
                content: popover_content,
                placement: 'top',
                html: true
            });
            field_content.on('shown.bs.popover', function () {
                var popover = $(this);
                // remove field
                $('.popover').find('.remove_field').on('click', function(){
                    popover.popover('hide');
                    $('#contentblock-'+ id + '-wrapper').remove();
                    delete_clallback(id);
                    return false;
                });
                // edit field
                $('.popover').find('.edit_field').on('click', function(){
                    popover.popover('hide');
                    var modal = new MT.ModalWindow();
                    field_instance.edit_field(modal,field_instance,id, data);
                    return false;
                });
                $(document).one('click', function(){
                    popover.popover('hide');
                    return false;
                });
            });

            return field_content;
        },
        edit_field: function(modal, field_instance, id, data){
            var edit_field = field_instance.get_edit_field.call(field_instance);
            modal.set_title(trans('Edit [_1] block', field_instance.get_type()));
            modal.set_body(edit_field);
            modal.set_default_actions();
            modal.set_ok(function(){
                field_instance.save.call(field_instance);
                modal.close();
            });
            modal.set_cancel(function(){
                field_instance.cancel.call(field_instance);
                modal.close();
            });
            modal.set_enabled_action();
            modal.show();
        },
        save: function(){
            // modal save
        },
        cancel: function(){
            // modal cancel
        },
        get_field_data: function(id){
            var self = this;
            var data = self.get_data();
            data.type = self.get_type();
            return data;
        },
        get_html: function(){
            return '';
        },
    });

})(jQuery);
