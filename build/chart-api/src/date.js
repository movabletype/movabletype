ChartAPI.Date = {};

/**
 * return the week start day
 * @param {!Date}
 * @return Date
 */
ChartAPI.Date.getWeekStartday = function (d) {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate() - d.getDay());
};

/**
 * return Date string array with padding zero which is for ISO 8601 string
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {Array.<string>}
 */
ChartAPI.Date.zeroPadArray = function (d, unit) {
  var array;
  ({
    'yearly': function () {
      array = [d.getFullYear()];
    },
    'monthly': function () {
      array = [d.getFullYear(), d.getMonth() + 1];
    },
    'quarter': function () {
      array = [d.getFullYear(), d.getMonth() + 1];
    },
    'weekly': function () {
      array = [d.getFullYear(), d.getMonth() + 1, d.getDate() - d.getDay()];
    },
    'daily': function () {
      array = [d.getFullYear(), d.getMonth() + 1, d.getDate()];
    },
    'hourly': function () {
      array = [d.getFullYear(), d.getMonth() + 1, d.getDate(), d.getHours()];
    }
  })[unit]();
  return jQuery.map(array, function (v) {
    v = v.toString();
    return v.length === 1 ? '0' + v : v;
  });
};

/**
 * return uniformalized Date string to use kinds of Date ID
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {string}
 */
ChartAPI.Date.createId = function (d, u) {
  return ChartAPI.Date.zeroPadArray(d, u).join('');
};

/**
 * return uniformalized Date string to use kinds of Date label
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {string}
 */
ChartAPI.Date.createXLabel = function (d, u) {
  var hour, str, array = ChartAPI.Date.zeroPadArray(d, u);
  if (u === 'hourly') {
    hour = array.pop();
    str = array.join('-') + ' ' + hour + ':00';
  } else {
    str = array.join('-');
  }
  return str;
};

/**
 * parse argument and return back Date object
 * reformeded date string and try again when Date.parser returns NaN or Invalid
 * @param {Date|number|string|null}
 * @return {Date|null}
 */
ChartAPI.Date.parse = function (d) {
  var date;
  if (!d || d instanceof Date) {
    date = d || null;
  } else if (typeof d === 'number') {
    date = new Date(d);
  } else {
    date = new Date(Date.parse(d.toString()));
  }
  if (date && /NaN|Invalid Date/.test(date.toString())) {
    date = d.replace(/-/g, '/').split('+')[0];
    if (date.split('/').length === 1) {
      // parse the string like 20130305T00:00:00
      date = d.match(/([0-9]{4})([0-9]{1,2})([0-9]{1,2})/);
      date = [date[1], date[2], date[3]].join('/');
    }
    if (date.split('/').length === 2) {
      date = date + '/01';
    }
    date = jQuery.each(date.split('/'), function (i, v) {
      return v.length === 1 ? '0' + v : v;
    }).join('/');
    date = new Date(Date.parse(date));
  }
  return date;
};

/**
 * @param {!Date}
 * @param {!number} number of data
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {boolean} calculates as start date when true
 * @return {Date}
 */
ChartAPI.Date.calcDate = function (date, l, u, sym) {
  var y, m, d, h;
  y = date.getFullYear();
  m = date.getMonth();
  d = date.getDate();
  h = 0;
  l = l - 1;
  sym = sym ? -1 : 1;
  ({
    'yearly': function () {
      y = y + (sym * l);
    },
    'monthly': function () {
      m = m + (sym * l);
    },
    'quarter': function () {
      m = m + (sym * l * 4);
    },
    'weekly': function () {
      d = d + (sym * l * 7) - date.getDay();
    },
    'daily': function () {
      d = d + (sym * l);
    },
    'hourly': function () {
      h = date.getHours() + (sym * l);
    }
  })[u]();
  return new Date(y, m, d, h);
};
