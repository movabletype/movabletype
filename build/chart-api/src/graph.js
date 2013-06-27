/**
 * Creates Graph Object
 * If you want to draw graph, fire APPEND_GRAPH event for its container Element like this
 * $container is the jQuery object to which the graph append
 * $('#graphContainer').trigger('APPEND_TO',[$container])
 * you want to update graph as well, fire UPDATE event like the same manner above.
 *
 * @param {object} graph setings
 * @param {object} object including range settings
 * @return {jQuery} return container jQuery object
 * @constructor
 */
ChartAPI.Graph = function (config, range) {
  this.config = $.extend({
    type: 'morris.bar',
    staticPath: '',
    data: 'graph.json'
  }, config);

  this.config.id = 'graph-' + (new Date()).valueOf() + Math.floor(Math.random() * 100);
  this.config.yLength = parseInt(this.config.yLength, 10) || 1;

  this.range = ChartAPI.Range.generate(range);

  if (typeof this.config.data === 'string') {
    this.origData_ = $.getJSON(this.config.staticPath + this.config.data);
  } else {
    this.origData_ = $.Deferred();
    this.origData_.resolve(this.config.data);
  }

  this.graphData = {};
  this.graphData[this.range.unit] = $.Deferred();

  this.getData($.proxy(function (data) {
    this.graphData[this.range.unit].resolve(this.generateGraphData(data));
  }, this));

  this.$graphContainer = $('<div id="' + this.config.id + '-container" class="graph-container">');

  /**
   * @return {jQuery} return jQuery object for chaining
   * update graph
   */
  this.$graphContainer.on('UPDATE', $.proxy(function (e, newRange, unit) {
    this.update_(newRange, unit);
    return $(this.$graphContainer);
  }, this));

  this.$graphContainer.on('REMOVE', $.proxy(function () {
    this.remove_();
  }, this));

  // IE8 fires resize event even when document.body.innerWidht/innerHeight changing
  // so check window.width and update only when window.width changing.
  var windowWidth = $(window).width();
  this.updateFunc = $.proxy(function () {
    if (windowWidth && windowWidth !== $(window).width()) {
      windowWidth = $(window).width();
      this.update_();
    }
  }, this);

  if (config.autoResize) {
    $(window).on('orientationchange debouncedresize', this.updateFunc);
  }

  /**
   * @return {jQuery} return jQuery object for chaining
   * return back the graph data range to callback
   */
  this.$graphContainer.on('GET_DATA_RANGE', $.proxy(function (e, callback) {
    $.proxy(this.getData($.proxy(function (data) {
      callback(ChartAPI.Range.getDataRange(data, this.range.isTimeline));
    }, this), this));
    return $(this.$graphContainer);
  }, this));

  /**
   * @return {jQuery} return jQuery object for chaining
   * return back the graph label array to callback
   */
  this.$graphContainer.on('GET_LABEL', $.proxy(function (e, indexArray, callback) {
    $.proxy(this.getData($.proxy(function (data) {
      callback(this.getDataLabelByIndex(indexArray, data));
    }, this), this));
    return $(this.$graphContainer);
  }, this));

  /**
   * append graph container to the desinated container
   * @return {jQuery} return jQuery object for chaining
   */
  this.$graphContainer.on('APPEND_TO', $.proxy(function (e, container) {
    this.$graphContainer.appendTo(container);
    this.graphData[this.range.unit].done($.proxy(function (data) {
      var filteredData;
      if (this.range.isTimeline) {
        filteredData = $.grep(data, $.proxy(function (v) {
          return this.range.start <= v.timestamp && v.timestamp <= this.range.end;
        }, this));
      } else {
        filteredData = data.slice(this.range.min, this.range.max + 1);
      }
      this.draw_(filteredData);
    }, this));
    return $(this.$graphContainer);
  }, this));

  return this.$graphContainer;
};

/**
 * call getData function for getting graph JSON data
 * @param {Function} callback function recieve graph JSON data
 */
ChartAPI.Graph.prototype.getData = function (callback) {
  ChartAPI.Data.getData(this.origData_, this.$graphContainer, callback, this);
};

/**
 * return data label array with array indexes
 * @param {!Array.<number>} array of indexes
 * @param {!Array.<object>} graph JSON data
 * @return {Array.<string>}
 */
ChartAPI.Graph.prototype.getDataLabelByIndex = function (indexArray, data) {
  var label = this.config.dataLabel || 'x';
  return $.map(indexArray, function (i) {
    return data[i][label];
  });
};

/**
 * get total count of desinated Y data set.
 * @param {!object} graph JSON data
 * @param {!number} the number of set of Y data
 * @return {number} return the number of total count in current range
 */
