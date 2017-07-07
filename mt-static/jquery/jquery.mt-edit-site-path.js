;(function ($) {
  /*
   * mtEditSitePath
   *
   * Usage:
   *   jQuery.mtEditSitePath();
   *
   */
  $.mtEditSitePath = function(options) {
      var defaults = {
          edit: 'Edit'
      },
      opts = $.extend(defaults, options),
      ids = ['site', 'archive'];
      $.each(ids, function() {
          var id = this, $path,
              $absolute_path = $('input#'+id+'_path_absolute');
          if ( !$absolute_path.hasClass('show-input') ) {
              $absolute_path
                  .before('<span class="'+id+'_path_absolute-text path-text"></span>')
                  .after('<button type="button" id="mt-set-'+id+'_path_absolute" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                  .hide();
              $('span.'+id+'_path_absolute-text').text($absolute_path.val());
          }

          $path = $('input#'+id+'_path');
          if ( !$path.hasClass('show-input') ) {
              $path
                  .before('<span class="'+id+'_path-text path-text"></span>')
                  .after('<button type="button" id="mt-set-'+id+'_path" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                  .hide();
              $('span.'+id+'_path-text').text($path.val());

              $path.parents('.field-content').find('.use-absolute').hide();
          }


          $('button#mt-set-'+id+'_path_absolute').click(function() {
              $('span.'+id+'_path_absolute-text').hide();
              $absolute_path.addClass('show-input').show();
              $('p#'+id+'_path-warning').show();
              $(this).hide();
              $path.parents('.field-content').find('.use-absolute').show();

              if ( !$path.hasClass('show-input') ) {
                  $('button#mt-set-'+id+'_path').click();
              }
              return false;
          });
          $('button#mt-set-'+id+'_path').click(function() {
              $('span.'+id+'_path-text').hide();
              $path.addClass('show-input').show();
              $('p#'+id+'_path-warning').show();
              $(this).hide();
              $path.parents('.field-content').find('.use-absolute').show();

              if ( !$absolute_path.hasClass('show-input') ) {
                  $('button#mt-set-'+id+'_path_absolute').click();
              }
              return false;
          });
      });
  };
})(jQuery);
