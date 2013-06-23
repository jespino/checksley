#
# Copar.js allows you to verify your form inputs frontend side, without writing a line of javascript. Or so..
#
# Based on Parsley.js of Guillaume Potier - @guillaumepotier
# Author: Jesús Espino - @jespinog

defaults =
   inputs: 'input, textarea, select'
   excluded: 'input[type=hidden], input[type=file], :disabled'.
   animate: true
   animateDuration: 300
   focus: 'first'


validators =
    notnull: (val) ->
        return val.length > 0

    notblank: (val) ->
        return _.isString(val) and '' != val.replace(/^\s+/g, '').replace(/\s+$/g, '')

    # Works on all inputs. val is object for checkboxes
    required: (val) ->
        # for checkboxes and select multiples. Check there is at least one required value
        if ('object' == typeof val)
            for i of val
                if (@required(val[i]))
                    return true
            return false

        return @notnull(val) and @notblank(val)

    type: (val, type) ->
        switch type
            when 'number' then regExp = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/
            when 'digits' then regExp = /^\d+$/
            when 'alphanum' then regExp = /^\w+$/

        # test regExp if not null
        if '' != val
            return regExp.test(val)

        return false

    regexp: (val, regExp, self) ->
        return new RegExp( regExp, self.options.regexpFlag or '' ).test( val )

    minlength: ( val, min ) ->
        return val.length >= min

    maxlength: ( val, max ) ->
        return val.length <= max

    rangelength: ( val, arrayRange ) ->
        return @minlength( val, arrayRange[ 0 ] ) and @maxlength( val, arrayRange[ 1 ] )

    min: ( val, min ) ->
        return Number( val ) >= min

    max: ( val, max ) ->
        return Number( val ) <= max

    range: ( val, arrayRange ) ->
        return val >= arrayRange[ 0 ] and val <= arrayRange[ 1 ]

    equalto: ( val, elem, self ) ->
        self.options.validateIfUnchanged = true

        return val == $( elem ).val()

    mincheck: (obj, val) ->
        return @minlength( obj, val )

    maxcheck: (obj, val) ->
        return @maxlength( obj, val)

    rangecheck: (obj, arrayRange) ->
        return @rangelength(obj, arrayRange)

messages =
    defaultMessage: "This value seems to be invalid."
    type:
        email:      "This value should be a valid email."
        url:        "This value should be a valid url."
        urlstrict:  "This value should be a valid url."
        number:     "This value should be a valid number."
        digits:     "This value should be digits."
        dateIso:    "This value should be a valid date (YYYY-MM-DD)."
        alphanum:   "This value should be alphanumeric."
        phone:      "This value should be a valid phone number."
    notnull:        "This value should not be null."
    notblank:       "This value should not be blank."
    required:       "This value is required."
    regexp:         "This value seems to be invalid."
    min:            "This value should be greater than or equal to %s."
    max:            "This value should be lower than or equal to %s."
    range:          "This value should be between %s and %s."
    minlength:      "This value is too short. It should have %s characters or more."
    maxlength:      "This value is too long. It should have %s characters or less."
    rangelength:    "This value length is invalid. It should be between %s and %s characters long."
    mincheck:       "You must select at least %s choices."
    maxcheck:       "You must select %s choices or less."
    rangecheck:     "You must select between %s and %s choices."
    equalto:        "This value should be the same."


class Parsley
    constructor: ->
        @injectPlugin(window.jQuery || window.Zepto)

    updateDefaults: (options) ->
        _.extend(defaults, options)

    updateValidators: (options) ->
        _.extend(validators, options)

    updateMessages: (options) ->
        _.extend(messages, options)

    injectPlugin: (jq) ->
        jq.fn.parsley = (options) ->
            elm = this
            element = $(elm)

            # Return null if a current element is not a
            # form element

            if not element.is("form")
                return null

            instance = element.data("parsleyForm")
            if instance is undefined
                instance = new Form(elm, options)
                element.data("parsleyForm", instance)

            return instance



class Field
    constructor: (elm, form, options) ->
        @id = _.uniqueId("field-")
        @element = $(elm)
        @form = form

        @valid = true
        @required = false
        @constraint = {}

        @populateConstraints()

    focus: ->
        @element.focus()

    errorClassTarget: ->
        return @element

    populateConstraints: ->
        for constraint, fn of @form.validators
            if @element.data(constrain) is undefined
                continue

            @constraints[constraint] =
                name: constraint
                valid: null
                fn: fn

            if constraint == "required"
                @required = true

    bindEvents: ->
        # Unbind any associated events.
        @element.off(".#{@id}")

    validate: (showErrors) ->
        val = @getValue()

        if not @hasConstraints()
            return null

        if not @required and val == ""
            @reset()
            return null

        # TODO: do not validate field already validated and unchanged
        valid = @applyValidators()

        showErrors = if showErrors? then showErrors else @options.showErrors
        if showErrors
            @manageValidationResult()

        return valid

    manageValidationResult: ->
        valid = null

        for constraint of @constraints
            if @constraints[constraint].valid == false
                @manageError(@constraints[constraint])
                valid = false

            else if  @constraints[constraint].valid == true
                @removeError(@constraints[constraint])
                valid = false != valid

        @valid = valid
        if @valid == true
            @removeErrors()
            # TODO: remove error class and add success class
        else if @valid == false
            # TODO ....

class FieldMultiple extends Field
    constructor: (elm, form, options) ->


class Form
    constructor: (elm, options={}) ->
        @element = $(elm)
        @options = _.extend({}, defaults, options)

        # Clone messages and validators
        @messages = _.clone(messages, true)
        @validators = _.clone(validators, true)

        # Initialize fields
        @initializeFields()

    initializeFields: ->
        @fields = []

        for fieldElm in @element.find(@options.inputs)
            element = $(fieldElm)
            if element.is(@options.excluded)
                continue

            if element.is("input[type=radio], input[type=checkbox]")
                @fields.push(new FieldMultiple(fieldElm, @, @options))
            else
                @fields.push(new Field(fieldElm, @, @options))

    validate: ->
        valid = true
        invalidFields = []

        for field in @fields
            if field.validate() == false
                valid = false
                invalidFields.push(field)

        if not valid
            switch @options.focus
                when "first" then invalidFields[0].focus()
                when "last" then invalidFields[invalidFields.length].focus()

        return valid

    removeErrors: ->
        for field in @fields
            field.reset()

    destroy: ->
        for field in @fields
            field.destroy()

        # TODO: off all events assigned
        # to the current element.

    reset: ->
        for field in @fields
            field.reset()


# Main parsley global instance
parsley = new Parsley()

# Expose internal clases
parsley.Form = Form
parsley.Field = Field
parsley.FieldMultiple = FieldMultiple
parsley.Validator = Validator

# Expose global instance to the world
@parsley = parsley
