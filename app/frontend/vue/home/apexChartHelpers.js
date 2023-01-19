export const apexChartOptions = weeks => ({
  bar: {
    chart: {
      animations: {
        animateGradually: {
          enabled: false,
        },
      },
      id: 'chart',
      height: '500px',
      width: '100%',
      type: 'bar',
      toolbar: { show: false },
      zoom: { enabled: false },
    },
    legend: {
      position: 'top',
      offsetY: 5,
    },
    grid: {
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
    yaxis: {
      min: 0,
      forceNiceScale: true,
    },
    tooltip: { shared: true, intersect: false },
  },
  line: {
    chart: {
      animations: {
        animateGradually: {
          enabled: false,
        },
      },
      id: 'chart',
      height: '500px',
      width: '100%',
      type: 'line',
      toolbar: { show: false },
      zoom: { enabled: false },
    },
    colors: [
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
    ],
    legend: {
      position: 'top',
      offsetY: 5,
    },
    stroke: {
      curve: 'straight',
      width: 1,
    },
    grid: {
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
      type: 'category',
      title: {
        text: 'Testwoche',
        offsetY: 90,
      },
      labels: {
        minHeight: 20,
      },
    },
    yaxis: {
      min: 0,
      forceNiceScale: true,
    },
  },
})

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

export const annotationsTargetOptions = (targetY) => ({
  id: 'target-annotation',
  y: targetY,
  y2: null, // TODO: add lower y2 value to show a "target area",
  strokeDashArray: 8,
  borderColor: '#424242',
  fillColor: '#424242',
  opacity: 0.3,
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
