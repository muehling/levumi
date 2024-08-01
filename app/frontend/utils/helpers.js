import { useGlobalStore } from '../store/store'
import { defaultCalcLayout, defaultFont } from './constants'

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

export const getFontSettingsDescription = (studentSettings, groupSettings) => {
  let usedSettings =
    studentSettings.font_size && studentSettings.font_family ? studentSettings : groupSettings

  if (!usedSettings.font_size && !usedSettings.font_family) {
    usedSettings = { font_size: defaultFont.fontSize, font_family: defaultFont.fontFamily }
  }

  if (usedSettings.font_size && usedSettings.font_family) {
    const raw = decodeURIComponent(usedSettings.font_family)
    const fontFamily = raw.charAt(0).toUpperCase() + raw.slice(1)
    switch (usedSettings.font_size) {
      case '1':
        return `${fontFamily}, normale Größe`
      case '2':
        return `${fontFamily}, vergrößert`
      case '3':
        return `${fontFamily}, stark vergrößert`
    }
  }
}

export const getCalcSettingsDescription = (studentSettings, groupSettings) => {
  let usedSetting = studentSettings.calculator_layout
    ? studentSettings.calculator_layout
    : groupSettings.calculator_layout
  if (!usedSetting) {
    usedSetting = defaultCalcLayout
  }

  switch (usedSetting) {
    case 'phone':
      return { id: 1, text: 'Telefontastatur' }
    case 'numpad':
      return { id: 2, text: 'Nummernblock' }
  }
}
