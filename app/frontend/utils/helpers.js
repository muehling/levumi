import { isObject } from 'lodash'
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

export const getFontSettingsDescription = (settings, isDefault) => {
  let settingsText = 'Standard'
  if (isObject(settings)) {
    const raw = decodeURIComponent(settings.font_family)
    const fontFamily = raw.charAt(0).toUpperCase() + raw.slice(1)
    switch (settings.font_size) {
      case '1':
        settingsText = `${isDefault ? 'Standard: ' : ''}${fontFamily}, normale Größe`
        break
      case '2':
        settingsText = `${isDefault ? 'Standard: ' : ''}${fontFamily}, vergrößert`
        break
      case '3':
        settingsText = `${isDefault ? 'Standard: ' : ''}${fontFamily}, stark vergrößert`
        break
    }
  }
  return settingsText
}
