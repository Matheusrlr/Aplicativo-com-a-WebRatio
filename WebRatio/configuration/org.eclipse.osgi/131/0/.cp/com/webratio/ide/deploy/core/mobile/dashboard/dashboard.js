(function($) {

    var POLL_PATH = "/poll";
    var POLL_INTERVAL = 1000;
    var MAX_FAILED_POLLS = 2;
    
    var polledOnce = false;
    var failedPolls = 0;
    var $block = null;
    var blockType = null;

    function poll(refresh) {
        var query = "";
        if (refresh) {
            query = "?refresh=true";
        }
        
        $.ajax({
            dataType: "json",
            url: POLL_PATH + query,
            success: processPollData,
            timeout: POLL_INTERVAL * 2
        }).done(function() {
            failedPolls = 0;
            polledOnce = true;
            setMainMessage(null);
        }).fail(function() {
            failedPolls++;
            if (failedPolls > MAX_FAILED_POLLS) {
                setMainMessage("Connection to the WebRatio Editor lost. Content may be out of date.");
                polledOnce = false;
            }
        }).always(function() {
            window.setTimeout(poll, POLL_INTERVAL);
        });
    }

    function processPollData(data) {
        var name
        for (name in data) {
            if (data.hasOwnProperty(name)) {
                createOrUpdateBlock(name, data[name]);
            }
        }
        refreshBlockStatus();
    }
    
    function refreshBlockStatus() {
        if ($block) {
            $(".noBlocksMessage").hide();
        } else {
            $(".noBlocksMessage").show();
        }
    }
    
    function createOrUpdateBlock(name, info) {
        if (!$block) {
            var templateHTML = $("#blockTemplate").html();
            $block = $($.parseHTML(templateHTML));
            //initBlock($block, name);
            $block.appendTo(document.body);
        }
        updateBlock($block, name, info);
    }
    
    function deleteBlock(name) {
        if ($block) {
            $block.remove();
        }
    }
    
    function initBlock($block, name) {
        $block.find(".removeLink").on("click", function() {
            deleteBlock(name);
        });
        $block.find(".name").text(name);
    }
    
    function updateBlock($block, name, info) {
        var key;
        for (key in info) {
            if (info.hasOwnProperty(key)) {
				callHandler($block, name, key, info[key]);
            }
        }
        
        $block.removeClass('block-' + blockType);
        blockType = name;
        $block.addClass('block-' + blockType);
        
        $block.find(".date").text((new Date()).toLocaleString());
    }
    
	function callHandler($block, group, key, value) {
		var handlersForGroup = HANDLERS[group];
		var handler = handlersForGroup && handlersForGroup[key];
		if (handler) {
			handler.handlerFn($block.find(handler.selector), value);
		} else if (group !== "generic") {
			callHandler($block, "generic", key, value); // recurse
		}
	}
	
    var HANDLERS = {
		"generic": {
    	    "projectName": handler(handleProjectName, ".name")
		},
		"test": {
            "emulate_waitState": handler(handleWaitState, ".emulateStatus .waitMessage"),
            "emulate_url": handler(handleEmulatorUrl, ".emulateStatus .message"),
            "serve_waitState": handler(handleWaitState, ".serveStatus .waitMessage"),
            "serve_address": handler(handleServeAddress, ".serveStatus .message"),
            "serve_address_qrcode_url": handler(handleQRCodeUrl, ".serveStatus .qrcode")
		},
		"build-android": {
            "build_waitState": handler(handleWaitState, ".androidBuildStatus .waitMessage"),
			"build_problems": handler(handleProblems, ".panel-build-android .problem-template"),
            "build_url": handler(handleRemotePackageUrl, ".androidBuildStatus .message"),
            "build_url_qrcode_url": handler(handleQRCodeUrl, ".androidBuildStatus .qrcode")
		},
		"build-ios": {
            "build_waitState": handler(handleWaitState, ".iosBuildStatus .waitMessage"),
			"build_problems": handler(handleProblems, ".panel-build-ios .problem-template"),
            "build_url": handler(handleRemotePackageUrl, ".iosBuildStatus .message"),
            "build_url_qrcode_url": handler(handleQRCodeUrl, ".iosBuildStatus .qrcode")
		},
		"build-windows": {
			"build_waitState": handler(handleWaitState, ".windowsBuildStatus .waitMessage"),
			"build_problems": handler(handleProblems, ".panel-build-windows .problem-template"),
			"build_install_command": handler(handleCommandName, ".windowsApplicationPanel"),
			"build_install_state": handler(handleWindowsApplicationPanel, ".windowsApplicationPanel"),
		},
    };
    
	var INTRO_MESSAGES = {
		".panel-test": {
			"running": "Test servers are starting",
			"": "Your Mobile Application is now ready to be tested."
		},
		".panel-build-android": {
			"running": "Your Mobile Application is building",
			"": "Your Mobile Application is now ready to be installed."
		},
		".panel-build-ios": {
			"running": "Your Mobile Application is building",
			"": "Your Mobile Application is now ready to be installed."
		},
		".panel-build-windows": {
			"running": "Your Mobile Application is building",
			"": "Your Mobile Application is now ready to be installed."
		}
	};
	
    var WAIT_MESSAGES = {
        ".emulateStatus": {
            "unavailable": "Invoke the <b>Generate and Run</b> command.",
            "running": "Emulator starting..."
        },
        ".serveStatus": {
            "unavailable": "Invoke the <b>Generate and Run</b> command.",
            "running": "Server starting..."
        },
        ".androidBuildStatus": {
            "unavailable": "Run an <i>Android</i> build configuration.",
            "running": "Build in progress..."
        },
        ".iosBuildStatus": {
            "unavailable": "Run an <i>iOS</i> build configuration.",
            "running": "Build in progress..."
        },
        ".windowsBuildStatus": {
            "unavailable": "Run a <i>Windows</i> build configuration.",
            "running": "Build in progress..."
        }
    };
    
    function handler(handlerFn, selector) {
        return {
            selector: selector,
            handlerFn: handlerFn
        };
    }
    
    function handleProjectName($el, value) {
        $el.text(value ? value : "");
    }
    
    function handleWaitState($el, value) {
		var introMessage = null;
		var selector;
		for (selector in INTRO_MESSAGES) {
			if (INTRO_MESSAGES.hasOwnProperty(selector) && $el.closest(selector)[0]) {
				introMessage = INTRO_MESSAGES[selector][value || ""];
			}
		}
		
        var waitMessage = null;
        if (value) {
            var selector;
			for (selector in WAIT_MESSAGES) {
				if (WAIT_MESSAGES.hasOwnProperty(selector) && $el.closest(selector)[0]) {
					waitMessage = WAIT_MESSAGES[selector][value];
				}
			}
        }
		
		if (introMessage) {
			$el.closest(".panel").find(".intro").text(introMessage);
		} else {
			$el.closest(".panel").find(".intro").empty();
		}
        
        if (waitMessage) {
            $el.html(waitMessage);
            $el.closest(".overlay").show();
        } else {
            $el.closest(".overlay").hide();
            $el.empty();
        }
    }
	
	function handleProblems($el, value) {
		value = value || [];
		$el.siblings(".problem").remove();
		for (var i = 0; i < value.length; i++) {
			var problem = value[i];
			var $message = $(document.importNode($el[0].content, true).childNodes);
			$message.addClass("problem-" + problem["severity"]);
			$message.text(problem["message"]);
			$message.insertAfter($el);
		}
	}
    
    function handleEmulatorUrl($el, value) {
        if (value) {
            $el.html("<a class=\"button\" href=\"" + value + "\" target=\"_blank\">Open Emulator</a>");
        } else {
            $el.empty();
        }
    }
    
    function handleServeAddress($el, value) {
        if (value) {
            $el.html(value);
        } else {
            $el.empty();
        }
    }
    
    function handleRemotePackageUrl($el, value) {
        if (value) {
            $el.find(".download-link").prop("href", value);
			$el.show();
        } else {
            $el.hide();
        }
    }
	
	function handleCommandName($el, value) {
		if (value) {
			$el.find(".command-link").each(function() {
				this.dataset["commandName"] = value;
			});
			$el.show();
		} else {
			$el.hide();
		}
	}
    
    function handleBuildMessage($el, value) {
        $el.html(value ? value : undefined);
    }
    
    function handleQRCodeUrl($el, value) {
        if (value) {
            $el.attr("src", value);
            $el.show();
        } else {
            $el.hide();
        }
    }
    
	function handleWindowsApplicationPanel($el, value) {
		
		var winAppMessage = $(".windowsApplicationMessage");
		var winAppOnPcButton = $(".windowsApplicationOnPcButton");
		var winAppOnPcMessage = $(".windowsApplicationOnPcMessage");
		var winAppOnDeviceButton = $(".windowsApplicationOnDeviceButton");
		var winAppOnDeviceMessage = $(".windowsApplicationOnDeviceMessage");
		var winAppErrorMessage = $(".windowsApplicationErrorMessage");
		
		// first disable all buttons and remove messages
		disableWindowsApplicationButton(winAppOnPcButton, winAppOnPcMessage);
		disableWindowsApplicationButton(winAppOnDeviceButton, winAppOnDeviceMessage);
		
		if (value) {
			value = JSON.parse(value);
		}
		if (value && (value["state"] == "starting")) {
			winAppMessage.css("opacity", ".5");
			if (value["device"] == "true") {
				showWindowsApplicationMessage(winAppOnDeviceButton, winAppOnDeviceMessage, "Starting on device");
			} else {
				showWindowsApplicationMessage(winAppOnPcButton, winAppOnPcMessage, "Starting on PC");
			}
		} else {
			winAppMessage.css("opacity", "1");
			enableWindowsApplicationButton(winAppOnPcButton, winAppOnPcMessage);
			enableWindowsApplicationButton(winAppOnDeviceButton, winAppOnDeviceMessage);
		}
		if (value && (value["state"] == "failed")) {
			winAppErrorMessage.html("Error: " + value["error"]);
			winAppErrorMessage.show();
		} else {
			winAppErrorMessage.hide();
		}
	}
	
	function showWindowsApplicationMessage(buttonElement, messageElement, message) {
		buttonElement.hide();
		messageElement.html(message);
		messageElement.show();
	}
	
	function enableWindowsApplicationButton(buttonElement, messageElement) {
		buttonElement.css("opacity", "1");
		buttonElement.attr("href", "#");
		buttonElement.on("click", function() {
			var commandName = this.dataset["commandName"];
			var commandArgs = this.dataset["commandArgs"];
			$.get(commandName + (commandArgs ? "?" + commandArgs : ""));
		});
		buttonElement.show();
		messageElement.hide();
	}
	
	function disableWindowsApplicationButton(buttonElement, messageElement) {
		buttonElement.css("opacity", ".5");
		buttonElement.removeAttr("href");
		buttonElement.removeAttr("onclick");
		buttonElement.show();
		messageElement.hide();
	}
	
    function setMainMessage(value) {
        var $el = $(".mainMessage");
        if (value) {
            $el.html(value);
            $el.show();
        } else {
            $el.hide();
            $el.empty();
        }
    }
    
	$(document).ready(function() {
		poll(true);
	});

})(jQuery);
