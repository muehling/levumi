import { printDate } from '../../../utils/date'
import { getAnnotationLabel } from '../../../utils/helpers'
import deepmerge from 'deepmerge'

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
    stroke: {
      curve: 'straight',
      width: 0,
      dashArray: 0
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
      width: 1,
      dashArray: 0
    },
    fill: {
      opacity: 0.9,
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
    markers: {
      size: 4,
      hover: { sizeOffset: 2 },
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
      colors: ['#10b600'], // intended to fill the target range, i.e. the allowed deviation area
      opacity: [0.9],
      type: 'solid',
    },
    stroke: {
      curve: 'straight',
      width: 1,
      dashArray: 0
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
    markers: {
      size: 4,
      hover: { sizeOffset: 2 },
    },
    dataLabels: {
      enabled: false
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
  x: printDate(annotation.start),
  ...(annotation.end !== annotation.start && { x2: printDate(annotation.end) }),
  strokeDashArray: 1,
  borderColor: '#c2c2c2',
  fillColor: '#c2c2c2',
  opacity: 0.3,
  label: {
    borderColor: '#c2c2c2',
    borderWidth: 1,
    text: getAnnotationLabel(annotation.annotation_category_id),
    textAnchor:
      weeks.indexOf(printDate(annotation.start)) < 2
        ? 'right'
        : weeks.indexOf(printDate(annotation.start)) > weeks.length - 2
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
  x: printDate(testWeek),
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
  opt = prepareOptionsAsArrays(opt, seriesIndex, true, deviate)
  // modify the options at the given index to set custom values for this series
  opt.colors[seriesIndex] = '#66666688'
  opt.fill.opacity[seriesIndex] = 0.9
  opt.stroke.width[seriesIndex] = 2
  opt.stroke.dashArray[seriesIndex] = 16
  opt.markers.size[seriesIndex] = 1
  // for the rangeArea
  if (deviate) {
    const rangeIndex = seriesIndex + 1
    opt.colors[rangeIndex] = '#10b600'
    opt.fill.opacity[rangeIndex] = 0.125
    opt.stroke.width[rangeIndex] = 0
    opt.stroke.dashArray[rangeIndex] = 0
    opt.markers.size[rangeIndex] = 0
  }
}

export function addTrendToChartData(graphData, opt, trendlineData, seriesType) {
  if (trendlineData?.length > 1) {  // as long as there is more than one data point
    opt = prepareOptionsAsArrays(opt, graphData.length, true, false)
    const i = graphData.length
    graphData.push({ name: 'Trend', type: seriesType, data: trendlineData }) // add the trend line as an additional series
    // next change display options for this appended series
    opt.colors[i] = '#545454'
    opt.stroke.width[i] = 2
    opt.stroke.dashArray[i] = 4
    opt.markers.size[i] = 0
  }
}

function prepareOptionsAsArrays(opt, size, createEnableTooltip, prepareFills) {
  const defaultLineOptions = apexChartOptions(null).line

  if (!opt.colors) { opt.colors = [] }
  // fill up the colors by continuing them based on apexColors, cycling just like ApexCharts would do if there were no more colors
  const aColors = apexColors()
  for (let i = opt.colors.length; opt.colors.length < size; ++i) {
    opt.colors.push(aColors[i % aColors.length])
  }

  if (!opt.stroke) { opt.stroke = defaultLineOptions.stroke } // check that opt.stroke exists
  if (opt.stroke.width == undefined) { opt.stroke.width = [defaultLineOptions.stroke.width] } // check that opt.stroke.width exists
  if (opt.stroke.width.length == undefined) { opt.stroke.width = [opt.stroke.width] } // if it is no array yet make it one
  // fill up by continuing based on what is already there
  {
    let w = opt.stroke.width
    for (let i = 0; w.length < size; ++i) {
      w.push(w[i])
    }
  }

  if (opt.stroke.dashArray == undefined) { opt.stroke.dashArray = [defaultLineOptions.stroke.dashArray] } // check that opt.stroke.width exists
  if (opt.stroke.dashArray.length == undefined) { opt.stroke.dashArray = [opt.stroke.dashArray] } // if it is no array yet make it one
  {
    let d = opt.stroke.dashArray
    for (let i = 0; d.length < size; ++i) {
      d.push(d[i])
    }
  }

  if (!opt.markers) { opt.markers = defaultLineOptions.markers }  // check that opt.markers exists
  if (opt.markers.size == undefined) { opt.markers.size = [defaultLineOptions.markers.size] } // check that opt.markers.size exists
  if (opt.markers.size.length == undefined) { opt.markers.size = [opt.markers.size] } // if it is no array yet make it one
  {
    let m = opt.markers.size
    for (let i = 0; m.length < size; ++i) {
      m.push(m[i])
    }
  }

  if (prepareFills) {
    if (!opt.fill) { opt.fill = defaultLineOptions.fill }  // check that opt.fill exists
    if (opt.fill.opacity == undefined) { opt.fill.opacity = [defaultLineOptions.fill.opacity] } // check that opt.fill.opacity exists
    if (opt.fill.opacity.length == undefined) { opt.fill.opacity = [opt.fill.opacity] } // if it is no array yet make it one
    {
      let o = opt.fill.opacity
      for (let i = 0; o.length < size; ++i) {
        o.push(o[i])
      }
    }
  }

  if (createEnableTooltip) {
    if (!opt.tooltip) { opt.tooltip = defaultLineOptions.tooltip }
    if (!opt.tooltip.enabledOnSeries) {
      opt.tooltip.enabledOnSeries = [...Array(size).keys()] // enable tooltip on all series within size
    }
  }
  return opt
}