;(function($) {
    "use strict";

    MT.ModalWindow = function(modal_class){
        this.modal_class = '.modal-blockeditor';
        this.title = $(this.modal_class + ' .modal-title');
        this.body = $(this.modal_class + ' .modal-body:eq(0)');
        this.options = $(this.modal_class + ' .modal-body.options');
        this.footer = $(this.modal_class + ' .modal-footer');
        this.clear();
        $(this.modal_class).modal();
    };
    $.extend(MT.ModalWindow.prototype, {
        set_title: function(title){
            this.title.empty()
            this.title.text(title);
        },
        get_title: function(){
            this.title.text()
        },
        set_body: function(body){
            this.body.empty();
            this.body.append(body);
        },
        append_body: function(options){
          this.options.empty();
          options.forEach(function(body){
            this.options.append(body);
          })
          this.body.after(this.options);
        },
        get_body: function(body){
            return this.body;
        },
        set_footer: function(footer){
            this.footer.empty();
            this.footer.append(footer);
        },
        get_footer: function(body){
            return this.footer;
        },
        show: function(){
            $(this.modal_class).modal('show');
        },
        close: function(){
            $(this.modal_class).modal('hide');
        },
        set_ok: function(callback){
            if( this.footer.children().length  < 1 ){
                this.set_default_actions();
            }
            this.footer.find('.submit').off('click').on('click', callback);
        },
        set_ok_label: function(label){
            this.footer.find('.submit').text(label);
        },
        set_cancel: function(callback){
            if( this.footer.children().length  < 1  ){
                this.set_default_actions();
            }
            this.footer.find('.modal-cancel').on('click', callback);
        },
        set_default_actions: function(){
            if( this.footer.children().length  < 1 ){
                var action_button = $('<div class="actions-bar actions-bar-bottom"></div>');
                var cancel = $('<a data-dismiss="modal" class="modal-cancel">' + trans('Cancel') + '</a>');
                var submit = $('<button type="button" class="btn btn-primary submit" disabled>' + trans('Add') + '</button>');
                action_button.append(cancel).append(submit);
                this.set_footer(action_button);
            }
        },
        set_disabled_action: function(){
            this.footer.find('.submit').attr('disabled','disabled');
        },
        set_enabled_action: function(){
            this.footer.find('.submit').prop('disabled', false);
        },
        clear: function(){
            this.title.empty();
            this.body.empty();
            this.options.empty();
            this.footer.empty();
        },
    });
})(jQuery);
