<template>
  <div id="niveau-overview">
    <b-container id="niv-container" :style="containerStyle" class="mb-3" fluid>
      <b-row v-for="n in niveauArray" :key="n" cols="3" class="niveau" :style="styleForLevel(n)">
        <b-col cols="2" class="l-niv">
          <span class="niv-name" style="display: flex; align-items: end; white-space: nowrap">
            {{ 'Niveau ' + n }}
          </span>
          <div id="normal-container" style="width: 100%; height: 100%">
            <svg
              v-if="n === niveauArray[0]"
              class="normal-dist"
              width="100%"
              :height="desiredHeight + 'px'"
              :viewBox="
                '0 ' +
                (normalPlotMean * (1 / normalPlotStdDeviation) * 119.85765 -
                  ((1 / normalPlotStdDeviation - 1) * 119.85765) / 2) +
                ' 21.41 ' +
                (1 / normalPlotStdDeviation) * 119.85765
              "
              preserveAspectRatio="none">
              <defs id="defs73643">
                <linearGradient id="linearGradient7580">
                  <stop id="stop7576" style="stop-color: #e5e5e5; stop-opacity: 0.6" offset="0" />
                  <stop id="stop7578" style="stop-color: #ffffff; stop-opacity: 0.5" offset="1" />
                </linearGradient>
                <linearGradient
                  id="linearGradient7582"
                  xlink:href="#linearGradient7580"
                  x1="0"
                  y1="59.928831"
                  x2="21.959299"
                  y2="59.928831"
                  gradientUnits="userSpaceOnUse" />
              </defs>
              <path
                id="polyline21800"
                style="
                  fill: #ffffff;
                  fill-opacity: 0.5;
                  stroke: #d2d2d2;
                  stroke-width: 0.357;
                  stroke-linejoin: round;
                  stroke-miterlimit: 10;
                  stroke-dasharray: none;
                  stroke-opacity: 1;
                "
                d="m 21.6308,119.85684 -0.003,-1.1994 -0.004,-1.19649 -0.004,-1.19941 -0.007,-1.19941 -0.009,-1.1965 -0.0101,-1.19939 -0.0144,-1.19941 -0.018,-1.1994 -0.0232,-1.1965 -0.0291,-1.1994 -0.0366,-1.1994 -0.0455,-1.19651 -0.0567,-1.19941 -0.0701,-1.19939 -0.0858,-1.1965 -0.10456,-1.19939 -0.12616,-1.199403 -0.15088,-1.1994 -0.18001,-1.19651 -0.21212,-1.1994 -0.24797,-1.199405 -0.28907,-1.196503 -0.33386,-1.199402 -0.38242,-1.199394 -0.43396,-1.199401 -0.48998,-1.196504 -0.54748,-1.199401 -0.60722,-1.199402 -0.66775,-1.196502 -0.72825,-1.199401 -0.78723,-1.199401 -0.84402,-1.196502 -0.89554,-1.199401 -0.94112,-1.199399 -0.9792,-1.199402 -1.00907,-1.196503 -1.0270101,-1.199401 -1.03299,-1.199399 -1.027,-1.196504 -1.00534,-1.1994 -0.97022,-1.1994 -0.9187,-1.199401 -0.85372,-1.196503 -0.7738,-1.199399 -0.68044,-1.199401 -0.57513,-1.196504 -0.45860995,-1.199399 -0.33387,-1.199401 -0.2024,-1.196504 -0.0687,-1.1994 0.0687,-1.1994 0.2024,-1.199402 0.33387,-1.196502 0.45860995,-1.199399 0.57513,-1.199401 0.68044,-1.196503 0.7738,-1.199401 0.85372,-1.1994 0.9187,-1.199401 0.97022,-1.196503 1.00534,-1.1994 1.027,-1.1994 1.03299,-1.196505 1.0270101,-1.199399 1.00907,-1.1994 0.9792,-1.1994 0.94112,-1.196503 0.89554,-1.199401 0.84402,-1.1994 0.78723,-1.196504 0.72825,-1.199399 0.66775,-1.199401 0.60722,-1.196504 0.54748,-1.1994 0.48998,-1.1994 0.43396,-1.1994 0.38242,-1.196503 0.33386,-1.199401 0.28907,-1.1994 0.24797,-1.196503 0.21212,-1.199401 0.18001,-1.1994 0.15088,-1.1994 0.12616,-1.196504 0.10456,-1.199401 0.0858,-1.199398 0.0701,-1.196504 0.0567,-1.199401 0.0455,-1.1994 0.0366,-1.196503 0.0291,-1.199401 0.0232,-1.1994002 0.018,-1.1994 0.0144,-1.196503 0.0101,-1.199401 0.009,-1.1993999 0.007,-1.1965033 0.004,-1.1994003 0.004,-1.1994003 0.003,-1.19940034194" />
            </svg>
          </div>
        </b-col>
        <b-col cols="6" lg="7" class="t-examples">
          <div v-for="(example, key) in examplesForLevel(n)" :key="key" class="example-div">
            <span v-for="(line, lineKey) in example.lines" :key="lineKey" style="display: block">
              <span
                v-for="(part, partKey) in line"
                :key="partKey"
                style="display: inline; vertical-align: middle">
                <span v-if="part.type === 'text-fraction'" class="fraction">
                  <p class="numerator">{{ part.numerator }}</p>
                  <p class="denominator">{{ part.denominator }}</p>
                </span>
                <span v-else-if="part.type === 'plain-text'" v-html="part.text"></span>
              </span>
            </span>
            <img
              v-if="example.image !== undefined"
              class="example-img"
              :src="example.image.filepath"
              :alt="'eine Beispielaufgabe für das Niveau' + n" />
          </div>
        </b-col>
        <b-col cols="4" lg="3" class="headline-col">
          <span class="explanation-tooltip" v-html="explanationForLevel(n)"></span>
          <span class="headline" v-html="headlineForLevel(n)"></span>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
  const A = 'Anforderungsstufen'
  const E = '_example'

  export default {
    name: 'NiveauOverview',

    props: {
      nivConfig: Object,
      infoAttachments: Array,
    },
    data: function () {
      return {
        nivColors: [
          ['#b2efb2'],
          ['#b2efb2', '#ffebb2'],
          ['#b2efb2', '#ffffb2', '#ffb2b2'],
          ['#b2efb2', '#ffffb2', '#ffebb2', '#ffb2b2'],
          ['#c6d3ec', '#b2efb2', '#ffffb2', '#ffebb2', '#ffb2b2'],
        ],
        nivTextColors: [
          ['#00b04f'],
          ['#00b04f', '#eb7d30'],
          ['#00b04f', '#ffbf00', '#bf0000'],
          ['#00b04f', '#ffbf00', '#eb7d30', '#bf0000'],
          ['#4270c2', '#00b04f', '#ffbf00', '#eb7d30', '#bf0000'],
        ],
        loaded: false,
      }
    },
    computed: {
      exampleImages() {
        return this.infoAttachments?.filter(
          attachment =>
            attachment.content_type.startsWith('image') && attachment.filename.startsWith(A + E)
        )
      },
      /** A decreasing list of niveau numbers, such as [4,3,2,1] for 4 niveaus. */
      niveauArray() {
        const nivCount = this.nivConfig.heights.length
        return [...Array(nivCount).keys()].map(x => x + 1).reverse()
      },
      containerStyle() {
        let s = {}
        s['max-height'] = this.desiredHeight + 'px'
        return s
      },
      /** The desired height of the overview in pixels */
      desiredHeight() {
        return 500 + this.niveauArray.length * 100
      },
      /** A percentage value determining how much the normal should be shifted upwards from its middle position. */
      normalPlotMean() {
        return this.nivConfig.normal_mean ? (this.nivConfig.normal_mean * (5 / 4)) / 10 : 0
      },
      /** The standard deviation of the shown normal function, as specified in the test.
       *  Used directly as a y-scale factor. */
      normalPlotStdDeviation() {
        return this.nivConfig.normal_sd ?? 1
      },
    },
    mounted() {
      this.loaded = true
    },
    methods: {
      examplesForLevel(level) {
        const example_texts = this.nivConfig.example_texts[level - 1]
        const example_images = this.exampleImages?.filter(img =>
          img.filename.startsWith(A + E + level)
        )
        // build examples from texts, adding images where appropriate
        let i = 1
        return example_texts.map(text => {
          // search for a corresponding image
          const image = example_images?.find(img =>
            img.filename.startsWith(A + E + level + '_' + i)
          )
          // first break the text into lines
          const lines = text.split('\n')
          // search the text for incidences of fractions (...⌹...) and split it there, keeping the separator
          const fracRegex = /([A-Za-z0-9□]+⌹[A-Za-z0-9□]+)/
          const htmlRegex = /(<\S+>.*<\/\S+>)/
          for (let j = 0; j < lines.length; ++j) {
            let k = -1
            // first split the text into html elements and free text
            const htmlElements = lines[j].split(htmlRegex)
            // html elements are treated as atomic and not split further
            // free text is instead split to make space for fractions, keeping spaces
            lines[j] = htmlElements.flatMap(elem => {
              if (htmlRegex.test(elem)) {
                ++k
                return [{ type: 'plain-text', id: k, text: elem }]
              } else {
                return (
                  elem
                    .split(fracRegex)
                    // map this to an array of objects that are either of a 'plain-text' or 'fraction' type
                    .map(s => {
                      ++k
                      if (fracRegex.test(s) && !htmlRegex.test(s)) {
                        const slots = s.split('⌹')
                        return {
                          type: 'text-fraction',
                          id: k,
                          numerator: slots[0],
                          denominator: slots[1],
                        }
                      } else {
                        return { type: 'plain-text', id: k, text: s }
                      }
                    })
                )
              }
            })
          }
          ++i
          return { lines: lines, image: image }
        })
      },
      headlineForLevel(level) {
        return this.nivConfig.headlines[level - 1]
      },
      styleForLevel(level) {
        const n = this.niveauArray.length - 1
        const l = level - 1
        return {
          color: this.nivTextColors[n][l],
          'background-color': this.nivColors[n][l],
          height: this.nivConfig.heights[l],
        }
      },
      explanationForLevel(level) {
        return this.nivConfig.explanations[level - 1]
      },
    },
  }
