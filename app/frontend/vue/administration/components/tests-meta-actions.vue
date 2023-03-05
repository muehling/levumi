<template>
  <div class="d-flex justify-content-end">
    <b-form-input v-if="isEdited" v-model="newName" class="mr-2"> </b-form-input>
    <b-btn
      class="btn-sm mr-1 text-nowrap"
      variant="outline-primary"
      @click="rename(type, data.item.id)"
    >
      <i class="fas fa-edit"></i>
      <span class="text-small d-none d-xl-inline pl-2">{{ editButtonText }}</span></b-btn
    >
    <b-btn
      class="btn-sm mr-1 text-nowrap"
      variant="outline-danger"
      :disabled="data.item.testCount > 0"
      @click="deleteItem(type, data.item.id)"
    >
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
    data() {
      return {
        isEdited: false,
        newName: this.data.item.name,
      }
    },
    computed: {
      editButtonText() {
        return this.isEdited ? 'Speichern' : 'Bearbeiten'
      },
    },
    watch: {
      data() {
        this.isEdited = false
        this.newName = this.data.item.name
      },
    },
    methods: {
      rename: function (type, id) {
        if (this.isEdited) {
          this.renameItem(type, id, this.newName.trim())
          this.isEdited = false
        } else {
          this.isEdited = true
        }
      },
    },
  }
</script>
