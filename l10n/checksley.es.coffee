validators =
    es_dni: ( val, elem, self ) ->
        letters = 'TRWAGMYFPDXBNJZSQVHLCKET'
        val = val.replace("-", "")
        val = val.toUpperCase()
        number = val.substring(0, val.length - 1)
        letter = val[val.length - 1]

        if (!/\d+/.test(number))
            return false

        if (!letters.indexOf(letter) < 0)
            return false

        return letter == letters[parseInt(number, 10) % 23]

    es_postalcode: (val, elem, self) ->
        if (!/^\d{5}$/.test(val))
            return false

        provinceCode = parseInt(val.substring(0,2), 10)

        if (provinceCode > 52 or provinceCode < 1)
            return false

        return true

    es_ssn: (val, elem, self) ->
        val = val.replace(/[ \/-]/g, "")
        if (!/^\d{12}$/.test(val))
            return false

        a = val.substring(0, 2)
        b = val.substring(2, 10)
        code = val.substring(10, 12)

        if (parseInt(b, 10) < 10000000)
            d = parseInt(b, 10) + (parseInt(a, 10) * 10000000)
        else
            d = a + b.replace(/0*$/, "")

        c = parseInt(d) % 97
        return c == parseInt(code)

    es_ccc: (val, elem, self) ->
        val = val.replace(/[ -]/g, "")
        if (!/\d{20}$/.test(val))
            return false

        weight = [1, 2, 4, 8, 5, 10, 9, 7, 3, 6]
        entity = val.substring(0, 4)
        office = val.substring(4, 8)
        controlCode = val.substring(8, 10)
        account = val.substr(10, 20)
        firstCode = "00" + entity + office
        secondCode = account
        firstCodeResult = 0

        for x in [0..9]
            firstCodeResult += parseInt(firstCode[x], 10) * weight[x]

        firstCodeMod = firstCodeResult % 11
        firstCodeResult = 11 - firstCodeMod

        if (firstCodeResult == 10)
            firstCodeResult = 1

        if (firstCodeResult == 11)
            firstCodeResult = 0

        secondCodeResult = 0
        for x in [0..9]
            secondCodeResult += parseInt(secondCode[x], 10) * weight[x]

        secondCodeMod = secondCodeResult % 11
        secondCodeResult = 11 - secondCodeMod
        if (secondCodeResult == 10)
            secondCodeResult = 1

        if (secondCodeResult == 11)
            secondCodeResult = 0

        if (firstCodeResult == parseInt(controlCode[0]) and secondCodeResult == parseInt(controlCode[1]))
            return true

        return false

    es_cif: (val, elem, self) ->

        val = val.replace(/-/g, "").toUpperCase()

        if (!/^[ABCDEFGHJKLMNPRQSUVW]\d{7}[\d[ABCDEFGHIJ]$/.test(val))
            return false

        letter = val.substring(0, 1)
        provinceCode = val.substring(1, 3)
        number = val.substring(3, 8)
        controlCode = val.substring(8, 9)

        if (/[CKLMNPQRSW]/.test(letter) and /\d/.test(controlCode))
            return false

        if (/[ABDEFGHJUV]/.test(letter) and /[A-Z]/.test(controlCode))
            return false

        oddSum = parseInt(provinceCode[1], 10) + parseInt(number[1], 10) + parseInt(number[3], 10)

        evenSum = 0
        oddNumbers = [
            parseInt(provinceCode[0], 10)
            parseInt(number[0], 10)
            parseInt(number[2], 10)
            parseInt(number[4], 10)
        ]

        for number in oddNumbers
            x = number * 2
            if (x >= 10)
                x = (x % 10) + 1
            evenSum += x

        totalSum = oddSum + evenSum
        reminder = totalSum % 10

        controlDigit = (if reminder != 0 then 10 - reminder else 0)

        if (controlCode != controlDigit.toString() and 'JABCDEFGHI'[controlDigit] != controlCode)
            return false

        return true


messages =
    es_dni:         "This value should be a valid DNI (Example: 00000000T)."
    es_cif:         "This value should be a valid CIF (Example: B00000000)."
    es_postalcode:  "This value should be a valid spanish postal code (Example: 28080)."
    es_ssn:         "This value should be a valid spanish social security number."
    es_ccc:         "This value should be a valid spanish bank client account code."


@checksley.updateValidators(validators)
@checksley.updateMessages("default", messages)
