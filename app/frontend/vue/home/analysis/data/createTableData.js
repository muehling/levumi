import { printDate } from '../../../../utils/date'
import deepmerge from 'deepmerge'

// input for <b-table-lite>
export const createSimpleTableData = (data, formatDate) => {
  return data.map(lineData => {
    const data = lineData.data.reduce((acc, d) => {
      // createSeries contains raw dates, so we need to format them here
      acc[formatDate ? d.x : printDate(d.x)] = d.y || '-'
      return acc
    }, {})
    return {
      name: lineData.name,
      ...data,
    }
  })
}

export const createHtmlTableFromViewConfig = data => {
  // data contains the following props from the analysis-view:
  // weeks
  // results
  // viewConfig
  // selectedStudentId
  // columns
  let weeks = data.weeks.slice().reverse()
  let res = []
  for (let w = 0; w < weeks.length; ++w) {
    let found = false
    for (let r = 0; r < data.results.length; ++r) {
      if (
        data.results[r].student_id === data.selectedStudentId &&
        data.results[r].test_week === weeks[w]
      ) {
        let temp = {}
        for (let i = 0; i < data.viewConfig.column_keys.length; ++i) {
          let key = data.viewConfig.column_keys[i]
          let name = data.viewConfig.columns[i]
          temp[name] = data.results[r].views[data.viewConfig.key][key]
          if (temp[name] === undefined) {
            temp[name] = '-'
          }
        }
        res.push(deepmerge({ week: weeks[w] }, temp))
        found = true
        break
      }
    }
    if (!found) {
      let temp = {}
      for (let c = 0; c < data.columns.length; ++c) {
        temp[data.columns[c]] = '-'
      }
      res.push(deepmerge({ week: weeks[w] }, temp))
    }
  }
  return res
}
