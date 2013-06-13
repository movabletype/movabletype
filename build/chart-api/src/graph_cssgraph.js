ChartAPI.Graph.css = {};

ChartAPI.Graph.css.Base = function (data, config) {
  this.len = data.length;
  this.$graphEl = $('<div id="' + config.id + '" class="css-graph">');
};

ChartAPI.Graph.css.Base.prototype.remove = function () {
  this.$graphEl.remove();
};

ChartAPI.Graph.css.Base.prototype.horizontalBar = function (data, config, range, $container) {
  if (config.width) {
    this.$graphEl.css({
      'width': config.width,
      'max-width': '100%',
      'margin': '0 auto'
    });
  }

  var barColor = config.barColor || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod)[1],
    barBackgroundColor = config.barBackgroundColor || '#f0f0f0',
    dateColor = config.dateColor || '#999999',
    dateColorSaturday = config.dateColorSaturday || dateColor,
    dateColorSunday = config.dateColorSunday || dateColor,
    labelColor = config.labelColor || '#999999',
    barWidth = parseInt(config.barWidth, 10) || 30,
    barInterval = parseInt(config.barInterval, 10) || 5,
    labelSize = parseInt(config.labelSize, 10) || barWidth * 0.45,
    createCSSGraphBarEl = function () {
      return $('<div class="css-graph-container"><div class="css-graph-date"></div><div class="css-graph-bar-container" style="height:' + barWidth + 'px; margin-bottom:' + barInterval + 'px"><div class="css-graph-bar"></div><div class="css-graph-bar-background"><div class="css-graph-bar-count"></div></div></div>');
    },
    dataY = $.map(data, function (d) {
      return parseInt(d.y, 10);
    }),
    label = $.map(data, function (d) {
      return {
        value: parseInt(d.x.substr(d.x.lastIndexOf('-') + 1), 10).toString(),
        weekday: ChartAPI.Date.parse(d.x) ? ChartAPI.Date.parse(d.x).getDay() : null
      }
    }),
    maxY = Math.max.apply(null, dataY) || 1,
    yLabel = config.yLabel || dataY,
    width, $el, $background, $bar, $count, $date;

  for (var i = this.len; i > 0;) {
    i = i - 1;
    width = Math.floor((dataY[i] / maxY) * 100) - 15;
    $el = createCSSGraphBarEl();
    $background = $el.find('.css-graph-bar-background');
    $background.css({
      'background-color': barBackgroundColor
    });

    if (config.showDate) {
      $date = $el.find('.css-graph-date');
      $date.text(label[i].value).css({
        'color': dateColor,
        'font-size': labelSize + 'px',
        'line-height': barWidth + 'px'
      });
      if (label[i].weekday === 6) {
        $date.addClass('saturday').css({
          'color': dateColorSaturday
        });
      } else if (label[i].weekday === 0) {
        $date.addClass('sunday').css({
          'color': dateColorSunday
        })
      }

      $el.find('.css-graph-bar-container').css({
        'margin-left': barWidth + 'px'
      });
    }

    $bar = $el.find('.css-graph-bar');
    $bar.css({
      'width': width + '%',
      'background-color': barColor
    });
    $count = $el.find('.css-graph-bar-count');
    $count.text(yLabel[i]).css({
      'color': labelColor,
      'font-size': labelSize + 'px',
      'line-height': barWidth + 'px'
    });
    $el.appendTo(this.$graphEl);
  }

  this.$graphEl.appendTo($container);
};

ChartAPI.Graph.css.Base.prototype.ratioHorizontalBar = function (data, config, range, $container) {
  var yLength = config.yLength,
    barWidth = parseInt(config.barWidth, 10) || 30,
    barInterval = parseInt(config.barInterval, 10) || 5,
    labelSize = parseInt(config.labelSize, 10) || barWidth * 0.45,
    dateColor = config.dateColor || '#999999',
    barColors = config.barColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    labelColors = config.labelColors,
    labelClasses = config.labelClasses,
    i, j,
    d, dataY, totalY, $barContainer, $el, $bar, label, $date, width, totalWidth;

  for (i = 0; i < this.len; i++) {
    d = data[i];
    dataY = [];
    totalY = 0;
    totalWidth = 0;
    for (j = 0; j < yLength; j++) {
      dataY.push(d['y' + (j || '')]);
      totalY = totalY + parseInt(d['y' + (j || '')], 10);
    }

    $barContainer = $('<div class="css-graph-container"></div>').appendTo(this.$graphEl);
    if (config.showDate && d.x) {
      label = parseInt(d.x.substr(d.x.lastIndexOf('-') + 1), 10).toString();
      $date = $('<div class="css-graph-date" style="color:' + dateColor + ';font-size: ' + labelSize + 'px; line-height:' + barWidth + 'px">' + label + '</div>').appendTo($barContainer);
    }

    $el = $('<div class="css-graph-bar-container" style="height:' + barWidth + 'px; margin-bottom:' + barInterval + 'px"></div>').appendTo($barContainer);

    if (config.showDate) {
      $el.css({
        'margin-left': barWidth + 'px'
      });
    }

    for (j = 0; j < yLength; j++) {
      width = Math.floor((dataY[j] / totalY) * 1000) / 10;

      if (width) {
        if (yLength === j) {
          width = 100 - totalWidth;
        }
        totalWidth = totalWidth + width;

        $bar = $('<div class="css-graph-y css-graph-y' + (j || '') + '" data-count="' + dataY[j] + '" style="line-height:' + barWidth + 'px; font-size:' + labelSize + 'px"></div>');
        $bar.css({
          'width': width + '%',
          'background-color': barColors[j]
        });

        if (config.showCount) {
          $bar.text(dataY[j]);
        }

        if (labelClasses && labelClasses[j]) {
          $bar.addClass(labelClasses[j]);
        }

        if (labelColors && labelColors[j]) {
          $bar.css({
            'color': labelColors[j]
          });
        }

        $bar.appendTo($el);
      }
    }

    $el.appendTo($barContainer);
  }
  this.$graphEl.appendTo($container);
};

ChartAPI.Graph.css.horizontalBar = ChartAPI.Graph.css.ratioHorizontalBar = function (data, config, range, $container) {
  var cssGraph = new ChartAPI.Graph.css.Base(data, config, range, $container);
  var method = config.type.slice(config.type.lastIndexOf('.') + 1);
  cssGraph[method](data, config, range, $container);
  return cssGraph;
};
