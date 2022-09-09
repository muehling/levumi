import { reactive } from 'vue'
import { ajax } from '../utils/ajax'
import { apiRoutes } from '../vue/routes/api-routes'
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

  materialsData: {},
  setMaterialsData(data) {
    this.materialsData = data
  },
})

export const getMaterialsInfo = async () => {
  const res = await ajax({ url: apiRoutes.materials.info })
  const data = await res.json()
  this.setMaterialsData(data)
}
