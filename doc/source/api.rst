API
===

.. js:class:: Checksley(jq)

  The main Checksley class.

  :param object jq: JQuery or Zepto instance.

  .. js:function:: updateDefaults(options)

    Update the default checksley configuration with the options object.

    :param object options: Options object to overwrite the defaults

  .. js:function:: updateValidators(validators)

    Updated (or add) checksley validators.

    :params object validators: Validators object to overwrite the checksley validators

  .. js:function:: updateMessages(lang, messages)

    Updated (or add) checksley messages of a language.

    :params string lang: Language code (optional)
    :params object messages: Messages object to overwrite the language messages.

  .. js:function:: injectPlugin()

    Inject the plugin on the jQuery or Zepto.

  .. js:function:: setLang(lang)

    Set the current language.

    :param string lang: Language code

  .. js:function:: detectLang()

    Try to detect the language from the html.

  .. js:function:: getMessage(key, lang)

    Get a message from a language.

    :param string key: The message key
    :param string lang: The language code (optional)

.. js:class:: Form(elm, options={})

  .. js:function:: initialize()

    Initialize the form initializing the fields, binding the events and bindind the data fields.

  .. js:function:: bindData()

    Set the data checksley attribute to the form storing the :js:class:`Form` object.

  .. js:function:: unbindData()

    Unset the data checksley attribute to the form storing the :js:class:`Form` object.

  .. js:function:: initializeFields()

    Initialize the Field objects for all the fields of the form.

  .. js:function:: setErrors()

    Add to html the errors of this form as custom error messages.

    :param object errors: An object of key/value with field name as key and error message as value.

  .. js:function:: validate()

    Validate all the fields of the form.

    :return: boolean

  .. js:function:: bindEvents()

    Connect valiation to the form events.

  .. js:function:: unbindEvents()

    Disconnect valiation of the form events.

  .. js:function:: removeErrors()

    Remove error messages.

  .. js:function:: destroy()

    Destroy the form.

  .. js:function:: reset()

    Reset the status of the form.

.. js:class:: Field(elm, options={})

  .. js:function:: bindData()

    Unset the data checksley-field attribute to the form storing the :js:class:`Field` object.

  .. js:function:: unbindData()

    Unset the data checksley-field attribute to the form storing the :js:class:`Field` object.

  .. js:function:: focus()

    Set the focus in the field.

  .. js:function:: eventValidate(event)

    Handle events that trigger the validation.

    :param Event event:

  .. js:function:: unbindEvents()

    Disconnect valiation of the field events.

  .. js:function:: bindEvents()

    Connect valiation to the field events.

  .. js:function:: errorClassTarget()

    # TODO: Review this method
    Return the target of the error class.

  .. js:function:: resetHtml5Constraints()

    Reload the constraints of the field based on his html5 type attribute.

  .. js:function:: resetConstraints()

    Reload the constraints of the field based on his data attributes.

  .. js:function:: hasConstraints()

    Check if the field has any constraint/validation.

    :return: boolean

  .. js:function:: validate(showErrors)

    Apply general validators and call :js:func:`applyValidators`.

    :param boolean showErrors: Enable error showing on this validation.

  .. js:function:: applyValidators(showErrors)

    Apply specific field validators.

    :param boolean showErrors: Enable error showing on this validation.

  .. js:function:: handleClasses(valid)

    Add/remove classes to the field based on valid param.

    :param boolean valid: validation status

  .. js:function:: manageError(name, constraint)

    Obtain and add to the html the error message for a validation and a constraint.

    :param string name: Validator name.
    :param object constraint: Constraint object.

  .. js:function:: setErrors(messages)

    Add to html the errors of this field as custom error messages.

    :param object messages: A string or an array of string with the error messages.

  .. js:function:: makeErrorElement(constraintName, message)

    Build a li element with the message as content, and with the classes checksley-<constraintName> and <constraintName>.

    :param string constraintName: The constraint thats generate the error.
    :param string message: The error mesage.
    :return: Element

  .. js:function:: addError(errorElement)

    :param Element errorElement: The li element with the error to add.

    Add the errorElement to the error container of the field.

  .. js:function:: reset()

    Reset the status of the field.

  .. js:function:: removeErrors()

    Remove the field errors.

  .. js:function:: getValue()

    Get the current value of the field.

    :return: string

  .. js:function:: errorContainerId()

    Get the error container id.

    :return: string

  .. js:function:: errorContainerClass()

    Get the error container class.

    :return: string

  .. js:function:: getErrorContainer()

    Return the field error container (create one if not exists).

  .. js:function:: destroy()

    Destroy the field.

  .. js:function:: setForm(form)

    Set the form of the field.

    :param Form form:

.. js:class:: FieldMultiple(elm, options)

  Subclass of Field.

  .. js:function:: getSibligns()

    Get the other fields in the multifield group.

  .. js:function:: getValue()

    Get the value based on the multiple field type (radio or checkbox).

    :return: string

  .. js:function:: unbindEvents()

    Disconnect valiation of the field events.

  .. js:function:: bindEvents()

    Connect valiation to the field events.

.. js:class:: ComposedField(elm, options)

  Subclass of Field.

  .. js:function:: getComponents()

    Get a list of jQuery objects that compound the composed field based on the
    data-composed attribute value.

    :return: [element]

  .. js:function:: getValue()

    Get the value based on the composition of the getComposed() returned fields
    joined with the data-composed-joiner attribute.

    :return: string

  .. js:function:: unbindEvents()

    Disconnect valiation of the field events.

  .. js:function:: bindEvents()

    Connect valiation to the field events.
