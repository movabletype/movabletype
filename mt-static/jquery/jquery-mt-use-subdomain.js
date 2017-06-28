;(function ($) {
  /*
   * mtUseSubdmain
   *
   * Usage:
   *   jQuery.mtUseSubdomain();
   *
   */
  $.mtUseSubdomain = function(options) {
      var $checkboxes = $('.url-field :checkbox');
      $checkboxes.each(function() {
          if (!this.checked) {
              $(this).parents('.field-content').find('.subdomain').hide();
          }
      });
      $checkboxes.click(function() {
          var $subdomain, $subdomain_input;

          if (this.checked) {
              $subdomain =
                  $(this).prop('checked',true).parents('.field-content').find('.subdomain').show();
          } else {
              $subdomain =
                  $(this).prop('checked',false).parents('.field-content').find('.subdomain').hide();
          }

          $subdomain_input = $subdomain.find('input');
          if ($subdomain_input.val() && $subdomain_input.data('mtValidator')) {
              $subdomain_input.mtValid({ focus: false });
          }
      });
  };
})(jQuery);
