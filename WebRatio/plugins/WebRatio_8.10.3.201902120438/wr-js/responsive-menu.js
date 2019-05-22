(function($) {

	$(document).ready(function() {
		$("ul#navmenu li a").each(function() {
			if ($(this).next().length > 0) {
				$(this).addClass("parent");
			}
		});

		$(".toggle-menu").click(function(e) {
			e.preventDefault();
			$("ul#navmenu .hover").removeClass("hover");
			$(this).toggleClass("active");
			$("ul#navmenu").toggleClass("active");
			return false;
		});

		var menuEvents = function() {
			if (document.body.clientWidth < 768) {

				if (!$(".toggle-menu").hasClass("active")) {
					$("ul#navmenu").removeClass("active");
				} else {
					$("ul#navmenu").addClass("active");
				}
				$("ul#navmenu li a.parent").off('click').on('click', function(e) {
					// must be attached to anchor element to prevent bubbling
					e.preventDefault();
					$(this).parent("li").toggleClass("hover");
					return false;
				});

			} else if (document.body.clientWidth >= 768) {

				$("ul#navmenu li.hover").removeClass("hover");
				$("ul#navmenu li a").off('click');

			}
		};

		$(window).on('resize orientationchange', function() {
			menuEvents();
		});

		menuEvents();
	});

}(jQuery));