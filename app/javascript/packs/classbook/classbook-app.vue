<template>

    <b-container fluid>
        <b-row class='mt-3'>
            <b-col md='12'>

                <div v-if="single"> <!-- nur eine Gruppe darstellen -->
                    <group-display
                            :groups="groups"
                            :index="1"
                            :readOnly="true"
                    ></group-display>
                </div>

                <div v-else> <!-- reguläre Darstellung mit Klassenliste -->
                    <b-tabs pills>

                        <b-tab active>
                            <template slot='title'>
                                Aktuelle Klassen
                            </template>

                            <b-card no-body class='mt-3'>
                                <b-tabs pills card>

                                    <!-- Neue Klasse anlegen -->
                                    <b-tab>
                                        <template slot='title'>
                                            <i class='fas fa-folder-plus' title='Neue Klasse anlegen'></i>
                                        </template>
                                        <!-- Group-Form mit index 0, da groups[0] ein leeres Objekt beinhaltet, für propagiertes Update die Rückgabe an Stelle 1 einfügen, Objekt an Stelle 0 bleibt erhalten.-->
                                        <group-form
                                                :group="groups[0]"
                                                :index="0"
                                                v-on:update:groups="groups.splice(1, 0, $event.object)"
                                        ></group-form>
                                    </b-tab>

                                    <!-- Alle Klassen als Tabs anzeigen, index bei 1 beginnen und Archiv ausklammern-->
                                    <b-tab
                                            v-for="(group, index) in groups"
                                            v-if="index > 0 & group.archive == false"
                                            :key="group.id"
                                            :active="index == 1"
                                    >
                                        <!-- Testklasse kursiv darstellen -->
                                        <template slot='title'>
                                            <i v-if="group.demo">{{group.label}}</i>
                                            <span v-else>{{group.label}}</span>
                                        </template>
                                        <group-display
                                                :groups="groups"
                                                :index="index"
                                                :readOnly="false"
                                        ></group-display>
                                    </b-tab>

                                </b-tabs>
                            </b-card>
                        </b-tab>

                        <!-- Klassenarchiv -->
                        <b-tab>
                            <template slot='title'>
                                Klassenarchiv
                            </template>

                            <b-card no-body class='mt-3'>
                                <b-tabs pills card vertical>

                                    <!-- Hinweistext falls keine Klasse vorhanden -->
                                    <div slot='empty'>
                                        <div v-cloak class='text-center text-muted'>
                                            Keine Klassen im Archiv vorhanden.
                                        </div>
                                    </div>
                                    <b-tab
                                            v-for="(group, index) in groups"
                                            v-if="group.archive == true"
                                            :key="group.id"
                                    >
                                        <!-- Testklasse kursiv darstellen -->
                                        <template slot='title'>
                                            <i v-if="group.demo">{{group.label}}</i>
                                            <span v-else>{{group.label}}</span>
                                        </template>
                                        <group-display
                                                :groups="groups"
                                                :index="index"
                                        ></group-display>
                                    </b-tab>
                                </b-tabs>
                            </b-card>

                        </b-tab>

                    </b-tabs>
                </div>
            </b-col>
        </b-row>
    </b-container>

</template>

<script>
    import GroupForm from './group-form';
    import GroupDisplay from './group-display';

    export default {
        components: {
            GroupDisplay, GroupForm
        },
        data: function () {
            return {
                groups: this.$root.groups,
                single: this.$root.single
            }
        },
        name: 'class-book-app'
    }
</script>
