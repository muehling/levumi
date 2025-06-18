<template>
  <b-nav vertical pills>
    <b-nav-item :active="current === 'general'" @click="handleClick('general')">
      Allgemein
    </b-nav-item>
    <b-nav-item
      v-if="permissions?.createShare"
      :active="current === 'share'"
      @click="handleClick('share')">
      Klasse teilen{{ shareCountDisplay }}
    </b-nav-item>
    <b-nav-item
      v-if="permissions?.moveStudents"
      :active="current === 'movestudents'"
      @click="handleClick('movestudents')">
      Schüler*innen verschieben
    </b-nav-item>
  </b-nav>
</template>
<script>
  import { access } from 'src/utils/access'
  export default {
    name: 'GroupViewActionsNav',
    props: { current: String, group: Object },
    computed: {
      shareCountDisplay() {
        return this.group.shares.length ? ` (${this.group.shares.length}x geteilt)` : ''
      },
      permissions() {
        return access(this.group).classbook
      },
    },
    methods: {
      handleClick(action) {
        this.$emit('groupview::action', action)
      },
    },
  }
</script>
