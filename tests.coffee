describe "Parsley test suite", ->
    describe "Form with required field", ->
        form = $(".required-section form").parsley()

        it "Check field validation 01", ->
            $(".required-section input").val("")
            expect(form.validate()).to.be(false)
