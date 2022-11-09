export default {
  classbook: {
    finishIntro: '/willkommen?classbook=true',
  },
  users: {
    update: id => ({ url: `/users/${id}`, method: 'PATCH' }),
    create: { url: '/users', method: 'POST' },
    usersMail: id => ({ url: `/users/${id}/mail`, method: 'PUT' }),
    coreData: '/users/core_data',
    logout: '/logout',
    statistics: '/users/statistics',
  },
  home: {
    finishIntro: '/willkommen',
  },
  materials: {
    info: '/materials/info',
    index: '/materials',
    import: { url: '/materials', method: 'POST', contentType: 'omit' },
  },
  tests: {
    index: '/tests',
    info: 'tests/info',
    import: { url: '/tests', method: 'POST', contentType: 'omit' },
    update: id => ({ url: `tests/${id}`, method: 'PATCH' }),
  },
  assessments: {
    excludeStudent: (groupId, testId, studentId) => ({
      url: `/groups/${groupId}/assessments/${testId}/?assessment[exclude]=${studentId}`,
      method: 'PUT',
    }),
    includeStudent: (groupId, testId, studentId) => ({
      url: `/groups/${groupId}/assessments/${testId}/?assessment[include]=${studentId}`,
      method: 'PUT',
    }),
    deleteResult: (studentId, resultId) => ({
      url: `/students/${studentId}/results/${resultId}`,
      method: 'DELETE',
    }),
    toggleAssessment: (groupId, testId, data) => ({
      url: `/groups/${groupId}/assessments/${testId}`,
      method: 'PUT',
      data,
    }),
  },
}
