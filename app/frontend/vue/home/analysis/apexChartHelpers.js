import { getAnnotationLabel } from '../../../utils/helpers'
import deepmerge from 'deepmerge'
import isArray from "lodash/isArray";

export const prepareOptions = (chartType, customOptions, weeks, isSlope, targetIsEnabled) => {
  // if any series wants to be of type rangeArea then the whole chart needs to be
  // therefore we need to save the "true" chart type to hand over to all non-rangeArea series (i.e. all except the slope target)
  if (chartType !== 'line' && chartType !== 'bar' && chartType !== 'rangeArea') {
    chartType = 'line'
  }
  let opt
  // only when targets are enabled and a slope target is desired and a line or rangeArea chart, only then use an rangeArea chart
  const needRangeAreaChart = isSlope && targetIsEnabled && (chartType === 'line' || chartType === 'rangeArea')
  if (needRangeAreaChart) {
    opt = apexChartOptions(weeks).rangeArea
  } else {
    // we allow only bar and rangeArea as custom chart types, all others default to line
    switch (chartType) {
      case 'bar':
        opt = apexChartOptions(weeks).bar
        break
      case 'rangeArea':
        opt = apexChartOptions(weeks).rangeArea
        break
      default:
        opt = apexChartOptions(weeks).line
    }
  }
  const options = deepmerge(opt, customOptions)
  if (needRangeAreaChart) {
    options.chart.type = 'rangeArea'
  }

  //Default für y-Achse: 10% Luft nach oben
  if (options.yaxis === undefined) {
    options.yaxis = {}
  }
  if (options.yaxis.max === undefined) {
    options.yaxis.max = function (max) {
      return 1.1 * max
    }
  }

  return options
}

export const apexChartOptions = weeks => ({
  bar: {
    chart: {
      ...commonChart(),
      type: 'bar',
    },
    ...commonOptions(),
    stroke: {
      curve: 'straight',
      width: 0, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      dashArray: 0 // must be kept in, as prepareOptionsAsArrays depends upon its existence
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
    xaxis: {  // TODO: Optionen hier vielleicht an andere Diagramme anpassen (datetime statt categories)
      tooltip: { enabled: false },
      type: 'category',
      categories: weeks,
      tickPlacement: 'between',
    },
    tooltip: { ...commonTooltip() },
  },
  line: {
    chart: {
      ...commonChart(),
      type: 'line',
    },
    ...commonOptions(),
    colors: apexColors(),
    stroke: {
      curve: 'straight',
      width: 1, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      dashArray: 0 // must be kept in, as prepareOptionsAsArrays depends upon its existence
    },
    fill: {
      opacity: 0.9, // must be kept in, as prepareOptionsAsArrays depends upon its existence
      type: 'solid',
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
      enabled: true,
      x: { show: false },
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
        format: 'dd.MM.yyyy',
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
      dashArray: 0 // must be kept in, as prepareOptionsAsArrays depends upon its existence
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
      enabled: true,
      x: {show: false},
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
        format: 'dd.MM.yyyy',
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
    size: 4,  // must be kept in, as prepareOptionsAsArrays depends upon its existence
    hover: { sizeOffset: 2 },
  },
  yaxis: {
    min: 0,
    forceNiceScale: true,
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
  shared: true,
  intersect: false
})

export const apexColors = () => [
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

export const targetAnnotationOptions = (targetY) => ({
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
    text: 'Zielwert: '+targetY,
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

export function addTargetToChartData(graphData, opt, deviate, startPoint, endPoint, startPointRange, endPointRange) {
  const seriesIndex = graphData.length
  graphData.push({ name: 'Ziel', type: 'line' , data: [startPoint, endPoint] })
  if (deviate) {
    graphData.push({ name: 'Erlaubte Abweichung', type: 'rangeArea', data: [startPointRange, endPointRange] })
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
  if (trendlineData?.length > 1) {  // as long as there is more than one data point
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
  if (!opt.colors) { opt.colors = [] }
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

  if(!isArray(opt.markers.size)) {
    console.log("YAR: "+opt.markers.size)
    opt.markers.size = new Array(size).fill(opt.markers.size)
    console.log("size: "+size)
    console.log("markers.size.length: "+opt.markers.size.length)
    opt.markers.size.forEach(a => console.log("a: "+a))
  } else {
    const len = opt.markers.size.length
    const last = opt.markers.size[len - 1]
    opt.markers.size.length = size
    opt.markers.size.fill(last, len)
  }

  console.log("prep: "+prepareFills)
  if (prepareFills) {
    if (!isArray(opt.fill.opacity)) {
      console.log("no and: "+opt.fill.opacity)
      opt.fill.opacity = new Array(size).fill(opt.fill.opacity)
      console.log("opt.file.opacity: "+opt.fill.opacity)
      console.log("now after: "+opt.fill.opacity.length)
    } else {
      const len = opt.fill.opacity.length
      const last = opt.fill.opacity[len - 1]
      console.log("yes and: "+len)
      opt.fill.opacity.length = size
      opt.fill.opacity.fill(last, len)
      console.log("opt.file.opacity: "+opt.fill.opacity)
      console.log("now after: "+opt.fill.opacity.length)
    }
  }

  if (createEnableTooltip && !isArray(opt.tooltip.enabledOnSeries)) {
    opt.tooltip.enabledOnSeries = [...Array(size).keys()] // enable tooltip on all series within size
  }
}