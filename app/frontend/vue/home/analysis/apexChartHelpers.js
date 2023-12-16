import { getAnnotationLabel } from '../../../utils/helpers'
import deepmerge from 'deepmerge'
import isArray from 'lodash/isArray'
import { printDate } from '@/utils/date'
import cloneDeep from 'lodash/cloneDeep'

export const prepareOptions = (
  chartType,
  customOptions,
  weeks,
  isSlope,
  targetIsEnabled,
  animate,
  yMax
) => {
  let opt
  // only when targets are enabled and a slope target is desired and a line or rangeArea chart, only then use an rangeArea chart
  const needRangeAreaChart =
    isSlope && targetIsEnabled && (chartType === 'line' || chartType === 'rangeArea')
  const weekLabels = weeks.map(w => printDate(w))
  if (needRangeAreaChart) {
    opt = apexChartOptions(weekLabels).rangeArea
  } else {
    // we allow only bar and rangeArea as custom chart types, all others default to line
    switch (chartType) {
      case 'bar':
        opt = customOptions?.chart?.stacked
          ? apexChartOptions(weekLabels).groupedStackedBar
          : apexChartOptions(weekLabels).bar
        break
      case 'rangeArea':
        opt = apexChartOptions(weekLabels).rangeArea
        break
      case 'line':
      default:
        opt = apexChartOptions(weekLabels).line
    }
  }
  const options = deepmerge(cloneDeep(opt), customOptions)
  if (needRangeAreaChart) {
    options.chart.type = 'rangeArea'
  }
  // for updates on a chart animations may be inadequate
  options.chart.animations.enabled = animate

  if (options.yaxis === undefined) {
    options.yaxis = {}
  }

  // check the y-axis needs to be adjusted to display a trend or target
  if (yMax) {
    options.yaxis.max = yMax
  } else if (options.yaxis.max === undefined) {
    options.yaxis.max = function (max) {
      return max * 1.1
    }
  }

  return options
}

export const apexChartOptions = weekLabels => ({
  bar: {
    chart: {
      ...commonChart(),
      type: 'bar',
    },
    ...commonOptions(),
    stroke: {
      curve: 'straight',
      width: 0, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      dashArray: 0, // must be kept in, as prepareOptionsAsArrays depends upon its existence
    },
    fill: {
      opacity: 0.9, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      type: 'solid',
    },
    grid: {
      ...commonGrid(),
      padding: {
        right: 15,
        left: 15,
      },
    },
    xaxis: {
      tooltip: { enabled: false },
      type: 'category',
      categories: weekLabels,
      tickPlacement: 'on',
    },
    tooltip: { ...commonTooltip() },
  },
  groupedStackedBar: {
    chart: {
      ...commonChart(),
      type: 'bar',
      stacked: true,
    },
    stroke: {
      curve: 'straight',
      width: 0, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      dashArray: 0, // must be kept in, as prepareOptionsAsArrays depends upon its existence
    },
    fill: {
      opacity: 0.9, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      type: 'solid',
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: '50%',
      },
    },
    xaxis: {
      tooltip: { enabled: false },
      type: 'category',
      categories: weekLabels,
    },
    yaxis: {
      labels: {
        style: {
          fontSize: '13px',
        },
        formatter: val => {
          return val > 1.0 ? '' : val.toFixed(1)
        },
      },
      min: 0.0,
      max: 1.0,
      //decimalsInFloat: 1,
    },
    colors: [
      'rgba(255,255,255,0)',
      'rgba(255,36,74,0.1)',
      '#ff244a',
      'rgba(255,224,35,0.1)',
      '#ffdb00',
      'rgba(255,224,35,0.1)',
      '#02d32c',
      'rgba(10,255,86,0.1)',

      'rgba(255,255,255,0)',
      'rgba(255,36,74,0.1)',
      '#ff244a',
      'rgba(32,52,164,0.1)',
      '#2f49ff',
      'rgba(47,73,255,0.1)',
      '#02d32c',
      'rgba(10,255,86,0.1)',

      'rgba(255,255,255,0)',
      'rgba(255,36,74,0.1)',
      '#ff244a',
      'rgba(30,220,220,0.1)',
      '#1edcdc',
      'rgba(30,220,220,0.1)',
      '#02d32c',
      'rgba(10,255,86,0.1)',

      'rgba(255,255,255,0)',
      'rgba(255,36,74,0.1)',
      '#ff244a',
      'rgba(141,46,204,0.1)',
      '#af2ecc',
      'rgba(141,46,204,0.1)',
      '#02d32c',
      'rgba(10,255,86,0.1)',

      'rgba(255,255,255,0)',
      'rgba(255,36,74,0.1)',
      '#ff244a',
      'rgba(255,127,36,0.1)',
      '#ff6a00',
      'rgba(255,127,35,0.1)',
      '#02d32c',
      'rgba(10,255,86,0.1)',
      'rgba(255,255,255,0)',
    ],
    tooltip: {
      ...commonTooltip(),
      custom: customPercentileBandTooltip,
    },
    legend: {
      position: 'top',
      offsetY: 5,
      onItemClick: {
        // should not be toggled, as this would destroy the custom style (gap between stacks) by recreating the elements
        toggleDataSeries: false,
      },
      // eslint-disable-next-line no-unused-vars
      formatter: function (seriesName, _opts) {
        const splitName = seriesName.split(' ')
        // only render the first series name (ending in " 0")
        if (splitName[1] === '0') {
          // don't render the 0
          return splitName[0]
        } else {
          return ''
        }
      },
    },
  },
  line: {
    ...commonOptions(),
    chart: {
      ...commonChart(),
      type: 'line',
    },
    colors: apexColors(),
    fill: {
      opacity: 0.9, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      type: 'solid',
    },
    stroke: {
      curve: 'straight',
      width: 1, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      dashArray: 0, // must be kept in, as prepareOptionsAsArrays depends upon its existence
    },
    grid: {
      ...commonGrid(),
      padding: {
        right: 35,
        left: 35,
      },
    },
    tooltip: {
      ...commonTooltip(),
      custom: customSharedTooltip,
    },
    xaxis: {
      tooltip: { enabled: false },
      type: 'datetime',
      title: {
        text: 'Testwoche',
        offsetY: 90,
      },
      labels: {
        minHeight: 20,
        formatter: function (value) {
          return printDate(value) //opts.dateFormatter(new Date(timestamp)).format('dd MMM')
        },
      },
    },
  },
  rangeArea: {
    ...commonOptions(),
    chart: {
      ...commonChart(),
      type: 'rangeArea',
    },
    colors: apexColors(),
    fill: {
      colors: ['#10b600'], // intended to fill the target range, i.e. the allowed deviation area (HAS TO BE ARRAY, see docs of apexcharts)
      opacity: 0.9, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      type: 'solid',
    },
    stroke: {
      curve: 'straight',
      width: 1, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      dashArray: 0, // must be kept in, as prepareOptionsAsArrays depends upon its existence
    },
    grid: {
      ...commonGrid(),
      padding: {
        right: 35,
        left: 35,
      },
    },
    tooltip: {
      ...commonTooltip(),
      custom: customSharedTooltip,
    },
    xaxis: {
      tooltip: { enabled: false },
      type: 'datetime',
      title: {
        text: 'Testwoche',
        offsetY: 90,
      },
      labels: {
        minHeight: 20,
        formatter: function (value) {
          return printDate(value) //opts.dateFormatter(new Date(timestamp)).format('dd MMM')
        },
      },
    },
  },
})

const commonOptions = () => ({
  dataLabels: { enabled: false },
  legend: {
    position: 'top',
    offsetY: 5,
  },
  markers: {
    size: 4, // must be kept in, as prepareOptionsAsArrays depends upon its existence
    hover: { sizeOffset: 2 },
  },
  yaxis: {
    min: 0,
    forceNiceScale: true,
    labels: {
      formatter: val => (typeof val === 'number' ? val?.toFixed(2) : val),
    },
  },
})

const commonChart = () => ({
  animations: {
    animateGradually: {
      enabled: false,
    },
  },
  id: 'chart',
  height: '500px',
  width: '100%',
  toolbar: { show: false },
  zoom: { enabled: false },
})

const commonGrid = () => ({
  borderColor: '#90A4AE22',
})

const commonTooltip = () => ({
  enabled: true,
  shared: true,
  intersect: false,
})

