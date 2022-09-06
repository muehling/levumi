import { store } from './store'

//Liefert das Student-Objekt zu einer ID in dessen Gruppe zurück.
export const getStudent = (groupId, studentId) => {
  const group = store.studentsInGroups[groupId]
  const student = group?.find(student => student.id === studentId)

  return student || null
}
