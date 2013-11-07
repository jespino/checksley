Validators
==========

To use the validators you have to define in the fiels a data attributed based on the validator name (Example: data-required="True").

Core validators
---------------

.. js:function:: type

  The value of the field must fit the data-type.

  :param string data-type: Type of validator

  .. js:data:: email

    The field value must be an email.

  .. js:data:: url

    The field value must be an url.

  .. js:data:: urlstrict

    The field value must be an url (must have the protocol defined).

  .. js:data:: digits

    The field value must be a digit.

  .. js:data:: dateIso

    The field value must be a date in iso format.

  .. js:data:: alphanum

    The field value must be a alphanumeric value.

  .. js:data:: phone

    The field value must be a US phone number.

.. js:function:: notnull

  The field must have a value.

  :param boolean data-notnull:

.. js:function:: notblank

  The field must have a not blank (spaces, tabs...) value.

  :param boolean data-notblank:

.. js:function:: required

  The field must have a value.

  :param boolean data-required:

.. js:function:: regexp

  The field value must match the data-regexp.

  :param string data-regexp: Regular expresion to verify

.. js:function:: min

  The field value must be greater than data-min.

  :param number data-min: Min value

.. js:function:: max

  The field value must be smaller than data-max.

  :param number data-max: Max value

.. js:function:: range

  The field value must be between data-range[0] and data-range[1].

  :param list data-range: List of [min, max]

.. js:function:: minlength

  The field value must be longer than data-minlength.

  :param integer data-minlength: Min length

.. js:function:: maxlength

  The field value must be shorter than data-maxlength.

  :param integer data-maxlength: Max length

.. js:function:: rangelength

  The field value must have a length between data-rangelength[0] and data-rangelength[1].

  :param list data-rangelength: List of [minlength, maxlength]

.. js:function:: mincheck

  Synonym of :js:func:`max`

.. js:function:: maxcheck

  Synonym of :js:func:`min`

.. js:function:: rangecheck

  Synonym of :js:func:`range`

.. js:function:: equalto


Extend validators
-----------------
.. js:function:: minwords

  The field value must have more than data-minwords words.

  :param integer data-minwords: Min words

.. js:function:: maxwords

  The field value must have less than data-maxwords words.

  :param integer data-maxwords: Max words

.. js:function:: rangewords

  The field value must have words between data-rangewords[0] and data-rangewords[1].

  :param list data-rangewords: List of [minwords, maxwords]

.. js:function:: greaterthanvalue

  The field value must be greater than the value of data-greaterthan.

  :param selector data-greaterthan: Min value.

.. js:function:: lessthanvalue

  The field value must be smaller than the value of data-lessthan.

  :param selector data-lessthan: Max value.

.. js:function:: beforedatevalue

  The field value must date be a date before the date in data-beforedate.

  :param selector data-beforedate: Max date.

.. js:function:: afterdatevalue

  The field value must date be a date after the date in data-afterdate.

  :param selector data-afterdate: Min date.

.. js:function:: greaterthan

  The field value must be greater than the field selected by data-greaterthan.

  :param selector data-greaterthan: A jquery selector of other field.

.. js:function:: lessthan

  The field value must be smaller than the field selected by data-lessthan.

  :param selector data-lessthan: A jquery selector of other field.

.. js:function:: beforedate

  The field value must date be a date before the field selected by data-beforedate.

  :param selector data-beforedate: A jquery selector of other field.

.. js:function:: afterdate

  The field value must date be a date after the field selected by data-afterdate.

  :param selector data-afterdate: A jquery selector of other field.

.. js:function:: inlist

  The field value must be in the list of valid values.

  :param string data-inlist: List of valid values
  :param string data-inlistDelimiter: Delimiter to split the data-inlist string in valid values.

.. js:function:: luhn

  The field value must pass the luhn algorithm (Validates credit card numbers,
  as well as some other kinds of account numbers).

  :param boolean data-luhn:

.. js:function:: americandate

  The field value must be a valid american date.

  :param boolean data-americandate:

L10N validators
---------------

ES
~~

.. js:function:: es_dni

  The field value must be a valid Spanish DNI.

  :param boolean data-es_dni:

.. js:function:: es_cif

  The field value must be a valid Spanish CIF.

  :param boolean data-es_cif:

.. js:function:: es_postalcode

  The field value must be a valid Spanish postal code.

  :param boolean data-es_postalcode:

.. js:function:: es_ssn

  The field value must be a valid Spanish social security number.

  :param boolean data-es_ssn:

.. js:function:: es_ccc

  The field value must be a valid Spanish bank account number (Codigo Cuenta Cliente).

  :param boolean data-es_ccc:

US
~~

.. js:function:: us_region

  The field value must be a valid USA region.

  :param boolean data-us_region:

.. js:function:: us_postalcode

  The field value must be a valid USA postal code.

  :param boolean data-us_postalcode:
