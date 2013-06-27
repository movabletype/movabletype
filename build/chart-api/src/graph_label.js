/**
 * @param {!jQuery}
 jQuery object to which attach label element(typically graph container)
 * @param {!number} length of set of data to use
 * @param {=string} html string to use label
 * @constructor
 */
ChartAPI.Graph.Labels = function ($container, yLength, template) {
  var i, key;

  this.$labelContainer = $('<div class = "graph-labels"></div>');
  if (template) {
    $('<div class="graph-label"></div>').html(template).prependTo(this.$labelContainer);
  }

  this.totals = {};
  for (i = 0; i < yLength; i++) {
    key = 'y' + (i || '');
    this.totals[key] = new ChartAPI.Graph.Labels.Total(this.$labelContainer, i);
  }

  this.$labelContainer.appendTo($container);
};

/**
 * remove label container
 */
ChartAPI.Graph.Labels.prototype.remove = function () {
  this.$labelContainer.remove();
};

/**
 * get ChartAPI.Graph.Labels.Total object
 * @param {=number} the number of Y data set
 * @return {ChartAPI.Graph.Labels.Total}
 */
ChartAPI.Graph.Labels.prototype.getTotalObject = function (i) {
  return this.totals['y' + (i || '')];
};

/**
 * @constructor
 * @param {!jQuery} jQuery object to attach
 * @param {!number} number for identify what Y data is associated with
 */
ChartAPI.Graph.Labels.Total = function (container, index) {
  this.index = index;
  this.$totalContainer = jQuery('<div class = "graph-total"></div>').appendTo(container);
};

/**
 * create element for displaying total count and append its container
 * @param {!number} total count
 */
ChartAPI.Graph.Labels.Total.prototype.createTotalCount = function (count) {
  jQuery('<span class="graph-total-count graph-total-count-y"' + (this.index || '') + '>' + count + '</span> ').appendTo(this.$totalContainer);
};

/**
 * create element for displaying delta
 * @param {!number} delta count
 */
ChartAPI.Graph.Labels.Total.prototype.createDeltaCount = function (delta) {
  var deltaClass = delta ? (delta < 0 ? 'minus ' : 'plus ') : 'zero ';

  jQuery('<span class="graph-delta graph-delta-y"' + (this.index || '') + '><span class="' + deltaClass + '">(' + delta + ')</span></span>').appendTo(this.$totalContainer);
};
