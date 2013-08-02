ChecksleyFormDirective = ($parse, $compile, $window) ->
    restrict: "A"
    link: (scope, elm, attrs) ->
        element = angular.element(elm)
        element.on "submit", (event) ->
            event.preventDefault()

        form = element.checksley(listeners: {onFormSubmit: onFormSubmit})
        callback = $parse(attrs.gmChecksleyForm)

        onFormSubmit = (ok, event, form) ->
            scope.$apply ->
                callback(scope) if ok

        attachChecksley = ->
            form.destroy()
            form.initialize()

        scope.$on("$includeContentLoaded", attachChecksley)
        scope.$on("checksley:reset", attachChecksley)

        scope.$watch "checksleyErrors", (errors) ->
            if not _.isEmpty(errors)
                form.setErrors(errors)


ChecksleySubmitButtonDirective = ->
    restrict: "A"
    link: (scope, elm, attrs) ->
        element = angular.element(elm)
        element.on "click", (event) ->
            event.preventDefault()
            element.closest("form").trigger("submit")


module = angular.module('checksley', [])
module.directive('checksleyForm', ['$parse', '$compile', '$window', ChecksleyFormDirective])
module.directive('checksleySubmitButton', [ChecksleySubmitButtonDirective])
