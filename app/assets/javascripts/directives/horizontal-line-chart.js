var congoApp = angular.module('congoApp');

congoApp.directive('horizontalLineChart', function () {
  return {
    restrict: 'E',
    replace: true,
    templateUrl: '/assets/directives/horizontal-line-chart.html',
    link: function ($scope, $element, $attrs) {
      var data = $scope.data;
      var strokeWidth = $attrs.strokeWidth;
      var strokeColor = $attrs.strokeColor;
      var marginX = parseInt(strokeWidth, 10);
      var marginY = parseInt(strokeWidth, 10);
      var chartWidth = $attrs.chartWidth;
      var chartHeight = $attrs.chartHeight;
      var xScale = (chartWidth - (2 * marginX)) / (data.items.length - 1);
      var yScale = chartHeight - (2 * marginY);

      $scope.data = data;
      $scope.chartWidth = chartWidth;
      $scope.chartHeight = chartHeight;
      $scope.strokeWidth = strokeWidth;
      $scope.strokeColor = strokeColor;
      $scope.points = _.map($scope.data.items, function (item, index) {
        var x = marginX + xScale * index;
        var y = marginY + item.value * yScale;

        return (index === 0 ? 'M' : 'L') + x.toString() + ',' + y.toString();
      }).join(' ');
    }
  };
});

