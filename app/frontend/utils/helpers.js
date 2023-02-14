import { useGlobalStore } from '../store/store'

// Returns the student object for the passed group and student id
export const getStudent = (groupId, studentId) => {
  const store = useGlobalStore()
  const group = store.studentsInGroups[groupId]
  const student = group?.find(student => student.id === studentId)

  return student || null
}

export const getAnnotationLabel = id => {
  const store = useGlobalStore()
  const category = store.staticData.annotationCategories.find(category => category.id === id)

  return category?.name || ''
}

export const getAnnotationOptions = () => {
  const store = useGlobalStore()
  return store.staticData.annotationCategories.map(category => ({
    value: category.id,
    text: category.name,
  }))
}
