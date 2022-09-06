import { reactive } from 'vue'

export const store = reactive({
  studentsInGroups: {},
  setStudentsInGroups(data) {
    this.studentsInGroups = data
  },
})
