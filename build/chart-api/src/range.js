ChartAPI.Range = {};
/**
 * return unified Range data object (plain object which does not have prototyped method)
 * @param {{start: string|number|Date|null, end: string|number|Date|null, length: string|number|null, maxLength: string|number|null, unit: string|null, dataType: string|null}}
 * @return {{start: Date, end: Date, length: number, maxLength: number, unit: string, dataType: string, max: Date|number, min: Date|number, isTimeline: boolean}}
 */
ChartAPI.Range.factory = function (obj) {
  var fn;
  obj = obj || {};
  obj.maxLength = obj.maxLength || 90;
  obj.dataType = obj.dataType || 'timeline';
  obj.isTimeline = ChartAPI.Range.isTimeline(obj.dataType);
  fn = obj.isTimeline ? ChartAPI.Range.calcDate : ChartAPI.Range.calcNum;
  return fn(obj.start, obj.end, obj.length, obj.maxLength, obj.unit, obj.dataType, obj.autoSized);
};

ChartAPI.Range.generate = ChartAPI.Range.factory;

/**
 * @param {string|null} data type
 * @return {boolean}
 */
ChartAPI.Range.isTimeline = function (dataType) {
  return !dataType || dataType === 'timeline';
};

/**
 * @param {=Date|null} start date
 * @param {=Date|null} end date
 * @param {=number|null} length: number of data from start date or end date. length is required when both start and end dates are null
 * @param {=number|null} maxinum length for data
 * @param {=string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {boolean} when true, auto caliculate length of data according to window width
 * @return {{start: Date, end: Date, length: number, maxLength: number, unit: string, dataType: string, max: Date|number, min: Date|number, isTimeline: boolean}}
 */
ChartAPI.Range.calcDate = function (s, e, length, maxLength, unit, dataType, autoSized) {
  unit = unit || 'monthly';
  length = length || (unit === 'hourly' ? 24 : 10);

  if (autoSized) {
    var width = jQuery(window).width();
    maxLength = Math.min(Math.ceil(width * 0.021875), maxLength);
    length = maxLength;
  }

  s = ChartAPI.Date.parse(s);
  e = ChartAPI.Date.parse(e);

  if (!s && !e) {
    e = ChartAPI.Range.getEndDate(new Date(), unit);
  }

  if (!s) {
    s = ChartAPI.Range.getStartDate(ChartAPI.Date.calcDate(e, length, unit, true), unit);
  }
  if (!e) {
    e = ChartAPI.Range.getEndDate(ChartAPI.Date.calcDate(s, length, unit, false), unit);
  }
  if (e > new Date()) {
    e = new Date();
  }
  if (s > e) {
    s = e;
  }
  length = ChartAPI.Range.getLength(s, e, unit);
  if (length > maxLength) {
    length = maxLength;
    s = ChartAPI.Date.calcDate(e, length, unit, true);
  }
  return {
    start: s,
    end: e,
    length: length,
    maxLength: maxLength,
    unit: unit,
    dataType: dataType,
    max: ChartAPI.Range.getEndDate(e, unit),
    min: ChartAPI.Range.getStartDate(s, unit),
    isTimeline: true
  };
};

/**
 * @param {=Date|null} start date
 * @param {=Date|null} end date
 * @param {=number|null} length: number of data from start date or end date. length is required when both start and end dates are null
 * @param {=number|null} maxinum length for data
 * @param {=string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {boolean} when true, auto caliculate length of data according to window width
 * @return {{start: Date, end: Date, length: number, maxLength: number, unit: string, dataType: string, max: Date|number, min: Date|number, isTimeline: boolean}}
 */
ChartAPI.Range.calcNum = function (s, e, length, maxLength, unit, dataType, autoSized) {
  length = length || 10;

  if (autoSized) {
    var width = jQuery(window).width();
    maxLength = Math.min(Math.ceil(width * 0.021875), maxLength);
    length = Math.min(length, maxLength);
  }

  if (!s && !e) {
    s = 0;
    e = length - 1;
  }

  s = parseInt(s, 10) || (s === 0 ? 0 : null);
  e = parseInt(e, 10) || (e === 0 ? 0 : null);

  if (s === null) {
    s = e - length;
    if (s < 0) {
      s = 0;
    }
  }
  if (e === null) {
    e = s + length;
  }
  if (s > e) {
    s = e;
  }
  length = e - s + 1;
  if (length > maxLength) {
    length = maxLength;
    s = e - maxLength;
  }
  return {
    start: s,
    end: e,
    length: length,
    maxLength: maxLength,
    dataType: dataType,
    unit: null,
    max: e,
    min: s,
    isTimeline: false
  };
};

