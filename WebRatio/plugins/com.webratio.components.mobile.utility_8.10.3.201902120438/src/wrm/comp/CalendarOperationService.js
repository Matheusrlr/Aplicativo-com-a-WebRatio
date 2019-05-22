/**
 * Service for Calendar Operation operations.
 * 
 * @constructor
 * @extends wrm.core.AbstractOperationService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractOperationService, {

    /** @override */
    initialize: function(descr) {

        /**
         * @private
         * @type {!string}
         */
        this._mode = descr["mode"];
    },

    /** @override */
    executeOperation: function(context) {
        var calendarPromise;
        if (this._mode === "save") {
            calendarPromise = this._executeSaveEvent(context);
        } else {
            calendarPromise = this._executeOpenCalendar(context);
        }
        return calendarPromise.then(function() {
            return new wrm.nav.Output("success");
        }, function(e) {
            return new wrm.nav.Output("error");
        });
    },

    /**
     * @private
     * @param {!wrm.core.OperationContext} context
     * @return {!Promise}
     */
    _executeSaveEvent: function(context) {
        var input = context.getInput();

        /* Compute dates and times */
        var startDate = wrm.data.toDate(input["startDate"]) || wrm.data.Date.fromDate(new Date());
        var startTime, endDate, endTime;
        if (input["allDay"]) {
            startTime = wrm.data.Time.fromTimestamp(0); // midnight
            endDate = wrm.data.Date.fromTimestamp(startDate.asDate().valueOf() + 86400000); // add 1 day
            endTime = wrm.data.Time.fromTimestamp(0); // midnight
        } else {
            endDate = wrm.data.toDate(input["endDate"]) || undefined;
            startTime = wrm.data.toTime(input["startTime"]);
            endTime = wrm.data.toTime(input["endTime"]);
        }

        /* Merge date and time */
        var startNativeDate = startDate.asDate();
        if (startTime) {
            startNativeDate.setHours(startTime.getHours());
            startNativeDate.setMinutes(startTime.getMinutes());
            startNativeDate.setSeconds(startTime.getSeconds());
            startNativeDate.setMilliseconds(startTime.getMilliseconds());
        }
        var endNativeDate = endDate ? endDate.asDate() : undefined;
        if (endNativeDate && endTime) {
            endNativeDate.setHours(endTime.getHours());
            endNativeDate.setMinutes(endTime.getMinutes());
            endNativeDate.setSeconds(endTime.getSeconds());
            endNativeDate.setMilliseconds(endTime.getMilliseconds());
        }

        /* Prepare other event properties */
        var title = input["title"];
        var location = input["location"];
        var notes = input["notes"];
        var options = /** @type {!CalendarCreateEventOptions} */({});
        if (input["recurrence"]) {
            options.recurrence = input["recurrence"];
            options.recurrenceEndDate = input["recEndDate"] ? wrm.data.toDate(input["recEndDate"]).asDate() : undefined;
        }

        return new Promise(function(resolve, reject) {
            return GLOBAL.plugins.calendar.createEventInteractivelyWithOptions(title, location, notes, startNativeDate, endNativeDate,
                    options, resolve, reject);
        });
    },

    /**
     * @private
     * @param {!wrm.core.OperationContext} context
     * @return {!Promise}
     */
    _executeOpenCalendar: function(context) {
        var input = context.getInput();
        var nativeDate = (wrm.data.toDate(input["date"]) || wrm.data.DateTime.now()).asDate();
        return new Promise(function(resolve, reject) {
            GLOBAL.plugins.calendar.openCalendar(nativeDate, resolve, reject);
        });
    }

});
