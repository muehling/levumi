import { reactive } from 'vue'

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
})
