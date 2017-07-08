;(function ($) {
  /*
   * mtEditInput
   *
   * Usage:
   *   jQuery('input.mt-edit-field').mtEditInput({ edit: '<__trans phrase="Edit">'});
   *
   *   <input name="test" class="mt-edit-field" />
   *
   */
  $.fn.mtEditInput = function(options) {
      var defaults = {
          save: 'Save'
      },
      opts = $.extend(defaults, options);
      return this.each(function() {
          var id = $(this).attr('id'),
              $input = $('input#'+id);
          if ($input.val() && !$input.hasClass('show-input')) {
              $input
                  .before('<span class="'+id+'-text"></span>')
                  .after('<button type="button" id="mt-set-'+id+'" class="btn btn-default mt-edit-field-button button">'+opts.edit+'</button>')
                  .hide();
              $('span.'+id+'-text').text($input.val());
          }
          if (!$input.val() && $input.hasClass('hide-input')) {
              $input
                  .before('<span class="'+id+'-text"></span>')
                  .after('<button type="button" id="mt-set-'+id+'" class="btn btn-default mt-edit-field-button button">'+opts.edit+'</button>')
                  .hide();
          }
          $('button#mt-set-'+id).click(function() {
              $(this).hide();
              $('span.'+id+'-text').hide();
              $('input#'+id).show();
              $('p#'+id+'-warning').show();
              return false;
          });
      });
  };
})(jQuery);
