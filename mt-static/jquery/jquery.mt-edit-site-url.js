;(function ($) {
  /*
   * mtEditSiteUrl
   *
   * Usage:
   *   jQuery.mtEditSiteUrl();
   *
   */
  $.mtEditSiteUrl = function(options) {
      var defaults = {
          edit: 'Edit'
      },
      opts = $.extend(defaults, options),
      ids = ['site', 'archive'];
      $.each(ids, function() {
          var id = this,
              $subdomain = $('input#'+this+'_url_subdomain'),
              $path = $('input#'+this+'_url_path'),
              subdomain = $subdomain.val();
          if (subdomain) {
              $subdomain
                  .parent('.subdomain')
                  .before('<span class="'+this+'_url_subdomain-text path-text"></span>');
              $('span.'+this+'_url_subdomain-text').text($subdomain.val()+'.');
          }
          if (!$path.hasClass('show-input')) {
              $path
                  .before('<span class="'+this+'_url_path-text path-text"></span>')
                  .after('<button type="button" id="mt-set-'+this+'_url_path" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                  .hide();
              $('span.'+this+'_url_path-text').text($path.val());
              $subdomain.parents('.field-content').find('.subdomain').hide();
              $subdomain.parents('.field-content').find('.use-subdomain').hide();
          } else {
              $subdomain.parents('.field-content').find('.subdomain').show();
              $subdomain.parents('.field-content').find('.use-subdomain').show();
          }
          if (subdomain && subdomain.match(/^http/)) {
              $subdomain.parents('.field-content').find('.use-subdomain').hide().end()
                  .find('span.archive-url-domain').hide()
                  .before('<span class="'+this+'_url_path-text path-text">'+$subdomain.val()+'</span>');
              if ($('button#mt-set-'+this+'_url_path').length === 0) {
                  $path
                      .after('<button type="button" id="mt-set-'+this+'_url_path" class="btn btn-default button mt-edit-field-button">'+opts.edit+'</button>')
                      .hide();
              }
          }
          $('button#mt-set-'+this+'_url_path').click(function() {
              $(this).hide();
              $('span.'+id+'_url_subdomain-text').hide();
              var subdomain = $subdomain.val();
              if (subdomain) {
                  $subdomain.parents('.field-content').find('.subdomain').show().end()
                      .find('span.archive-url-domain').show();
                  if (subdomain.match(/^http/)) {
                      $subdomain.val('');
                  }
              }
              $('span.'+id+'_url_path-text').hide();
              $path.show();
              $(this).parents('.field-content').find('.use-subdomain').show();
              $('p#'+id+'_url-warning').show();
              return false;
          });
      });
  };
})(jQuery);
