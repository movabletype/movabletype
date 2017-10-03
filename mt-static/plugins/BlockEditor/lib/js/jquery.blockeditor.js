;(function($){
    var _generate_unique_id = function(){
        return new Date().getTime().toString(16)  + Math.floor(Math.random()*9999).toString(16)
    }
    var managers = {};
    var block_field_class = 'block_field';
    var add_menu_class = 'add_menu';
    var _get_block_field = function(editor_id) {
        var m = editor_id.match(/-(\d+)$/);
        if(m){
            field_id = m[1];
        }
        return $('#'+field_id + '-collapseEditor .' + block_field_class );
    }
    var _create_field = function(editor_id, input_field){
        var block_field = _get_block_field(editor_id);
        block_field.append(input_field);
        block_field.siblings('.add_field-group').find('.' + add_menu_class).remove();

        block_field.sortable('refresh');
    };
    var _init = function(data){
        return this.each(function(){
            var $this = $(this);
            var editor_id = $this.attr('id');
            var block_field = $('<div class="' + block_field_class + ' sortable"></div>');
            var add_field = $('<div class="form-group add_field-group"><button type="button" class="btn btn-default add_field icon-mini-left addblock">' + trans('add block') + '</button></div>');

            var manager = new MT.BlockEditorFieldManager(editor_id);
            managers[editor_id] = manager;

            add_field.on('click', 'button', function(){
                var self = this;
                block_field.siblings('.add_field-group').find('.' + add_menu_class).remove();
                var manager = managers[editor_id];
                var buttons = manager.create_button.call(manager, _create_field);
                buttons.forEach(function(button){
                    add_field.find('button').before($('<div class="row no-gutters py-2 ' + add_menu_class + '"></div>').append(button));
                });
                add_field.find('.add_menu').on('click', function(){
                  $(this).find('.add').click();
                });
            });

            var m = editor_id.match(/-(\d+)$/);
            if(m){
                field_id = m[1];
            }
            $('#'+field_id + '-collapseEditor').prepend(block_field);

            block_field.sortable({
                items: '.sort-enabled',
                placeholder: 'placeholder',
                distance: 3,
                opacity: 0.8,
                cursor: 'move',
                forcePlaceholderSize: true,
                handle: '.mt-ic_move',
                containment: block_field,
            });
            block_field.after(add_field);

            if(data){
                var input_fields = manager.set_data(data);
                input_fields.forEach(function(input_field){
                    _create_field(editor_id, input_field);
                })
            }

            block_field.on('mouseover', '.field-content div', function(){
              $(this).parents('.mt-collapse__block').addClass('mt-collapse__block--selected');
            });
            block_field.on('mouseout', '.field-content div', function(){
              $(this).parents('.mt-collapse__block').removeClass('mt-collapse__block--selected');
            });




        });
    };
    var _destroy = function(){
        var editor_id = this.attr('id');
        var block_field = _get_block_field(editor_id);
        block_field.siblings('.add_field-group').remove();
        block_field.remove();
        window.block_editor_data[editor_id] = null;
        return this;
    };
    var _get_data = function(){
        var editor_id = this.attr('id');
        var manager = managers[editor_id];
        var data = manager.get_data.apply(manager);
        var block_field = _get_block_field(editor_id);
        var order = block_field.sortable("toArray");
        jQuery.each( order, function( index, id_wrap_str ) {
            var id = id_wrap_str.replace('-wrapper','');
            data[id]["order"] = index + 1;
        });
        console.log(data);
        return data;
    };
    var _get_html = function(){
        var editor_id = this.attr('id');
        var manager = managers[editor_id];
        var htmls = manager.get_html.apply(manager);
        return htmls.join("\n");
    }
    var _set = function(){
        return this;
    }
    var methods = {
        init: _init,
        destroy: _destroy,
        get_data: _get_data,
        get_html: _get_html,
        set: _set,
    }

    $.fn.blockeditor = function(method){
        if ( methods[method] ) {
            return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if ( typeof method === 'object' || ! method ) {
            return methods.init.apply( this, arguments );
        } else {
            $.error( 'Method ' +  method + ' does not exist on jQuery.blockeditor' );
        }

    }
})(jQuery);
