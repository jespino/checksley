# Checksley
# Based on Parsley.js of Guillaume Potier - @guillaumepotier
#
# Author: Jesús Espino / @jespinog
# Author: Andrey Antukh / @niwibe

defaults =
    inputs: 'input, textarea, select'
    excluded: 'input[type=hidden], input[type=file], :disabled'
    focus: 'first'

    validationMinlength: 3
    validateIfUnchanged: false
    interceptSubmit: true

    messages: {}
    validators: {}

    showErrors: true
    errorClass: "checksley-error"
    successClass: "checksley-ok"

    validatedClass: "checksley-validated"
    onlyOneErrorElement: false

    containerClass: "checksley-error-list"
    containerGlobalSearch: false
    containerPreferenceSelector: ".errors-box"

    errors:
        classHandler: (element, isRadioOrCheckbox) ->
            return element

        container: (element, isRadioOrCheckbox) ->
            return element.parent()

        errorsWrapper: "<ul />"
        errorElem: "<li />"

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
        # for checkboxes and select multiples. Check there is at least one required value
        if _.isArray(val)
            for element in val
                if validators.required(val[i])
                    return true
            return false

        return validators.notnull(val) and validators.notblank(val)

    type: (val, type) ->
        regExp = null
        switch type
            when 'number' then regExp = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/
            when 'digits' then regExp = /^\d+$/
            when 'alphanum' then regExp = /^\w+$/
            when 'email' then regExp = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i
            when 'url'
                if not /(https?|s?ftp|git)/i.test(val)
                    val = "http://#{val}"

                regExp = /^(https?|s?ftp|git):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
            when 'urlstrict' then regExp = /^(https?|s?ftp|git):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
            when 'dateIso' then regExp = /^(\d{4})\D?(0[1-9]|1[0-2])\D?([12]\d|0[1-9]|3[01])$/
            when 'phone' then regExp = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/

        if regExp
            return regExp.test(val)
        return false

    regexp: (val, regExp, self) ->
        return new RegExp( regExp, self.options.regexpFlag or '' ).test( val )

    minlength: (val, min) ->
        return val.length >= min

    maxlength: (val, max) ->
        return val.length <= max

    rangelength: (val, arrayRange) ->
        return val.length >= arrayRange[0] and val.length <= arrayRange[1]

    min: (val, min) ->
        return Number(val) >= min

    max: (val, max) ->
        return Number(val) <= max

    range: (val, arrayRange) ->
        return val >= arrayRange[ 0 ] and val <= arrayRange[ 1 ]

    equalto: ( val, elem, self ) ->
        self.options.validateIfUnchanged = true

        return val == $( elem ).val()

    mincheck: (obj, val) ->
        return validators.minlength( obj, val )

    maxcheck: (obj, val) ->
        return validators.maxlength( obj, val)

    rangecheck: (obj, arrayRange) ->
        return validators.rangelength(obj, arrayRange)


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
    if not _.isArray(args)
        args = [args]
    return message.replace /%s/g, (match) ->
        return String(args.shift())


toInt = (num) ->
    return parseInt(num, 10)


_checksley = (options) ->
    elm = this
    element = $(elm)

    if not element.is("form, input, select, textarea")
        throw "element is not a valid element for checksley"

    instance = element.data("checksley")
    if instance is undefined or instance is null
        _options = {}
        if _.isPlainObject(options)
            _options = options

        if element.is("input[type=radio], input[type=checkbox]")
            instance = new FieldMultiple(element, options)
        else if element.is("input, select, textarea")
            instance = new Field(element, options)
        else
            instance = new Form(element, options)

    # Parsley.js compatibility (incomplete)
    if _.isString(options)
        switch options
            when "validate" then instance.validate()
            when "destroy" then instance.destroy()
            when "reset" then instance.reset()
    else
        return instance


class Checksley
    constructor: (jq) ->
        if jq is undefined
            @.jq = window.jQuery || window.Zepto
        else
            @.jq = jq

        @.messages = {
            default: {
                defaultMessage: "Invalid"
            }
        }

        @.lang = @detectLang()

    updateDefaults: (options) ->
        _.merge(defaults, options)

    updateValidators: (validators) ->
        _.extend(validators, validators)

    updateMessages: (lang, messages) ->
        if @.messages[lang] is undefined
            @.messages[lang] = {}

        _.merge(@.messages[lang], messages)

    injectPlugin: ->
        @.jq.fn.checksley = _checksley

    setLang: (lang) ->
        @.lang = lang

    detectLang: ->
        # Very simple lang detection
        # TODO: must be improved
        return @.jq("html").attr("lang") or "default"

    getMessage: (key, lang) ->
        if lang is undefined
            lang = @lang

        messages = @messages[lang]
        if messages == undefined
            messages = {}

        message = messages[key]
        if message is undefined
            if lang == "default"
                return @.getMessage("defaultMessage", lang)
            else
                return @.getMessage(key, "default")

        return message


