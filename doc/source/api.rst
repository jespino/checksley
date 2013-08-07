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

  .. js:function:: bindData()

    Set the data checksley attribute to the form storing the :js:class:`Form` object.

  .. js:function:: unbindData()

    Unset the data checksley attribute to the form storing the :js:class:`Form` object.

  .. js:function:: initializeFields()

  .. js:function:: setErrors()

  .. js:function:: validate()

  .. js:function:: bindEvents()

  .. js:function:: unbindEvents()

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

  .. js:function:: unbindEvents()

    Disconnect valiation of the field events.

  .. js:function:: bindEvents()

    Connect valiation to the field events.

  .. js:function:: errorClassTarget()

  .. js:function:: resetHtml5Constraints()

  .. js:function:: resetConstraints()

  .. js:function:: hasConstraints()

  .. js:function:: validate(showErrors)

  .. js:function:: applyValidators(showErrors)

  .. js:function:: handleClasses(valid)

  .. js:function:: manageError(name, constraint)

  .. js:function:: setErrors(messages)

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

  .. js:function:: getValue()

    Get the current value of the field.

    :return: string

  .. js:function:: errorContainerId()

  .. js:function:: errorContainerClass()

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
