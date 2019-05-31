
wrx = window.wrx || {};
wrx.EmulatorSupport = (function() {
	
	var IGNORED_STUBS = {
	};
	
	function createAllStubs() {
		var allStubs = {};
		
		function addStubs(stubs) {
			var nativeObjName
			for (nativeObjName in stubs) {
				if (!stubs.hasOwnProperty(nativeObjName)) {
					continue;
				}
				if (allStubs[nativeObjName]) {
					console.error("Found conflicting emulator stubs for native object '" + nativeObjName + "'");
				}
				allStubs[nativeObjName] = stubs[nativeObjName];
			}
		}
		
		
				
				(function() {
					console.log("Enabling emulation of plugin com.webratio.accountmanager");
					function createStubs() {

    var STORAGE_KEY = "com.webratio.accountmanager.data";
    var INITIAL_DATA = {
        username: null,
        password: null,
        token: null
    };
    var $ = window.top.jQuery;
    var loginDialog = null;

    function log() {
        var args = [].slice.call(arguments, 0);
        args.unshift("[accountmanager]");
        console.log.apply(console, args);
    }

    function save(data) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    }

    function load() {
        var s = localStorage.getItem(STORAGE_KEY);
        return s ? JSON.parse(s) : INITIAL_DATA;
    }

    function promptLogin(message, title, buttonLabels, username, readonly) {

        if (!loginDialog) { // create dialog
            var loginPrompt = $('<div id="am-login-prompt" title="Login">' + '<p class="msg"></p>' + '<form>' + '<fieldset>'
                    + '<label for="name" style="display: block;">Username</label>'
                    + '<input type="text" name="username" id="username" class="text ui-corner-all" style="width: 100%;">'
                    + '<label for="password" style="display: block;">Password</label>'
                    + '<input type="password" name="password" id="password" class="text ui-corner-all" style="width: 100%;">'
                    + '</fieldset>' + '</form>' + '</div>');

            $('#overlay-views').append(loginPrompt);
            loginDialog = loginPrompt.dialog({
                appendTo: "#overlay-views",
                autoOpen: false,
                closeOnEscape: false,
                modal: true,
                position: { my: "center", at: "center", of: $('#viewport-container') },
                close: function() {
                    var result = {
                        "buttonIndex": loginDialog.data("clickedButton"),
                        "username": $("#username", loginDialog).val(),
                        "password": $("#password", loginDialog).val()
                    }
                    loginDialog.data("resolver")(result);
                }
            });

        }
        
        loginDialog.data("clickedButton", 0);
        loginDialog.data("resolver", null);

        // configure dialog options
        loginDialog.dialog("option", "title", title);
        $(".msg", loginDialog).text(message);
        $("#username", loginDialog).val((username && username.length) ? username : "");
        if (readonly) {
            $("#username", loginDialog).prop("disabled", "disabled");
        } else {
            $("#username", loginDialog).removeProp("disabled");
        }

        $("#password", loginDialog).val("");

        return new Promise(function(resolve, reject) {
            loginDialog.data("resolver", resolve);
            var buttons = [];
            var buttonCreate = function(label, i) {
                var index = i + 1;
                return {
                    text: label,
                    click: function() {
                        loginDialog.data("clickedButton", index);
                        loginDialog.dialog("close");
                    }
                }
            }

            for (var i = 0; i < buttonLabels.length; i++) {
                buttons.push(buttonCreate(buttonLabels[i], i))
            }
            
            $('#platform-events-fire-back').css("display", "none");
            $('#platform-events-fire-suspend').before("<button id=\"platform-events-fire-back-contacts\">Back</button>");
            $('#platform-events-fire-back-contacts').button().css("width", "90px").click(function(evt) {
                $('#platform-events-fire-back-contacts').remove();
                $('#platform-events-fire-back').css("display", "");
                loginDialog.dialog("close");
            });
            

            loginDialog.dialog("option", "buttons", buttons);
            loginDialog.dialog("open");
        })
    }

    return {
        AM: {
            setPackage: function(packageName) {
                log("Set package", packageName);
            },
            enableSharing: function(groupId, teamId) {
                log("Enabled sharing", groupId, teamId);
            },
            clear: function() {
                save(INITIAL_DATA);
                log("Cleared", load());
            },
            setUsername: function(username) {
                var data = load();
                data.username = username;
                save(data);
                log("Updated username", load());
            },
            getUsername: function() {
                var username = load().username;
                log("Read username");
                return username;
            },
            setPassword: function(password) {
                var data = load();
                data.password = password;
                save(data);
                log("Updated password", load());
            },
            getPassword: function() {
                var password = load().password;
                log("Read password");
                return password;
            },
            setToken: function(token) {
                var data = load();
                data.token = token;
                save(data);
                log("Updated token", load());
            },
            getToken: function() {
                var token = load().token;
                log("Read token");
                return token;
            },
            getDeviceId: function() {
                return device.uuid;
            },
            loginPrompt: function(message, title, buttonLabels, username, readonly) {
                log("Login Prompt");
                return promptLogin(message, title, buttonLabels, username, readonly);
            }
        }
    };
};
					addStubs(createStubs(Object.create(emulatorContext, {
						loadScriptFile: {
							value: function(path) {
								var doc = this.rippleWindow.document;
								var head = doc.getElementsByTagName("head")[0];
								var script = doc.createElement("SCRIPT");
								script.setAttribute("src", "app/emulation_libs/com.webratio.accountmanager/" + path);
								head.appendChild(script);
							}
						}
					})));
				})();
				
			
				
				(function() {
					console.log("Enabling emulation of plugin cordova-plugin-dialogs");
					function createStubs() {
    
    var audioContext = (function() {
        // Determine if the Audio API is supported by this browser
        var AudioApi = window.AudioContext;
        if (!AudioApi) {
            AudioApi = window.webkitAudioContext;
        }
        
        if (AudioApi) {
            // The Audio API is supported, so create a singleton instance of the
            // AudioContext
            return new AudioApi();
        }
        
        return undefined;
    }());
    
    function log() {
        var args = [].slice.call(arguments, 0);
        args.unshift("[notification]");
        console.log.apply(console, args);
    }
    
    return {
        Notification : {
            prompt : function(message, title, buttonLabels, defaultText) {
                if (title) {
                    message = title + "\n" + message;
                }
                var result = window.prompt(message, defaultText || '');
                
                if (result === null) {
                    return {
                        buttonIndex : 2,
                                input1 : ''
                    }; // Cancel
                } else {
                    return {
                        buttonIndex : 1,
                        input1 : result
                    }; // OK
                }
                
            },
            
            progressStart : function(title, message) {
                log("progressStart");
            },
            
            progressStop : function() {
                log("progressStop");
            },
            
            progressValue : function(value) {
                log("progressValue");
            },
            
            vibrate : function(success, error, args) {
                log("vibrate");
            },
            
            beep : function(times) {
                if (times > 0) {
                    var BEEP_DURATION = 700;
                    var BEEP_INTERVAL = 300;
                    
                    if (audioContext) {
                        // Start a beep, using the Audio API
                        var osc = audioContext.createOscillator();
                        osc.type = 0; // sounds like a "beep"
                        osc.connect(audioContext.destination);
                        osc.start(0);
                        
                        setTimeout(function() {
                            // Stop the beep after the BEEP_DURATION
                            osc.stop(0);
                            
                            if (--times > 0) {
                                // Beep again, after a pause
                                setTimeout(function() {
                                    navigator.notification.beep(times);
                                }, BEEP_INTERVAL);
                            }
                            
                        }, BEEP_DURATION);
                    } else if (typeof (console) !== 'undefined'
                            && typeof (console.log) === 'function') {
                        // Audio API isn't supported, so just write `beep` to
                        // the console
                        for (var i = 0; i < times; i++) {
                            log('Beep!');
                        }
                    }
                }
            }
        }
    };
};

					addStubs(createStubs(Object.create(emulatorContext, {
						loadScriptFile: {
							value: function(path) {
								var doc = this.rippleWindow.document;
								var head = doc.getElementsByTagName("head")[0];
								var script = doc.createElement("SCRIPT");
								script.setAttribute("src", "app/emulation_libs/cordova-plugin-dialogs/" + path);
								head.appendChild(script);
							}
						}
					})));
				})();
				
			
				
				(function() {
					console.log("Enabling emulation of plugin ionic-plugin-keyboard");
					function createStubs() {

    document.body.addEventListener('focusin', function(e) {
        cordova.fireWindowEvent('native.keyboardshow', { 'keyboardHeight': "0"});
    });
    document.body.addEventListener('focusout', function(e) {
        cordova.fireWindowEvent('native.keyboardhide');
    });

    function log() {
        var args = [].slice.call(arguments, 0);
        args.unshift("[Keyboard]");
        console.log.apply(console, args);
    }

    return {
        Keyboard: {
            hideKeyboardAccessoryBar: function(hide) {
                log("Hide Keyboard Accessory Bar", hide);
            },
            close: function() {
                //log("Close");
            },
            show: function() {
                //log("Show");
            },
            disableScroll: function(disable) {
                log("Disable Scroll", disable);
            }
        }
    };
};
					addStubs(createStubs(Object.create(emulatorContext, {
						loadScriptFile: {
							value: function(path) {
								var doc = this.rippleWindow.document;
								var head = doc.getElementsByTagName("head")[0];
								var script = doc.createElement("SCRIPT");
								script.setAttribute("src", "app/emulation_libs/ionic-plugin-keyboard/" + path);
								head.appendChild(script);
							}
						}
					})));
				})();
				
			
		
		return allStubs;
	}
	
	function getRippleWindow() {
		var win = window.parent;
		return (!!win.ripple ? win : null);
	}
	
	function getRippleCordovaBridge() {
		var rippleWindow = getRippleWindow();
		return rippleWindow && rippleWindow.ripple("platform/cordova/2.0.0/bridge");
	}
	
	function enableRippleSupport() {
		var bridge = getRippleCordovaBridge();
		if (!bridge) {
			return;
		}
		var allStubs = createAllStubs();
		
		function createWrappedFunction(stubFn) {
			return function(successCB, errorCB, args) {
				successCB = successCB || function() {};
				errorCB = errorCB || function() {};
				try {
					Promise.resolve(stubFn.apply(this, args)).then(successCB, errorCB);
				} catch (e) {
					errorCB(e);
				}
			};
		}
		
		var nativeObjName
		for (nativeObjName in allStubs) {
			if (!allStubs.hasOwnProperty(nativeObjName)) {
				continue;
			}
			var stub = allStubs[nativeObjName];
			
			var wrappedStub = {};
			var functionName;
			for (functionName in stub) {
				var stubFn = stub[functionName];
				if (!IGNORED_STUBS[nativeObjName + "/" + functionName]) {
					wrappedStub[functionName] = createWrappedFunction(stubFn);
				}
			}
			
			bridge.merge(nativeObjName, wrappedStub);
		}
	}
	
	function configureManagement() {
		console.log("Configuring app management module");
		angular.module("wr.mvc.mgmt.AppManagement").config(function(wrAppManagementConfigProvider) {
			wrAppManagementConfigProvider.set(
				{
  "runtime" : [ { } ],
  "classes" : {
    "data.AppUser" : {
      "id" : "MUser"
    },
    "data.AppRole" : {
      "id" : "MRole"
    },
    "data.Categoria" : {
      "id" : "cls2"
    },
    "data.Estabelecimento" : {
      "id" : "cls3"
    },
    "data.Tipo" : {
      "id" : "cls1"
    },
    "data.Feedback" : {
      "id" : "cls4"
    },
    "data.Menu" : {
      "id" : "cls5"
    }
  },
  "notifications" : { },
  "databases" : {
    "Guia de Calouro" : { }
  },
  "screens" : {
    "scr6" : {
      "name" : "Menu",
      "setNames" : [ ]
    },
    "scr2" : {
      "name" : "Login",
      "setNames" : [ ]
    },
    "scr5" : {
      "name" : "Estabelecimentos",
      "setNames" : [ ]
    },
    "scr1" : {
      "name" : "Home",
      "setNames" : [ ]
    },
    "scr4" : {
      "name" : "Variedade",
      "setNames" : [ ]
    },
    "scr8" : {
      "name" : "Detalhes",
      "setNames" : [ ]
    },
    "scr3" : {
      "name" : "Categorias",
      "setNames" : [ ]
    },
    "scr7" : {
      "name" : "Formulário",
      "setNames" : [ ]
    }
  },
  "locales" : {
    "en" : {
      "language" : "en"
    }
  }
}
			);
		});
	}
	
	function getConfigOverrides() {
		return new Promise(function(resolve, reject) {
			resolveLocalFileSystemURL(cordova.file.dataDirectory + "wr-config.json", function(fileEntry) {
				fileEntry.file(function(file) {
					var fr = new FileReader();
					fr.onload = function() {
						resolve(fr.result);
					};
					fr.onerror = reject;
					fr.readAsText(file);
				}, reject);
			}, reject);
		}).then(function(configText) {
			var config = JSON.parse(configText);
			console.log("Overriding app configuration: " + JSON.stringify(config));
			return config;
		}, function(e) {
			return {};
		});
	}
	
	var _startListeners = [];
	
	var emulatorContext = {
		rippleWindow: getRippleWindow(),
		properties: {
			
		},
		addStartListener: function(fn) {
			_startListeners.push(fn);
		}
	};
	
	var _resultingModule = {
		start: function() {
			enableRippleSupport();
			configureManagement();
			
			function invokeListeners() {
				if (!angular.element(window.document).injector()) {
					setTimeout(invokeListeners, 15); // delay until Angular is ready
					return;
				}
				_startListeners.forEach(function(listener) {
					listener();
				});
			}
			invokeListeners();
		},
		getConfigOverrides: getConfigOverrides
	};
	
	
	
	
		(function() {
			var _additions = (function() {
				/*
 * Makes available an emulation operation that adds a screen switching UI.
 */

var rippleDoc = emulatorContext.rippleWindow && emulatorContext.rippleWindow.document;

/* Function for creating the main positioned element */
function createMainElement(doc, name) {
    var el = doc.createElement(name);
    el.style.position = "absolute";
    el.style.top = "1em";
    el.style.width = "60%";
    el.style.left = "20%";
    el.style.backgroundColor = "#1E1E1E";
    doc.getElementById("device-container").appendChild(el);
    return el;
}

var switcherEnabled = false;

/* Function for enabling the switcher UI */
function enableScreenSwitcher() {
    if (switcherEnabled) {
        return;
    }
    if (!rippleDoc) {
        return;
    }

    var screens;
    try {
        screens = wr.mvc.mgmt.Screen.getAll();
    } catch (e) {
        var errorEl = createMainElement(rippleDoc, "DIV");
        errorEl.style.maxHeight = "2em";
        errorEl.style.overflowY = "scroll";
        errorEl.style.fontSize = "90%";
        errorEl.style.color = "#FF0000";
        errorEl.textContent = e.message;
        switcherEnabled = true;
        return;
    }

    /* Prepare information about select options for each screen */
    var options = [];
    var ssKeys = {};
    screens.forEach(function(screen) {
        var setNames = screen.getSetNames();

        options.push({
            label: screen.getName(),
            depth: setNames.length,
            qname: screen.getQualifiedName(),
            screen: screen
        });

        for (var i = setNames.length; i > 0; i--) {
            var ssKey = setNames.slice(0, i).join(" / ");
            if (ssKeys[ssKey] === true) {
                continue;
            }
            ssKeys[ssKey] = true;
            options.push({
                label: setNames[i - 1],
                depth: i - 1,
                qname: ssKey,
                screen: null
            });
        }
    });

    /* Sort options by alphabet and tree depth */
    options.sort(function(a, b) {
        var aq = a.qname.toUpperCase(), bq = b.qname.toUpperCase();
        return (aq < bq ? -1 : (aq > bq ? 1 : 0));
    });

    /* Create the screen selector */
    var selectEl = createMainElement(rippleDoc, "SELECT");
    selectEl.style.color = "#FFFFFF";

    /* Add options to the selector */
    options.forEach(function(option, optionIndex) {
        var label = "";
        for (var i = 0; i < option.depth; i++) {
            label += " - ";
        }
        label += option.label;

        var optionEl = rippleDoc.createElement("OPTION");
        if (!option.screen) {
            optionEl.style.color = "#AAAAAA";
            optionEl.disabled = true;
        }
        optionEl.value = optionIndex;
        optionEl.textContent = label;
        selectEl.appendChild(optionEl);
    });

    /* Initiate a screen switch when the selection changes */
    selectEl.addEventListener("change", function(event) {
        var option = options[selectEl.value];
        console.log("[Screen Switch UI] Switching to " + option.screen);
        selectEl.disabled = true;
        option.screen.switchTo().then(function() {
            selectEl.disabled = false;
            console.log("[Screen Switch UI] Switch complete");
        }, function(e) {
            selectEl.disabled = false;
            console.error("[Screen Switch UI] Switch failed");
        });
    });

    /* Refresh the selection when the screen is switched for other reasons */
    function refreshCurrentScreen() {
        var screen = wr.mvc.mgmt.Screen.getCurrent();
        if (screen) {
            for (var i = 0; i < options.length; i++) {
                if (options[i].screen === screen) {
                    selectEl.value = i;
                    return;
                }
            }
        }
        selectEl.value = "";
    }
    wr.mvc.mgmt.Screen.registerSwitchListener(refreshCurrentScreen);
    refreshCurrentScreen(); // first refresh

    switcherEnabled = true;
}

/* Enable as soon as the emulator starts, if asked via properties */
if (emulatorContext.properties["screenSwitcher"] === "true") {
    emulatorContext.addStartListener(function() {
        enableScreenSwitcher();
    });
}

return {
    enableScreenSwitcher: enableScreenSwitcher
};

			})();
			for (var p in _additions) {
				if (_additions.hasOwnProperty(p)) {
					_resultingModule[p] = _additions[p];
				}
			}
		})();
	
	
	return _resultingModule;
})();