/** credit goes to @Splinter0 on GitHub: https://github.com/apexcharts/apexcharts.js/issues/420#issuecomment-1047056648*/
function customSharedTooltip({ series, seriesIndex, dataPointIndex, w }) {
  const hoverXaxis = w.globals.seriesX[seriesIndex][dataPointIndex]
  const hoverIndexes = w.globals.seriesX.map(seriesX => {
    return seriesX.findIndex(xData => xData === hoverXaxis)
  })

  let hoverList = ''
  hoverIndexes.forEach((hoverIndex, seriesEachIndex) => {
    if (hoverIndex >= 0 && series[seriesEachIndex][hoverIndex]) {
      hoverList += `
                        <div class="apexcharts-tooltip-series-group apexcharts-active" style="order: 1; display: flex;">
                            <span class="apexcharts-tooltip-marker" style="background-color: ${
                              w.globals.markers.colors[seriesEachIndex]
                            };"></span>
                            <div class="apexcharts-tooltip-text" style="font-family: Helvetica, Arial, sans-serif; font-size: 12px;">
                                <div class="apexcharts-tooltip-y-group">
                                    <span class="apexcharts-tooltip-text-y-label">${
                                      w.globals.seriesNames[seriesEachIndex]
                                    }: </span>
                                    <span class="apexcharts-tooltip-text-y-value">${w.globals.yLabelFormatters[0](
                                      series[seriesEachIndex][hoverIndex]
                                    )}</span>
                                </div>
                            </div>
                        </div>`
    }
  })
  const date = new Date(hoverXaxis).toLocaleDateString('de')
  return `<div class="apexcharts-tooltip-title" style="font-family: Helvetica, Arial, sans-serif; font-size: 12px;">${date}</div>${hoverList}`
}

// eslint-disable-next-line no-unused-vars
function customPercentileBandTooltip({ series, _seriesIndex, dataPointIndex, w }) {
  const s = w.globals.series
  const sCount = 8
  // calculate how many stacks there are per date
  const stackCount = s.length / sCount
  // for each stack (task type) get the quartile values and build fitting messages
  const stacks = []
  const yLabels = ['25%-Perzentil:', '50%-Perzentil:', '75%-Perzentil:']

  const f = n => n.toFixed(2)
  for (let seriesIndex = 0; seriesIndex < stackCount; ++seriesIndex) {
    // push a new array representing a series of a certain (task) type to be filled
    const seriesStart = seriesIndex * sCount
    // reconstruct the real quartiles here by adding up the series values
    const percentiles = []
    let sum = 0.0
    // go up to 8, as there are 8 series when including the artificial separator lines
    for (let i = 0; i < sCount; ++i) {
      sum += Number(series[seriesStart + i][dataPointIndex])
      percentiles.push(sum)
    }
    // the separator lines are at indices 2, 4 and 6
    const low = `${f(percentiles[2])}`
    const mid = `${f(percentiles[4])}`
    const high = `${f(percentiles[6])}`
    stacks.push([low, mid, high])
  }

  let html = ''
  stacks.forEach((stack, stackIndex) => {
    html += `<div class="apexcharts-tooltip-series-group apexcharts-active" style="display: flex;">
                <div class="apexcharts-tooltip-text" style="font-family: Helvetica, Arial, sans-serif; font-size: 12px;">
                    <div class="apexcharts-tooltip-y-group">
                        <span class="apexcharts-tooltip-text-y-label">
                            Verteilung der Lösungsraten beim Typ
                        </span>
                        <span class="apexcharts-tooltip-text-y-value">"${
                          w.globals.seriesNames[sCount * stackIndex].split(' ')[0]
                        }":</span>
                    </div>
                </div>
            </div>`
    for (let i = 2; i >= 0; --i) {
      html += `<div class="apexcharts-tooltip-series-group apexcharts-active" style="display: flex;">
                  <span class="apexcharts-tooltip-marker" style="background-color: ${
                    w.globals.markers.colors[sCount * stackIndex + (i + 1) * 2]
                  };"></span>
                  <div class="apexcharts-tooltip-text" style="font-family: Helvetica, Arial, sans-serif; font-size: 12px;">
                      <div class="apexcharts-tooltip-y-group">
                          <span class="apexcharts-tooltip-text-y-label">${yLabels[i]} </span>
                          <span class="apexcharts-tooltip-text-y-value">${stack[i]}</span>
                      </div>
                  </div>
              </div>`
    }
  })
  html += `<div class="apexcharts-tooltip-series-group apexcharts-active" style="display: flex;">
                <div class="apexcharts-tooltip-text" style="font-family: Helvetica, Arial, sans-serif; font-size: 12px;">
                    <div class="apexcharts-tooltip-y-group">
                        <span class="apexcharts-tooltip-text-y-label">
                            <b>Hinweis:</b> Jeder transparente Abschnitt stellt je ein Viertel der Klasse dar.
                        </span>
                    </div>
                </div>
            </div>`
  return html
}

