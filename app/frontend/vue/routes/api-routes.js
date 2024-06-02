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
    login: { url: '/login', method: 'POST' },
    renewLogin: ({ email, password }) => ({
      url: '/renew_login',
      method: 'POST',
      data: { email, password },
    }),
    statistics: '/users/statistics',
    delete: () => ({ url: `/delete_self`, method: 'DELETE', accept: 'text/html' }),
    index: pageNumber => ({ url: `/users/page/${pageNumber}` }),
  },
  home: {
    finishIntro: '/willkommen',
  },
  materials: {
    info: '/materials/info',
    index: '/materials',
    import: { url: '/materials', method: 'POST', contentType: 'omit' },
    materialsForTest: id => `/materials/test/${id}`,
  },
  tests: {
    index: '/tests',
    info: '/tests/info',
    import: { url: '/tests', method: 'POST', contentType: 'omit' },
    update: id => ({ url: `/tests/${id}`, method: 'PATCH' }),
    testMetaData: { url: '/tests_meta' },
    checkUploadVersion: { url: 'check_upload_version', method: 'POST' },
    items: id => ({ url: `/tests/items/${id}` }),
    info_attachments: id => ({ url: `/tests/info_attachments/${id}` }),
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
    updateAll: groupId => ({ url: `/groups/${groupId}/assessments`, method: 'PUT' }),
    currentAssessment: (groupId, testId) => ({ url: `/groups/${groupId}/assessments/${testId}` }),
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
  annotationCategories: {
    index: '/annotation_categories',
    create: { url: '/annotation_categories', method: 'POST' },
    delete: id => ({ url: `/annotation_categories/${id}`, method: 'DELETE' }),
  },
  testTypes: {
    index: '/test_types',
    create: { url: '/test_types', method: 'POST' },
    delete: id => ({ url: `/test_types/${id}`, method: 'DELETE' }),
  },
  targets: {
    createStudentTarget: (groupId, testId, data) => ({
      url: `/groups/${groupId}/assessments/${testId}/targets`,
      method: 'POST',
      data,
    }),
    getStudentTargets: (groupId, testId) => ({
      // gets all student targets for an assessment instead of just one to minimize request count
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
  },
  administration: {
    areas: {
      update: id => ({ url: `/areas/${id}`, method: 'PUT' }),
      delete: id => ({ url: `/delete_area/${id}`, method: 'DELETE' }),
    },
    competences: {
      update: id => ({ url: `/competences/${id}`, method: 'PUT' }),
      delete: id => ({ url: `/competences/${id}`, method: 'DELETE' }),
    },
    testFamilies: {
      update: id => ({ url: `/test_families/${id}`, method: 'PUT' }),
      delete: id => ({ url: `/test_families/${id}`, method: 'DELETE' }),
    },
  },
  students: {
    activeAssessments: id => ({ url: `/students/${id}` }),
  },
  groups: {
    group: id => ({ url: `/groups/${id}` }),
    getTestData: id => ({ url: `/groups/${id}/test_data` }),
  },
}
