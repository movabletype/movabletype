function toggleSelectedRow(checkbox) {
  var $tr = jQuery(checkbox).parents('tr');
  var highlightClass = 'mt-table__highlight';
  if (checkbox.checked) {
    $tr.addClass(highlightClass);
  } else {
    $tr.removeClass(highlightClass);
  }
}

