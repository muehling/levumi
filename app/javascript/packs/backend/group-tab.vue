<template>
 <p>
  <b-table hover :items="students"></b-table>
 </p>
</template>

<script>
export default {
    props: {
        students: Array
    },
    name: "group-tab"
}
</script>

<style>
</style>