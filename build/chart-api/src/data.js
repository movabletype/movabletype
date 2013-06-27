ChartAPI.Data = {};

/**
 * return back cloned data to callback.
 * @param {!jQuery} jQuery ajax/deffered object
 * @param {=jQuery} jQuery objecto of container element to attach ajax response status message which is required when this keyword has context(not null).
 * @param {Function} callback function
 * @param {=Object} current context
 * @return {object}
 */
ChartAPI.Data.getData = function (obj, $container, callback, that) {
  var cloneData, status, def, errorClassName;
  if (obj) {
    obj.done(function (data) {
      if (!cloneData) {
        if (typeof data === 'string') {
          cloneData = data.toString();
        } else if (jQuery.isArray(data)) {
          cloneData = jQuery.map(data, function (v) {
            return jQuery.extend({}, v);
          });
        } else {
          cloneData = jQuery.extend({}, data);
        }
      }
      callback(cloneData);
    })
      .fail(function (e) {
      status = {
        '404': 'Data is not found',
        '403': 'Data is forbidden to access'
      };
      def = 'Some error occured in the data fetching process';
      errorClassName = e.status ? 'error-' + e.status : 'error-unknown';
      if (that) {
        that.$errormsg = jQuery('<div class="error ' + errorClassName + '">' + (status[e.status] || def) + '</div>')
          .appendTo($container);
      }
    })
      .always(function () {
      if (that && that.$progress && that.$progress.parent().length > 0) {
        that.$progress.remove();
      }
    })
      .progress(function () {
      if (that && (!that.$progress || that.$progress.parent().length === 0)) {
        that.$progress = jQuery('<div class="progress">fetching data...</div>')
          .appendTo($container);
      }
    });
  }
};
/**
 * @param {!object} JSON data to filter
 * @param {!Date|number} maximum threshold value for filtering
 * @param {!Date|number} minimum threshold value for filtering
 * @param {!string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 * @param {=number} the number of set of Y data
 * @param {boolean} true if you do not want to unify data into a weekly data.
 * @return {object} filtered JSON data
 */
ChartAPI.Data.filterData = function (data, max, min, u, yLength, noConcat) {
  var str, hash = {};

  yLength = yLength || 1;
  jQuery.each(data, function (i, v) {
    var td, key;
    td = ChartAPI.Date.parse(v.x);
    if (td && td >= min && td <= max) {
      if (noConcat) {
        key = ChartAPI.Date.createId(td, 'daily');
        hash[key] = v;
      } else {
        if (u === 'weekly') {
          td = ChartAPI.Date.getWeekStartday(td);
        }
        key = ChartAPI.Date.createId(td, u);
        if (hash[key]) {
          for (i = 0; i < yLength; i++) {
            str = i ? 'y' + i : 'y';
            hash[key][str] = parseInt(hash[key][str], 10) + parseInt(v[str], 10);
          }
        } else { /* clone the object to prevent changing original */
          hash[key] = jQuery.extend({}, v);
        }
      }
    }
  });
  return hash;
};
