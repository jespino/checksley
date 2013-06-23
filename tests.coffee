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
        it "required field", ->
            element = $("<input />", {"type": "text", "data-required": "true"})
            element.insertBefore($("body"))

            field = new parsley.Field(element)
            expect(field.validate()).to.be(false)

            element.val("dd")
            expect(field.validate()).to.be(true)
            element.remove()
