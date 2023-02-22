<template>
  <div class="text-right">
    <b-btn class="btn-sm mr-1" variant="outline-primary" @click="renameItem(type, data.item.id)">
      <i class="fas fa-edit"></i>
      <span class="text-small d-none d-xl-inline pl-2">Bearbeiten</span></b-btn
    >
    <b-btn class="btn-sm mr-1" variant="outline-danger" @click="deleteItem(type, data.item.id)">
      <i class="fas fa-trash"></i>
      <span class="text-small d-none d-xl-inline pl-2">Löschen</span></b-btn
    >
  </div>
</template>
<script>
  export default {
    name: 'TestsMetaActions',
    props: {
      data: Object,
      type: String,
      renameItem: Function,
      deleteItem: Function,
    },
  }
</script>
