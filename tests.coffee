createElement = (type="text", attrs={}) ->
    params = {type: type}
    params = _.extend(params, attrs)

    element = $("<input />", params)
    $("#tests-data").append(element)
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

    describe "FieldMultiple tests", ->
        field = null

        afterEach ->
            if field != null
                field.destroy()

        it "Check field multiple directly", ->
            element1 = createElement("checkbox", {"data-mincheck": "2", "name": "tt"})
            element2 = createElement("checkbox", {"data-mincheck": "2", "name": "tt"})
            element3 = createElement("checkbox", {"data-mincheck": "2", "name": "tt"})

            field = new parsley.FieldMultiple(element1)
            expect(field.validate()).to.be(false)

            element1.attr("checked", "true")
            element2.attr("checked", "true")
            expect(field.validate()).to.be(true)


    describe "Individual form field validation", ->
        element = null
        field = null

        afterEach ->
            if field != null
                field.destroy()

            if element != null
                element.remove()


        it "required field", ->
            element = createElement("text", {"data-required": "true"})
            field = new parsley.Field(element)

            expect(field.validate()).to.be(false)

            element.val("dd")
            expect(field.validate()).to.be(true)
            element.remove()

        it "type digits", ->
            element = createElement("text", {"data-type":"digits"})
            field = new parsley.Field(element)
            expect(field.validate()).to.be(null)

            element.val("dd")
            expect(field.validate()).to.be(false)

            element.val("22")
            expect(field.validate()).to.be(true)

        it "type number", ->
            element = createElement("text", {"data-type": "number"})
            field = new parsley.Field(element)

            element.val("2.2")
            expect(field.validate()).to.be(true)

            element.val("dd")
            expect(field.validate()).to.be(false)


