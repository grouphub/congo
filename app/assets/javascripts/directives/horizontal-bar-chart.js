var congoApp = angular.module('congoApp');

congoApp.directive('horizontalBarChart', function () {
  return {
    restrict: 'E',
    replace: true,
    templateUrl: '/assets/directives/horizontal-bar-chart.html',
    link: function ($scope, $element, $attrs) {
      var data = $scope.data;
      var chartWidth = $attrs.chartWidth;
      var chartHeight = $attrs.chartHeight;
      var chartMargin = parseInt($attrs.chartMargin, 10);
      var barColor = $attrs.barColor;

      $scope.data = data;
      $scope.chartWidth = chartWidth;
      $scope.chartHeight = chartHeight;
      $scope.chartMargin = chartMargin;
      $scope.barColor = barColor;

      var html = _.map($scope.data.items, function (item, index) {
        var width = (chartWidth / $scope.data.items.length) - chartMargin * 2;
        var x = (chartWidth / $scope.data.items.length) * index;
        var y = item.value * chartHeight;
        var height = chartHeight - y;

        var $point = '<rect id="Rectangle-1" ' +
          'sketch:type="MSShapeGroup" ' +
          'x="' + x + '" ' +
          'y="' + y + '" ' +
          'width="' + width + '" ' +
          'height="' + height + '"></rect>';

        return $point;
      }).join("\n");

      $element.find('.horizontal-bar-chart').html(html);
    }
  };
});

