/**
 * create Slider Object
 * If you want to draw slider, fire APPEND_SLIDER event for its container Element like this
 * $('.container').trigger('APPEND_SLIDER')
 *
 * @param {object} slider setings
 * @param {object} range object
 * @param {jQuery} jQuery object of graph/list container element for getting data range
 * @param {Array.<jQuery>} array of jQuery object to fire update event
 * @param {
   Array. < jQuery >
 }
 array of jQuery object to fire event
 for getting amount labels(this event fired when range is timeline)
 * @return {object} jQuery object of slider container for chaining
 * @constructor
 */
ChartAPI.Slider = function (config, range, $dataRangeTarget, updateTarget, amountTarget) {
  if (!$.ui || !$.ui.slider) {
    throw 'ChartAPI.Slider requied jQuery UI Slider';
  }
  var that = this;
  this.id = 'slider-' + (new Date()).valueOf() + Math.floor(Math.random() * 100);
  this.config = config;
  this.range = ChartAPI.Range.generate(range);
  this.$dataRangeTarget = $dataRangeTarget;
  this.$sliderContainer = $('<div id="' + this.id + '-container" class="slider-container"></div>');

  this.eventTargetList = {
    update: this.initEventTarget(),
    amount: this.initEventTarget()
  };

  $.each(updateTarget, function (i, v) {
    that.eventTargetList.update.add(v);
  });

  $.each(amountTarget, function (i, v) {
    that.eventTargetList.amount.add(v);
  });

  /**
   * @param {object} jQuery event object
   * @param {jQuery} jQuery object to attach slider
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('APPEND_TO', function (e, $container) {
    that.$container = $container;
    that.draw_($container);
    return $(this);
  });

  /**
   * for building slider UI
   * @param {object} jQuery event object
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('BUILD_SLIDER', function () {
    that.$dataRangeTarget.trigger('GET_DATA_RANGE', function (dataRange) {
      that.buildSlider(dataRange.min, dataRange.max);
    });
    return $(this);
  });

  /**
   * @param {object} jQuery event object
   * @param {jQuery} jQuery object of container for graph|list object to get data range
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('SET_DATA_RANGE', function (e, $target) {
    that.$dataRangeTarget = $target;
    return $(this);
  });

  /**
   * @param {object} jQuery event object
   * @param {string} the type of event (update|amount) to fire on
   * @param {Array.<jQuery>} array of jQuery object to add event target
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('ADD_EVENT_LIST', function (e, type, $targets) {
    $targets = $.isArray($targets) ? $targets : [$targets];
    $.each($targets, function (i, $target) {
      that.eventTargetList[type].add($target);
    });
    return $(this);
  });

  /**
   * @param {object} jQuery event object
   * @param {string} the type of event (update|amount) to fire on
   * @param {Array.<jQuery>} array of jQuery object to remove from event targets
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('REMOVE_EVENT_LIST', function (e, type, $targets) {
    $targets = $.isArray($targets) ? $targets : [$targets];
    $.each($targets, function (i, $target) {
      that.eventTargetList[type].remove($target);
    });
    return $(this);
  });


  this.$sliderContainer.on('ERASE', function () {
    that.erase_();
    return $(this);
  });

  this.$sliderContainer.on('REDRAW', function () {
    var $this = $(this);
    $this.trigger('BUILD_SLIDER').trigger('APPEND_TO', [that.$container]);
    return $(this);
  });

  this.$sliderContainer.on('UPDATE', function (e, values) {
    that.$slider("values", values);
    that.updateSliderAmount(values);
    return $(this);
  });

  return this.$sliderContainer;
};

/**
 * return event target object encapsulated target array
 * @return {{add:Function, remove:Function, get:Function}}
 */
ChartAPI.Slider.prototype.initEventTarget = function () {
  var target = [];
  return {
    add: function (newTarget) {
      target.push(newTarget);
    },
    remove: function (removeTarget) {
      target = $.grep(target, function (v) {
        return v !== removeTarget;
      });
    },
    get: function () {
      return target;
    }
  };
};

/**
 * build Slider UI
 * @param {number} number of the left slider handler position
 * @param {number} number of the right slider handler position
 * @param {{max:number, min:number}} Object which has max and min values
 * @return nothing
 */
ChartAPI.Slider.prototype.buildSlider = function (sliderMin, sliderMax, values) {
  var that = this;
  values = values || [this.range.min, this.range.max];

  if (this.$slider) {
    this.$slider.destroy();
    this.$slider.remove();
  }
  this.$slider = $('<div class="slider"></div>').slider({
    'range': true,
    'min': sliderMin,
    'max': sliderMax,
    'values': values,
    'slide': function (e, ui) {
      that.updateSliderAmount(ui.values, ui);
    },
    'stop': function (e, ui) {
      that.updateGraphAndList(ui.values);
    }
  }).appendTo(that.$sliderContainer);

  if (!this.config.hideSliderAmount) {
    this.$amount = $('<div class="amount"></div>');

    if (!this.config.appendSliderAmountBottom) {
      this.$amount.prependTo(this.$sliderContainer);
    } else {
      this.$amount.appendTo(this.$sliderContainer);
    }

    this.updateSliderAmount(values);
  }
};

/**
 * append Slider container to desinated element
 * @param {jQuery}
 * @return nothing
 */
ChartAPI.Slider.prototype.draw_ = function ($container) {
  this.$sliderContainer.appendTo($container);
};

/**
 * erase Slider by removing the container
 * if you want to redraw Slider, trigger 'REDRAW' for the slider container.
 */
ChartAPI.Slider.prototype.erase_ = function () {
  if (this.$slider) {
    this.$slider.destroy();
  }
  this.$sliderContainer.html('');
};

/**
 * update Slider Amount contents
 * @param {Array.<number>} values of slider position
 * @param {object} ui object returned from Slider event
 */
ChartAPI.Slider.prototype.updateSliderAmount = function (values, ui) {
  var s, e, u, newRange, maxLength = this.range.maxLength,
    $amount = this.$amount;

  if (this.range.isTimeline) {
    s = ChartAPI.Date.parse(values[0]);
    e = ChartAPI.Date.parse(values[1]);
    u = this.range.unit;

    newRange = ChartAPI.Range.getLength(s, e, u);

    if (ui && newRange > maxLength) {
      if (ui.value === ui.values[0]) {
        e = ChartAPI.Date.calcDate(s, maxLength, u, false);
        this.$slider.slider('values', 1, e.valueOf());
      } else {
        s = ChartAPI.Date.calcDate(e, maxLength, u, true);
        this.$slider.slider('values', 0, s.valueOf());
      }
    }

    if ($amount) {
      $amount.text([ChartAPI.Date.createXLabel(s, u), ChartAPI.Date.createXLabel(e, u)].join(' - '));
    }
  } else {
    s = values[0];
    e = values[1];
    if ((e - s) > maxLength) {
      if (ui.value === ui.values[0]) {
        e = maxLength - s;
        this.$slider.slider('values', 1, e);
      } else {
        s = e - maxLength;
        this.$slider.slider('values', 0, s);
      }
    }
    if ($amount) {
      $.each(this.eventTargetList.amount.get(), function (i, $target) {
        $target.trigger('GET_LABEL', [
          [s, e],
          function (a) {
            $amount.text([a[0], a[1]].join(' - '));
          }
        ]);
      });
    }
  }
};

/**
 * @param {Array.<number>} values of slider handler position
 * @param {=string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 */
ChartAPI.Slider.prototype.updateGraphAndList = function (values, newUnit) {
  $.each(this.eventTargetList.update.get(), function (i, $target) {
    $target.trigger('UPDATE', [values, newUnit]);
  });
};

/**
 * update slider handlers position
 * @param {number} index of slider handler (left is 0, right is 1)
 * @param {number} value of slider handler position
 */
ChartAPI.Slider.prototype.update_ = function (index, value) {
  this.$slider.slider('values', index, value);
};