class Field
    constructor: (elm, options={}) ->
        @.id = _.uniqueId("field-")
        @.element = $(elm)
        @.validatedOnce = false
        @.options = _.merge({}, defaults, options)
        @.isRadioOrCheckbox = false

        # Clone messages and validators
        @.validators = validators

        @.resetConstraints()
        @.bindEvents()
        @.bindData()

    bindData: ->
        @.element.data("checksley-field", @)

    unbindData: ->
        @.element.data("checksley-field", null)

    focus: ->
        @.element.focus()

    eventValidate: (event) ->
        trigger = @.element.data("trigger")
        value = @.getValue()

        if event.type is "keyup" and not /keyup/i.test(trigger) and not @.validatedOnce
            return true

        if event.type is "change" and not /change/i.test(trigger) and not @.validatedOnce
            return true

        if value.length < @.options.validationMinlength and not @.validatedOnce
            return true

        @.validate()

    unbindEvents: ->
        @.element.off(".#{@.id}")

    bindEvents: ->
        @unbindEvents()
        trigger = @.element.data("trigger")

        if _.isString(trigger)
            @.element.on("#{trigger}.#{@.id}", _.bind(@.eventValidate, @))

        if @.element.is("select") and trigger != "change"
            @.element.on("change.#{@.id}", _.bind(@.eventValidate, @))

        if trigger != "keyup"
            @.element.on("keyup.#{@.id}", _.bind(@.eventValidate, @))

    errorClassTarget: ->
        return @.element

    resetHtml5Constraints: ->
        # Html5 validators compatibility
        if @element.prop("required")
            @required = true

        typeRx = new RegExp(@.element.attr('type'), "i")
        if typeRx.test("email url number range")
            type = @element.attr('type')
            switch type
                when "range"
                    min = @.element.attr('min')
                    max = @.element.attr('max')

                    if min and max
                        @.constraints[type] =
                            valid: true
                            params: [toInt(min), toInt(max)]
                            fn: @.validators[type]

    resetConstraints: ->
        @.constraints = {}
        @.valid = true
        @.required = false

        @.resetHtml5Constraints()
        @.element.addClass('checksley-validated')

        for constraint, fn of @.validators
            if @.element.data(constraint) is undefined
                continue

            @.constraints[constraint] =
                valid: true
                params: @.element.data(constraint)
                fn: fn

            if constraint == "required"
                @.required = true

    hasConstraints: ->
        return not _.isEmpty(@.constraints)

    validate: (showErrors) ->
        @.validatedOnce = true

        if not @.hasConstraints()
            return null

        if @.options.listeners.onFieldValidate(@.element, this)
            @.reset()
            return null

        if not @.required and @.getValue() == ""
            @.reset()
            return null

        return @applyValidators(showErrors)

    applyValidators: (showErrors) ->
        if showErrors is undefined or showErrors is null
            showErrors = @.options.showErrors

        val = @.getValue()
        valid = true

        listeners = @.options.listeners

        # If showErrors is true, remove previous errors
        # before put new errors.
        if showErrors
            @.removeErrors()

        # Apply all declared validators
        for name, data of @.constraints
            data.valid = data.fn(@.getValue(), data.params, @)

            if data.valid is false
                valid = false
                @.manageError(name, data) if showErrors
                listeners.onFieldError(@.element, data, @)
            else
                listeners.onFieldSuccess(@.element, data, @)

        @.handleClasses(valid)
        return valid

    handleClasses: (valid) ->
        classHandlerElement = @.options.errors.classHandler(@.element, false)

        errorClass = @.options.errorClass
        successClass = @.options.successClass

        switch valid
            when null
                classHandlerElement.removeClass(errorClass)
                classHandlerElement.removeClass(successClass)
            when false
                classHandlerElement.removeClass(successClass)
                classHandlerElement.addClass(errorClass)
            when true
                classHandlerElement.removeClass(errorClass)
                classHandlerElement.addClass(successClass)

    manageError: (name, constraint) ->
        data = @.element.data()

        if data["errorMessage"] != undefined
            message = data["errorMessage"]
        else if name == "type"
            message = checksley.getMessage("type")[constraint.params]
        else
            message = checksley.getMessage(name)

        if message is undefined
            message = checksley.getMessage("default")

        if constraint.params
            message = formatMesssage(message, _.clone(constraint.params, true))

        @.addError(@.makeErrorElement(name, message))

    setErrors: (messages) ->
        if not _.isArray(messages)
            messages = [messages]

        for message in messages
            @.addError(@.makeErrorElement("custom", message))

    makeErrorElement: (constraintName, message) ->
        element = $("<li />", {"class": "checksley-#{constraintName}"})
        element.html(message)
        element.addClass(constraintName)
        return element

    addError: (errorElement) ->
        container = @.getErrorContainer()
        if @.options.errors.onlyOneErrorElement
            container.empty()

        container.append(errorElement)

    reset: ->
        @.handleClasses(null)
        @.resetConstraints()
        @.removeErrors()

    removeErrors: ->
        # Remove errors container
        $("##{@.errorContainerId()}").remove()

    getValue: ->
        return @.element.val()

    errorContainerId: ->
        return "checksley-error-#{@.id}"

    errorContainerClass: ->
        return "checksley-error-list"

    getErrorContainer: ->
        errorContainerEl = $("##{@.errorContainerId()}")
        if errorContainerEl.length == 1
            return errorContainerEl

        params =
            "class": @.errorContainerClass()
            "id": @.errorContainerId()

        errorContainerEl = $("<ul />", params)

        definedContainer = @.element.data('error-container')
        if definedContainer is undefined
            if @.isRadioOrCheckbox
                errorContainerEl.insertAfter(@.element.parent())
            else
                errorContainerEl.insertAfter(@.element)
            return errorContainerEl

        if @.options.errors.containerGlobalSearch
            container = $(definedContainer)
        else
            container = @.element.closest(definedContainer)

        preferenceSelector = @.options.errors.containerPreferenceSelector
        if container.find(preferenceSelector).length == 1
            container = container.find(preferenceSelector)

        container.append(errorContainerEl)
        return errorContainerEl

    destroy: ->
        @.unbindEvents()
        @.removeErrors()
        @.unbindData()

    setForm: (form) ->
        @.form = form


