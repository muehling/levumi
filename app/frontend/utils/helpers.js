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

export const getTrendFromResults = data => {
  if (!data || data.length < 3) {
    return
  }

  const [x1, x2, x3] = data

  // some edge cases
  if (x1 === 1 && x2 === 1 && x3 === 1) {
    return 'NO_SUPPORT'
  }
  if (x1 === 1 && x3 === 1 && x2 <= 0.33) {
    return 'HIGH_SUPPORT'
  }
  if (x1 === 1 && x3 === 1 && x2 > 0.33) {
    return 'MEDIUM_SUPPORT'
  }

  if (x1 >= x3) {
    return 'HIGH_SUPPORT'
  } else if (x1 < x3 && (x1 > x2 || x2 > x3)) {
    return 'MEDIUM_SUPPORT'
  } else if (x1 < x3 && x1 <= x2 && x2 <= x3) {
    return 'NO_SUPPORT'
  }
}
