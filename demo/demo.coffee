# Required fields

demo =
    requiredForm: ->
        section = $(".required-section")
        form = section.find("form").parsley()

        section.on "click", ".validate", (event) ->
            event.preventDefault()
            form.validate()

    digitsForm: ->
        section = $(".type-digits-section")
        form = section.find("form").parsley()

        section.on "click", ".validate", (event) ->
            event.preventDefault()
            form.validate()


$ ->
    fn() for name, fn of demo
