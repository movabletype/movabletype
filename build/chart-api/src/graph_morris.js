ChartAPI.Graph.morris = {};

ChartAPI.Graph.morris.Base = function (data, config, range, $container) {
  if (!window.Morris && typeof window.require === 'function') {
    require(['raphael', 'morris'], $.proxy(function () {
      this.build_(Morris, data, config, range, $container);
    }, this));
  } else {
    var width = config.width || $container.width();
    if (width) {
      this.build_(Morris, data, config, range, $container);
    } else {
      setTimeout($.proxy(function () {
        this.build_(Morris, data, config, range, $container);
      }, this), 100);
    }
  }
};

ChartAPI.Graph.morris.Base.prototype.build_ = function (Morris, data, config, range, $container) {
  var i,
    graphDefaults, graphConfig,
    method = config.type.split('.')[1],
    yLength = config.yLength,
    width = config.width || $container.width() || 300,
    height = config.height || $container.height() || 300;

  this.$graphEl = $('<div id="' + config.id + '" class="graph-element"></div>').css({
    'height': height + 'px',
    'width': width + 'px'
  }).prependTo($container);

  config = $.extend({}, config, {
    element: config.id,
    data: data,
    xkey: 'x',
    labels: this.getYLabels_(yLength, config.labels),
    ykeys: this.getYKeys_(yLength),
    ymax: this.getYMax_(data, method, yLength),
    ymin: config.ymin || 0,
    lineWidth: parseInt(config.lineWidth, 10) || 6,
    pointSize: parseInt(config.pointSize, 10) || 6,
    smooth: config.smooth || false
  });

  config.barColors = config.barColors || this.getChartColors(config);
  config.colors = config.colors || this.getChartColors(config);
  config.lineColors = config.lineColors || this.getChartColors(config);
  config.numLines = parseInt(config.numLines, 10) || this.getNumLines_(config.ymax, height);

  config.pointStrokeColors = config.pointStrokeColors ? config.pointStrokeColors.split(/,/) : [];
  if (!config.pointStrokeColors.length) {
    for (i = 0; i < yLength; i++) {
      config.pointStrokeColors.push('none');
    }
  }

  graphDefaults = {
    element: null,
    data: null,
    xkey: 'x',
    labels: [],
    ykeys: [],

    // gridDefaults
    dateFormat: null,
    axes: true,
    grid: true,
    gridLineColor: '#aaa',
    gridStrokeWidth: 0.5,
    gridTextColor: '#888',
    gridTextSize: 12,
    hideHover: false,
    hoverCallback: null,
    yLabelFormat: null,
    numLines: 5,
    padding: 25,
    parseTime: true,
    postUnits: '',
    preUnits: '',
    ymax: 'auto',
    ymin: 'auto 0',
    goals: [],
    goalStrokeWidth: 1.0,
    goalLineColors: ['#666633', '#999966', '#cc6666', '#663333'],
    events: [],
    eventStrokeWidth: 1.0,
    eventLineColors: ['#005a04', '#ccffbb', '#3a5f0b', '#005502'],

    // Line defaults
    lineWidth: 3,
    pointSize: 4,
    lineColors: ['#0b62a4', '#7A92A3', '#4da74d', '#afd8f8', '#edc240', '#cb4b4b', '#9440ed'],
    pointWidths: [1],
    pointStrokeColors: ['#ffffff'],
    pointFillColors: [],
    smooth: true,
    xLabels: 'auto',
    xLabelFormat: null,
    xLabelMargin: 50,
    continuousLine: true,

    // Bar defaults
    barSizeRatio: 0.75,
    barGap: 3,
    barColors: ['#0b62a4', '#7a92a3', '#4da74d', '#afd8f8', '#edc240', '#cb4b4b', '#9440ed'],

    // Donut defaults
    colors: ['#0B62A4', '#3980B5', '#679DC6', '#95BBD7', '#B0CCE1', '#095791', '#095085', '#083E67', '#052C48', '#042135'],
    backgroundColor: '#FFFFFF',
    labelColor: '#000000',
    formatter: Morris.commas
  };

  graphConfig = {};
  $.each(config, function (key, value) {
    if (graphDefaults[key] !== undefined) {
      graphConfig[key] = value;
    }
  });

  // IE8(VML) occured error setting smooth false
  if (!ChartAPI.Graph.test.svg) {
    graphConfig.smooth = true;
  }

  // shows percentage as Y label when graph method is donut
  if (method === 'donut') {
    var totalCount = this.getTotalCount_(data, i);
    graphConfig.formatter = function (y) {
      return y + '(' + Math.ceil((y / totalCount * 10000)) / 100 + '%)';
    };
  }

  var M = ({
    'bar': Morris.Bar,
    'line': Morris.Line,
    'donut': Morris.Donut,
    'area': Morris.Area
  })[method];

  this.graph = new M(graphConfig);
};

