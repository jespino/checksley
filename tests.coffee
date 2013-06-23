createElement = (type="text", attrs={}) ->
    params = {type: type}
    params = _.extend(params, attrs)

    element = $("<input />", params)
    $("#tests-data").append(element)
    return element


urls = [
      { url: "http://foo.com/bar_(baz)#bam-1", expected: true, strict: true }
    , { url: "http://www.foobar.com/baz/?p=364", expected: true, strict: true }
    , { url: "mailto:name@example.com", expected: true, strict: false }
    , { url: "foo.bar", expected: true, strict: false }
    , { url: "www.foobar.baz", expected: true, strict: false }
    , { url: "https://foobar.baz", expected: true, strict: true }
    , { url: "git://foobar.baz", expected: true, strict: true }
    , { url: "foo", expected: false, strict: false }
    , { url: "foo:bar", expected: false, strict: false }
    , { url: "foo://bar", expected: false, strict: false }
]

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
            $(".required-section input").val("foo")
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

        it "not null field", ->
            element = createElement("text", {"data-notnull": "true"})
            field = new parsley.Field(element)
            expect(field.validate()).to.be(null)

            element.val("  ")
            expect(field.validate()).to.be(true)

            element.val("foo")
            expect(field.validate()).to.be(true)

            element.remove()

        it "not blank field", ->
            element = createElement("text", {"data-notblank": "true"})
            field = new parsley.Field(element)
            expect(field.validate()).to.be(null)

            element.val("  ")
            expect(field.validate()).to.be(false)

            element.val("foo")
            expect(field.validate()).to.be(true)

            element.remove()

        it "required field", ->
            element = createElement("text", {"data-required": "true"})
            field = new parsley.Field(element)
            expect(field.validate()).to.be(false)

            element.val("dd")
            expect(field.validate()).to.be(true)

            element.remove()

        it "type number", ->
            element = createElement("text", {"data-type": "number"})
            field = new parsley.Field(element)

            element.val("2.2")
            expect(field.validate()).to.be(true)

            element.val("dd")
            expect(field.validate()).to.be(false)

            element.remove()

        it "type digits", ->
            element = createElement("text", {"data-type":"digits"})
            field = new parsley.Field(element)

            element.val("dd")
            expect(field.validate()).to.be(false)

            element.val("22")
            expect(field.validate()).to.be(true)

            element.remove()

        it "type alphanum", ->
            element = createElement("text", {"data-type":"alphanum"})
            field = new parsley.Field(element)

            element.val("@&")
            expect(field.validate()).to.be(false)

            element.val("foo")
            expect(field.validate()).to.be(true)

            element.remove()

        it "type email", ->
            element = createElement("text", {"data-type":"email"})
            field = new parsley.Field(element)

            element.val("foo")
            expect(field.validate()).to.be(false)

            element.val("foo@bar")
            expect(field.validate()).to.be(false)

            element.val("foo+baz@bar.com")
            expect(field.validate()).to.be(true)

            element.val("foo.bar@bar.com.ext")
            expect(field.validate()).to.be(true)

            element.remove()

        it "type url", ->
            element = createElement("text", {"data-type":"url"})

            for urlData in urls
                console.log urlData
                element.val(urlData.url)
                expect(field.validate()).to.be(urlData.expected)

            element.remove()

        it "type urlstrict", ->
            element = createElement("text", {"data-type":"url"})

            for urlData in urls
                console.log urlData
                element.val(urlData.url)
                expect(field.validate()).to.be(urlData.strict)

            element.remove()

        it "type dateIso", ->
            element = createElement("text", {"data-type":"dateIso"})
            field = new parsley.Field(element)

            element.val("foo")
            expect(field.validate()).to.be(false)

            element.val("1983-11-21")
            expect(field.validate()).to.be(true)

            element.remove()

        it "type phone", ->
            element = createElement("text", {"data-type":"phone"})
            field = new parsley.Field(element)

            element.val("foo")
            expect(field.validate()).to.be(false)

            element.val("(917) 5878 5457")
            expect(field.validate()).to.be(true)

            element.remove()

        it "validation minlength", ->
            element = createElement("text", {"data-minlength":"6"})
            field = new parsley.Field(element)

            element.val("foo")
            expect(field.validate()).to.be(false)

            element.val("foofoo")
            expect(field.validate()).to.be(true)

            element.remove()

        it "validation maxlength", ->
            element = createElement("text", {"data-maxlength":"6"})
            field = new parsley.Field(element)

            element.val("foo")
            expect(field.validate()).to.be(true)

            element.val("foofoofoo")
            expect(field.validate()).to.be(false)

            element.remove()

        it "validation rangelength", ->
            element = createElement("text", {"data-rangelength":"[3,6]"})
            field = new parsley.Field(element)

            element.val("fo")
            expect(field.validate()).to.be(false)

            element.val("foo")
            expect(field.validate()).to.be(true)

            element.val("foofoo")
            expect(field.validate()).to.be(true)

            element.val("foofoofoo")
            expect(field.validate()).to.be(false)

            element.remove()

        it "validation min", ->
            element = createElement("text", {"data-min":"3"})
            field = new parsley.Field(element)

            element.val(" ")
            expect(field.validate()).to.be(false)

            element.val("1")
            expect(field.validate()).to.be(false)

            element.val("5")
            expect(field.validate()).to.be(true)

            element.remove()

        it "validation max", ->
            element = createElement("text", {"data-max":"3"})
            field = new parsley.Field(element)

            element.val(" ")
            expect(field.validate()).to.be(true)

            element.val("1")
            expect(field.validate()).to.be(true)

            element.val("5")
            expect(field.validate()).to.be(false)

            element.remove()

        #TODO
        #    range:
        #    equalto:
        #    mincheck:
        #    maxcheck:
        #    rangecheck:
