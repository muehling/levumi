<template>
  <div>
    <b-table :items="news" :fields="fields">
      <template #cell(message)="d">
        <span class="abbreviate">{{ d.item.message }}</span>
      </template>
      <template #cell(actions)="data">
        <div class="text-nowrap">
          <b-button
            variant="outline-success"
            class="edit-user btn btn-sm mr-1"
            @click="showNews(data.item)">
            <i class="fas fa-edit"></i>
            <span class="d-none d-lg-inline">Anzeigen</span>
          </b-button>
          <b-button
            variant="outline-danger"
            class="edit-user btn btn-sm mr-1"
            @click="deleteNews(data.item)">
            <i class="fas fa-trash"></i>
            <span class="d-none d-lg-inline">Löschen</span>
          </b-button>
        </div>
      </template>
    </b-table>
  </div>
</template>
<script setup>
  import { ajax } from 'src/utils/ajax'
  import { onBeforeMount, ref } from 'vue'

  const news = ref()

  const fields = [
    { key: 'id', label: 'Id' },
    { key: 'date', label: 'Datum' },
    { key: 'title', label: 'Titel' },
    { key: 'message', label: 'Nachricht' },
    { key: 'actions', label: 'Aktionen' },
  ]

  onBeforeMount(async () => {
    const res = await ajax({ url: '/news' })
    news.value = res.data
  })

  const showNews = id => {}

  const deleteNews = async item => {
    console.log('items', item)

    await ajax({ url: `/news/${item.id}`, method: 'DELETE' })
  }
</script>
