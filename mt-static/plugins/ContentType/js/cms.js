(function($) {

var isdirty = false;
window.setDirty = function(dirty) {
  isdirty = dirty;
  if (isdirty) {
    $('button.save').removeAttr('disabled').removeClass('disabled');
  }
  else {
    $('button.save').attr('disabled', 'disabled').addClass('disabled');
  }
}

$(window).bind('beforeunload', function() {
  if (isdirty) {
    return trans('You have unsaved changes to this page that will be lost.');
  }
});

})(jQuery);
