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
