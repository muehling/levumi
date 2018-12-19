<template>
    <b-container fluid>
        <div v-cloak>
            <b-row>
                <b-col md="12" class="mt-3">
                    <b-tabs pills>

                        <div slot="empty">
                            <div class="text-center text-muted">
                                Keine aktuellen Klassen vorhanden.
                            </div>
                        </div>

                        <!-- Oberste Ebene - aktuelle Klassen -->
                        <b-tab v-for="(group, index) in groups"
                                    :key="group.id"
                                    :title="group.label"
                        >

                            <!-- Zweite Ebene - Lernbereiche -->
                            <group-view
                                    :group="group"
                                    :group_info="group_info[index]"
                            >
                            </group-view>

                        </b-tab>

                    </b-tabs>
                </b-col>
            </b-row>
        </div>

    </b-container>
</template>

<script>
    import GroupView from "./group-view";
    export default {
        components: {GroupView},
        data: function () {
            return {
                groups: this.$root.groups,
                group_info: this.$root.group_info
            }
        },
        name: "home-app"
    }
</script>
