/**
 * Service for Calendar view components.
 * 
 * @constructor
 * @extends wrm.core.AbstractCachedViewComponentService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractCachedViewComponentService, {

    /** @override */
    initialize: function(descr) {
        var thisService = this;

        /**
         * @private
         * @type {!boolean}
         */
        this._classBased = descr["classBased"];

        if (this._classBased) {

            /**
             * @private
             * @type {!wrm.data.meta.Entity}
             */
            this._entity; // init'd below

            /**
             * @private
             * @type {!wrm.data.meta.Property}
             */
            this._dateAttribute; // init'd below

            /**
             * @private
             * @type {!Array}
             */
            this._order = descr["order"];

            /**
             * @private
             * @type {!Object}
             */
            this._output; // set below

            /**
             * @private
             * @type {!Object}
             */
            this._toBind; // init'd below

            // TODO cache query instead
            /**
             * @private
             * @type {!Object}
             */
            this._condExpr; // init'd below

            /**
             * @private
             * @type {!wrm.data.DataService}
             */
            this._dataService; // init'd below
        }

        /**
         * @private
         * @type {wrm.l10n.NameWidth}
         */
        this._daysType = (descr["shortWeekdays"] ? wrm.l10n.NameWidth.ABBREVIATED : wrm.l10n.NameWidth.WIDE);

        /**
         * @private
         * @type {wrm.l10n.NameWidth}
         */
        this._monthsType = (descr["shortMonths"] ? wrm.l10n.NameWidth.ABBREVIATED : wrm.l10n.NameWidth.WIDE);

        /**
         * @private
         * @type {number}
         */
        this._yearsBlockSize = descr["yearsBlockSize"];

        /**
         * @private
         * @type {!wrm.l10n.LocalizationService}
         */
        this._l10nService; // set below

        var promises = [];
        var manager = this.getManager();

        var localizationServicePromise = manager.getLocalizationService().then(function(l10nService) {
            thisService._l10nService = l10nService;
        });
        promises.push(localizationServicePromise);

        if (this._classBased) {
            var dataServicePromise = manager.getDataService().then(function(dataService) {
                thisService._dataService = dataService;
                thisService._entity = dataService.getMetadata().getEntity(descr["entity"]);
                thisService._dateAttribute = thisService._entity.getProperty(descr["dateAttribute"]);
                thisService._condExpr = descr["condExprs"];
                var keyAttr = thisService._entity.getKeyAttribute();
                var output = descr["output"];
                thisService._output = {};
                thisService._toBind = {};
                if (output.length !== 0) {
                    output.forEach(function(column) {
                        thisService._output[column["viewName"]] = column["ref"];
                        thisService._toBind[column["viewName"]] = column["bindName"];
                    });
                }
                thisService._output["__key"] = keyAttr.getId(); // for row tracking
            });
            promises.push(dataServicePromise);
        }
        return Promise.all(promises);
    },

    /** @override */
    createResult: function(context) {
        var input = context.getInput();
        var view = context.getView();
        var localeInfo = this._l10nService.getCurrentLocaleInfo();
        var now = new Date();
        var firstDay = localeInfo.getFirstDayOfWeek();
        var monthsNames = [];
        localeInfo.getMonthNames(this._monthsType).forEach(function(month, index) {
            monthsNames.push({
                "month": month,
                "index": index
            });
        });
        var currentDate = Number(input["inputDate"]) || view["currentDate"] || now.getDate();
        var currentMonth = (input["currentMonth"] ? Number(input["currentMonth"]) - 1 : undefined);
        if (currentMonth === undefined) {
            currentMonth = (view["currentMonth"] ? view["currentMonth"]["index"] : undefined);
        }
        if (currentMonth === undefined) {
            currentMonth = now.getMonth();
        }
        currentMonth = monthsNames[currentMonth];
        var currentYear = Number(input["currentYear"]) || view["currentYear"] || now.getFullYear();
        var daysInMonth = new Date(currentYear, currentMonth["index"] + 1, 0).getDate();
        var date = [];
        for (var i = 1; i <= daysInMonth; i++) {
            var dateObject = {
                "date": new Date(currentYear, currentMonth["index"], i),
                "data": [],
                "dataSize": 0
            };
            date.push(dateObject);
        }

        var result = {
            "monthsNames": monthsNames,
            "daysNames": localeInfo.getDayNames(this._daysType),
            "firstDay": firstDay,
            "currentDate": currentDate,
            "currentMonth": currentMonth,
            "currentYear": currentYear,
            "years": this._expandYears(currentYear, this._yearsBlockSize)
        };

        if (this._classBased) {
            var thisService = this;
            input[thisService.getId() + "-greatherOrEqualFirst"] = new Date(currentYear, currentMonth["index"], 1);
            input[thisService.getId() + "-lessOrEqualEnd"] = new Date(currentYear, currentMonth["index"], daysInMonth);

            var resultsPromise = this._dataService.execute(function(d) {
                var options = {
                    output: thisService._output,
                    outputConfig: {
                        useNames: true
                    },
                    filter: thisService._condExpr,
                    order: thisService._order
                };
                return d.select(thisService._entity.getId(), options, input);
            });
            return resultsPromise.then(function(rows) {
                result["date"] = [];
                date.forEach(function(day) {
                    rows.forEach(function(row) {
                        if (wrm.data.equal(row[thisService._dateAttribute.getName()], day["date"])) {
                            day["data"].push(row);
                            day["dataSize"] = day["dataSize"] + 1;
                        }
                        context.markForViewTracking(row, row["__key"]);
                    });
                    result["date"].push(day);
                });
                rows.forEach(function(row) {
                    delete row["__key"];
                });
                return result;
            }, function(e) {
                thisService.getLog().error(e);
            });
        }
        result["date"] = date;
        return result;
    },

    /** @override */
    catchEvent: function(context, event) {
        var view = context.getView();
        var parameters = event.getParameters();
        var date = (parameters["date"] !== undefined ? parameters["date"] : view["currentDate"]);
        var month = (parameters["month"] !== undefined ? parameters["month"] : view["currentMonth"]);
        if (angular.isNumber(month)) {
            month = view["monthsNames"][month];
        }
        var year = (parameters["year"] !== undefined ? parameters["year"] : view["currentYear"]);
        var dateIndex = (parameters["dateIndex"] !== undefined ? parameters["dateIndex"] : view["dateIndex"]);
        var dataIndex = (parameters["dataIndex"] !== undefined ? parameters["dataIndex"] : view["dataIndex"]);
        view["currentDate"] = date;
        view["currentMonth"] = month;
        view["currentYear"] = year;
        view["years"] = this._expandYears(year, this._yearsBlockSize);
        view["dateIndex"] = dateIndex;
        view["dataIndex"] = dataIndex;
    },

    /** @override */
    computeOutputFromResult: function(context, result) {
        var year = ("0000" + Number(result["currentYear"])).slice(-4);
        var month = ("00" + Number(result["currentMonth"]["index"] + 1)).slice(-2);
        var day = ("00" + Number(result["currentDate"])).slice(-2);
        var date = wrm.data.Date.fromString(year + "-" + month + "-" + day);
        var output = {
            data: {},
            dataSize: 0,
            date: date
        };
        if (this._classBased) {
            var thisService = this;
            result["date"].forEach(function(dateBean) {
                if (wrm.data.equal(date, dateBean["date"])) {
                    output.data = (dateBean["data"][0] ? thisService._dataService.extractPropertyValuesByName(dateBean["data"][0],
                            thisService._entity.getId()) : {});
                    output.dataSize = dateBean["dataSize"];
                }
            });
        }
        return output;
    },

    /** @override */
    submitView: function(context) {
        var view = context.getView();
        var currentDate = view["dateIndex"];
        var currentResult = (currentDate !== undefined ? view["date"][currentDate] : undefined);
        return this._computeOutput(view, currentDate, currentResult);
    },

    _computeOutput: function(view, currentDate, currentResult) {
        var output = {};
        if (currentResult !== undefined) {
            output["date"] = currentResult["date"], output["dataSize"] = currentResult["dataSize"];

            if (this._classBased) {
                if (currentResult["dataSize"] > 0) {
                    var currentData = view["dataIndex"];
                    if (currentData !== undefined) {
                        var toBind = this._toBind;
                        var currentRow = currentResult["data"][currentData];
                        var outputData = {};
                        Object.keys(this._output).forEach(function(key) {
                            outputData[toBind[key]] = currentRow[key];
                        });
                        output["data"] = outputData;
                    }
                }
            }
        } else if (currentDate !== undefined) {
            output["date"] = view["date"][currentDate];
        }

        return output;
    },

    /**
     * @private
     * @param {number} current
     * @param {number} block
     * @return {!Array.<string>}
     */
    _expandYears: function(current, block) {
        var result = [];
        var index = Math.floor(block / 2);
        var i = index;
        while (i > 0) {
            result.push(current - i);
            i--;
        }
        while (i <= index) {
            result.push(current + i);
            i++;
        }
        return result;
    },

});
