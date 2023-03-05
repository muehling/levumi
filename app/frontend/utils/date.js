import format from 'date-fns/format'

export const printDate = date => {
  //Datumsanzeige formatieren
  if (date) {
    return format(new Date(date), 'dd.MM.yyyy')
  } else {
    return ''
  }
}