/**
 * get maximum value among the desinated Y data set
 * @param {!Array.<object>} graph data to get max Y
 * @param {!number} number of set of Y data
 * @return {number} return the number of maxY for graph
 */
ChartAPI.Graph.morris.Base.prototype.getYMax_ = function (data, method, yLength) {
  var i, maxY, array, sum, key;

  if (method !== 'area') {
    array = [];
    $.each(data, function (index, value) {
      for (i = 0; i < yLength; i++) {
        key = 'y' + (i || '');
        array.push(parseInt(value[key], 10));
      }
    });
    maxY = Math.max.apply(null, array);
  } else {
    maxY = Math.max.apply(null, $.map(data, function (value) {
      sum = 0;
      for (i = 0; i < yLength; i++) {
        key = 'y' + (i || '');
        sum = sum + parseInt(value[key], 10);
      }
      return sum;
    }));
  }

  if (!maxY) {
    maxY = 1;
  }

  if (maxY % 2 !== 0) {
    maxY = maxY + 1;
  }

  return maxY;
};

ChartAPI.Graph.morris.Base.prototype.getChartColors = function (config) {
  if (!this.chartColors) {
    this.chartColors = config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod);
  }
  return this.chartColors;
};

/**
 * return YKeys array for graph setting
 * @param {!number} number of set of y data
 * @return {Array.<string>} array of y key strings
 */
ChartAPI.Graph.morris.Base.prototype.getYKeys_ = function (yLength) {
  var i, array = [];
  for (i = 0; i < yLength; i++) {
    array.push('y' + (i || ''));
  }
  return array;
};

/**
 * return YLables array for graph setting
 * @param {!number} number of set of y data
 * @return {Array.<string>} array of y key strings
 */
ChartAPI.Graph.morris.Base.prototype.getYLabels_ = function (yLength, yLabel) {
  var i, array = [];
  yLabel = yLabel ? yLabel.split(/,/) : [];
  for (i = 0; i < yLength; i++) {
    array.push((yLabel[i] || 'Count'));
  }
  return array;
};

/**
 * caliculate the number of horizental lines in graph
 * @param {!number} maximum value among the Y data set.
 * @return {number}
 */
ChartAPI.Graph.morris.Base.prototype.getNumLines_ = function (maxY, height) {
  var numlines;
  if (maxY >= 18) {
    numlines = 9;
  } else if (maxY === 2) {
    numlines = 3;
  } else {
    numlines = (maxY / 2) + 1;

  }
  numlines = Math.min((numlines || 1), Math.floor(height / 56));

  return numlines;
};

/**
 * get total count of desinated Y data set.
 * @param {!object} graph JSON data
 * @param {!number} the number of set of Y data
 * @return {number} return the number of total count in current range
 */
ChartAPI.Graph.morris.Base.prototype.getTotalCount_ = function (data, index) {
  var total = 0,
    str = 'y' + (index || '');
  $.each(data, function (i, v) {
    total = total + (v[str] || v.value || 0);
  });
  return total;
};

ChartAPI.Graph.morris.Base.prototype.remove = function () {
  this.$graphEl.remove();
};

ChartAPI.Graph.morris.bar = ChartAPI.Graph.morris.line = ChartAPI.Graph.morris.donut = ChartAPI.Graph.morris.area = function (data, config, range, $container) {
  if (ChartAPI.Graph.test.vml()) {
    var morrisGraph = new ChartAPI.Graph.morris.Base(data, config, range, $container);
    return morrisGraph;
  } else {
    console.warn('Morris graph requires for SVG/VML capability');
    $container.trigger('REMOVE');
  }
};
