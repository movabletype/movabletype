;(function($) {
  var managers = {};
  var block_field_class = 'block_field';
  var add_menu_class = 'add_menu';
  var _get_block_field = function(editor_id) {
    var m = editor_id.match(/.*-(\d+)-.*$/);
    if (m) {
      field_id = m[1];
    }
    return $('#editor-input-content-field-' + field_id + '-blockeditor')
  };
  var _create_field = function(editor_id, input_field) {
    var block_field = _get_block_field(editor_id);
    block_field.append(input_field);
    block_field.siblings('.add_field-group').find('.' + add_menu_class).remove();
    setDirty(true);
    log('found dirty form: #' + editor_id);
    if (typeof(app) !== 'undefined') {
      (app.getIndirectMethod('setDirty'))();
    }
    $('.modal-blockeditor').modal('hide');
    $('#blockeidor_menus-' + field_id + ' .nav-link[href="#prev"]').trigger('click');
  };
  var _init = function(data) {
    return this.each(function() {
      var $this = $(this);
      var field_id = $this.data('blockeditor-field_id');
      var editor_id = $this.attr('id');
      var block_field = $this;
      var add_field = $('#blockeditor_add-'+field_id);
      add_field.prop('hidden', false);
      var manager = new MT.BlockEditorFieldManager(editor_id);
      managers[editor_id] = manager;

      add_field.on('click', function() {
        var modal = new MT.ModalWindow();
        modal.set_title(trans('Select a block'));
        var buttons = manager.create_button.call(manager, _create_field);

        // var buttons = manager.create_button();
        var add_function = function(){
            var type = button_field.val();
            var field_id = '';
            var field_class = '';
            var data = {};
            _create_field(editor_id, manager.create_field.call(manager, type, '', data));
        };
        var next_function = function(){
            var type = button_field.val();
            var option_view = manager.create_option_view(type);
            modal.set_body(option_view);
            modal.set_ok_label(trans('Add'));

            var type = button_field.val();
            var field_id = '';
            var field_class = '';
            var data = {};
            modal.set_ok(function(){
                var type = button_field.val();
                var field_id = '';
                var field_class = '';
                var data = {};
                _create_field(editor_id, manager.create_save_field.call(manager, type, '', data));
            });
        }


        var button_field = $('<input type="hidden" id="blockeditor-' + field_id + '-field-type" name="blockeditor-field-type" value="">');
        buttons.forEach(function(button){
          button.on('click', function(){
            button_field.val(button.find('button').attr('data-blockeditor-type'));
            buttons.forEach(function(button){
                button.find('button').removeClass('btn-contentblock--selected');
            });
            button.find('button').addClass('btn-contentblock--selected');
            if( manager.is_option( button_field.val() ) ){
                modal.set_ok_label(trans('Next'));
                modal.set_ok(next_function);
            } else {
                modal.set_ok_label(trans('Add'));
                modal.set_ok(add_function);
            }
            modal.set_enabled_action();
            return false;
          });
        });
        var modal_body = modal.get_body();
        modal_body.append(buttons);
        modal_body.append(button_field);
        modal_body.children(".button-col").wrapAll('<div class="row buttons-wrapper"></div>')
        modal.set_default_actions();
        modal.show();
        // $('.modal-blockeditor').modal();
      });

      window.blockEditorFieldSortableChanged = {};

      $('#blockeidor_menus-' + field_id + ' .nav-link').on('click', function(){
          if($(this).hasClass('active')) return;
          var href = $(this).attr('href');
          var mode = href.replace(/#/,'')
          var editor_id = $this.attr('id');
          var manager = managers[editor_id];
          manager.change_mode(mode);
          $('#blockeidor_menus-' + field_id).find('.nav-link').removeClass('active');
          $(this).addClass('active');
          if(mode == 'sort'){
              jQuery('#editor-input-content-field-' + field_id + '-blockeditor').find('p:last-child').prop('hidden', false);
              jQuery('#blockeditor_add-' + field_id).attr('hidden', '');
              jQuery('select[name=content-field-' + field_id + '_convert_breaks]').parent().attr('hidden', '');
              block_field.sortable({
                items: '.sort-enabled',
                placeholder: 'placeholder',
                distance: 3,
                opacity: 0.8,
                cursor: 'move',
                forcePlaceholderSize: true,
                handle: MT.Util.isMobileView() ? '.col-auto:first-child' : false,
                containment: block_field.parents('.multi_line_text-field-container').get(0),
                start: function (event, ui) {
                    ui.item.attr('aria-grabbed', true);

                    if (window.blockEditorFieldSortableChanged[field_id]) {
                      ui.helper.offset({
                        top: ui.helper.offset().top + jQuery('body').scrollTop()
                      });
                    }
                },
                sort: function (event, ui) {
                    if (window.blockEditorFieldSortableChanged[field_id]) {
                      ui.helper.offset({
                        top: ui.helper.offset().top + jQuery('body').scrollTop()
                      });
                    }
                },
                change: function (event, ui) {
                  window.blockEditorFieldSortableChanged[field_id] = true;
                },
                update: function(ev, ui){
                    var order = $(this).sortable("toArray");
                    manager.set_order(order);
                },
                stop: function (event, ui) {
                    ui.item.attr('aria-grabbed', false);
                }
              });
          } else {
              jQuery('#editor-input-content-field-' + field_id + '-blockeditor > p').attr('hidden', '');
              jQuery('#blockeditor_add-' + field_id).prop('hidden', false);
              jQuery('select[name=content-field-' + field_id + '_convert_breaks]').parent().prop('hidden', false);
          }
      });

      if ("MutationObserver" in window) {
        var observer = new MutationObserver(function() {
          $(window).trigger('field_created', [editor_id]);
        });
        observer.observe(block_field.get(0), {
          childList: true
        });
      }

      if (data) {
        var input_fields = manager.set_data(data);
        input_fields.forEach(function(input_field) {
          _create_field(editor_id, input_field);
        })
      }

      block_field.on('mouseover', '.field-content div', function() {
        $(this).parents('.mt-collapse__block').addClass('mt-collapse__block--selected');
      });
      block_field.on('mouseout', '.field-content div', function() {
        $(this).parents('.mt-collapse__block').removeClass('mt-collapse__block--selected');
      });

      jQuery(window).on('pre_autosave', function() {
        $.updateblock();
        log('pre_autosave updateblock');
      });

      block_field.on('change', 'input[mt\\:watch-change="1"]', function(event) {
        setDirty(true);
      });

      jQuery('button.publish,button.preview').on('click', function(event) {
        $.updateblock()
      });
      setDirty(false);
    });
  };
  var _destroy = function() {
    var editor_id = this.attr('id');
    var block_field = _get_block_field(editor_id);
    block_field.siblings('.add_field-group').remove();
    block_field.empty();
    if( typeof block_editor_data !== 'undefined' ){
        block_editor_data[editor_id] = null;
    }
    if( typeof managers !== 'undefined' ){
        managers[editor_id] = null;
    }
    return this;
  };
  var _get_data = function() {
    var editor_id = this.attr('id');
    var manager = managers[editor_id];
    return manager.get_data.apply(manager);
  };
  var _get_html = function() {
    var editor_id = this.attr('id');
    var manager = managers[editor_id];
    var htmls = manager.get_html.apply(manager);
    return htmls.join("\n");
  }
  var _set = function() {
    return this;
  }
  var methods = {
    init: _init,
    destroy: _destroy,
    get_data: _get_data,
    get_html: _get_html,
    set: _set,
  }

  $.fn.blockeditor = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' + method + ' does not exist on jQuery.blockeditor');
    }

  };
  $.updateblock = function() {
    var block_editor_data = {};
    jQuery('.editorfield').each(function(i) {
      var editor_id = this.id + '-blockeditor';
      var format = jQuery('.convert_breaks[data-target=' + this.id + ']').val();
      if (format == "blockeditor") {
        block_editor_data[editor_id] = jQuery('#' + editor_id).blockeditor('get_data');
      }
    });
    if (Object.keys(block_editor_data).length > 0) {
      jQuery('#block_editor_data').val(JSON.stringify(block_editor_data))
    } else {
      jQuery('#block_editor_data').val('')
    }
    setDirty(false);
  };
})(jQuery);
