export default {
  classbook: {
    finishIntro: '/willkommen?classbook=true',
  },
  users: {
    show: id => ({ url: `/users/${id}` }),
    update: id => ({ url: `/users/${id}`, method: 'PATCH' }),
    create: { url: '/users', method: 'POST' },
    usersMail: id => ({ url: `/users/${id}/mail`, method: 'PUT' }),
    coreData: '/users/core_data',
    logout: '/logout',
    renewLogin: ({ email, password }) => ({
      url: '/renew_login',
      method: 'POST',
      data: { email, password },
    }),
    statistics: '/users/statistics',
    delete: () => ({ url: `/delete_self`, method: 'DELETE', accept: 'text/html' }),
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
    info: '/tests/info',
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
    info: groupId => ({ url: `/groups/${groupId}/assessments` }),
    delete: (groupId, assessmentId) => ({
      url: `/groups/${groupId}/assessments/${assessmentId}`,
      method: 'DELETE',
    }),
  },
  annotations: {
    create: (groupId, testId) => ({
      url: `/groups/${groupId}/assessments/${testId}/annotations`,
      method: 'POST',
    }),
    delete: annotationId => ({
      url: `/groups/1/assessments/1/annotations/${annotationId}`, // hardcoded 1 for group and assessment id are ok, as they are ignored in the controller anyway
      method: 'DELETE',
    }),
  },
}
