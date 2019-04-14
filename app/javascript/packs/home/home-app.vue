<template>
    <b-container fluid>
        <div v-cloak>
            <b-row>
                <b-col md='12' class='mt-3'>

                    <!-- Klassenauswahl nur bei mehreren Klassen anzeigen (=> Privatpersonen...) -->
                    <!-- TODO: Besser! -->
                    <b-tabs pills v-if="groups.length > 1">

                        <div slot='empty'>
                            <div class='text-center text-muted'>
                                Keine aktuellen Klassen vorhanden.
                            </div>
                        </div>

                        <!-- Oberste Ebene - aktuelle Klassen, falls pre_select gesetzt, direkt auswählen -->
                        <b-tab v-for="(group, index) in groups"
                               :key="group.id"
                               :title="group.label"
                               :active="$root.pre_select && ($root.pre_select.group == group.id)"
                        >

                            <!-- Zweite Ebene - gewählte Klasse -->
                            <group-view
                                    :group="group"
                                    :group_info="group_info[index]"
                            >
                            </group-view>

                        </b-tab>

                    </b-tabs>

                    <!-- Ansonsten Klasse vorauswählen -->
                    <group-view v-else
                                :group="groups[0]"
                                :group_info="group_info[0]">
                    </group-view>

                </b-col>
            </b-row>
        </div>

    </b-container>
</template>

<script>
    import GroupView from './group-view';
    export default {
        components: {GroupView},
        data: function () {
            return {
                groups: this.$root.groups,
                group_info: this.$root.group_info
            }
        },
        updated() {
            this.$root.pre_select = undefined;
        },
        name: 'home-app'
    }
</script>
