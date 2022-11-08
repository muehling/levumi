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
      type: 'categories',
      categories: weeks,
      tickPlacement: 'between',
    },
    yaxis: {
      min: 0,
      forceNiceScale: true,
    },
    tooltip: { shared: true },
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
      x: { show: false },
    },
    markers: {
      size: 4,
      hover: { sizeOffset: 2 },
    },
    xaxis: {
      tooltip: { enabled: false },
      type: 'numeric',
      min: 0,
      max: weeks.length - 1,
      tickAmount: weeks.length - 1,
      labels: {
        minHeight: 20,
      },
      title: {
        text: 'Testwoche',
      },
    },
    yaxis: {
      min: 0,
      forceNiceScale: true,
    },
  },
})
