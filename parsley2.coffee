#
# Copar.js allows you to verify your form inputs frontend side, without writing a line of javascript. Or so..
#
# Based on Parsley.js of Guillaume Potier - @guillaumepotier
# Author: Jesús Espino - @jespinog

defaults =
    inputs: 'input, textarea, select'
    excluded: 'input[type=hidden], input[type=file], :disabled'
    focus: 'first'

    validationMinlength: 3
    validateIfUnchanged: false
    interceptSubmit: true

    errors:
        showErrors: true
        errorClass: "parsley-error"
        validClass: "parsley-ok"
        validatedClass: "parsley-validated"
        onlyOneErrorElement: false

        containerClass: "parsley-error-list"
        containerGlobalSearch: false
        containerPreferenceSelector: ".errors-box"

        containerWrapper: "<ul />"
        elementWrapper: "<li />"

        classHandler: (element, isRadioOrCheckbox) ->
            return element

        container: (element, isRadioOrCheckbox) ->
            return element.parent()

    # Default listeners
    listeners:
        onFieldValidate: (element, field) -> return false
        onFormSubmit: (ok, event, form) -> return
        onFieldError: (element, constraints, field) -> return
        onFieldSuccess: (element, constraints, field) -> return


validators =
    notnull: (val) ->
        return val.length > 0

    notblank: (val) ->
        return _.isString(val) and '' != val.replace(/^\s+/g, '').replace(/\s+$/g, '')

    # Works on all inputs. val is object for checkboxes
    required: (val) ->
        return validators.notnull(val) and validators.notblank(val)

    type: (val, type) ->
        if val.length == 0
            return false

        regExp = null

        switch type
            when 'number' then regExp = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/
            when 'digits' then regExp = /^\d+$/
            when 'alphanum' then regExp = /^\w+$/

        # test regExp if not null
        if regExp
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


formatMesssage = (message, args) ->
    return message.replace /%s/g, (match) ->
        return String(args.shift())