const apexColors = () => [
  '#449DD1',
  '#F86624',
  '#EA3546',
  '#662E9B',
  '#C5D86D',
  '#4ECDC4',
  '#C7F464',
  '#81D4FA',
  '#546E7A',
  '#FD6A6A',
  '#5C4742',
  '#A5978B',
  '#8D5B4C',
  '#5A2A27',
  '#C4BBAF',
]

export const annotationsLineOptions = (annotation, weeks) => ({
  id: 'a' + annotation.id,
  x: new Date(annotation.start).getTime(),
  ...(annotation.end !== annotation.start && { x2: new Date(annotation.end).getTime() }),
  strokeDashArray: 1,
  borderColor: '#c2c2c2',
  fillColor: '#c2c2c2',
  opacity: 0.3,
  label: {
    borderColor: '#c2c2c2',
    borderWidth: 1,
    text: getAnnotationLabel(annotation.annotation_category_id),
    textAnchor:
      weeks.indexOf(annotation.start) < 2
        ? 'right'
        : weeks.indexOf(annotation.start) > weeks.length - 2
        ? 'left'
        : 'middle',
    position: 'top',
    offsetY: 0,
    offsetX: 0,
    orientation: 'horizontal',
    style: {
      background: '#fff',
      color: '#777',
      fontSize: '12px',
      cssClass: 'apexcharts-xaxis-annotation-label',
    },
  },
})

export const annotationsPointOptions = (view, annotation, y, testWeek) => ({
  id: 'a' + annotation.id,
  x: new Date(testWeek).getTime(),
  y: y,
  strokeDashArray: 1,
  borderColor: '#c2c2c2',
  fillColor: '#c2c2c2',
  opacity: 0.3,
  label: {
    borderColor: '#c2c2c2',
    borderWidth: 1,
    text: getAnnotationLabel(annotation.annotation_category_id),
    textAnchor: 'middle',
    position: 'top',
    orientation: 'horizontal',
    offsetY: 0,
    offsetX: 0,
    style: {
      background: '#fff',
      color: '#777',
      fontSize: '12px',
      cssClass: 'apexcharts-xaxis-annotation-label',
    },
  },
})

export const targetAnnotationOptions = targetY => ({
  id: 'target-annotation',
  y: targetY,
  strokeDashArray: 16,
  borderColor: '#66666688',
  borderWidth: 2,
  fillColor: '#10b600',
  opacity: 0.9,
  label: {
    borderColor: '#424242',
    borderWidth: 1,
    text: 'Zielwert: ' + targetY,
    textAnchor: 'end',
    position: 'right',
    offsetY: 0,
    offsetX: 0,
    style: {
      background: '#fff',
      color: '#777',
      fontSize: '12px',
      cssClass: 'apexcharts-yaxis-annotation-label',
    },
  },
})

export const targetRangeAnnotationOptions = (targetY, y2 = null) => ({
  id: 'target-range-annotation',
  y: targetY,
  y2: y2,
  strokeDashArray: 0,
  borderColor: '#00000000',
  fillColor: '#10b600',
  opacity: 0.125,
  label: {
    borderColor: '#00000000',
    borderWidth: 0,
    text: undefined,
    style: {
      background: '#00000000',
      color: '#00000000',
    },
  },
})

export function quantile(arr, q) {
  const asc = arr => arr.sort((a, b) => a - b)
  const sorted = asc(arr)
  const pos = (sorted.length - 1) * q
  const base = Math.floor(pos)
  const rest = pos - base
  if (sorted[base + 1] !== undefined) {
    return sorted[base] + rest * (sorted[base + 1] - sorted[base])
  } else {
    return sorted[base]
  }
}

export function addTargetToChartData(
  graphData,
  opt,
  deviate,
  startPoint,
  endPoint,
  startPointRange,
  endPointRange
) {
  const seriesIndex = graphData.length
  graphData.push({ name: 'Ziel', type: 'line', data: [startPoint, endPoint] })
  if (deviate) {
    graphData.push({
      name: 'Erlaubte Abweichung',
      type: 'rangeArea',
      data: [startPointRange, endPointRange],
    })
  }
  // enableTooltip could have already been created by the trend line, but if there's none create it now
  prepareOptionsAsArrays(opt, seriesIndex, true, deviate)
  // modify the options at the given index to set custom values for this series
  setTargetOptions(opt, seriesIndex, deviate)
}

