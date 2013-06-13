/**
 * builder funciton. return jQuery object for chaining and triggering events
 * @return {jQuery}
 */
ChartAPI.Build = function (settings) {
  var $container;
  if (typeof settings === 'string' && (/\.json$/).test(settings)) {
    $container = $('<div class="mtchart-container">');
    ChartAPI.Data.getData($.getJSON(settings), null, function (settings) {
      settings.$container = $container;
      ChartAPI.Build_(settings).trigger('APPEND');
    });
  } else {
    $container = ChartAPI.Build_(settings).trigger('APPEND');
  }
  return $container;
};

/**
 * internal method for building graph|slider|list objects
 * @param {Object} settings
 * @param {=jQuery} jQuery object to attach graph|slider|list object
 */
ChartAPI.Build_ = function (settings) {
  var $container, $graphContainer, $sliderContainer, $listContainer, dataRangeTarget, sliderUpdateTarget, sliderAmountTarget;

  $container = settings.$container || $('<div class="mtchart-container">');

  sliderUpdateTarget = [];

  if (settings.graph) {
    $graphContainer = new ChartAPI.Graph(settings.graph, settings.range);
    sliderUpdateTarget.push($graphContainer);
  }

  if (settings.list) {
    $listContainer = new ChartAPI.List(settings.list, settings.range);
    if (settings.list.data) {
      sliderUpdateTarget.push($listContainer);
    }
  }

  if (settings.graph && settings.graph.type !== 'donut') {
    dataRangeTarget = $graphContainer;
    sliderAmountTarget = [$graphContainer];
  } else {
    dataRangeTarget = $listContainer;
    sliderAmountTarget = [$listContainer];
  }

  var isSmartPhone = function () {
    var userAgent = window.navigator ? window.navigator.userAgent : '';
    return (/android|iphone|ipod|ipad/i).test(userAgent);
  };

  if (settings.slider && (settings.slider.force || !isSmartPhone())) {
    $sliderContainer = new ChartAPI.Slider(settings.slider, settings.range, dataRangeTarget, sliderUpdateTarget, sliderAmountTarget);
  }

  $container.on('APPEND', function () {
    if ($graphContainer) {
      $graphContainer.trigger('APPEND_TO', [$container]);
    }
    if ($sliderContainer) {
      $sliderContainer.trigger('BUILD_SLIDER')
        .trigger('APPEND_TO', [$container]);
    }
    if ($listContainer) {
      $listContainer.trigger('APPEND_TO', [$container]);
    }
  });

  $container.on('GET_CONTAINER', function (e, type, callback) {
    callback({
      'graph': $graphContainer,
      'slider': $sliderContainer,
      'list': $listContainer
    }[type]);
  });

  return $container;
};
