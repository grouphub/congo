!function(){
  "use strict";

  angular.module('congoApp').factory('carrierIdService', carrierIdService);

  function carrierIdService(){
    var carrierId = null;

    function get(){
      return carrierId;
    };

    function set(id){
      carrierId = id;
    };

    return {
      get: get,
      set: set
    }
  };
}();
