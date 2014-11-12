var congoApp = angular.module('congoApp');

congoApp.factory('eventsFactory', [
  function () {
    var emitter = new EventEmitter2();

    return {
      on: function ($scope, type, listener) {
        emitter.on(type, listener);

        $scope.$on('$destroy', function() {
          emitter.off(type, listener);
        });
      },
      off: function (type, listener) {
        emitter.off(type, listener);
      },
      emit: function () {
        emitter.emit.apply(emitter, arguments);
      }
    };
  }
]);

