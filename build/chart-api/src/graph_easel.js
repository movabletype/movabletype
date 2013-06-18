ChartAPI.Graph.easel = {};

ChartAPI.Graph.easel.Base = function (data, config, range, $container) {
  this.data = data;
  this.config = config;
  this.range = range;
  this.$container = $container;
  if (!window.createjs && typeof window.require === 'function') {
    require(['easeljs'], $.proxy(function () {
      this.buildCanvas(createjs);
    }, this));
  } else {
    var width = parseInt((config.width || $container.width()), 10);

    if (width) {
      this.buildCanvas(createjs);
    } else {
      setTimeout($.proxy(function () {
        this.buildCanvas(createjs);
      }, this), 100);
    }
  }
};

ChartAPI.Graph.easel.Base.prototype.buildCanvas = function (createjs) {
  this.width = parseInt((this.config.width || this.$container.width()), 10) || 300;
  this.height = parseInt((this.config.height || this.$container.height()), 10) || 300;

  this.$canvas = $('<canvas id="' + this.config.id + '" class="graph-canvas" width="' + this.width + '" height="' + this.height + '">').appendTo(this.$container);
  this.canvas = this.$canvas.get(0);
  this.canvas.getContext('2d');

  this.stage = this.graph = new createjs.Stage(this.canvas);
  this.stage.update();
  var method = this.config.type.split('.')[1];
  this[method](this.data, this.config);
};

ChartAPI.Graph.easel.Base.prototype.remove = function () {
  this.$canvas.remove();
};

ChartAPI.Graph.easel.Base.prototype.bar = function (data, config) {
  var length = data.length,
    barColorAlpha = config.chartColorsAlpha ? config.chartColorsAlpha[0] : 1,
    barColors = config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    barColor = this.convertColor(barColors[0], barColorAlpha),
    barMargin = parseInt(config.barMargin, 10) || 10,
    barContentWidth = Math.floor(this.width / length),
    barWidth = barContentWidth - barMargin,
    leftMargin = Math.floor((this.width - (barContentWidth * length)) / 2) + barMargin / 2,
    dataY = $.map(data, function (d) {
      return parseInt(d.y, 10);
    }),
    maxY = Math.max.apply(null, dataY) || 1,
    shape,
    bar,
    x,
    y,
    barHeight;

  for (var i = 0; i < length; i++) {
    shape = new createjs.Shape();
    bar = shape.graphics;
    x = i * barContentWidth + leftMargin;
    barHeight = Math.floor(dataY[i] / maxY * this.height);
    y = this.height - barHeight;

    bar.beginFill(barColor).drawRect(x, y, barWidth, barHeight);
    this.stage.addChild(shape);
  }
  this.stage.update();
};

