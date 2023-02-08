export const apexChartOptions = weeks => ({
  bar: {
    ...commonOptions(),
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
    xaxis: {
      tooltip: { enabled: false },
      type: 'category',
      categories: weeks,
      tickPlacement: 'between',
    },
    tooltip: { shared: true, intersect: false },
  },
  line: {
    ...commonOptions(),
    chart: {
      ...commonChart(),
      type: 'line',
    },
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
      enabled: true,
      intersect: false,
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
      enabled: true,
      intersect: false,
      x: { show: false },
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

export const annotationsLineOptions = annotation => ({
  x: this.weeks.indexOf(annotation.start),
  x2: this.weeks.indexOf(annotation.end),
  strokeDashArray: 1,
  borderColor: '#c2c2c2',
  fillColor: '#c2c2c2',
  opacity: 0.3,
  label: {
    borderColor: '#c2c2c2',
    borderWidth: 1,
    text: this.decode_text(annotation.content),
    textAnchor:
      this.weeks.indexOf(annotation.start) < 2
        ? 'right'
        : this.weeks.indexOf(annotation.start) > this.weeks.length - 2
        ? 'left'
        : 'middle',
    position: 'top',
    offsetY: 100,
    offsetX: 10,
    orientation: 'horizontal',
    style: {
      background: '#fff',
      color: '#777',
      fontSize: '12px',
      cssClass: 'apexcharts-xaxis-annotation-label',
    },
  },
})

export const annotationsPointOptions = (view, annotation, maxY) => ({
  x:
    view.options.chart.type === 'line'
      ? this.weeks.indexOf(annotation.start)
      : this.printDate(annotation.start),
  y: 1.025 * maxY,
  strokeDashArray: 1,
  borderColor: '#c2c2c2',
  fillColor: '#c2c2c2',
  opacity: 0.3,
  label: {
    borderColor: '#c2c2c2',
    borderWidth: 1,
    text: this.decode_text(annotation.content),
    textAnchor: 'middle',
    position: 'top',
    orientation: 'horizontal',
    offsetY: 15,
    offsetX: 10,
    style: {
      background: '#fff',
      color: '#777',
      fontSize: '12px',
      cssClass: 'apexcharts-xaxis-annotation-label',
    },
  },
})

export const annotationsTargetOptions = (targetY, y2 = null) => ({
  id: 'target-annotation',
  y: targetY,
  y2: y2,
  strokeDashArray: 16,
  borderColor: y2 == null ? '#888888' : '#000000',
  fillColor: '#10b600',
  opacity: 0.15,
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
