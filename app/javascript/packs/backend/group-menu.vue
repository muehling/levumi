<template>

    <b-nav pills fill class="mt-3">
        <b-nav-item v-for="(group, index) in groups"
                    v-if="group.archive == false"
                    :key="group.id"
                    :active="active == index"
                    @click="active = index"
        >
            {{ group.label }}
        </b-nav-item>
    </b-nav>

</template>

<script>
    export default {
        props: {
            groups: Array
        },
        data: function () {
            return {
                active: 0
            }
        },
        name: "group-menu"
    }
</script>
