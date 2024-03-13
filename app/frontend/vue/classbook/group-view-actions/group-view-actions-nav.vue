<template>
  <b-nav vertical pills>
    <b-nav-item :active="current === 'general'" @click="handleClick('general')">
      Allgemein
    </b-nav-item>
    <b-nav-item :active="current === 'share'" @click="handleClick('share')">
      Klasse teilen
    </b-nav-item>
    <b-nav-item :active="current === 'movestudents'" @click="handleClick('movestudents')">
      Schüler:innen verschieben
    </b-nav-item>
  </b-nav>
</template>
<script>
  export default {
    name: 'GroupViewActionsNav',
    props: { current: String },
    methods: {
      handleClick(action) {
        this.$emit('groupview::action', action)
      },
    },
  }
</script>
