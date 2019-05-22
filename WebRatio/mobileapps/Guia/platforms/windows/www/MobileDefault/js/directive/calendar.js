(function () {
	/* Module with customizations for MobileDefault Calendar Component Style */
	var module = angular.module('mobileDefault.calendar', []);
	
	module.directive('wrMonthCalendar', function() {
		
		function link (scope, element, attr) {

			scope.$watch(attr["dateCollection"], function(newData, oldData) {
				
				var date = angular.copy(newData);
				var firstDay = scope.$eval(attr["firstDay"]);
				var lastDayofWeek = (firstDay + 6) % 7;
				var weeks = [];
				
				if (date && date.length) {
					/* Add previous month days */
				    var firstDate = new Date(date[0]["date"]);
				    while (firstDate.getDay() !== firstDay) {
				    	firstDate.setDate(firstDate.getDate() - 1);
				    	date.splice(0, 0, {
				    		"date": new Date(firstDate),
				            "data": [],
				            "dataSize": 0
				    	});
				    }

					/* Add next month days */
				    var lastDate = new Date(date[date.length-1]["date"]);
				    while (lastDate.getDay() !== lastDayofWeek) {
				    	lastDate.setDate(lastDate.getDate() + 1);
				    	date.push({
				    		"date": new Date(lastDate),
				            "data": [],
				            "dataSize": 0
				    	});
				    }
				    
				    var week = null;
				    date.forEach(function(day, index) {
				    	if (day["date"].getDay() === firstDay) {
				    		// new week
				    		week = { "days": [] };
				    		weeks.push(week);
				    	} 
				    	week["days"].push(day);
				    	
				    })
					
				}
				
				scope["weeks"] = weeks;
			});
		}
		
		
		return {
			restrict: 'E',
			link: link,
			
		}
	});
	
})();