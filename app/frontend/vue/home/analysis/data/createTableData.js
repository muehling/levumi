import { printDate } from '../../../../utils/date'
import deepmerge from 'deepmerge'

// input for <b-table-lite>
export const createSimpleTableData = (data, formatDate) => {
  const d = data.map(lineData => {
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
  return d
}

export const createHtmlTableFromViewConfig = ({
  weeks,
  results,
  viewConfig,
  selectedStudentId,
  columns,
}) => {
  weeks = weeks.slice().reverse()
  let res = []
  for (let w = 0; w < weeks.length; ++w) {
    let found = false
    for (let r = 0; r < results.length; ++r) {
      if (results[r].student_id === selectedStudentId && results[r].test_week === weeks[w]) {
        let temp = {}
        for (let i = 0; i < viewConfig.column_keys.length; ++i) {
          let key = viewConfig.column_keys[i]
          let name = viewConfig.columns[i]
          temp[name] = results[r].views?.[viewConfig.key]?.[key]
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
      for (let c = 0; c < columns.length; ++c) {
        temp[columns[c]] = '-'
      }
      res.push(deepmerge({ week: weeks[w] }, temp))
    }
  }
  return res
}
