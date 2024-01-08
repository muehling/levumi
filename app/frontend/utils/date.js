import format from 'date-fns/format'

export const printDate = date => {
  if (date) {
    return !isNaN(new Date(date)) ? format(new Date(date), 'dd.MM.yyyy') : date
  } else {
    return ''
  }
}
