import { reactive } from 'vue'
//TODO the vue onboard solution allows mutating the contents without
//TODO restrictions (e. g. directly overwriting a stored key). This
//TODO is rather too side-effecty for my taste. This might be replaced by
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
})
