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