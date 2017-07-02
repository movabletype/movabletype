;(function($){
    var _generate_unique_id = function(){
        return new Date().getTime().toString(16)  + Math.floor(Math.random()*9999).toString(16)
    }
    var managers = {};
    var block_field_class = 'block_field';
    var add_menu_class = 'add_menu';
    var _get_block_field = function(editor_id) {
      return $('#'+editor_id ).parents('.editor-content').siblings('.' + block_field_class);
    }
    var _create_field = function(editor_id, input_field){
      var block_field = _get_block_field(editor_id);
      block_field.append(input_field);
      block_field.siblings('.' + add_menu_class).remove();

      block_field.sortable('refresh');
    };
    var _init = function(data){
        return this.each(function(){
            var $this = $(this);
            var editor_id = $this.attr('id');
            var block_field = $('<div class="' + block_field_class + ' sortable"></div>');
            var add_field = $('<div class="add_field icon-mini-left addnew">' + trans('Create New') + '</div>');
                
            var manager = new MT.BlockEditorFieldManager(editor_id);
            managers[editor_id] = manager;

            add_field.on('click', function(){
              var self = this;
              block_field.siblings('.' + add_menu_class).remove();
              var add_menu = $('<div class="' + add_menu_class + '"></div>');
              var manager = managers[editor_id];
              var buttons = manager.create_button.apply(manager, [_create_field, editor_id]);
              buttons.forEach(function(button){
                add_menu.append(button);
              });
              $(this).after(add_menu);
            })

            $this.parents('.editor-content').after(block_field);

            block_field.sortable({
              items: '.sort-enabled',
              placeholder: 'placeholder',
              distance: 3,
              opacity: 0.8,
              cursor: 'move',
              forcePlaceholderSize: true,
              handle: '.field-header',
              containment: '.block_field',
            });
            block_field.after(add_field);

            if(data){
              var input_fields = manager.set_data(data);
              input_fields.forEach(function(input_field){
                _create_field(editor_id, input_field);
              })
            }

        });
    };
    var _destoroy = function(editor_id){
        var editor_content = $('#'+editor_id ).parents('.editor-content');
        editor_content.siblings('.' + block_field_class).remove();
        return this;
    };
    var _get_data = function(){
        var editor_id = this.attr('id');
        var manager = managers[editor_id];
        var datas = manager.get_data.apply(manager);
        var block_field = _get_block_field(editor_id);
        var order = block_field.sortable("toArray");
        jQuery.each( order, function( index, id_wrap_str ) {
          var id = id_wrap_str.replace('-wrapper','');
          datas[id]["order"] = index + 1;
        });
        return datas;
    };
    var _set = function(){
        return this;
    }
    var methods = {
        init: _init,
        destoroy: _destoroy,
        get_data: _get_data,  
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