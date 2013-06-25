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

        it "validation range", ->
            element = createElement("text", {"data-range":"[3, 1000]"})
            field = new parsley.Field(element)

            element.val("1")
            expect(field.validate()).to.be(false)

            element.val("666")
            expect(field.validate()).to.be(true)

            element.val("1666")
            expect(field.validate()).to.be(false)

            element.remove()

        it "validation equalto", ->
            element = createElement("text", {"data-equalto":"#elementEqualId"})
            elementEqual = createElement("text", {"value":"foo", "id":"elementEqualId"})

            field = new parsley.Field(element)

            element.val("notfoo")
            expect(field.validate()).to.be(false)

            element.val("foo")
            expect(field.validate()).to.be(true)

            element.remove()
            elementEqual.remove()

        #TODO: checkboxes options
        #    mincheck:
        #    maxcheck:
        #    rangecheck:

    describe "Spanish form field validation", ->
        it "es_ssn field", ->
            element = createElement("text", {"data-es_ssn":"true"})
            field = new parsley.Field(element)

            element.val '281234567840'
            expect(field.validate()).to.be(true)

            element.val '351234567825'
            expect(field.validate()).to.be(true)

            element.val '35/12345678/25'
            expect(field.validate()).to.be(true)

            element.val '720111361735'
            expect(field.validate()).to.be(false)

            element.val '35X1234567825'
            expect(field.validate()).to.be(false)

            element.val '031322136383'
            expect(field.validate()).to.be(false)

            element.val '72011a361732'
            expect(field.validate()).to.be(false)

            element.val '73011a361731'
            expect(field.validate()).to.be(false)

            element.val '03092a136383'
            expect(field.validate()).to.be(false)

            element.val '03132a136385'
            expect(field.validate()).to.be(false)

            element.val '201113617312'
            expect(field.validate()).to.be(false)

            element.val '301113617334'
            expect(field.validate()).to.be(false)

            element.val '309221363823'
            expect(field.validate()).to.be(false)

            element.val '313221363822'
            expect(field.validate()).to.be(false)

            element.remove()

        it "es_ccc field", ->
            element = createElement("text", {"data-es_ccc":"true"})
            field = new parsley.Field(element)

            element.val '2077 0024 00 3102575766'
            expect(field.validate()).to.be(true)

            element.val '0000 0000 00 0000000000'
            expect(field.validate()).to.be(true)

            element.val '0001 0001 65 0000000001'
            expect(field.validate()).to.be(true)

            element.val '0'
            expect(field.validate()).to.be(false)

            element.val '2034 4505 73 1000034682'
            expect(field.validate()).to.be(false)

            element.val '1111 1111 11 1111111111'
            expect(field.validate()).to.be(false)

            element.remove()

         it 'es_postalcode', ->
            element = createElement("text", {"data-es_postalcode":"true"})
            field = new parsley.Field(element)

            element.val '28080'
            expect(field.validate()).to.be(true)

            element.val '35500'
            expect(field.validate()).to.be(true)

            element.val '12012'
            expect(field.validate()).to.be(true)

            element.val '25120'
            expect(field.validate()).to.be(true)

            element.val '59000'
            expect(field.validate()).to.be(false)

            element.val '10'
            expect(field.validate()).to.be(false)

            element.val 'X123'
            expect(field.validate()).to.be(false)

            element.remove()

         it 'es_cif', ->
            element = createElement("text", {"data-es_cif":"true"})
            field = new parsley.Field(element)

            element.val 'A58818501'
            expect(field.validate()).to.be(true)

            element.val 'B00000000'
            expect(field.validate()).to.be(true)

            element.val 'C0000000J'
            expect(field.validate()).to.be(true)

            element.val 'D00000000'
            expect(field.validate()).to.be(true)

            element.val 'E00000000'
            expect(field.validate()).to.be(true)

            element.val 'F00000000'
            expect(field.validate()).to.be(true)

            element.val 'G00000000'
            expect(field.validate()).to.be(true)

            element.val 'H00000000'
            expect(field.validate()).to.be(true)

            element.val 'J00000000'
            expect(field.validate()).to.be(true)

            element.val 'K0000000J'
            expect(field.validate()).to.be(true)

            element.val 'L0000000J'
            expect(field.validate()).to.be(true)

            element.val 'M0000000J'
            expect(field.validate()).to.be(true)

            element.val 'N0000000J'
            expect(field.validate()).to.be(true)

            element.val 'P0000000J'
            expect(field.validate()).to.be(true)

            element.val 'Q0000000J'
            expect(field.validate()).to.be(true)

            element.val 'R0000000J'
            expect(field.validate()).to.be(true)

            element.val 'S0000000J'
            expect(field.validate()).to.be(true)

            element.val 'U00000000'
            expect(field.validate()).to.be(true)

            element.val 'V00000000'
            expect(field.validate()).to.be(true)

            element.val 'W0000000J'
            expect(field.validate()).to.be(true)

            element.val 'B-00000000'
            expect(field.validate()).to.be(true)

            element.val 'K-0000000-J'
            expect(field.validate()).to.be(true)


            element.val 'X00000000'
            expect(field.validate()).to.be(false)

            element.val 'X0000000J'
            expect(field.validate()).to.be(false)

            element.val 'Y00000000'
            expect(field.validate()).to.be(false)

            element.val 'Y0000000J'
            expect(field.validate()).to.be(false)

            element.val 'Z00000000'
            expect(field.validate()).to.be(false)

            element.val 'Z0000000J'
            expect(field.validate()).to.be(false)

            element.val 'B0000000J'
            expect(field.validate()).to.be(false)

            element.val 'BC0000000'
            expect(field.validate()).to.be(false)

            element.val '123456678'
            expect(field.validate()).to.be(false)

            element.val 'I00000000'
            expect(field.validate()).to.be(false)

            element.val 'I0000000J'
            expect(field.validate()).to.be(false)

            element.val 'O00000000'
            expect(field.validate()).to.be(false)

            element.val 'O0000000J'
            expect(field.validate()).to.be(false)

            element.val 'T00000000'
            expect(field.validate()).to.be(false)

            element.val 'T0000000J'
            expect(field.validate()).to.be(false)

            element.remove()

         it 'es_dni', ->
            element = createElement("text", {"data-es_dni":"true"})
            field = new parsley.Field(element)

            element.val '12345678Z'
            expect(field.validate()).to.be(true)

            element.val '00000000T'
            expect(field.validate()).to.be(true)

            element.val '0T'
            expect(field.validate()).to.be(true)

            element.val '00000000-T'
            expect(field.validate()).to.be(true)

            element.val '12345678Z'
            expect(field.validate()).to.be(true)

            element.val '87654321J'
            expect(field.validate()).to.be(false)

            element.val '123456781'
            expect(field.validate()).to.be(false)

            element.val 'X12345678'
            expect(field.validate()).to.be(false)

            element.val '123K'
            expect(field.validate()).to.be(false)

            element.val '43215678X'
            expect(field.validate()).to.be(false)

            element.remove()