</script>

<style>
  #niveau-overview {
    width: 100%;
    margin: 2.3rem;
    font-weight: bold;
  }
  @media (max-width: 1400px) {
    #niveau-overview {
      margin: 2.3rem 1.15rem;
    }
  }
  @media (max-width: 992px) {
    #niveau-overview {
      margin: 2.3rem 0.5rem;
    }
  }
  #niv-container {
    height: 100%;
    max-width: 1800px;
    /* for the normal distribution */
    overflow: clip;
  }
  .niveau {
    border: 0 solid #b9b9b9;
    border-bottom-width: 1px;
  }
  .niveau:first-child {
    border-radius: 8px 8px 0 0;
  }
  .niveau:last-child {
    border-radius: 0 0 8px 8px;
    border-width: 0;
  }
  .t-examples {
    padding: 0 !important;
    display: flex;
    flex-wrap: wrap;
    flex-direction: column;
    background-color: white;
    color: black;
    height: 100%;
    max-width: 100%;
    overflow: auto;
  }
  .l-niv {
    flex-wrap: nowrap;
    height: 100%;
    padding: 0 0 0 0.6rem !important;
    position: relative;
    display: flex;
  }
  @media (max-width: 892px) {
    .niv-name {
      align-self: center;
      writing-mode: vertical-rl;
      text-orientation: upright;
      margin-right: 3px;
    }
  }
  .headline-col {
    display: flex;
    padding: 0.2rem;
    position: relative;
    height: 100%;
  }
  .headline {
    display: flex;
    align-self: center;
    max-height: 100%;
    overflow: auto;
  }
  .example-div {
    /* take up half the space, leading to two columns of examples being shown */
    display: flex;
    flex-flow: column;
    width: 50%;
    max-height: 100%;
    padding: 10px 1em;
    font-weight: normal;
    white-space: pre-wrap;
  }
  @media (max-width: 992px) {
    .example-div {
      /* take up the full space, leading to only one column of examples being shown */
      width: 100%;
    }
  }
  .example-img {
    padding-top: 4px;
    padding-bottom: 0;
    margin-left: auto;
    margin-right: auto;
    object-fit: contain;
    width: auto;
    max-width: 100%;
    min-height: 0;
    max-height: 100%;
  }
  .explanation-tooltip {
    left: -0.1rem;
    top: 0;
    white-space: pre-wrap;
    background-color: #f5f5f5;
    color: black;
    font-weight: 400;
    border: 1px solid rgba(0, 0, 0, 0.225);
    border-radius: 4px;
    padding: 11px;
    position: absolute;
    display: inline;
    width: 115%;
    transform: translate(-100%, 0%);
    visibility: hidden;
    z-index: 999;
    opacity: 0;
    transition: opacity 0.4s;
  }
  @media (max-width: 1150px) {
    .explanation-tooltip {
      width: 200%;
    }
  }
  .headline-col:hover .explanation-tooltip {
    visibility: visible;
    opacity: 1;
  }
  .fraction {
    display: inline-grid;
    width: max-content;
    font-size: 75%;
    margin: 1pt;
    text-align: center;
    vertical-align: middle;
  }
  .numerator {
    border-bottom: 1px solid black;
    padding-left: 2pt;
    padding-right: 2pt;
    margin: 0 2pt 0;
  }
  .denominator {
    border-top: 1px solid black;
    padding-left: 2pt;
    padding-right: 2pt;
    margin: 0 2pt 0;
  }
</style>