/**
 * return start date within the date's unit range
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {Date}
 */
ChartAPI.Range.getStartDate = function (d, unit) {
  var start, year = d.getFullYear(),
    month = d.getMonth(),
    date = d.getDate();
  ({
    'yearly': function () {
      start = new Date(year, 0, 1, 0, 0, 0);
    },
    'monthly': function () {
      start = new Date(year, month, 1, 0, 0, 0);
    },
    'quarter': function () {
      start = new Date(year, month, 1, 0, 0, 0);
    },
    'weekly': function () {
      start = new Date(year, month, date - d.getDay(), 0, 0, 0);
    },
    'daily': function () {
      start = new Date(year, month, date, 0, 0, 0);
    },
    'hourly': function () {
      start = new Date(year, month, date, d.getHours(), 0, 0);
    }
  })[unit]();
  return start;
};

/**
 * return end date within the date's unit range
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {Date}
 */
ChartAPI.Range.getEndDate = function (d, unit) {
  var end, year = d.getFullYear(),
    month = d.getMonth(),
    date = d.getDate();
  ({
    'yearly': function () {
      end = new Date(year, 11, 31, 23, 59, 59);
    },
    'monthly': function () {
      end = new Date(new Date(year, month + 1, 1, 0, 0, 0).valueOf() - 1);
    },
    'quarter': function () {
      end = new Date(new Date(year, month + 1, 1, 0, 0, 0).valueOf() - 1);
    },
    'weekly': function () {
      end = new Date(year, month, date - d.getDay() + 6, 23, 59, 59);
    },
    'daily': function () {
      end = new Date(year, month, date, 23, 59, 59);
    },
    'hourly': function () {
      end = new Date(year, month, date, d.getHours(), 0, 0);
    }
  })[unit]();
  return end < new Date() ? end : new Date();
};

/**
 * return next date against the desinated range unit
 * @param {Date} start date
 * @param {Date} end date
 * @param {number} increment number from start date
 * @param {string} data u
 * @return {Date}
 */
ChartAPI.Range.getNextDate = function (s, e, i, u) {
  var d, year = s.getFullYear(),
    month = s.getMonth(),
    date = s.getDate();
  ({
    'yearly': function (i) {
      d = new Date(year + i, 0, 1);
    },
    'monthly': function (i) {
      d = new Date(year, month + i, 1);
    },
    'quarter': function (i) {
      d = new Date(year, month + i * 4, 1);
    },
    'weekly': function (i) {
      d = new Date(year, month, date + i * 7 - s.getDay());
    },
    'daily': function (i) {
      d = new Date(year, month, date + i);
    },
    'hourly': function (i) {
      d = new Date(year, month, date, s.getHours() + i);
    }
  })[u](i);
  return d < e ? d : null;
};

/**
 * return max and min value in JSON data
 * @param {!object} JSON data
 * @param {=boolean} true when data type is timeline
 * @return {{max:number, min:number}}
 */
ChartAPI.Range.getDataRange = function (data, isTimeline) {
  var map, max, min;

  if (isTimeline) {
    map = jQuery.map(data, function (v) {
      return ChartAPI.Date.parse(v.x)
        .valueOf();
    });
    max = Math.max.apply(null, map);
    min = Math.min.apply(null, map);
  } else {
    min = 0;
    max = data.length - 1;
  }

  return {
    max: max,
    min: min
  };
};

/**
 * return number of data between start and end date
 * @param {!Date}
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {number}
 */
ChartAPI.Range.getLength = function (s, e, u) {
  var length;
  ({
    'yearly': function () {
      length = Math.ceil(e.getFullYear() - s.getFullYear());
    },
    'monthly': function () {
      length = Math.ceil(e.getFullYear() * 12 + e.getMonth() - (s.getFullYear() * 12 + s.getMonth()));
    },
    'quarter': function () {
      length = Math.ceil((e.getFullYear() * 12 + e.getMonth() - (s.getFullYear() * 12 + s.getMonth())) / 4);
    },
    'weekly': function () {
      length = Math.ceil((ChartAPI.Date.getWeekStartday(e) - ChartAPI.Date.getWeekStartday(s)) / (7 * 24 * 60 * 60 * 1000));
    },
    'daily': function () {
      length = Math.ceil((e - s) / (24 * 60 * 60 * 1000));
    },
    'hourly': function () {
      length = Math.ceil((e - s) / (60 * 60 * 1000));
    }
  })[u]();
  return length > 0 ? length + 1 : 1;
};
