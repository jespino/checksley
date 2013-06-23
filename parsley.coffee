#
# Copar.js allows you to verify your form inputs frontend side, without writing a line of javascript. Or so..
#
# Based on Parsley.js of Guillaume Potier - @guillaumepotier
# Author: Jesús Espino - @jespinog
#

(($) ->
    ###*
    # Validator class stores all constraints functions and associated messages.
    # Provides public interface to add, remove or modify them
    #
    # @class Validator
    # @constructor
    ###
    class Validator
        constructor: (options) ->
            ###*
            # Error messages
            #
            # @property messages
            # @type {Object}
            ###
            @messages =
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


            @init(options)


        ###*
        # Validator list. Built-in validators functions
        #
        # @property validators
        # @type {Object}
        ###
        validators:
            notnull: (val) ->
                return val.length > 0

            notblank: (val) ->
                return 'string' == typeof val and '' != val.replace( /^\s+/g, '' ).replace( /\s+$/g, '' )

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
                    when 'email' then regExp = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i
                    when 'url'
                        if /(https?|s?ftp|git)/i.test(val)
                            val = val
                        else
                            val = "http://#{val}"
                        regExp = /^(https?|s?ftp|git):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
                    when 'urlstrict' then regExp = /^(https?|s?ftp|git):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
                    when 'dateIso' then regExp = /^(\d{4})\D?(0[1-9]|1[0-2])\D?([12]\d|0[1-9]|3[01])$/
                    when 'phone' then regExp = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/
                    else
                        return false

                # test regExp if not null
                if '' != val
                    return regExp.test(val)
                else
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

            remote: ( val, url, self ) ->
                result = null
                data = {}
                dataType = {}

                data[self.$element.attr('name')] = val

                if (self.options.remoteDatatype?)
                    dataType = { dataType: self.options.remoteDatatype }

                manage = ( isConstraintValid, message ) ->
                    # remove error message if we got a server message, different from previous message
                    if (message? and self.Validator.messages.remote? and message != self.Validator.messages.remote)
                        $("#{self.ulError} .remote").remove()

                    self.updtConstraint( { name: 'remote', valid: isConstraintValid }, message )
                    self.manageValidationResult()

                # transform string response into object
                handleResponse = ( response ) ->
                    if ('object' == typeof response)
                        return response

                    try
                        response = $.parseJSON(response)
                    catch err then

                    return response

                manageErrorMessage = (response) ->
                    if 'object' == typeof response and response?
                        if response.error?
                            return response.error
                        else
                            if response.message?
                                return response.message
                    return null

                $.ajax($.extend({},
                    url: url
                    data: data
                    type: self.options.remoteMethod or 'GET'
                    success: ( response ) ->
                        response = handleResponse( response )
                        manage(
                            1 == response or
                            true == response or
                            (
                                'object' == typeof response and
                                response? and
                                response.success?
                            ),
                            manageErrorMessage( response )
                        )
                    error: ( response ) ->
                        response = handleResponse( response )
                        manage( false, manageErrorMessage( response ) )
                , dataType))

                return result

            #
            # Aliases for checkboxes constraints
            #
            mincheck: (obj, val) ->
                return @minlength( obj, val )

            maxcheck: (obj, val) ->
                return @maxlength( obj, val)

            rangecheck: (obj, arrayRange) ->
                return @rangelength(obj, arrayRange)

        #
        # Register custom validators and messages
        #
        init: ( options ) ->
            customValidators = options.validators
            customMessages = options.messages

            for key of customValidators
                @addValidator(key, customValidators[ key ])

            for key of customMessages
                @addMessage(key, customMessages[ key ])

        ###*
        # Replace %s placeholders by values
        #
        # @method formatMesssage
        # @param {String} message Message key
        # @param {Mixed} args Args passed by validators functions. Could be string, number or object
        # @return {String} Formatted string
        ###
        formatMesssage: ( message, args ) ->
            if ( 'object' == typeof args )
                for i of args
                    message = @formatMesssage(message, args[i])

                return message

            if 'string' == typeof message
                return message.replace( new RegExp( '%s', 'i' ), args )

            return ''

        ###*
        # Add / override a validator in validators list
        #
        # @method addValidator
        # @param {String} name Validator name. Will automatically bindable through data-name=''
        # @param {Function} fn Validator function. Must return {Boolean}
        ###
        addValidator: (name, fn) ->
            @validators[ name ] = fn

        ###*
        # Add / override error message
        #
        # @method addMessage
        # @param {String} name Message name. Will automatically be binded to validator with same name
        # @param {String} message Message
        ###
        addMessage: (key, message, type) ->
            if ( type? and true == type )
                @messages.type[ key ] = message
                return

            # custom types messages are a bit tricky cuz' nested ;)
            if ( 'type' == key )
                for i of message
                    @messages.type[i] = message[i]

                return

            @messages[key] = message

    ###*
    # ParsleyField class manage each form field inside a validated Parsley form.
    # Returns if field valid or not depending on its value and constraints
    # Manage field error display and behavior, event triggers and more
    #
    # @class ParsleyField
    # @constructor
    ###
    class ParsleyField
        constructor: (element, options, type) ->
            @options = options
            @Validator = new Validator( options )

            # if type is ParsleyFieldMultiple, just return @ used for clone
            if ( type == 'ParsleyFieldMultiple' )
                return @

            @init(element, type or 'ParsleyField')

        ###*
        # Set some properties, bind constraint validators and validation events
        #
        # @method init
        # @param {Object} element
        # @param {Object} options
        ###
        init: (element, type) ->
            @type = type
            @valid = true
            @element = element
            @validatedOnce = false
            @$element = $( element )
            @val = @$element.val()
            @isRequired = false
            @constraints = {}

            # overriden by ParsleyItemMultiple if radio or checkbox input
            if ( 'undefined' == typeof @isRadioOrCheckbox )
                @isRadioOrCheckbox = false
                @hash = @generateHash()
                @errorClassHandler = @options.errors.classHandler( element, @isRadioOrCheckbox ) or @$element

            # error ul dom management done only once at init
            @ulErrorManagement()

            # bind some html5 properties
            @bindHtml5Constraints()

            # bind validators to field
            @addConstraints()

            # bind parsley events if validators have been registered
            if ( @hasConstraints() )
                @bindValidationEvents()

        setParent: (elem) ->
            @$parent = $(elem)

        getParent: () ->
            return @$parent

        ###*
        # Bind some extra html5 types / validators
        #
        # @private
        # @method bindHtml5Constraints
        ###
        bindHtml5Constraints: () ->
            # add html5 required support + class required support
            if ( @$element.hasClass( 'required' ) or @$element.prop( 'required' ) )
                @options.required = true

            # add html5 supported types & options
            if ( @$element.attr('type')? and new RegExp( @$element.attr( 'type' ), 'i' ).test( 'email url number range' ) )
                @options.type = @$element.attr( 'type' )

                # number and range types could have min and/or max values
                if ( new RegExp( @options.type, 'i' ).test( 'number range' ) )
                    @options.type = 'number'

                    # double condition to support jQuery and Zepto.. :(
                    if ( @$element.attr('min')? and @$element.attr( 'min' ).length )
                        @options.min = @$element.attr( 'min' )

                    if ( @$element.attr('max')? and @$element.attr( 'max' ).length )
                        @options.max = @$element.attr( 'max' )

            if ( 'string' == typeof @$element.attr( 'pattern' ) and @$element.attr( 'pattern' ).length )
                @options.regexp = @$element.attr( 'pattern' )

        ###*
        # Attach field validators functions passed through data-api
        #
        # @private
        # @method addConstraints
        ###
        addConstraints: () ->
            for constraint of @options
                addConstraint = {}
                addConstraint[ constraint ] = @options[ constraint ]
                @addConstraint( addConstraint, true )

        ###*
        # Dynamically add a new constraint to a field
        #
        # @method addConstraint
        # @param {Object} constraint { name: requirements }
        ###
        addConstraint: ( constraint, doNotUpdateValidationEvents ) ->
            for name of constraint
                name = name.toLowerCase()

                if ( 'function' == typeof @Validator.validators[ name ] )
                    @constraints[ name ] =
                        name: name
                        requirements: constraint[ name ]
                        valid: null

                    if ( name == 'required' )
                        @isRequired = true

                    @addCustomConstraintMessage( name )

            # force field validation next check and reset validation events
            if ( 'undefined' == typeof doNotUpdateValidationEvents )
                @bindValidationEvents()

        ###*
        # Dynamically update an existing constraint to a field.
        # Simple API: { name: requirements }
        #
        # @method updtConstraint
        # @param {Object} constraint
        ###
        updateConstraint: (constraint, message) ->
            for name of constraint
                @updtConstraint( { name: name, requirements: constraint[ name ], valid: null }, message )
            return null

        ###*
        # Dynamically update an existing constraint to a field.
        # Complex API: { name: name, requirements: requirements, valid: boolean }
        #
        # @method updtConstraint
        # @param {Object} constraint
        ###
        updtConstraint: ( constraint, message ) ->
            @constraints[ constraint.name ] = $.extend( true, @constraints[ constraint.name ], constraint )

            if ( 'string' == typeof message )
                @Validator.messages[ constraint.name ] = message

            # force field validation next check and reset validation events
            @bindValidationEvents()

        ###*
        # Dynamically remove an existing constraint to a field.
        #
        # @method removeConstraint
        # @param {String} constraintName
        ###
        removeConstraint: ( constraintName ) ->
            constraintName = constraintName.toLowerCase()

            delete @constraints[ constraintName ]

            if ( constraintName == 'required' )
                @isRequired = false

            # if there are no more constraint, destroy parsley instance for this field
            if ( !@hasConstraints() )
                # in a form context, remove item from parent
                if ( 'ParsleyForm' == typeof @getParent() )
                    @getParent().removeItem( @$element )
                    return

                @destroy()
                return

            @bindValidationEvents()

        ###*
        # Add custom constraint message, passed through data-API
        #
        # @private
        # @method addCustomConstraintMessage
        # @param constraint
        ###
        addCustomConstraintMessage: ( constraint ) ->
            # custom message type data-type-email-message -> typeEmailMessage | data-minlength-error => minlengthMessage
            customMessage = constraint + ( if 'type' == constraint and @options[ constraint ]? then @options[ constraint ].charAt( 0 ).toUpperCase() + @options[ constraint ].substr( 1 ) else '' ) + 'Message'

            if ( @options[ customMessage ]? )
                @Validator.addMessage((if 'type' == constraint then @options[constraint] else constraint), @options[ customMessage ], 'type' == constraint )

        ###*
        # Bind validation events on a field
        #
        # @private
        # @method bindValidationEvents
        ###
        bindValidationEvents: () ->
            # this field has validation events, that means it has to be validated
            @valid = null
            @$element.addClass( 'parsley-validated' )

            # remove eventually already binded events
            @$element.off(".#{@type}")

            # force add 'change' event if async remote validator here to have result before form submitting
            if ( @options.remote and !new RegExp( 'change', 'i' ).test( @options.trigger ) )
                @options.trigger = if !@options.trigger then 'change' else ' change'

            # alaways bind keyup event, for better UX when a field is invalid
            triggers = ( if !@options.trigger then '' else @options.trigger ) + ( if new RegExp( 'key', 'i' ).test( @options.trigger ) then '' else ' keyup' )

            # alaways bind change event, for better UX when a select is invalid
            if ( @$element.is( 'select' ) )
                triggers += if new RegExp( 'change', 'i' ).test( triggers ) then '' else ' change'

            # trim triggers to bind them correctly with .on()
            triggers = triggers.replace( /^\s+/g , '' ).replace( /\s+$/g , '' )

            @$element.on( ( triggers + ' ' ).split( ' ' ).join( '.' + @type + ' ' ), false, $.proxy( @eventValidation, this ) )

        ###*
        # Hash management. Used for ul error
        #
        # @method generateHash
        # @returns {String} 5 letters unique hash
        ###
        generateHash: () ->
            return 'parsley-' + ( Math.random() + '' ).substring( 2 )

        ###*
        # Public getHash accessor
        #
        # @method getHash
        # @returns {String} hash
        ###
        getHash: () ->
            return @hash

        ###*
        # Returns field val needed for validation
        # Special treatment for radio & checkboxes
        #
        # @method getVal
        # @returns {String} val
        ###
        getVal: () ->
            return @$element.data('value') or @$element.val()

        ###*
        # Called when validation is triggered by an event
        # Do nothing if val.length < @options.validationMinlength
        #
        # @method eventValidation
        # @param {Object} event jQuery event
        ###
        eventValidation: ( event ) ->
            val = @getVal()

            # do nothing on keypress event if not explicitely passed as data-trigger and if field has not already been validated once
            if ( event.type == 'keyup' and !/keyup/i.test( @options.trigger ) and !@validatedOnce )
                return true

            # do nothing on change event if not explicitely passed as data-trigger and if field has not already been validated once
            if ( event.type == 'change' and !/change/i.test( @options.trigger ) and !@validatedOnce )
                return true

            # start validation process only if field has enough chars and validation never started
            if ( !@isRadioOrCheckbox and val.length < @options.validationMinlength and !@validatedOnce )
                return true

            @validate()

        ###*
        # Return if field verify its constraints
        #
        # @method isValid
        # @return {Boolean} Is field valid or not
        ###
        isValid: () ->
            return @validate( false )

        ###*
        # Return if field has constraints
        #
        # @method hasConstraints
        # @return {Boolean} Is field has constraints or not
        ###
        hasConstraints: () ->
            for constraint of @constraints
                return true

            return false

        ###*
        # Validate a field & display errors
        #
        # @method validate
        # @param {Boolean} errorBubbling set to false if you just want valid boolean without error bubbling next to fields
        # @return {Boolean} Is field valid or not
        ###
        validate: ( errorBubbling ) ->
            val = @getVal()
            valid = null

            # do not even bother trying validating a field w/o constraints
            if ( !@hasConstraints() )
                return null

            # reset Parsley validation if onFieldValidate returns true, or if field is empty and not required
            if ( @options.listeners.onFieldValidate( @element, this ) or ( '' == val and !@isRequired ) )
                @reset()
                return null

            # do not validate a field already validated and unchanged !
            if ( !@needsValidation( val ) )
                return @valid

            valid = @applyValidators()

            if ( if errorBubbling? then errorBubbling else @options.showErrors )
                @manageValidationResult()

            return valid

        ###*
        # Check if value has changed since previous validation
        #
        # @method needsValidation
        # @param value
        # @return {Boolean}
        ###
        needsValidation: ( val ) ->
            if ( !@options.validateIfUnchanged and @valid != null and @val == val and @validatedOnce )
                return false

            @val = val
            return @validatedOnce = true

        ###*
        # Loop through every fields validators
        # Adds errors after unvalid fields
        #
        # @method applyValidators
        # @return {Mixed} {Boolean} If field valid or not, null if not validated
        ###
        applyValidators: () ->
            valid = null

            for constraint of @constraints
                result = @Validator.validators[ @constraints[ constraint ].name ]( @val, @constraints[ constraint ].requirements, this )

                if ( false == result )
                    valid = false
                    @constraints[ constraint ].valid = valid
                    @options.listeners.onFieldError( @element, @constraints, this )
                else if ( true == result )
                    @constraints[ constraint ].valid = true
                    valid = false != valid
                    @options.listeners.onFieldSuccess( @element, @constraints, this )

            return valid

        ###*
        # Fired when all validators have be executed
        # Returns true or false if field is valid or not
        # Display errors messages below failed fields
        # Adds parsley-success or parsley-error class on fields
        #
        # @method manageValidationResult
        # @return {Boolean} Is field valid or not
        ###
        manageValidationResult: () ->
            valid = null

            for constraint of @constraints
                if ( false == @constraints[ constraint ].valid )
                    @manageError( @constraints[ constraint ] )
                    valid = false
                else if ( true == @constraints[ constraint ].valid )
                    @removeError( @constraints[ constraint ].name )
                    valid = false != valid

            @valid = valid

            if ( true == @valid )
                @removeErrors()
                @errorClassHandler.removeClass( @options.errorClass ).addClass( @options.successClass )
                return true
            else if ( false == @valid )
                @errorClassHandler.removeClass( @options.successClass ).addClass( @options.errorClass )
                return false

            return valid

        ###*
        # Manage ul error Container
        #
        # @private
        # @method ulErrorManagement
        ###
        ulErrorManagement: () ->
            @ulError = "##{@hash}"
            @ulTemplate = $( @options.errors.errorsWrapper ).attr( 'id', @hash ).addClass( 'parsley-error-list' )

        ###*
        # Remove li / ul error
        #
        # @method removeError
        # @param {String} constraintName Method Name
        ###
        removeError: ( constraintName ) ->
            liError = "#{@ulError} .#{constraintName}"
            that = this

            if @options.animate then $( liError ).fadeOut( @options.animateDuration, () ->
                $( this ).remove()

                if ( that.ulError and $( that.ulError ).children().length == 0 )
                    that.removeErrors()
            ) else $( liError ).remove()

            # remove li error, and ul error if no more li inside
            if ( @ulError and $( @ulError ).children().length == 0 )
                @removeErrors()

        ###*
        # Add li error
        #
        # @method addError
        # @param {Object} { minlength: "error message for minlength constraint" }
        ###
        addError: ( error ) ->
            for constraint of error
                liTemplate = $( @options.errors.errorElem ).addClass( constraint )

                $( @ulError ).append( if @options.animate then $( liTemplate ).html( error[ constraint ] ).hide().fadeIn( @options.animateDuration ) else $( liTemplate ).html( error[ constraint ] ) )

        ###*
        # Remove all ul / li errors
        #
        # @method removeErrors
        ###
        removeErrors: () ->
            if @options.animate then $( @ulError ).fadeOut( @options.animateDuration, () -> $( this ).remove() ) else $( @ulError ).remove()

        ###*
        # Remove ul errors and parsley error or success classes
        #
        # @method reset
        ###
        reset: () ->
            @valid = null
            @removeErrors()
            @validatedOnce = false
            @errorClassHandler.removeClass( @options.successClass ).removeClass( @options.errorClass )

            for constraint of @constraints
                @constraints[ constraint ].valid = null

            return this

        ###*
        # Add li / ul errors messages
        #
        # @method manageError
        # @param {Object} constraint
        ###
        manageError: ( constraint ) ->
            # display ulError container if it has been removed previously (or never shown)
            if ( !$( @ulError ).length )
                @manageErrorContainer()

            # TODO: refacto properly
            # if required constraint but field is not null, do not display
            if ( 'required' == constraint.name and null != @getVal() and @getVal().length > 0 )
                return
            # if empty required field and non required constraint fails, do not display
            else if ( @isRequired and 'required' != constraint.name and ( null == @getVal() or 0 == @getVal().length ) )
                return

            # TODO: refacto error name w/ proper & readable function
            constraintName = constraint.name
            liClass = if false != @options.errorMessage then 'custom-error-message' else constraintName
            liError = {}
            message = if false != @options.errorMessage then @options.errorMessage else ( if constraint.name == 'type' then @Validator.messages[ constraintName ][ constraint.requirements ] else ( if 'undefined' == typeof @Validator.messages[ constraintName ] then @Validator.messages.defaultMessage else @Validator.formatMesssage( @Validator.messages[ constraintName ], constraint.requirements ) ) )

            # add liError if not shown. Do not add more than once custom errorMessage if exist
            if ( !$("#{@ulError} .#{liClass}").length )
                liError[ liClass ] = message
                @addError( liError )

        ###*
        # Create ul error container
        #
        # @method manageErrorContainer
        ###
        manageErrorContainer: () ->
            errorContainer = @options.errorContainer or @options.errors.container( @element, @isRadioOrCheckbox )
            ulTemplate = if @options.animate then @ulTemplate.show() else @ulTemplate

            if ( errorContainer? )
                $( errorContainer ).append( ulTemplate )
                return

            if !@isRadioOrCheckbox then @$element.after( ulTemplate ) else @$element.parent().after( ulTemplate )

        ###*
        # Add custom listeners
        #
        # @param {Object} { listener: () {} }, eg { onFormSubmit: ( valid, event, focus ) { ... } }
        ###
        addListener: ( object ) ->
            for listener of object
                @options.listeners[ listener ] = object[ listener ]

        ###*
        # Destroy parsley field instance
        #
        # @private
        # @method destroy
        ###
        destroy: () ->
            @$element.removeClass( 'parsley-validated' )
            @reset().$element.off(".#{@type}").removeData( @type )

    ###*
    # ParsleyFieldMultiple override ParsleyField for checkbox and radio inputs
    # Pseudo-heritance to manage divergent behavior from ParsleyItem in dedicated methods
    #
    # @class ParsleyFieldMultiple
    # @constructor
    ###
    class ParsleyFieldMultiple
        constructor: ( element, options, type ) ->
            @initMultiple( element, options )
            @inherit( element, options )
            @Validator = new Validator( options )

            # call ParsleyField constructor
            @init( element, type or 'ParsleyFieldMultiple' )

        ###*
        # Set some specific properties, call some extra methods to manage radio / checkbox
        #
        # @method init
        # @param {Object} element
        # @param {Object} options
        ###
        initMultiple: ( element, options ) ->
            @element = element
            @$element = $( element )
            @group = options.group or false
            @hash = @getName()
            @siblings = if @group then "[data-group=\"#{@group}\"]" else "input[name=\"#{@$element.attr('name')}\"]"
            @isRadioOrCheckbox = true
            @isRadio = @$element.is( 'input[type=radio]' )
            @isCheckbox = @$element.is( 'input[type=checkbox]' )
            @errorClassHandler = options.errors.classHandler( element, @isRadioOrCheckbox ) or @$element.parent()

        ###*
        # Set specific constraints messages, do pseudo-heritance
        #
        # @private
        # @method inherit
        # @param {Object} element
        # @param {Object} options
        ###
        inherit: ( element, options ) ->
            clone = new ParsleyField( element, options, 'ParsleyFieldMultiple' )

            for property of clone
                if ('undefined' == typeof @[property])
                    @[property] = clone[property]

        ###*
        # Set specific constraints messages, do pseudo-heritance
        #
        # @method getName
        # @returns {String} radio / checkbox hash is cleaned 'name' or data-group property
        ###
        getName: () ->
            if ( @group )
                return "parsley-#{@group}"

            if ('undefined' == typeof @$element.attr('name'))
                throw
                    name: "no data-group or name error"
                    message: "A radio / checkbox input must have a data-group attribute or a name to be Parsley validated !"

            return "parsley-#{@$element.attr('name').replace(/(:|\.|\[|\])/g, '')}"

        ###*
        # Special treatment for radio & checkboxes
        # Returns checked radio or checkboxes values
        #
        # @method getVal
        # @returns {String} val
        ###
        getVal: () ->
            if ( @isRadio )
                return $("#{@siblings}:checked").val() or ''

            if ( @isCheckbox )
                values = []

                $("#{@siblings}:checked").each () ->
                    values.push( $( this ).val() )

                return values

        ###*
        # Bind validation events on a field
        #
        # @private
        # @method bindValidationEvents
        ###
        bindValidationEvents: () ->
            # this field has validation events, that means it has to be validated
            @valid = null
            @$element.addClass( 'parsley-validated' )

            # remove eventually already binded events
            @$element.off(".#{@type}")

            # alaways bind keyup event, for better UX when a field is invalid
            self = this
            triggers = ( if !@options.trigger then '' else @options.trigger ) + ( if new RegExp( 'change', 'i' ).test( @options.trigger ) then '' else ' change' )

            # trim triggers to bind them correctly with .on()
            triggers = triggers.replace( /^\s+/g , '' ).replace( /\s+$/g ,'' )

            # bind trigger event on every siblings
            $( @siblings ).each () ->
                $( this ).on( triggers.split( ' ' ).join(".#{self.type} ") , false, $.proxy( self.eventValidation, self ) )

    ###*
    # ParsleyForm class manage Parsley validated form.
    # Manage its fields and global validation
    #
    # @class ParsleyForm
    # @constructor
    ###
    class ParsleyForm
        constructor: (element, options, type) ->
            @init( element, options, type or 'parsleyForm' )

        # init data, bind jQuery on() actions
        init: ( element, options, type ) ->
            @type = type
            @items = []
            @$element = $( element )
            @options = options
            self = this

            @$element.find( options.inputs ).each () ->
                self.addItem( this )

            @$element.on("submit.#{@type}", false, $.proxy(@validate, this))

        ###*
        # Add custom listeners
        #
        # @param {Object} { listener: () {} }, eg { onFormSubmit: ( valid, event, focus ) { ... } }
        ###
        addListener: ( object ) ->
            for listener of object
                if ( new RegExp( 'Field' ).test( listener ) )
                    for item in [0..@items.length-1]
                        @items[item].addListener( object )
                else
                    @options.listeners[ listener ] = object[ listener ]

        ###*
        # Adds a new parsleyItem child to ParsleyForm
        #
        # @method addItem
        # @param elem
        ###
        addItem: ( elem ) ->
            if ($(elem).is(@options.excluded))
                return false

            parsleyField = $(elem).parsley(@options)
            parsleyField.setParent(this)

            @items.push(parsleyField)

        ###*
        # Removes a parsleyItem child from ParsleyForm
        #
        # @method removeItem
        # @param elem
        # @return {Boolean}
        ###
        removeItem: ( elem ) ->
            parsleyItem = $( elem ).parsley()

            # identify & remove item if same Parsley hash
            for i in [0..@items.length-1]
                if ( @items[ i ].hash == parsleyItem.hash )
                    @items[ i ].destroy()
                    @items.splice( i, 1 )
                    return true

            return false

        ###*
        # Process each form field validation
        # Display errors, call custom onFormSubmit() function
        #
        # @method validate
        # @param {Object} event jQuery Event
        # @return {Boolean} Is form valid or not
        ###
        validate: ( event ) ->
            valid = true
            @focusedField = false

            for item in [0..@items.length-1]
                if ( @items[ item ]? and false == @items[ item ].validate() )
                    valid = false

                    if ( !@focusedField and 'first' == @options.focus or 'last' == @options.focus )
                        @focusedField = @items[ item ].$element

            # form is invalid, focus an error field depending on focus policy
            if ( @focusedField and !valid )
                @focusedField.focus()

            @options.listeners.onFormSubmit( valid, event, this )

            return valid

        isValid: () ->
            for item in [0..@items.length-1]
                if ( false == @items[ item ].isValid() )
                    return false

            return true

        ###*
        # Remove all errors ul under invalid fields
        #
        # @method removeErrors
        ###
        removeErrors: () ->
            for item in [0..@items.length-1]
                @items[ item ].parsley( 'reset' )

        ###*
        # destroy Parsley binded on the form and its fields
        #
        # @method destroy
        ###
        destroy: () ->
            for item in [0..@items.length-1]
                @items[ item ].destroy()

            @$element.off(".#{@type}").removeData(@type)

        ###*
        # reset Parsley binded on the form and its fields
        #
        # @method reset
        ###
        reset: () ->
            for item in [0..@items.length-1]
                @items[ item ].reset()

    ###*
    # Parsley plugin definition
    # Provides an interface to access public Validator, ParsleyForm and ParsleyField functions
    #
    # @class Parsley
    # @constructor
    # @param {Mixed} Options. {Object} to configure Parsley or {String} method name to call a public class method
    # @param {Function} Callback function
    # @return {Mixed} public class method return
    ###
    $.fn.parsley = ( option, fn ) ->
        options = $.extend( true, {}, $.fn.parsley.defaults, (if window.ParsleyConfig? then window.ParsleyConfig else {}), option, @data() )
        newInstance = null

        bind = (self, type) ->
            parsleyInstance = $(self).data(type)

            # if data never binded or we want to clone a build (for radio & checkboxes), bind it right now!
            if ( !parsleyInstance )
                switch ( type )
                    when 'parsleyForm' then parsleyInstance = new ParsleyForm(self, options, 'parsleyForm')
                    when 'parsleyField' then parsleyInstance = new ParsleyField(self, options, 'parsleyField')
                    when 'parsleyFieldMultiple' then parsleyInstance = new ParsleyFieldMultiple( self, options, 'parsleyFieldMultiple' )
                    else return

                $(self).data(type, parsleyInstance)

            # here is our parsley public function accessor
            if ( 'string' == typeof option and 'function' == typeof parsleyInstance[ option ] )
                response = parsleyInstance[ option ]( fn )

                return if response? then response else $(self)

            return parsleyInstance

        # if a form elem is given, bind all its input children
        if ($(this).is('form') or true == $(this).data('bind'))
            newInstance = bind($(@), 'parsleyForm')

        # if it is a Parsley supported single element, bind it too, except inputs type hidden
        # add here a return instance, cuz' we could call public methods on single elems with data[ option ]() above
        else if ( $( this ).is( options.inputs ) and !$( this ).is( options.excluded ) )
            newInstance = bind( $( this ), if !$( this ).is( 'input[type=radio], input[type=checkbox]' ) then 'parsleyField' else 'parsleyFieldMultiple' )

        return if 'function' == typeof fn then fn() else newInstance

    $.fn.parsley.Constructor = ParsleyForm.constructor

    ###*
    # Parsley plugin configuration
    #
    # @property $.fn.parsley.defaults
    # @type {Object}
    ###
    $.fn.parsley.defaults =
        # basic data-api overridable properties here..
        inputs: 'input, textarea, select'           # Default supported inputs.
        excluded: 'input[type=hidden], input[type=file], :disabled' # Do not validate input[type=hidden] & :disabled.
        trigger: false                            # $.Event() that will trigger validation. eg: keyup, change..
        animate: true                             # fade in / fade out error messages
        animateDuration: 300                      # fadein/fadout ms time
        focus: 'first'                            # 'fist'|'last'|'none' which error field would have focus first on form validation
        validationMinlength: 3                    # If trigger validation specified, only if value.length > validationMinlength
        successClass: 'parsley-success'           # Class name on each valid input
        errorClass: 'parsley-error'               # Class name on each invalid input
        errorMessage: false                       # Customize an unique error message showed if one constraint fails
        validators: {}                            # Add your custom validators functions
        showErrors: true                          # Set to false if you don't want Parsley to display error messages
        messages: {}                              # Add your own error messages here

        #some quite advanced configuration here..
        validateIfUnchanged: false                                          # false: validate once by field value change
        errors:
            classHandler: ( elem, isRadioOrCheckbox ) -> return             # specify where parsley error-success classes are set
            container: ( elem, isRadioOrCheckbox ) -> return                # specify an elem where errors will be **apened**
            errorsWrapper: '<ul></ul>'                                        # do not set an id for this elem, it would have an auto-generated id
            errorElem: '<li></li>'                                            # each field constraint fail in an li
        listeners:
            onFieldValidate: ( elem, ParsleyForm ) -> return false  # Executed on validation. Return true to ignore field validation
            onFormSubmit: ( isFormValid, event, ParsleyForm ) -> return     # Executed once on form validation
            onFieldError: ( elem, constraints, ParsleyField ) -> return     # Executed when a field is detected as invalid
            onFieldSuccess: ( elem, constraints, ParsleyField ) -> return   # Executed when a field passes validation

    # PARSLEY auto-bind DATA-API + Global config retrieving
    # ==================================
    $(window).on('load', () ->
        $('[data-validate="parsley"]').each( () ->
            $(this).parsley()
        )
    )

    # This plugin works with jQuery or Zepto (with data extension built for Zepto.)
)(window.jQuery or window.Zepto)
