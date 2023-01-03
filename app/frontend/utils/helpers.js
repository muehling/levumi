import { useGlobalStore } from '../store/store'

// Returns the student object for the passed group and student id
export const getStudent = (groupId, studentId) => {
  const store = useGlobalStore()

  const group = store.studentsInGroups[groupId]
  const student = group?.find(student => student.id === studentId)

  return student || null
}