toInt = (num) ->
    return parseInt(num, 10)


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
    constructor: (elm, form) ->
        @id = _.uniqueId("field-")
        @element = $(elm)
        @form = form
        @validatedOnce = false

        @resetConstraints()
        @bindEvents()

        _.bindAll(@)

    focus: ->
        @element.focus()

    eventValidate: (event) ->
        trigger = @element.data("trigger")
        value = @getValue()

        if event.type is "keyup" and not /keyup/i.test(trigger) and not @validatedOnce
            return true

        if event.type is "change" and not /change/i.test(trigger) and not @validatedOnce
            return true

        if value.length < @form.options.validationMinlength and not @validatedOnce
            return true

        @validate()

    bindEvents: ->
        @element.off(".#{@id}")
        trigger = @element.data("trigger")

        if _.isString(trigger)
            @element.on("#{trigger}.#{@id}", _.bind(@eventValidate, @))

        if @element.is("select") and trigger != "change"
            @element.on("change.#{@id}", _.bind(@eventValidate, @))

        if trigger != "keyup"
            @element.on("keyup.#{@id}", _.bind(@eventValidate, @))

    errorClassTarget: ->
        return @element

    resetHtml5Constraints: ->
        # Html5 validators compatibility
        if @element.prop("required")
            @required = true

        typeRx = new RegExp(@element.attr('type'), "i")
        if typeRx.test("email url number range")
            type = @element.attr('type')
            switch type
                when "range"
                    min = @element.attr('min')
                    max = @element.attr('max')

                    if min and max
                        @constraints[type] =
                            valid: true
                            params: [toInt(min), toInt(max)]
                            fn: @form.validators[type]

    resetConstraints: ->
        @constraints = {}
        @valid = true
        @required = false

        @resetHtml5Constraints()
        @element.addClass('parsley-validated')

        for constraint, fn of @form.validators
            if @element.data(constraint) is undefined
                continue

            @constraints[constraint] =
                valid: true
                params: @element.data(constraint)
                fn: fn

            if constraint == "required"
                @required = true

    hasConstraints: ->
        return not _.isEmpty(@constraints)

    validate: (showErrors) ->
        @validatedOnce = true
        if not @hasConstraints()
            return null

        if @form.options.listeners.onFieldValidate(@element, this)
            @reset()
            return null

        if not @required and @getValue() == ""
            @reset()
            return null

        return @applyValidators(showErrors)

    applyValidators: (showErrors) ->
        if showErrors is undefined
            showErrors = @form.options.errors.showErrors

        val = @getValue()
        valid = true

        listeners = @form.options.listeners

        # If showErrors is true, remove previous errors
        # before put new errors.
        if showErrors
            @removeErrors()

        # Apply all declared validators
        for name, data of @constraints
            data.valid = data.fn(@getValue(), data.params)

            if data.valid is false
                valid = false
                @manageError(name, data) if showErrors
                listeners.onFieldError(@element, data, @)
            else
                listeners.onFieldSuccess(@element, data, @)

        @handleClases(valid)
        return valid

    handleClases: (valid) ->
        classHandlerElement = @form.options.errors.classHandler(@element, false)

        errorClass = @form.options.errors.errorClass
        validClass = @form.options.errors.validClass

        switch valid
            when null
                classHandlerElement.removeClass(errorClass)
                classHandlerElement.removeClass(validClass)
            when false
                classHandlerElement.removeClass(validClass)
                classHandlerElement.addClass(errorClass)
            when true
                classHandlerElement.removeClass(errorClass)
                classHandlerElement.addClass(validClass)

    manageError: (name, constraint) ->
        if name == "type"
            message = @form.messages["type"][constraint.params]
        else
            message = @form.messages[name]

        if message is undefined
            message = @form.messages["default"]

        if constraint.params
            message = formatMesssage(message, _.clone(constraint.params, true))

        @addError(@makeErrorElement(name, message))

    addError: (errorElement) ->
        container = @getErrorContainer()
        if @form.options.errors.onlyOneErrorElement
            container.empty()

        container.append(errorElement)

    reset: ->
        @handleClases(null)
        @resetConstraints()
        @removeErrors()

    removeErrors: ->
        # Remove errors container
        $("##{@errorContainerId()}").remove()

    getValue: ->
        return @element.val()

    errorContainerId: ->
        return "parsley-error-#{@id}"

    errorContainerClass: ->
        return "parsley-error-list"

    getErrorContainer: ->
        errorContainerEl = $("##{@errorContainerId()}")
        if errorContainerEl.length == 1
            return errorContainerEl

        params =
            "class": @errorContainerClass()
            "id": @errorContainerId()

        errorContainerEl = $("<ul />", params)

        definedContainer = @element.data('error-container')
        if definedContainer is undefined
            errorContainerEl.insertAfter(@element)
            return errorContainerEl

        if @form.options.errors.containerGlobalSearch
            container = $(definedContainer)
        else
            container = @element.closest(definedContainer)

        preferenceSelector = @form.options.errors.containerPreferenceSelector
        if container.find(preferenceSelector).length == 1
            container = container.find(preferenceSelector)

        container.append(errorContainerEl)
        return errorContainerEl

    makeErrorElement: (constraintName, message) ->
        element = $("<li />", {"class": "parsley-#{constraintName}"})
        element.html(message)
        return element


class FieldMultiple extends Field
    constructor: (elm, form, options) ->


class Form
    constructor: (elm, options={}) ->
        @id = _.uniqueId("parsleyform-")
        @element = $(elm)
        @options = _.extend({}, defaults, options)

        # Clone messages and validators
        @messages = _.clone(messages, true)
        @validators = _.clone(validators, true)

        # Initialize fields
        @initializeFields()
        @bindEvents()

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

    bindEvents: ->
        self = @

        @element.on "submit.#{@id}", (event) ->
            ok = self.validate()
            self.options.listeners.onFormSubmit(ok, event, self)

            if self.options.interceptSubmit and not ok
                event.preventDefault()

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

# Expose global instance to the world
@parsley = parsley
