;(function ($) {
  /*
   * mtCheckbox
   *
   * Usage:
   *   jQuery.mtCheckbox();
   *
   */
  $.mtCheckbox = function() {
      function verify_all_checked($table) {
          var n = $table.find('tbody input:checked').length;
          if ($table.find('tbody :checkbox').length === n) {
              $table.find('thead :checkbox, tfoot :checkbox').prop('checked', true);
          } else {
              $table.find('thead :checkbox, tfoot :checkbox').prop('checked',false);
          }
      }

      $('thead :checkbox, tfoot :checkbox').click(function() {
          var $checkboxes = $(this).parents('table').find(':checkbox');
          if (this.checked) {
              $checkboxes.prop('checked', true).parents('tr').addClass('selected').next('.slave').addClass('selected');
          } else {
              $checkboxes.prop('checked', false).parents('tr').removeClass('selected').next('.slave').removeClass('selected');
          }
      });

      $('tbody :checkbox').click(function() {
          if (this.checked) {
              $(this).parents('tr').addClass('selected').next('.slave').addClass('selected');
          } else {
              $(this).parents('tr').removeClass('selected').next('.slave').removeClass('selected');
          }
          verify_all_checked($(this).parents('table'));
      });

      $('tbody').each(function() {
          $(this).find(':checkbox').parents('tr').removeClass('selected')
              .find('input:checked').parents('tr').addClass('selected');
          verify_all_checked($(this).parents('table'));
      });
  };
})(jQuery);
