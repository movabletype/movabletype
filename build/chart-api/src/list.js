/**
 * create List Object
 * If you want to draw list, fire APPEND_LIST event for its container Element like this
 * $('.container').trigger('APPEND_LIST')
 *
 * @param {object} list setings
 * @param {object} range object
 * @return {jQuery} return jQuery object for chaining
 * @constructor
 */
ChartAPI.List = function (config, range) {
  this.id = 'list-' + (new Date()).valueOf() + Math.floor(Math.random() * 100);
  this.config = config;

  this.config.staticPath = this.config.staticPath || '';

  if (this.config.data && typeof this.config.data === 'string') {
    this.origData_ = $.getJSON(this.config.staticPath + this.config.data);
  } else {
    this.origData_ = $.Deferred();
    this.origData_.resolve(this.config.data);
  }

  if (this.config.template) {
    if (window.require && typeof require === 'function') {
      var templateType = this.config.type || 'text';
      this.template_ = $.Deferred();
      require([templateType + '!' + this.config.staticPath + this.config.template], $.proxy(function (template) {
        this.template_.resolve(template);
      }, this));
    } else {
      this.template_ = $.get(this.config.staticPath + this.config.template, 'text');
    }

    this.range = ChartAPI.Range.generate(range);

    this.$listContainer = $('<div id="' + this.id + '-container" class="list-container"></div>');

    this.$listContainer.on('UPDATE', $.proxy(function (e, range) {
      this.update_(range);
    }, this));

    /**
     * @return {jQuery} return jQuery object for chaining
     * return back the graph data range to callback
     */
    this.$listContainer.on('GET_DATA_RANGE', $.proxy(function (e, callback) {
      this.getData($.proxy(function (data) {
        callback(ChartAPI.Range.getDataRange(data, this.range.isTimeline));
      }, this));
      return this.$listContainer;
    }, this));

    /**
     * @return {jQuery} return jQuery object for chaining
     * return back the graph label array to callback
     */

    this.$listContainer.on('GET_LABEL', $.proxy(function (e, indexArray, callback) {
      this.getData($.proxy(function (data) {
        callback(this.getDataLabelByIndex(indexArray, data));
      }, this));
      return this.$listContainer;
    }, this));

    /**
     * append graph container to the desinated container
     * @return {jQuery} return jQuery object for chaining
     */

    this.$listContainer.on('APPEND_TO', $.proxy(function (e, $container) {
      this.$listContainer.appendTo($container);
      this.getData($.proxy(function (data) {
        this.draw_(data);
      }, this));
      return this.$listContainer;
    }, this));

    return this.$listContainer;
  }
};

/**
 * get list data JSON
 * @param {!Function} callback function which recieve jSON data
 */
ChartAPI.List.prototype.getData = function (callback) {
  if (this.config.data) {
    ChartAPI.Data.getData(this.origData_, this.$listContainer, callback, this);
  } else {
    callback();
  }
};

/**
 * get list template string
 * @param {!Function} callback function which recieve template string
 */
ChartAPI.List.prototype.getTemplate = function (callback) {
  ChartAPI.Data.getData(this.template_, this.$listContainer, callback, this);
};

/**
 * generate html using template string
 * @param {!object} list JSON data
 */
ChartAPI.List.prototype.draw_ = function (data) {
  var that = this;
  this.getTemplate(function (templateString) {
    data = that.createListData(data);
    that.$listContainer.html(_.template(templateString, data));
  });
};

/**
 * provide x label data for slider
 * @param {!Array.<number>} array of index to get data
 * @param {!object} list JSON data
 */
ChartAPI.List.prototype.getDataLabelByIndex = function (indexArray, data) {
  var label = this.config.dataLabel || 'x';
  return $.map(indexArray, function (i) {
    return data[i][label];
  });
};

/**
 * @param {!object} list JSON data
 * @return {object} filtered data for using list template
 */
ChartAPI.List.prototype.createListData = function (data) {
  var filteredData = '';
  if (data) {
    if (this.range.isTimeline) {
      filteredData = ChartAPI.Data.filterData(data, this.range.max, this.range.min, this.range.unit, 1, true);
    } else {
      filteredData = data.slice(this.range.min, this.range.max + 1);
    }
  }
  return {
    'data': filteredData
  };
};

/**
 * update list template
 * @param {=Array.<number>} array of number
 * @param {=string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 */
ChartAPI.List.prototype.update_ = function (newRange, unit) {
  var that = this;
  newRange = newRange || [];
  unit = unit || this.range.unit;
  this.range = ChartAPI.Range.generate({
    'start': newRange[0] || this.range.start,
    'end': newRange[1] || this.range.end,
    'length': null,
    'maxLength': this.range.maxLength,
    'unit': unit,
    'dataType': this.range.dataType
  });
  this.getData(function (data) {
    that.draw_(data);
  });
};
