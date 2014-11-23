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
          message: message
        });

        eventsFactory.emit('flashes:changed', flashes);
      },
      remove: function (type, message) {
        flashes = _(flashes).reject(function (flash) {
          return (flash.type === type && flash.message === message);
        });

        eventsFactory.emit('flashes:changed', flashes);
      }
    };
  }
]);

