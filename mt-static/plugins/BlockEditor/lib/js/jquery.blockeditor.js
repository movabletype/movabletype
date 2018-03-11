;(function($) {
  var _generate_unique_id = function() {
    return new Date().getTime().toString(16) + Math.floor(Math.random() * 9999).toString(16)
  };
  var managers = {};
  var block_field_class = 'block_field';
  var add_menu_class = 'add_menu';
  var _get_block_field = function(editor_id) {
    var m = editor_id.match(/-(\d+)$/);
    if (m) {
      field_id = m[1];
    }
    return $('#' + field_id + '-collapseEditor .' + block_field_class);
  };
  var _create_field = function(editor_id, input_field) {
    var block_field = _get_block_field(editor_id);
    block_field.append(input_field);
    block_field.siblings('.add_field-group').find('.' + add_menu_class).remove();

    block_field.sortable('refresh');
    setDirty(true);
    log('found dirty form: #' + editor_id);
    if (typeof(app) !== 'undefined') {
      (app.getIndirectMethod('setDirty'))();
    }
    $('.modal-blockeditor').modal('hide');

  };
  var _init = function(data) {
    return this.each(function() {
      var $this = $(this);
      var editor_id = $this.attr('id');
      var block_field = $('<div class="' + block_field_class + ' sortable"></div>');
      var add_field = $('<div class="add_field-group"><div class="add_block"><svg title="追加" role="img" class="mt-icon mt-icon--lg"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_add"/></svg></div></div>');

      var manager = new MT.BlockEditorFieldManager(editor_id);
      managers[editor_id] = manager;

      add_field.on('click', function() {
        var modal_title = $('.modal-blockeditor .modal-title');
        var modal_body = $('.modal-blockeditor .modal-body:eq(0)');
        var modal_options = $('.modal-blockeditor .modal-body.options');
        var modal_footer = $('.modal-blockeditor .modal-footer');

        modal_title.text(trans('Select add block'));
        var cancel = $('<a data-dismiss="modal" class="modal-cancel">' + trans('Cancel') + '</a>');
        var prev = $('<button type="button" class="btn btn-default prev" style="display:none;">' + trans('Back') + '</button>');
        var next = $('<button type="button" class="btn btn-primary next" style="display:none;">' + trans('Next') + '</button>');
        var submit = $('<button type="button" class="btn btn-primary submit">' + trans('Add') + '</button>');
        modal_footer.empty();
        modal_footer.append(cancel);
        modal_footer.append(prev);
        modal_footer.append(next);
        modal_footer.append(submit);

        var manager = managers[editor_id];
        var buttons = manager.create_button.call(manager, _create_field);


        modal_body.empty();
        modal_body.append(buttons);
        do {
          modal_body.children(".button-col:lt(2)").wrapAll('<div class="row buttons-wrapper mt-3"></div>')
        } while (modal_body.children(".button-col").length);
        modal_options.hide();
        modal_body.show();
        $('.modal-blockeditor').modal();
      });

      var m = editor_id.match(/-(\d+)$/);
      if (m) {
        field_id = m[1];
      }
      $('#' + field_id + '-collapseEditor').prepend(block_field);

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
        log(jQuery('#block_editor_data').val());
      });

      block_field.on('change', 'input[mt\\:watch-change="1"]', function(event) {
        var dirty = app.getIndirectEventListener("setDirty");
        dirty(event);
      });

      jQuery('form#edit-content-type-data-form').submit(function() {
        $.updateblock();
      });

    });
  };
  var _destroy = function() {
    var editor_id = this.attr('id');
    var block_field = _get_block_field(editor_id);
    block_field.siblings('.add_field-group').remove();
    block_field.remove();
    window.block_editor_data[editor_id] = null;
    managers[editor_id] = null;
    return this;
  };
  var _get_data = function() {
    var editor_id = this.attr('id');
    var manager = managers[editor_id];
    var data = manager.get_data.apply(manager);
    var block_field = _get_block_field(editor_id);
    var order = block_field.sortable("toArray");
    jQuery.each(order, function(index, id_wrap_str) {
      var id = id_wrap_str.replace('-wrapper', '');
      data[id]["order"] = index + 1;
    });
    return data;
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
      var format = jQuery('.convert_breaks[data-target=' + this.id + ']').val();
      if (format == "blockeditor") {
        block_editor_data[this.id] = jQuery('#' + this.id).blockeditor('get_data');
      }
    });
    if (Object.keys(block_editor_data).length > 0) {
      jQuery('#block_editor_data').val(JSON.stringify(block_editor_data))
    } else {
      jQuery('#block_editor_data').val('')
    }
  };
})(jQuery);