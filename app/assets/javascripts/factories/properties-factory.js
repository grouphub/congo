var congoApp = angular.module('congoApp');

congoApp.factory('propertiesFactory', [
  function () {
    return {
      getPropertiesFromElements: function (elements) {
        return _.reduce(
          elements,
          function (sum, element) {
            sum[element.name] = element.value;

            return sum;
          },
          {}
        );
      }
    };
  }
]);

