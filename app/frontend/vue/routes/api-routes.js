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
  targets: {
    createStudentTarget: (groupId, testId, data) => ({
      url: `/groups/${groupId}/assessments/${testId}/targets`,
      method: 'POST',
      data,
    }),
    getStudentTargets: (groupId, testId) => ({    // gets all student targets for an assessment instead of just one to minimize request count
      url: `/groups/${groupId}/assessments/${testId}/targets`,
      method: 'GET',
    }),
    updateStudentTarget: (groupId, testId, targetId, data) => ({
      url: `/groups/${groupId}/assessments/${testId}/targets/${targetId}`,
      method: 'PUT',
      data,
    }),
    deleteStudentTarget: (groupId, testId, targetId) => ({
      url: `/groups/${groupId}/assessments/${testId}/targets/${targetId}`,
      method: 'DELETE',
    }),
  }
}
