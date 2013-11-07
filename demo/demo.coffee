# Required fields

demo =
    requiredForm: ->
        section = $(".required-section")
        form = section.find("form").checksley()

        section.on "click", ".validate", (event) ->
            event.preventDefault()
            form.validate()

    digitsForm: ->
        section = $(".type-digits-section")
        form = section.find("form").checksley()

        section.on "click", ".validate", (event) ->
            event.preventDefault()
            form.validate()

    rangeForm: ->
        section = $(".type-range-section")
        form  = section.find("form").checksley()

        section.on "click", ".validate", (event) ->
            event.preventDefault()
            form.validate()

    composedValidationForm: ->
        section = $(".type-composed-validation")
        form  = section.find("form").checksley()

        section.on "click", ".validate", (event) ->
            event.preventDefault()
            form.validate()

    interceptSubmit: ->
        section = $(".intercept-submit")
        form = section.find("form").checksley({interceptSubmit:true})


$ ->
    fn() for name, fn of demo
