<template>

    <b-container fluid>
        <b-row class='mt-3'>
            <b-col md='12'>

                <div v-if="single"> <!-- nur eine Gruppe darstellen -->
                    <group-view
                            :groups="groups"
                            :index="1"
                    ></group-view>
                </div>

                <div v-else> <!-- reguläre Darstellung mit Klassenliste -->
                    <b-tabs pills>

                        <b-tab active>
                            <template slot='title'>
                                Eigene Klassen
                            </template>

                            <b-card no-body class='mt-3'>
                                <b-tabs pills card>

                                    <!-- Neue Klasse anlegen -->
                                    <b-tab>
                                        <template slot='title'>
                                            <i class='fas fa-folder-plus fa-lg' title='Neue Klasse anlegen'></i>
                                        </template>
                                        <!-- Group-Form mit index 0, da groups[0] ein leeres Objekt beinhaltet, für propagiertes Update die Rückgabe an Stelle 1 einfügen, Objekt an Stelle 0 bleibt erhalten.-->
                                        <group-form
                                                :group="groups[0]"
                                                :index="0"
                                                :active="firstOwnIndex == 0"
                                                v-on:update:groups="create($event)"
                                        ></group-form>
                                    </b-tab>

                                    <!-- Alle Klassen als Tabs anzeigen, index bei 1 beginnen und Archiv ausklammern -->
                                    <!-- "title-link-class" ist workaround, damit ein Re-render nach Umbennenen getriggert wird. TODO: Überflüssig bei neuer Version von BootstrapVue? -->
                                    <b-tab
                                            v-for="(group, index) in groups"
                                            v-if="index > 0 & !group.archive && group.owner"
                                            :key="group.id"
                                            :active="index == firstOwnIndex"
                                            :title-link-class="{ update_trigger_hack: group.label }"
                                            class='m-3'
                                    >
                                        <!-- Testklasse kursiv darstellen -->
                                        <template slot='title'>
                                            <i v-if="group.demo">{{group.label}}</i>
                                            <span v-else>{{group.label}}</span>
                                        </template>
                                        <group-view
                                                :groups="groups"
                                                :index="index"
                                        ></group-view>
                                    </b-tab>

                                </b-tabs>
                            </b-card>
                        </b-tab>

                        <!-- Geteilte Klassen -->
                        <b-tab>
                            <template slot='title'>
                                Geteilte Klassen <span v-if="new_shares" class="badge badge-info">Neu!</span>
                            </template>

                            <b-card no-body class='mt-3'>
                                <b-tabs pills card>

                                    <!-- Hinweistext falls keine Klasse vorhanden -->
                                    <div slot='empty'>
                                        <div v-cloak class='text-center text-muted'>
                                            Keine geteilten Klassen vorhanden.
                                        </div>
                                    </div>
                                    <b-tab
                                            v-for="(group, index) in groups"
                                            v-if="index > 0 && !group.owner"
                                            :key="group.id"
                                            :active="index == firstSharedIndex"
                                            class='m-3'
                                    >
                                        <!-- Testklasse kursiv darstellen -->
                                        <template slot='title'>
                                            <i v-if="group.demo">{{group.label}}</i>
                                            <span v-else>{{group.label}}</span>
                                            <span v-if="group.key == null" class="badge badge-info">Neu!</span>
                                        </template>
                                        <group-view
                                                :groups="groups"
                                                :index="index"
                                        ></group-view>
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
                                            v-if="index > 0 && group.archive"
                                            :key="group.id"
                                            class='m-3'
                                    >
                                        <!-- Testklasse kursiv darstellen -->
                                        <template slot='title'>
                                            <i v-if="group.demo">{{group.label}}</i>
                                            <span v-else>{{group.label}}</span>
                                        </template>
                                        <group-view
                                                :groups="groups"
                                                :index="index"
                                        ></group-view>
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
    import GroupView from './group-view';

    export default {
        components: {
            GroupView, GroupForm
        },
        methods: {
            create(val) {
                this.groups.splice(1, 0, val.object);
                //Globale Daten aktualisieren
                //TODO: Classbook-App autark halten?
                keys[val.object.id] = val.object.key;
                groups[val.object.id] = [];
            },
            sort: function(groups) {
                let empty = groups.shift();       //Erstes Element ist leere Gruppe für "new"
                groups.sort((a, b) => b.id - a.id); //Rest nach ID absteigend sortieren
                groups.unshift(empty);
                return groups;
            }
        },
        computed: {
          firstOwnIndex: function() {
              for (let i = 1; i < this.groups.length; ++i)
                  if (this.groups[i].owner && !this.groups[i].archive)
                      return i;
              return 0;
          },
          firstSharedIndex: function() {
              for (let i = 1; i < this.groups.length; ++i)
                  if (!this.groups[i].owner)
                      return i;
              return 0;
          },
          new_shares: function() {
              for (let i = 1; i < this.groups.length; ++i)
                  if (this.groups[i].key == null)
                      return true;
              return false;
          }
        },
        data: function () {
            return {
                groups: this.sort(this.$root.groups),
                single: this.$root.single
            }
        },
        name: 'class-book-app'
    }
</script>
