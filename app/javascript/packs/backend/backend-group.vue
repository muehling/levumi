<template>
    <b-card :title="title"
            :sub-title="'Klassengröße: ' + size"
    >
    </b-card>
</template>

<script>
export default {
    props: {
        title: String,
        size: Number
    },
    name: "backend-group"
}
</script>

<style>
    .card {
        margin: 10px;
    }
</style>