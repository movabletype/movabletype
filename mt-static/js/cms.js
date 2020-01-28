(function($) {

var isdirty = false;
window.setDirty = function(dirty) {
  isdirty = dirty;
  if (isdirty) {
    $('button.save').prop('disabled', false).removeClass('disabled');
  }
  else {
    $('button.save').attr('disabled', 'disabled').addClass('disabled');
  }
}

$(window).on('beforeunload', function() {
  if (isdirty) {
    return trans('You have unsaved changes to this page that will be lost.');
  }
});

})(jQuery);
