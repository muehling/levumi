<template>
  <div>
    <b-button
      v-if="props.group.demo && !props.group.has_demo_students"
      size="sm"
      class="me-2"
      variant="outline-success"
      :disabled="isWorkingOnDemoStudents"
      @click="createDemoData">
      <span class="text-nowrap">
        <i class="fa-solid fa-hammer"></i>
        Demo-Daten anlegen
      </span>
      <i v-if="isWorkingOnDemoStudents" class="fas fa-spinner fa-spin"></i>
    </b-button>
    <b-button
      v-if="props.group.demo && props.group.has_demo_students"
      size="sm"
      class="me-2"
      variant="outline-danger"
      :disabled="isWorkingOnDemoStudents"
      @click="deleteDemoData">
      <span class="text-nowrap">
        <i class="fa-solid fa-hammer"></i>
        Demo-Daten entfernen
      </span>
      <i v-if="isWorkingOnDemoStudents" class="fas fa-spinner fa-spin"></i>
    </b-button>
    <confirm-dialog ref="confDialog" />
  </div>
</template>
<script setup>
  import { ajax } from 'src/utils/ajax'
  import { defineProps, ref } from 'vue'
  import { encryptWithMasterKeyAndGroup } from 'src/utils/encryption'
  import { useGlobalStore } from 'src/store/store'
  import { useRouter } from 'vue-router'
  import { useAssessmentsStore } from 'src/store/assessmentsStore'
  import ConfirmDialog from '../confirm-dialog.vue'

  const store = useGlobalStore()
  const assessmentsStore = useAssessmentsStore()
  const router = useRouter()

  const confDialog = ref(0)

  const props = defineProps({ group: Object, source: String })

  const isWorkingOnDemoStudents = ref(false)

  const navigateAfterDemoData = async res => {
    if (props.source === 'home') {
      router.push(`/diagnostik/${props.group.id}`)
    }
    await assessmentsStore.fetch(props.group.id)

    store.setGroupsData(res)
  }

  const createDemoData = async () => {
    const answer = await confDialog.value.open({
      message: `Mit dieser Aktion werden drei Demo-Schüler*innen sowie jeweils fünf Messergebnisse pro Schüler*in angelegt. Möchten Sie fortfahren?`,
      okText: 'Ja, Daten erstellen',
      okIntent: 'outline-success',
      containsHtml: true,
      cancelText: 'Abbrechen',
      title: 'Demo-Daten erstellen',
    })

    if (!answer) {
      return
    }

    isWorkingOnDemoStudents.value = true
    // encoding will fail if password was reset by admins
    const demoNames = [
      'Felix',
      'August',
      'Karl',
      'Rudi',
      'Ernst',
      'Rosa',
      'Klara',
      'Marie',
      'Franziska',
      'Luise',
      'Helene',
      'Kurt',
    ]

    const getRandomNames = () => [...demoNames].sort(() => 0.5 - Math.random()).slice(0, 3)

    const encodedNames = getRandomNames().map(name =>
      encodeURIComponent(encryptWithMasterKeyAndGroup(name, props.group.id))
    )
    const studentData = {
      student_names: encodedNames,
    }
    const res = await ajax({
      url: `/groups/${props.group.id}/add_demo_data`,
      method: 'POST',
      data: studentData,
    })
    if (res.status === 200) {
      navigateAfterDemoData(res)
    } else {
      store.setErrorMessage(res.data.message)
    }
    isWorkingOnDemoStudents.value = false
  }
  const deleteDemoData = async () => {
    const answer = await confDialog.value.open({
      message: `Mit dieser Aktion werden alle erstellten Demo-Daten gelöscht. Selbst erfasste Daten sind davon nicht betroffen. Möchten Sie fortfahren?`,
      okText: 'Ja, Demo-Daten löschen',
      okIntent: 'outline-danger',
      containsHtml: true,
      cancelText: 'Abbrechen',
      title: 'Demo-Daten löschen',
    })

    if (!answer) {
      return
    }

    isWorkingOnDemoStudents.value = true
    const groupId = props.group.id
    const res = await ajax({
      url: `/groups/${props.group.id}/delete_demo_data`,
      method: 'POST',
      data: groupId,
    })
    if (res.status === 200) {
      navigateAfterDemoData(res)
    }
    isWorkingOnDemoStudents.value = false
  }
</script>
