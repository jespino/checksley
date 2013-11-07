/*! checksley - v0.4.0 - 2013-11-07 */
(function() {
  var messages, validators;

  validators = {
    minwords: function(val, nbWords) {
      val = val.replace(/(^\s*)|(\s*$)/gi, "");
      val = val.replace(/[ ]{2,}/gi, " ");
      val = val.replace(/\n /, "\n");
      val = val.split(' ').length;
      return val >= nbWords;
    },
    maxwords: function(val, nbWords) {
      val = val.replace(/(^\s*)|(\s*$)/gi, "");
      val = val.replace(/[ ]{2,}/gi, " ");
      val = val.replace(/\n /, "\n");
      val = val.split(' ').length;
      return val <= nbWords;
    },
    rangewords: function(val, obj) {
      val = val.replace(/(^\s*)|(\s*$)/gi, "");
      val = val.replace(/[ ]{2,}/gi, " ");
      val = val.replace(/\n /, "\n");
      val = val.split(' ').length;
      return val >= obj[0] && val <= obj[1];
    },
    greaterthan: function(val, elem, self) {
      self.options.validateIfUnchanged = true;
      return new Number(val) > new Number($(elem).val());
    },
    lessthan: function(val, elem, self) {
      self.options.validateIfUnchanged = true;
      return new Number(val) < new Number($(elem).val());
    },
    beforedate: function(val, elem, self) {
      return Date.parse(val) < Date.parse($(elem).val());
    },
    afterdate: function(val, elem, self) {
      return Date.parse($(elem).val()) < Date.parse(val);
    },
    greaterthanvalue: function(val, min, self) {
      self.options.validateIfUnchanged = true;
      return new Number(val) > new Number(min);
    },
    lessthanvalue: function(val, max, self) {
      self.options.validateIfUnchanged = true;
      return new Number(val) < new Number(max);
    },
    beforedatevalue: function(val, date, self) {
      return Date.parse(val) < Date.parse(date);
    },
    afterdatevalue: function(val, date, self) {
      return Date.parse(date) < Date.parse(val);
    },
    inlist: function(val, list, self) {
      var delimiter, listItems;
      delimiter = self.element.data('inlistDelimiter') || ',';
      listItems = (list + "").split(new RegExp("\\s*\\" + delimiter + "\\s*"));
      return listItems.indexOf(val.trim()) !== -1;
    },
    luhn: function(val, unused, self) {
      var digit, key, sum, _i, _len, _ref;
      val = val.replace(/[ -]/g, '');
      sum = 0;
      _ref = val.split('').reverse();
      for (key = _i = 0, _len = _ref.length; _i < _len; key = ++_i) {
        digit = _ref[key];
        digit = +digit;
        if (key % 2) {
          digit *= 2;
          if (digit < 10) {
            sum += digit;
          } else {
            sum += digit - 9;
          }
        } else {
          sum += digit;
        }
      }
      return sum % 10 === 0;
    },
    americandate: function(val, unused, self) {
      var day, month, monthLength, parts, year;
      if (!/^([01]?[0-9])[\.\/-]([0-3]?[0-9])[\.\/-]([0-9]{4}|[0-9]{2})$/.test(val)) {
        return false;
      }
      parts = val.split(/[.\/-]+/);
      day = parseInt(parts[1], 10);
      month = parseInt(parts[0], 10);
      year = parseInt(parts[2], 10);
      if (year === 0 || month === 0 || month > 12) {
        return false;
      }
      monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
      if (year % 400 === 0 || (year % 100 !== 0 && year % 4 === 0)) {
        monthLength[1] = 29;
      }
      return day > 0 && day <= monthLength[month - 1];
    }
  };

  messages = {
    minwords: "This value should have %s words at least.",
    maxwords: "This value should have %s words maximum.",
    rangewords: "This value should have between %s and %s words.",
    greaterthan: "This value should be greater than %e.",
    lessthan: "This value should be less than %e.",
    beforedate: "This date should be before %e.",
    afterdate: "This date should be after %e.",
    greaterthanvalue: "This value should be greater than %s.",
    lessthanvalue: "This value should be less than %s.",
    beforedatevalue: "This date should be before %s.",
    afterdatevalue: "This date should be after %s.",
    inlist: "This value should be in the list %s.",
    luhn: "This value should pass the luhn test.",
    americandate: "This value should be a valid date (MM/DD/YYYY)."
  };

  this.checksley.updateValidators(validators);

  this.checksley.updateMessages("default", messages);

}).call(this);