class FieldMultiple extends Field
    constructor: (elm, options) ->
        super(elm, options)

        @.isRadioOrCheckbox = true
        @.isRadio = @.element.is("input[type=radio]")
        @.isCheckbox = @.element.is("input[type=checkbox]")

    getSiblings: ->
        group = @.element.data("group")
        if group is undefined
            return "input[name=#{@.element.attr('name')}]"
        else
            return "[data-group=\"#{group}\"]"

    getValue: ->
        if @.isRadio
            return $("#{@.getSiblings()}:checked").val() or ''

        if @.isCheckbox
            values = []

            for element in $("#{@.getSiblings()}:checked")
                values.push($(element).val())

            return values

    unbindEvents: ->
        for element in $(@.getSiblings())
            $(element).off(".#{@id}")

    bindEvents: ->
        @.unbindEvents()
        trigger = @.element.data("trigger")

        for element in $(@.getSiblings())
            element = $(element)

            if _.isString(trigger)
                element.on("#{trigger}.#{@.id}", _.bind(@.eventValidate, @))

            if trigger != "change"
                element.on("change.#{@.id}", _.bind(@.eventValidate, @))


class Form
    constructor: (elm, options={}) ->
        @.id = _.uniqueId("checksleyform-")
        @.element = $(elm)
        @.options = _.extend({}, defaults, options)
        @.initialize()

    initialize: ->
        # Initialize fields
        @.initializeFields()
        @.bindEvents()
        @.bindData()

    bindData: ->
        @.element.data("checksley", @)

    unbindData: ->
        @.element.data("checksley", null)

    initializeFields: ->
        @.fields = []
        @.fieldsByName = {}

        for fieldElm in @.element.find(@.options.inputs)
            element = $(fieldElm)
            if element.is(@.options.excluded)
                continue

            if element.is("input[type=radio], input[type=checkbox]")
                field = new checksley.FieldMultiple(fieldElm, @.options)
            else
                field = new checksley.Field(fieldElm, @.options)


            field.setForm(@)
            @.fields.push(field)
            @.fieldsByName[element.attr("name")] = field

    setErrors: (errors) ->
        for name, error of errors
            field = @.fieldsByName[name]
            if field
                field.setErrors(error)

    validate: ->
        valid = true
        invalidFields = []

        for field in @.fields
            if field.validate() == false
                valid = false
                invalidFields.push(field)

        if not valid
            switch @.options.focus
                when "first" then invalidFields[0].focus()
                when "last" then invalidFields[invalidFields.length].focus()

        return valid

    bindEvents: ->
        self = @
        @.unbindEvents()
        @.element.on "submit.#{@.id}", (event) ->
            ok = self.validate()
            self.options.listeners.onFormSubmit(ok, event, self)

            if self.options.interceptSubmit and not ok
                event.preventDefault()

    unbindEvents: ->
        @.element.off(".#{@.id}")

    removeErrors: ->
        for field in @.fields
            field.reset()

    destroy: ->
        @.unbindEvents()
        @.unbindData()

        for field in @.fields
            field.destroy()

        @.field = []


    reset: ->
        for field in @.fields
            field.reset()


# Main checksley global instance
checksley = new Checksley()
checksley.updateMessages("default", messages)
checksley.injectPlugin()

# Expose internal clases
checksley.Checksley = Checksley
checksley.Form = Form
checksley.Field = Field
checksley.FieldMultiple = FieldMultiple

# Expose global instance to the world
@checksley = checksley
