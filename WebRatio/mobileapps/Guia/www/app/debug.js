
(function() {

	

	/* Improve logging on some platforms */
	if (navigator.userAgent.indexOf("Windows Phone ") >= 0) {

		/* Ensure that unexpected errors are logged */
		window.addEventListener("error", function(event) {
			console.error("Uncaught error: " + event.message + "\n\tat " + event.filename + ":" + event.lineno + ":" + event.colno);
		});
	}

})();