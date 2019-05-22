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
