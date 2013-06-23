# Required fields

requiredForm = ->
    form = $("form.required-form").parsley()
    $("form.required-form").on "click", ".validate", (event) ->
        event.preventDefault()
        form.validate()


$ ->
    requiredForm()
