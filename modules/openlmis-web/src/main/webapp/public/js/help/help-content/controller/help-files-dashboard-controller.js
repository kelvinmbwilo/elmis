/*
 * Electronic Logistics Management Information System (eLMIS) is a supply chain management system for health commodities in a developing country setting.
 *
 * Copyright (C) 2015  John Snow, Inc (JSI). This program was produced for the U.S. Agency for International Development (USAID). It was prepared under the USAID | DELIVER PROJECT, Task Order 4.
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
function HelpDashboardContentController($scope, $location,HelpUsertopicList){
    $scope.title = "Help Content List View";
    ////alert('here');
    // all products list
    HelpUsertopicList.get({}, function (data) {
        $scope.helpTopicList = data.helpTopicList;
    }, function (data) {
        ////alert('successfully loaded');
        $location.path($scope.$parent.sourceUrl);
    });
//    this is to edit the help category
//    $scope.editHelpTopic = function (id) {
//        ////alert(' here to edit');
////        var data = {query: $scope.query};
////        navigateBackService.setData(data);
////        sharedSpace.setCountOfDonations(donationCount);
//        $location.path('/edit/:' + id);
//    };

    $scope.viewHelpContent = function (id) {
        ////alert(' nave to help content view');
//        var data = {query: $scope.query};
//        navigateBackService.setData(data);
//        sharedSpace.setCountOfDonations(donationCount);
        $location.path('/viewhelp/' + id);
    };
}
