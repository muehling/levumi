import { reactive } from 'vue'
import { ajax } from '../utils/ajax'
import { decryptStudentName } from '../utils/encryption'
import apiRoutes from '../vue/routes/api-routes'
//TODO the vue onboard solution allows mutating the contents without
//TODO restrictions (e. g. directly overwriting a stored key or function). This
//TODO is rather too side-effecty and error-prone for my taste. This might be replaced by
//TODO Pinia, the official Vue state package
export const store = reactive({
  login: {},
  setLogin(data) {
    this.login = data
  },

  studentsInGroups: {},
  setStudentsInGroups(data) {
    this.studentsInGroups = data
  },

  shareKeys: {},
  setShareKeys(data) {
    this.shareKeys = data
  },

  groups: [],
  setGroups(data) {
    this.groups = data
  },

  masquerade: false,
  setMasquerade(val) {
    this.masquerade = val
  },

  staticData: {},
  setStaticData(data) {
    this.staticData = data
  },

  materialsData: { competences: {}, test_families: {}, tests: {}, supports: {}, materials: {} },
  setMaterialsData(data) {
    this.materialsData = data
  },

  testsData: {},
  setTestsData(data) {
    this.testsData = data
  },
})

export const getMaterialsData = async () => {
  const res = await ajax({ url: apiRoutes.materials.info })
  const data = await res.json()
  store.setMaterialsData(data.materials)
}

export const getTestsData = async () => {
  const res = await ajax({ url: apiRoutes.tests.info })
  const data = await res.json()
  store.setTestsData(data.tests)
}

export const getCoreData = async () => {
  // get core data
  const res = await ajax({ url: `/users/core_data` })
  const coreData = await res.json()

  store.setShareKeys(coreData.share_keys)
  store.setGroups(coreData.groups)
  store.setMasquerade(coreData.masquerade)
  store.setLogin(coreData.login)
  store.setStaticData({
    states: coreData.states,
    schoolTypes: coreData.schoolTypes,
    focusTypes: coreData.focusTypes,
    accountTypes: coreData.accountTypes,
  })

  // decrypt student names
  if (coreData.groups) {
    const studentsInGroups = coreData.groups.reduce((acc, group) => {
      acc[group.id] = group.students?.map(student => {
        return {
          ...student,
          name: decryptStudentName(student.name, `Kind_${student.id}`, group.id),
        }
      })
      return acc
    }, {})

    store.setStudentsInGroups(studentsInGroups)
  }
}
