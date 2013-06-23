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


@parsley.updateValidators(validators)
@parsley.updateMessages(messages)
