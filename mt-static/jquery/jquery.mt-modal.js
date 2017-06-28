;(function ($) {

  $.fn.mtModal = function (options) {
    var defaults = {
        loadingimage: MT.App.StaticURI + 'images/indicator.gif',
        esckeyclose: true
    };
    var opts = $.extend(defaults, options);
    initModal();
    return this.each(function() {
        $(this).on('click', function() {
          openModal(this.href, opts);
          return false;
        });
    });
  };

  $.fn.mtModalClose = function () {
    return this.each(function () {
      $(this).on('click', function () {
        var $modal = window.parent.$('.mt-modal');
        if ($modal.length > 0) {
          $modal.modal('hide');
        }
      });

      var url = $(this).data().mtModalClose;
      if (url) {
        var $modal = window.parent.$('.mt-modal');
        if ($modal.length > 0) {
          $modal.on('hide.bs.modal', function () {
            window.parent.location = url;
          });
        }
      }
    });
  };

  $.fn.mtModal.open = function (url, options) {
    var defaults = {
        loadingimage: MT.App.StaticURI + 'images/indicator.gif',
        esckeyclose: true
    };
    var opts = $.extend(defaults, options);
    initModal();
    openModal(url, opts);
  };

  function getModalHtml() {
    return '<div class="modal fade mt-modal">'
      + '<div class="modal-dialog">'
      + '<div class="modal-content embed-responsive">'
      + '<iframe class="embed-responsive-item"></iframe>'
      + '</div>'
      + '</div>'
      + '</div>';
  }

  function initModal() {
    var $modal = $('.mt-modal');
    if ($modal.length == 0) {
      var modalHtml = getModalHtml();
      $(document.body).append(modalHtml);

      // Disable drag & drop on overlay.
      $modal.on('dragover drop', function(e) {
        e.preventDefault();
        e.stopPropagation();
      });

      $('iframe').load(resizeModal);
      $(window).on('resize', resizeModal);
    }
  }

  function openModal(href, opts) {
    if (opts.form) {
      openModalWithForm(href, opts);
    } else {
      openModalWithoutForm(href, opts);
    }

    var $modal = $('.mt-modal');

    if (opts.large) {
      $modal.find('.modal').addClass('bs-example-modal-lg');
      $modal.find('.modal-dialog').addClass('modal-lg');
    } else {
      $modal.find('.modal').removeClass('bs-example-modal-lg');
      $modal.find('.modal-dialog').removeClass('modal-lg');
    }

    $modal.find('iframe').attr('src', href);

    $modal.modal({ keyboard: opts.esckeyclose });
  }

  function openModalWithForm(href, opts) {

  }

  function openModalWithoutForm(href, opts) {

  }

  function resizeModal() {
    var modalHeight;
    if ($('iframe').contents().find('body .modal-body').length > 0) {
      modalHeight = $('iframe').contents().find('body').outerHeight(true);
    } else {
      modalHeight = $('iframe').contents().find('body > *:first').outerHeight(true);
    }
    $('.mt-modal .modal-content').css('padding-bottom', modalHeight);
  }

})(jQuery);
