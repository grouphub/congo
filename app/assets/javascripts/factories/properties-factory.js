var congoApp = angular.module('congoApp');

congoApp.factory('propertiesFactory', [
  function () {
    return {
      getPropertiesFromElements: function (elements) {
        return _.reduce(
          elements,
          function (sum, element) {
            var value;
            if (element.items) {
              value = element.items[0].name;
            } else {
              value = element.value
            }

            sum[element.name] = value;

            return sum;
          },
          {}
        );
      }
    };
  }
]);

