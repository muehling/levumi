export const checkField = (field, constraints) => {
  if (!constraints) {
    return false
  }

  if (constraints.includes('multiple') /* && field.includes('|')*/) {
    const singleFieldConstraints = constraints.filter(c => c != 'multiple')
    const singleFields = field.split('|')
    const checked = singleFields.reduce((acc, fieldEntry) => {
      acc = acc && checkField(fieldEntry, singleFieldConstraints)
      return acc
    }, true)
    return checked
  } else {
    const checked = constraints.reduce((acc, constraint) => {
      let looksCorrect = true
      if (constraint === 'empty' && !field) {
        return true
      }
      switch (constraint) {
        case 'text':
          if (field.includes('"') && !constraints.includes('json')) {
            looksCorrect = false
          } else if (field.includes("'") && !constraints.includes('html')) {
            looksCorrect = false
          }
          break
        case 'html':
          if (field.includes('"')) {
            looksCorrect = false
          }
          break
        case 'json':
          if (field.includes("'")) {
            looksCorrect = false
          }
          try {
            JSON.parse(field)
          } catch (e) {
            looksCorrect = false
          }
          break
        case 'number':
          if (isNaN(parseInt(field, 10))) {
            looksCorrect = false
          }
          break
        case 'empty':
          looksCorrect = true
          break
        case 'image':
          if (
            !field.endsWith('jpg') &&
            !field.endsWith('jpeg') &&
            !field.endsWith('gif') &&
            !field.endsWith('png') &&
            !field.endsWith('webp') &&
            !field.endsWith('svg')
          ) {
            looksCorrect = false
          }
          break
        case 'audio':
          break
        default:
          console.warn(`CSV-Upload: unknown constraint type '${constraint}'`)
          looksCorrect = false
      }
      return acc && looksCorrect
    }, true)
    return checked
  }
}

export const checkLine = (line, constraints) => {
  const t = line.map((field, index) => checkField(field, constraints[index]))
  return t
}