ChartAPI.Graph.prototype.getTotalCount_ = function (data, index) {
  var total = 0,
    str = 'y' + (index || '');
  $.each(data, function (i, v) {
    total = total + parseInt((v[str] || v.value || 0), 10);
  });
  return total;
};

/**
 * return the delta number and className between last and last second count
 * @param {!object} graph JSON data
 * @param {!number} number of set of Y data
 * @return {y:[number,string],y1:[number,string]}
 */
ChartAPI.Graph.prototype.getDelta_ = function (data, index) {
  var e, s, delta, key, length = data.length;

  key = 'y' + (index || '');
  e = data[length - 1];
  s = data[length - 2];
  delta = (s && e && s[key]) ? e[key] - s[key] : e[key];
  return delta === undefined ? '' : delta;
};

ChartAPI.Graph.presetColors = function () {
  return ['#6AAC2B', '#FFBE00', '#CF6DD3', '#8F2CFF', '#2D85FF', '#5584D4', '#5ED2B8', '#9CCF41', '#F87085', '#2C8087', '#8EEC6A', '#FFE700', '#FF5E19', '#FF4040', '#976BD6', '#503D99', '#395595'];
};

ChartAPI.Graph.getChartColors = function (colors, type) {
  var func = {
    'reverse': function (arr) {
      return arr.reverse();
    },
    'shuffle': function (arr) {
      var i, j, length, tmp;
      length = arr.length;
      for (i = 0; i < length; i++) {
        j = Math.floor(Math.random() * length);
        tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
      }
      return arr;
    },
    'def': function (arr) {
      return arr;
    }
  };
  return func[(type || 'def')](colors || ChartAPI.Graph.presetColors());
};

ChartAPI.Graph.cachedChartColors = {};
ChartAPI.Graph.getCachedChartColors = function (graphId, colors, type) {
  return ChartAPI.Graph.cachedChartColors[graphId] = ChartAPI.Graph.cachedChartColors[graphId] || ChartAPI.Graph.getChartColors(colors, type);
};

/**
 * Draw Graph
 * @param {!Array.<object>} graph data
 * @param {=string} graph type (bar|line|area|donut)
 * @return nothing
 */
ChartAPI.Graph.prototype.draw_ = function (data) {
  var arr = this.config.type.split('.');
  var lib = arr[0];
  var method = arr[1];
  var config = this.config;

  if (config.label) {
    if (this.labelTemplate) {
      this.generateLabel(this.labelTemplate);
    } else {
      if (config.label.template) {
        var labelTemplate = config.label.template;
        if (window.require && typeof require === 'function') {
          var templateType = config.label.type;
          require([templateType + '!' + config.staticPath + labelTemplate], $.proxy(function (template) {
            this.labelTemplate = template;
            this.generateLabel(template);
          }, this));
        } else {
          var dfd = $.get(config.staticPath + labelTemplate, 'text');
          ChartAPI.Data.getData(dfd, this.$graphContainer, $.proxy(function (template) {
            this.labelTemplate = template;
            this.generateLabel(template);
          }, this));
        }
      } else {
        this.labelTemplate = '<span class="graph-label-label"></span>';
        this.generateLabel(this.labelTemplate);
      }
    }
  }

  if (config.fallback && config.fallback.test) {
    if (!ChartAPI.Graph.test[config.fallback.test]()) {
      arr = config.fallback.type.split('.');
      lib = arr[0];
      method = arr[1];
      config = $.extend(config, config.fallback);
    }
  }

  if (config.chartColors && typeof config.chartColors === 'string') {
    config.chartColors = config.chartColors.split(',');
  }

  this.graphObject = ChartAPI.Graph[lib][method](data, config, this.range, this.$graphContainer);
};

ChartAPI.Graph.test = {};

ChartAPI.Graph.test.canvas = function () {
  var elem = document.createElement('canvas');
  return elem.getContext && elem.getContext('2d');
};

ChartAPI.Graph.test.svg = function () {
  var ns = {
    'svg': 'http://www.w3.org/2000/svg'
  };
  return !!document.createElementNS && !! document.createElementNS(ns.svg, 'svg').createSVGRect;
};

/*
 * this test checks suport both VML and SVG since we only use VML for SVG fallback
 */
