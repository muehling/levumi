<template>
  <b-container>
    <b-button class="mb-4" variant="outline-primary" @click="isDialogOpen = true">
      Neue News
    </b-button>
    <b-table :items="news" :fields="fields">
      <template #cell(message)="d">
        <span class="abbreviate">{{ d.item.message }}</span>
      </template>
      <template #cell(actions)="data">
        <div class="text-nowrap">
          <b-button
            variant="outline-success"
            class="edit-user btn btn-sm me-1"
            @click="showNews(data.item)">
            <i class="fas fa-edit"></i>
            <span class="d-none d-lg-inline">Anzeigen</span>
          </b-button>
          <b-button
            variant="outline-danger"
            class="edit-user btn btn-sm me-1"
            @click="deleteNews(data.item)">
            <i class="fas fa-trash"></i>
            <span class="d-none d-lg-inline">Löschen</span>
          </b-button>
        </div>
      </template>
    </b-table>
    <confirm-dialog ref="confDialog" />
    <b-modal
      ref="createNewsDialog"
      v-model="isDialogOpen"
      title="News erstellen/bearbeiten"
      cancel-variant="outline-danger"
      cancel-title="Abbrechen"
      ok-variant="outline-success"
      ok-title="Speichern"
      @ok="saveNews"
      @hidden="resetDialog">
      <b-form>
        <b-form-input v-model="title" placeholder="Titel eingeben (optional)" class="mb-2" />
        <b-form-textarea v-model="message" placeholder="Nachricht eingeben" class="mb-2" />
      </b-form>
    </b-modal>
  </b-container>
</template>
<script setup>
  import { ajax } from 'src/utils/ajax'
  import { onBeforeMount, ref } from 'vue'
  import ConfirmDialog from 'src/vue/shared/confirm-dialog.vue'

  const news = ref()
  const selectedNews = ref()

  const title = ref('')
  const message = ref('')
  const isDialogOpen = ref(false)

  const confDialog = ref(0)
  const createNewsDialog = ref(0)

  const fields = [
    { key: 'id', label: 'Id' },
    { key: 'date', label: 'Datum' },
    { key: 'title', label: 'Titel' },
    { key: 'message', label: 'Nachricht' },
    { key: 'actions', label: 'Aktionen' },
  ]

  onBeforeMount(async () => {
    fetch()
  })

  const fetch = async () => {
    const res = await ajax({ url: '/news' })
    news.value = res.data
  }

  const showNews = item => {
    selectedNews.value = news.value.find(n => n.id === item.id)
    title.value = selectedNews.value.title
    message.value = selectedNews.value.message
    isDialogOpen.value = true
  }

  const saveNews = async () => {
    if (!selectedNews.value) {
      await ajax({
        url: '/news',
        method: 'POST',
        data: { news: { title: title.value, message: message.value } },
      })
    } else {
      await ajax({
        url: `/news/${selectedNews.value.id}`,
        method: 'PATCH',
        data: { news: { title: title.value, message: message.value } },
      })
    }
    await fetch()
    isDialogOpen.value = false
  }

  const deleteNews = async item => {
    const ok = await confDialog.value.open({
      title: 'Messung löschen',
      message: `Diese Messung unwiderruflich löschen! Sind Sie sicher?`,
      okText: 'Ja, löschen',
    })
    if (ok) {
      const res = await ajax({ url: `/news/${item.id}`, method: 'DELETE' })
      news.value = res.data
    }
  }
  const resetDialog = () => {
    selectedNews.value = undefined
    title.value = ''
    message.value = ''
  }
</script>
