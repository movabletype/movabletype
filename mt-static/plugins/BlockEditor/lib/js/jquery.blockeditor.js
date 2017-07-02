;(function($){
    var _generate_unique_id = function(){
        return new Date().getTime().toString(16)  + Math.floor(Math.random()*9999).toString(16)
    }
    var manager;
    var block_field;
    var add_field;
    var add_menu;
    var _create_field = function(editor_id, input_field){
      block_field.append(input_field);
      add_menu.remove();
      block_field.sortable('refresh');
      _update_data(editor_id);
    };
    var _update_data = function(editor_id){
        var datas = manager.get_data.apply(manager);
        var order = block_field.sortable("toArray");
        jQuery.each( order, function( index, id_wrap_str ) {
          var id = id_wrap_str.replace('-wrapper','');
          block_editor_data[editor_id][id] = datas[id];
          block_editor_data[editor_id][id].order = index + 1;
        });
    }


    var _init = function(data){
        return this.each(function(){
            var $this = $(this);
            var editor_id = $this.attr('id');
            block_editor_data[editor_id] = {};

            block_field = jQuery('<div class="block_field sortable"></div>');
            add_field = $('<div class="add_field icon-mini-left addnew">' + trans('Create New') + '</div>');
                
            manager = new MT.BlockEditorFieldManager(editor_id);
            manager.set_data(data);
            add_field.on('click', function(){
              var self = this;
              add_menu = jQuery('<div class="add_menu"></div>');
              var buttons = manager.create_button.apply(manager, [_create_field, editor_id]);
              buttons.forEach(function(button){
                add_menu.append(button);
              });
              jQuery(this).after(add_menu);
            })

            jQuery('#' + editor_id).parents('.editor-content').after(block_field);

            block_field.sortable({
              items: '.sort-enabled',
              placeholder: 'placeholder',
              distance: 3,
              opacity: 0.8,
              cursor: 'move',
              forcePlaceholderSize: true,
              handle: '.field-header',
              containment: '.block_field',
              update : function(ev, ui) {
                _update_data(editor_id);
              }
            });
            block_field.after(add_field);
        });
    };
    var _destoroy = function(editor_id){
        if(block_field)
          block_field.remove();
        block_editor_data[editor_id] = null;
        return this;
    };
    var _get_data = function(){
        var editor_id = this.attr('id');
        _update_data(editor_id);
        return block_editor_data[this.attr('id')];
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