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

  return category?.name.split('#')[0] || ''
}

export const getAnnotationOptions = () => {
  const store = useGlobalStore()
  const categories = store.staticData.annotationCategories.map(category => {
    const [name, group, index] = category.name.split('#')
    return {
      id: category.id,
      name: name,
      group: parseInt(group, 10) || 1,
      index: parseInt(index, 10) || 1,
    }
  })

  return categories.sort((a, b) => a.group - b.group || a.index - b.index)
}
