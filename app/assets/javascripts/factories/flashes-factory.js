var congoApp = angular.module('congoApp');

congoApp.factory('flashesFactory', [
  'eventsFactory',
  function (eventsFactory) {
    var flashes = [];
    var maxAge = 1;

    return {
      flashes: flashes,
      add: function (type, message) {
        flashes = [];

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
      clear: function () {
        flashes = [];

        eventsFactory.emit('flashes:changed', flashes);
      },
      update: function () {
        var me = this;

        flashes = _(flashes).reduce(function (sum, flash) {
          if (isNaN(flash.age)) {
            flash.age = 0;
          }

          if (flash.age < maxAge) {
            sum.push(flash);
          }

          flash.age++;

          return sum;
        }, []);

        eventsFactory.emit('flashes:changed', flashes);
      }
    };
  }
]);

