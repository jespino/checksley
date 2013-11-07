/*! checksley - v0.4.0 - 2013-11-07 */
(function() {
  var ChecksleyFormDirective, ChecksleySubmitButtonDirective, module;

  ChecksleyFormDirective = function($parse, $compile, $window) {
    return {
      restrict: "A",
      link: function(scope, elm, attrs) {
        var attachChecksley, callback, element, form, onFormSubmit;
        element = angular.element(elm);
        element.on("submit", function(event) {
          return event.preventDefault();
        });
        callback = $parse(attrs.checksleyForm);
        onFormSubmit = function(ok, event, form) {
          return scope.$apply(function() {
            if (ok) {
              return callback(scope);
            }
          });
        };
        form = element.checksley({
          listeners: {
            onFormSubmit: onFormSubmit
          }
        });
        attachChecksley = function() {
          form.destroy();
          return form.initialize();
        };
        scope.$on("$includeContentLoaded", attachChecksley);
        scope.$on("checksley:reset", attachChecksley);
        return scope.$watch("checksleyErrors", function(errors) {
          if (!_.isEmpty(errors)) {
            return form.setErrors(errors);
          }
        });
      }
    };
  };

  ChecksleySubmitButtonDirective = function() {
    return {
      restrict: "A",
      link: function(scope, elm, attrs) {
        var element;
        element = angular.element(elm);
        return element.on("click", function(event) {
          event.preventDefault();
          return element.closest("form").trigger("submit");
        });
      }
    };
  };

  module = angular.module('checksley', []);

  module.directive('checksleyForm', ['$parse', '$compile', '$window', ChecksleyFormDirective]);

  module.directive('checksleySubmitButton', [ChecksleySubmitButtonDirective]);

}).call(this);
