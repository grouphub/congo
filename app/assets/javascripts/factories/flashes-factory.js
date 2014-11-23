var congoApp = angular.module('congoApp');

congoApp.factory('flashesFactory', [
  'eventsFactory',
  function (eventsFactory) {
    var flashes = [];
    
    return {
      flashes: flashes,
      add: function (type, message) {
        flashes.push({
          type: type,
          message: message,
          age: 0,
          id: _.uniqueId()
        });

        eventsFactory.emit('flashes:changed', flashes);
      },
      // TODO: Use id instead
      remove: function (type, message) {
        flashes = _(flashes).reject(function (flash) {
          return (flash.type === type && flash.message === message);
        });

        eventsFactory.emit('flashes:changed', flashes);
      },
      update: function () {
        var me = this;

        flashes = _(flashes).reduce(function (sum, flash) {
          if (isNaN(flash.age)) {
            flash.age = 0;
          }

          flash.age++;

          if (flash.age < 2) {
            sum.push(flash);
          }

          return sum;
        }, []);

        eventsFactory.emit('flashes:changed', flashes);
      }
    };
  }
]);

