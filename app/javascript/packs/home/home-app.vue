<template>
    <b-container fluid>
        <div v-cloak>

            <b-row>
                <b-col md="12">
                    <b-nav pills fill class="mt-3">
                        <b-nav-item v-for="(group, index) in groups"
                                    v-if="group.archive == false"
                                    :key="group.id"
                                    :active="selected_group == index"
                                    @click="selected_group = index"
                        >
                            {{ group.label }}
                        </b-nav-item>
                    </b-nav>
                </b-col>
            </b-row>

            <b-row>
                <b-col md="12">
                    <b-nav pills fill class="mt-5">
                        <b-nav-item v-for="test in tests"
                                    :key="test.id"
                        >
                            {{ test.name }}
                        </b-nav-item>
                    </b-nav>
                </b-col>
            </b-row>

            <b-row class="justify-content-md-center">Klasseninfo</b-row>

        </div>

    </b-container>
</template>

<script>
    export default {
        data: function () {
            return {
                groups: this.$root.groups,
                tests: this.$root.tests,
                selected_group: 0
            }
        },
        name: "home-app"
    }
</script>