ChartAPI.Graph.easel.Base.prototype.motionLine = function (data, config) {
  var length = data.length,
    lineWidth = parseInt(config.lineWidth, 10) || 8,
    yLength = config.yLength || 1,
    lineColors = config.lineColors || config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    lineColorsAlpha = config.chartColorsAlpha || [null],
    pointerColors = config.pointerColors || config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    pointerColorsAlpha = config.pointerColorsAlpha || [null],
    pointerRadius = config.pointerRadius || 10,
    paddingTop = lineWidth / 2,
    paddingBottom = 0,
    count = (length - 1) * 2,
    moveX = Math.floor(this.width / length) / 2,
    paddingLeft = (this.width - (moveX * count)) / 2,
    height = this.height,
    canvasInnnerHeight = this.height - lineWidth,
    dataYs = [],
    dataY,
    mapfunc = function (d) {
      return parseInt(d['y' + (i || '')], 10);
    };

  if (config.drawPointer) {
    paddingBottom = paddingBottom + pointerRadius;
  }

  for (var i = 0; i < yLength; i++) {
    dataY = $.map(data, mapfunc);
    dataYs.push(dataY);
  }

  var dataYAll = [];
  $.each(dataYs, function (i, dataY) {
    dataYAll = dataYAll.concat(dataY);
  });

  var maxY = Math.max.apply(null, dataYAll) || 1,
    moveYs = [];

  var generateMoveY = function (dataY) {
    var moveY = [];
    $.each(dataY, function (i, y) {
      if (i > 0) {
        var prevY = dataY[i - 1];
        var medium = prevY + Math.floor((y - prevY) / 2);

        medium = Math.floor((medium / maxY) * canvasInnnerHeight) + paddingTop + paddingBottom;
        y = Math.floor((y / maxY) * canvasInnnerHeight) + paddingTop + paddingBottom;
        moveY = moveY.concat([medium, y]);
      } else {
        y = Math.floor((y / maxY) * canvasInnnerHeight) + paddingTop + paddingBottom;
        moveY.push(y);
      }
    });
    return moveY;
  };

  $.each(dataYs, function (i, dataY) {
    moveYs.push(generateMoveY(dataY));
  });

  var lineColor,
    shapes = [],
    lines = [],
    x = paddingLeft,
    y,
    circles = [],
    pointerColor;

  for (i = 0; i < yLength; i++) {
    lineColor = this.convertColor(lineColors[i], lineColorsAlpha[i]);
    shapes[i] = new createjs.Shape();
    lines[i] = shapes[i].graphics;
    y = height - moveYs[i][0];
    lines[i].setStrokeStyle(lineWidth).beginStroke(lineColor).moveTo(x, y);
    this.stage.addChild(shapes[i]);
    if (config.drawPointer) {
      pointerColor = this.convertColor(pointerColors[i], pointerColorsAlpha[i]);
      circles[i] = new createjs.Shape();
      circles[i].graphics.beginFill(pointerColor).drawCircle(0, 0, pointerRadius);
      this.stage.addChild(circles[i]);
    }
  }

  var stage = this.stage;

  var tick = function (e) {
    // if we are on the last frame of animation then remove the tick listener:
    count = count - 1;
    if (count === 0) {
      createjs.Ticker.removeEventListener("tick", tick);
    }

    x = x + moveX;

    var moveY;
    for (var i = 0; i < yLength; i++) {
      moveY = moveYs[i];
      y = height - moveY[moveY.length - count - 1];
      lines[i].lineTo(x, y);
      if (config.drawPointer) {
        circles[i].x = x;
        circles[i].y = Math.max(y, pointerRadius);
      }
    }

    stage.update(e);
  };

  createjs.Ticker.useRAF = true;
  createjs.Ticker.setFPS(30);
  createjs.Ticker.addEventListener('tick', tick);
};

ChartAPI.Graph.easel.Base.prototype.convertColor = function (str, alpha) {
  if (str.indexOf('#') !== -1) {
    var r = parseInt(str.substr(1, 2), 16),
      g = parseInt(str.substr(3, 2), 16),
      b = parseInt(str.substr(5, 2), 16);

    if (alpha) {
      str = 'rgba(' + [r, g, b, alpha].join(',') + ')';
    } else {
      str = 'rgb(' + [r, g, b].join(',') + ')';
    }
  } else if (str.indexOf('rgb') !== -1) {
    // wrap rgb/rgba string
    if (str.split(',').length < 4) {
      str = 'rgb(' + str + ')';
    } else {
      str = 'rgba(' + str + ')';
    }
  }
  return str;
};

ChartAPI.Graph.easel.Base.prototype.mix = function (data, config) {
  var count = 0;

  var splitData = function (length, data) {
    length = length || 1;
    var map = $.map(data, function (d) {
      var obj = {
        x: d.x
      }, key, val;

      for (var i = 0; i < length; i++) {
        key = 'y' + (i || '');
        val = 'y' + (count + i || '');
        obj[key] = d[val];
      }
      return obj;
    });
    count = count + length;
    return map;
  };

  var chartColors = config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod);

  $.each(config.mix, $.proxy(function (index, conf) {
    var colors = {
      chartColors: chartColors.slice(count, count + conf.yLength)
    };
    var partialData = splitData(conf.yLength, data);
    conf = $.extend({}, config, colors, conf);
    this[conf.type](partialData, conf);
  }, this));
};

ChartAPI.Graph.easel.bar = ChartAPI.Graph.easel.motionLine = ChartAPI.Graph.easel.mix = function (data, config, range, $container) {
  if (ChartAPI.Graph.test.canvas()) {
    var easelGraph = new ChartAPI.Graph.easel.Base(data, config, range, $container);
    return easelGraph;
  } else {
    console.warn('EaselJS graph requires for HTML5 Canvas capability');
    $container.trigger('REMOVE');
  }
};
