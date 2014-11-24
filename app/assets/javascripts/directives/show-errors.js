angular.module('app', []).
  directive('showErrors', function() {
    return {
      restrict: 'A',
      link: function(scope, el) {
        el.bind('blur', function() {
          var valid = // is valid logic
          el.toggleClass('has-error', valid);
        });
      }
    }
  });