/**
 Credit goes to https://github.com/JarrydLisher. repo-link: https://github.com/JarrydLisher/vue-apxcharts-trendline/blob/master/src/VueApexchartsTrendline.vue
 */
import format from "date-fns/format";

function xDateToInt(xVal) {
    return xVal ? Date.parse(xVal) / 1000 : null;   // divide by 1000 to turn to seconds (to somewhat avoid very large numbers)
}

function xDatesToInts(series) {
    for (let i = 0; i < series.length; i++) {
        series[i].x = xDateToInt(series[i].x)
    }
}

// to make sure y is a number
function yAsInts(series) {
    for (let i = 0; i < series.length; i++) {
        series[i].y = Number(series[i].y)
    }
}

function xIntsToDates(series) {
    for (let i = 0; i < series.length; i++) {
        // TODO: Code mostly copy-pasted from assessment-view.vue; Maybe refactor to a common helper function;
        series[i].x = series[i].x ? format(new Date(series[i].x * 1000), 'dd.MM.yyyy') : null;  // multiply by 1000 to get milliseconds
    }
}

const defaultRegression = () => {
    return {
        sums: {
            x: 0,
            y: 0,
            xy: 0,
            x2: 0,
            y2: 0,
            count: 0,
        },
        a: 0,
        b: 0,
    };
};

/**
 * A helper function to create a linear regression over given values. Returns an array of x-y values specifying a line going from
 * the first x value in data up to xEnd x-wise.
 * @param data An Array of { x: String | Number , y: String | Number }, where x should be a date string or a number
 * @param xEnd The endpoint up to which the generated linear regression should go. Can be a date string or number. Defaults to the last x value in data (no matter whether there is a y value there).
 * @param handleDates If true (default) x values are handles as date strings
 * @returns {[{x: String | Number, y: String}]}
 */
export function createTrendline(data, xEnd = null, handleDates = true) {
    let processed = [],
        i;
    if (data.length <= 1) {
        return processed;
    }
    // set the regression values to default
    let regression = defaultRegression();
    // convert dates to seconds since epoch if necessary
    if (handleDates) {
        xDatesToInts(data)
        if (xEnd) { xEnd = xDateToInt(xEnd) }
    }
    yAsInts(data)
    // filter out invalid data points
    const modelData = data.filter(function (el) {
        return Boolean(el.x) && Boolean(el.y)
    });
    // calculate the regression new sums
    for (i = 0; i < modelData.length; i++) {
        addToRegressionSums(regression, modelData[i]);
    }
    // calculate "a" and "b" values for the regression equation.
    regression.a = calculateAValue(regression);
    regression.b = calculateBValue(regression);
    // get "y" values for the trend line.
    for (i = 0; i < data.length; i++) {
        const xVal = data[i].x
        if (xVal) { // y values can only be calculated for non-null x-values
            processed.push({
                x: xVal,
                y: calculateYValue(regression, xVal).toFixed(2),
            })
        }
    }
    // add whatever point would be at x = xEnd, if xEnd is given and greater than the currently last x value
    if (xEnd && xEnd > processed[processed.length - 1].x) {
        processed.push({
            x: xEnd,
            y: calculateYValue(regression, xEnd).toFixed(2),
        })
    }
    // convert seconds back to dates if necessary
    if (handleDates) { xIntsToDates(processed) }
    return processed;
}

function addToRegressionSums(regression, item) {
    regression.sums.x += item.x;
    regression.sums.y += item.y;
    regression.sums.xy += (item.x * item.y);
    regression.sums.x2 += (item.x ** 2);
    regression.sums.y2 += (item.y ** 2);
    regression.sums.count++;
}

/**
 *  Get "a" (the Y intercept value) for the regression equation.
 *
 *  a = (Σy)(Σx^2) - (Σx)(Σxy) / n(Σx^2) - (Σx)^2
 */
function calculateAValue(regression) {
    return (
        (regression.sums.y * regression.sums.x2) // (Σy)(Σx^2)
        -
        (regression.sums.x * regression.sums.xy) // (Σx)(Σxy)
    ) / (
        (regression.sums.count * regression.sums.x2) // n(Σx^2)
        -
        (regression.sums.x ** 2) // (Σx)^2
    );
}

/**
 * Get "b" (the slope of the line) for the regression equation.
 *
 * b = n(Σxy) - (Σx)(Σy) / n(Σx^2) - (Σx)^2
 */
function calculateBValue(regression) {
    return (
        (regression.sums.count * regression.sums.xy) // n(Σxy)
        -
        (regression.sums.x * regression.sums.y) // (Σx)(Σy)
    ) / (
        (regression.sums.count * regression.sums.x2) // n(Σx^2)
        -
        (regression.sums.x ** 2) // (Σx)^2
    );
}


/**
 * Get the Y value for an x coordinate using a linear regression equation.
 *
 * y = a + bx
 */
function calculateYValue(regression, x) {
    return regression.a + (regression.b * x);
}