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

  .. js:function:: unbindData()

  .. js:function:: initializeFields()

  .. js:function:: setErrors()

  .. js:function:: validate()

  .. js:function:: bindEvents()

  .. js:function:: unbindEvents()

  .. js:function:: removeErrors()

  .. js:function:: destroy()

  .. js:function:: reset()

.. js:class:: Field(elm, options={})

  .. js:function:: bindData()

  .. js:function:: unbindData()

  .. js:function:: focus()

  .. js:function:: eventValidate(event)

  .. js:function:: unbindEvents()

  .. js:function:: bindEvents()

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

  .. js:function:: addError(errorElement)

  .. js:function:: reset()

  .. js:function:: removeErrors()

  .. js:function:: getValue()

  .. js:function:: errorContainerId()

  .. js:function:: errorContainerClass()

  .. js:function:: getErrorContainer()

  .. js:function:: destroy()

  .. js:function:: setForm(form)

    :param Form form:

.. js:class:: FieldMultiple(elm, options)

  Subclass of Field.

  .. js:function:: getSibligns()

  .. js:function:: getValue()

  .. js:function:: unbindEvents()

  .. js:function:: bindEvents()
