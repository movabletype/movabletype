;(function ($) {
  /*
   * mtUseAbsolute
   *
   * Usage:
   *   jQuery.mtUseAbsolute();
   *
   */
  $.mtUseAbsolute = function() {
      var $checkboxes = $('.site-path-field :checkbox');
      $checkboxes.each(function() {
          var $obj;
          if (!this.checked) {
              $obj = $(this).parents('.field-content');
              $obj.find('.relative-site_path').show();
              $obj.find('.absolute-site_path').hide();
              $obj.find('.relative-site_path-hint').show();
              $obj.find('.absolute-site_path-hint').hide();
          } else {
              $obj = $(this).parents('.field-content');
              $obj.find('.relative-site_path').hide();
              $obj.find('.absolute-site_path').show();
              $obj.find('.relative-site_path-hint').hide();
              $obj.find('.absolute-site_path-hint').show();
          }
      });
      $checkboxes.click(function() {
          var $obj;
          if (this.checked) {
              $obj = $(this).prop('checked', true).parents('.field-content');
              $obj.find('.relative-site_path').hide();
              $obj.find('.absolute-site_path').show();
              $obj.find('.relative-site_path-hint').hide();
              $obj.find('.absolute-site_path-hint').show();
              $obj.find('.absolute-site_path').find(':input').removeClass('ignore-validate');
              $obj.find('.relative-site_path').find(':input').addClass('ignore-validate');
          } else {
              $obj = $(this).prop('checked', false).parents('.field-content');
              $obj.find('.relative-site_path').show();
              $obj.find('.absolute-site_path').hide();
              $obj.find('.relative-site_path-hint').show();
              $obj.find('.absolute-site_path-hint').hide();
              $obj.find('.relative-site_path').find(':input').removeClass('ignore-validate');
              $obj.find('.absolute-site_path').find(':input').addClass('ignore-validate');
          }
      });
  };
})(jQuery);