ChartAPI.Graph.test.vml = function () {
  var vmlSupported;
  var svgSupported = ChartAPI.Graph.test.svg();
  // http://stackoverflow.com/questions/654112/how-do-you-detect-support-for-vml-or-svg-in-a-browser
  if (!svgSupported) {
    var a = document.body.appendChild(document.createElement('div'));
    a.innerHTML = '<v:shape id="vml_flag1" adj="1" />';
    var b = a.firstChild;
    b.style.behavior = "url(#default#VML)";
    vmlSupported = b ? typeof b.adj === "object" : true;
    a.parentNode.removeChild(a);
  }
  return (svgSupported || vmlSupported);
};

ChartAPI.Graph.prototype.generateLabel = function (template) {
  var data = this.config.label.template && this.config.label.data ? this.config.label.data : {},
    yLength = this.config.label.yLength || this.config.yLength,
    dfd;

  var finalize = $.proxy(function () {
    this.labels = new ChartAPI.Graph.Labels(this.$graphContainer, yLength, template);

    this.getData($.proxy(function (data) {
      for (var i = 0; i < yLength; i++) {
        if (!this.config.label.hideTotalCount) {
          this.labels.getTotalObject(i).createTotalCount(this.getTotalCount_(data, i));
        }
        if (!this.config.label.hideDeltaCount && this.range.isTimeline) {
          this.labels.getTotalObject(i).createDeltaCount(this.getDelta_(data, i));
        }
      }
    }, this));
  }, this);

  if (data && typeof data === 'string') {
    dfd = $.getJSON(this.config.staticPath + data);
  } else {
    dfd = $.Deferred();
    dfd.resolve(data);
  }

  dfd.done(function (data) {
    if (template && typeof template === 'function') {
      template = template(data);
      finalize();
    } else if (window._) {
      template = _.template(template, data);
      finalize();
    } else {
      template = template;
      finalize();
    }
  });
};

/**
 * update Graph
 * @param {=Array.<number>}
 * @param {=string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 */
ChartAPI.Graph.prototype.update_ = function (newRange, unit) {
  var that = this;
  newRange = newRange || [];
  if (this.graphObject && this.graphObject.remove) {
    this.graphObject.remove();
  }
  if (this.labels) {
    this.labels.remove();
  }
  this.range = ChartAPI.Range.generate({
    'start': (newRange[0] || this.range.start),
    'end': (newRange[1] || this.range.end),
    'length': null,
    'maxLength': this.range.maxLength,
    'unit': (unit || this.range.unit),
    'dataType': this.range.dataType,
    'autoSized': this.range.autoSized
  });

  this.graphData[this.range.unit].done($.proxy(function (data) {
    var filteredData;
    if (that.range.isTimeline) {
      filteredData = $.grep(data, $.proxy(function (v) {
        return this.range.min <= v.timestamp && v.timestamp <= this.range.max;
      }, this));
    } else {
      filteredData = data.slice(this.range.min, this.range.max + 1);
    }
    this.draw_(filteredData);
  }, this));
};

ChartAPI.Graph.prototype.remove_ = function () {
  if (this.config.autoResize) {
    $(window).off('orientationchange debouncedresize', this.updateFunc);
  }
  if (this.graphObject && this.graphObject.remove) {
    this.graphObject.remove();
  }
  if (this.labels) {
    this.labels.remove();
  }
  this.$graphContainer.remove();
};

ChartAPI.Graph.prototype.generateGraphData = function (data) {
  var i, j, td, key, range = this.range,
    start = range.start,
    end = range.end,
    u = range.unit,
    length = range.length,
    array = [],
    yLength = this.config.yLength || 1,
    filteredData, obj, str;
  if (this.range.isTimeline) {
    var dataRange = ChartAPI.Range.getDataRange(data, this.range.isTimeline);
    start = new Date(Math.min(this.range.min, dataRange.min));
    end = new Date(Math.max(this.range.max, dataRange.max));
    length = ChartAPI.Range.getLength(start, end, u);
    filteredData = ChartAPI.Data.filterData(data, dataRange.max, dataRange.min, u, yLength);

    for (i = 0; i < length; i++) {
      td = ChartAPI.Range.getNextDate(start, end, i, u);
      if (td) {
        key = ChartAPI.Date.createId(td, u);
        obj = {
          timestamp: td.valueOf(),
          x: ChartAPI.Date.createXLabel(td, u)
        };
        for (j = 0; j < yLength; j++) {
          str = 'y' + (j || '');
          obj[str] = filteredData[key] ? (filteredData[key][str] || 0) : 0;
        }
        array.push(obj);
      } else {
        break;
      }
    }
  } else {
    array = data;
  }
  if (this.config.type === 'morris.donut') {
    $.each(array, function (i, v) {
      $.extend(v, {
        label: (v.xLabel || v.x),
        value: v.y
      });
    });
  }
  return array;
};
