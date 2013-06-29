validators =
    minwords: (val, nbWords) ->
        val = val.replace(/(^\s*)|(\s*$)/gi, "")
        val = val.replace(/[ ]{2,}/gi, " ")
        val = val.replace(/\n /, "\n")
        val = val.split(' ').length
        return val >= nbWords

    maxwords: (val, nbWords) ->
        val = val.replace(/(^\s*)|(\s*$)/gi, "")
        val = val.replace(/[ ]{2,}/gi, " ")
        val = val.replace(/\n /, "\n")
        val = val.split(' ').length

        return val <= nbWords

    rangewords: (val, obj) ->
        val = val.replace(/(^\s*)|(\s*$)/gi, "")
        val = val.replace(/[ ]{2,}/gi, " ")
        val = val.replace(/\n /, "\n")
        val = val.split(' ').length

        return val >= obj[0] and val <= obj[1]

    greaterthan: (val, elem, self) ->
        self.options.validateIfUnchanged = true

        return new Number(val) > new Number($(elem).val())

    lessthan: (val, elem, self) ->
        self.options.validateIfUnchanged = true

        return new Number(val) < new Number($(elem).val())

    beforedate: (val, elem, self) ->
        return Date.parse(val) < Date.parse($(elem).val())

    afterdate: (val, elem, self) ->
        return Date.parse($(elem).val()) < Date.parse(val)

    inlist: (val, list, self) ->
        delimiter = self.element.data('inlistDelimiter') or ','

        listItems = (list + "").split(new RegExp("\\s*\\#{delimiter}\\s*"))

        return (listItems.indexOf(val.trim()) != -1)

    luhn: (val, elem, self) ->
        val = val.replace(/[ -]/g, '')
        sum = 0
        for digit, key in val.split('').reverse()
            digit = +digit
            if (key % 2)
                digit *= 2
                if (digit < 10)
                    sum += digit
                else
                    sum += digit - 9
            else
                sum += digit
        return sum % 10 == 0

    americandate: (val, elem, self) ->
        if(!/^([01]?[0-9])[\.\/-]([0-3]?[0-9])[\.\/-]([0-9]{4}|[0-9]{2})$/.test(val))
            return false
        parts = val.split(/[.\/-]+/)
        day = parseInt(parts[1], 10)
        month = parseInt(parts[0], 10)
        year = parseInt(parts[2], 10)
        if (year == 0 or month == 0 or month > 12)
            return false
        monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if(year % 400 == 0 or (year % 100 != 0 and year % 4 == 0))
            monthLength[1] = 29
        return day > 0 and day <= monthLength[month - 1]


messages =
    minwords:       "This value should have %s words at least."
    maxwords:       "This value should have %s words maximum."
    rangewords:     "This value should have between %s and %s words."
    greaterthan:    "This value should be greater than %s."
    lessthan:       "This value should be less than %s."
    beforedate:     "This date should be before %s."
    afterdate:      "This date should be after %s."
    inlist:         "This value should be in the list %s."
    luhn:           "This value should pass the luhn test."
    americandate:   "This value should be a valid date (MM/DD/YYYY)."


@checksley.updateValidators(validators)
@checksley.updateMessages("default", messages)
