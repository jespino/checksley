validators =
    us_postalcode: (val, elem, self) ->
        region = $(elem).data('region')
        if not region
            return /^[0-9]{5}((-| )[0-9]{4})?$/.test(val)

        switch region
            when 'PW' then ranges = {'696': '969'}  # Palau
            when 'FM' then ranges = {'696': '969'}  # Micronesia
            when 'MH' then ranges = {'696': '969'}  # Marshall Islands
            when 'MP' then ranges = {'696': '969'}  # North Marina Islands
            when 'GU' then ranges = {'696': '969'}  # Guam
            when 'AS' then ranges = {'96799': '96799'}  # American Samoa
            when 'AP' then ranges = {'962': '966'}  # American Forces (Pacific)
            when 'WA' then ranges = {'980': '994'}  # Washington
            when 'OR' then ranges = {'97': '97'}  # Oregon
            when 'HI' then ranges = {'967': '968'}  # Hawii
            when 'CA' then ranges = {'900': '961'}  # California
            when 'AK' then ranges = {'995': '999'}  # Alaska
            when 'WY' then ranges = {'820': '831', '83414': '83414'}  # Wyoming
            when 'UT' then ranges = {'84': '84'}  # Utah
            when 'NM' then ranges = {'870': '884'}  # New Mexico
            when 'NV' then ranges = {'889': '899'}  # Nevada
            when 'ID' then ranges = {'832': '839'}  # Idaho
            when 'CO' then ranges = {'80': '81'}  # Colorado
            when 'AZ' then ranges = {'85': '86'}  # Arizona
            when 'TX' then ranges = {'75': '79', '885': '885', '73301': '73301', '73344': '73344'}  # Texas
            when 'OK' then ranges = {'73': '74'}  # Oklahoma
            when 'LA' then ranges = {'700': '715'}  # Louisiana
            when 'AR' then ranges = {'716': '729'}  # Arkansas
            when 'NE' then ranges = {'68': '69'}  # Nebraska
            when 'MO' then ranges = {'63': '65'}  # Missouri
            when 'KS' then ranges = {'66': '67'}  # Kansas
            when 'IL' then ranges = {'60': '62'}  # Illinois
            when 'WI' then ranges = {'53': '54'}  # Wisconsin
            when 'SD' then ranges = {'57': '57'}  # South Dakota
            when 'ND' then ranges = {'58': '58'}  # North Dakota
            when 'MT' then ranges = {'59': '59'}  # Montana
            when 'MN' then ranges = {'550': '567'}  # Minnesota
            when 'IA' then ranges = {'50': '52'}  # Iowa
            when 'OH' then ranges = {'43': '45'}  # Ohio
            when 'MI' then ranges = {'48': '49'}  # Michigan
            when 'KY' then ranges = {'400': '427'}  # Kentucky
            when 'IN' then ranges = {'46': '47'}  # Indiana
            when 'AA' then ranges = {'340': '340'}  # American Forces (Central and South America)
            when 'TN' then ranges = {'370': '385'}  # Tennessee
            when 'MS' then ranges = {'386': '397'}  # Mississippi
            when 'GA' then ranges = {'30': '31', '398': '398', '39901': '39901'}  # Georgia
            when 'FL' then ranges = {'32': '34'}  # Flordia
            when 'AL' then ranges = {'35': '36'}  # Alabama
            when 'WV' then ranges = {'247': '269'}  # West Virginia
            when 'VA' then ranges = {'220': '246', '200': '201'}  # Virginia (partially overlaps with DC)
            when 'SC' then ranges = {'29': '29'}  # South Carolina
            when 'NC' then ranges = {'27': '28'}  # North Carolina
            when 'MD' then ranges = {'206': '219'}  # Maryland
            when 'DC' then ranges = {'200': '200', '202': '205', '569': '569'}  # District of Columbia
            when 'PA' then ranges = {'150': '196'}  # Pennsylvania
            when 'NY' then ranges = {'10': '14', '06390': '06390', '00501': '00501', '00544': '00544'}  # New York
            when 'DE' then ranges = {'197': '199'}  # Delaware
            when 'VI' then ranges = {'008': '008'}  # Virgin Islands
            when 'PR' then ranges = {'006': '007', '009': '009'}  # Puerto Rico
            when 'AE' then ranges = {'09': '09'}  # American Forces (Europe)
            when 'VT' then ranges = {'05': '05'}  # Vermont
            when 'RI' then ranges = {'028': '029'}  # Rhode Island
            when 'NJ' then ranges = {'07': '08'}  # New Jersey
            when 'NH' then ranges = {'030': '038'}  # New Hampshire
            when 'MA' then ranges = {'010': '027', '05501': '05501', '05544': '05544'}  # Massachusetts
            when 'ME' then ranges = {'039': '049'}  # Maine
            when 'CT' then ranges = {'06': '06'}  # Connecticut
            when 'UM' then ranges = {'': ''}  # U.S. Minor Outlying Islands
            else
                ranges = {'': ''}

        if (postalCode.length > 5)
            postalCode = postalCode.substr(0, 5)

        if (postalCode.length < 5)
            tmp = "00000#{postalCode}"
            postalCode = tmp.substr(tmp.length-5, tmp.length)

        valid = false
        for start, end in ranges
            zip_start = postalCode.substr(0, start.length)
            if (zip_start.parseInt(10) >= start.parseInt(10) and zip_start.parseInt(10) <= end.parseInt(10))
                valid = true
                break

        return valid

    us_region: (val, elem, self) ->
        val = val.toUpperCase()
        return val in ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC',
                       'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
                       'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT',
                       'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH',
                       'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT',
                       'VT', 'VA', 'WA', 'WV', 'WI', 'WY']

messages =
    us_region:      "This value should be a valid US region."
    us_postalcode:  "This value should be a valid US postal code."

@checksley.updateValidators(validators)
@checksley.updateMessages(messages)
