'use strict';
angular.module('non_reporting', ['openlmis', 'ngGrid', 'ui.bootstrap.modal', 'ui.bootstrap.dropdownToggle'])
.config(['$routeProvider', function ($routeProvider) {
  $routeProvider.
    when('/list', {controller:NonReportingController, templateUrl:'partials/list.html',reloadOnSearch:false}).
    otherwise({redirectTo:'/list'});
}]).run(function($rootScope) {
   // $rootScope.Selected = "selected";
  });