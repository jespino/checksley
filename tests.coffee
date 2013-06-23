createElement = (type="text", attrs={}) ->
    params = {type: type}
    params = _.extend(params, attrs)

    element = $("<input />", params)
    element.insertBefore($("body"))
    return element

describe "Parsley test suite", ->
    describe "Form basic validation", ->
        form = null

        beforeEach ->
            if form != null
                form.destroy()
            form = $(".required-section form").parsley()

        it "Check required field validation 01", ->
            $(".required-section input").val("")
            expect(form.validate()).to.be(false)

        it "Check required field validation 02", ->
            $(".required-section input").val("kk")
            expect(form.validate()).to.be(true)

        it "Check error visualization", ->
            $(".required-section input").val("")
            form.validate()
            expect(form.element.find(".parsley-error").length).to.be(1)

    describe "Individual form field validation", ->
        element = null

        afterEach ->
            if element != null
                element.remove()

        it "required field", ->
            element = createElement("text", {"data-required": "true"})

            field = new parsley.Field(element)
            expect(field.validate()).to.be(false)

            element.val("dd")
            expect(field.validate()).to.be(true)
            element.remove()

        it "type number", ->
            element = createElement("text", {"data-type":"digits"})
            field = new parsley.Field(element)
            expect(field.validate()).to.be(null)

            element.val("dd")
            expect(field.validate()).to.be(false)

            element.val("22")
            expect(field.validate()).to.be(true)