function setTargetOptions(options, seriesIndex, deviate) {
  options.colors[seriesIndex] = '#66666688'
  options.stroke.width[seriesIndex] = 2
  options.stroke.dashArray[seriesIndex] = 16
  options.markers.size[seriesIndex] = 1
  // for the rangeArea
  if (deviate) {
    const rangeIndex = seriesIndex + 1
    options.colors[rangeIndex] = '#10b600'
    options.fill.opacity[seriesIndex] = 0.9 // give the line a fill value too just so that it's defined
    options.fill.opacity[rangeIndex] = 0.125
    options.stroke.width[rangeIndex] = 0
    options.stroke.dashArray[rangeIndex] = 0
    options.markers.size[rangeIndex] = 0
  }
}

export function addTrendToChartData(graphData, opt, trendlineData, seriesType) {
  if (trendlineData?.length > 1) {
    // as long as there is more than one data point
    prepareOptionsAsArrays(opt, graphData.length, true, false)
    const i = graphData.length
    graphData.push({ name: 'Trend', type: seriesType, data: trendlineData }) // add the trend line as an additional series
    // next change display options for this appended series
    setTrendOptions(opt, i)
  }
}

function setTrendOptions(opt, i) {
  opt.colors[i] = '#545454'
  opt.stroke.width[i] = 2
  opt.stroke.dashArray[i] = 4
  opt.markers.size[i] = 0
}

function prepareOptionsAsArrays(opt, size, createEnableTooltip, prepareFills) {
  if (!opt.colors) {
    opt.colors = []
  }
  // fill up the colors by continuing them based on apexColors, cycling just like ApexCharts would do if there were no more colors
  const aColors = apexColors()
  for (let i = opt.colors.length; opt.colors.length < size; ++i) {
    opt.colors.push(aColors[i % aColors.length])
  }

  // turn all relevant option fields into arrays as long as they aren't arrays yet
  // when they are we assume that no damage is done by extending the array with copies of the last value
  if (!isArray(opt.stroke.width)) {
    opt.stroke.width = new Array(size).fill(opt.stroke.width)
  } else {
    const len = opt.stroke.width.length
    const last = opt.stroke.width[len - 1]
    opt.stroke.width.length = size
    opt.stroke.width.fill(last, len)
  }
  if (!isArray(opt.stroke.dashArray)) {
    opt.stroke.dashArray = new Array(size).fill(opt.stroke.dashArray)
  } else {
    const len = opt.stroke.dashArray.length
    const last = opt.stroke.dashArray[len - 1]
    opt.stroke.dashArray.length = size
    opt.stroke.dashArray.fill(last, len)
  }

  if (!isArray(opt.markers.size)) {
    opt.markers.size = new Array(size).fill(opt.markers.size)
  } else {
    const len = opt.markers.size.length
    const last = opt.markers.size[len - 1]
    opt.markers.size.length = size
    opt.markers.size.fill(last, len)
  }

  if (prepareFills) {
    if (!isArray(opt.fill.opacity)) {
      opt.fill.opacity = new Array(size).fill(opt.fill.opacity)
    } else {
      const len = opt.fill.opacity.length
      const last = opt.fill.opacity[len - 1]
      opt.fill.opacity.length = size
      opt.fill.opacity.fill(last, len)
    }
  }

  if (createEnableTooltip && !isArray(opt.tooltip.enabledOnSeries)) {
    opt.tooltip.enabledOnSeries = [...Array(size).keys()] // enable tooltip on all series within size
  }
}

/**
 * Adds a small gap between the stacks by adding transforms to the g-elements of the series.
 */
export function postProcessGroupedStackedBars(viewConfig) {
  // first get the series names which are the base of the 'seriesName' attribute added by ApexCharts
  const seriesNames = viewConfig.series
  // get all series
  const gSeries = document.querySelectorAll('.apexcharts-series')
  let i = 0
  for (let sName of seriesNames) {
    // currentSeries contains all g-elements belonging to sName
    const currentSeries = Array.from(gSeries).filter(gS =>
      gS.getAttribute('seriesName').startsWith(sName)
    )
    console.log('currentSeries: ', currentSeries)
    for (let g of currentSeries) {
      g.style.transform = `translateX(${i * 10}px)`
    }
    i++
  }
}
