<template>

    <div>
        <div v-if="index > 0">
            <b-btn v-b-toggle="'collapse_' + group.id" class="btn"><i class="fas fa-edit"></i> Klasse bearbeiten</b-btn>

            <a class="btn"
               :href="'/groups/' + group.id"
               data-method="put"
               data-remote="true"
               data-params="group[archive]=1"
               v-on:ajax:success="success"
            >
                <i class="fas fa-file-export"></i> Klasse in Archiv verschieben
            </a>
        </div>

        <b-collapse :id="'collapse_' + group.id" class="mt-2" :visible="index == 0">
            <b-card>

                <b-form inline
                        :action="index == 0 ? '/groups' : '/groups/' + group.id"
                        accept-charset="UTF-8"
                        method="post"
                        data-remote="true"
                        v-on:ajax:success="success"
                >
                    <!-- Hidden Field für Rails/Update -->
                    <input v-if="index > 0"
                           type="hidden"
                           value="put"
                           name="_method"
                    />
                    <label class="sr-only" for="label">Klassenbezeichner</label>
                    <b-input class="mr-2"
                             id="label"
                             v-model="label"
                             name="group[label]"
                             placeholder="Klassenbezeichner"
                    />
                    <!-- Button für neue Klasse -->
                    <b-button v-if="index === 0"
                              type="submit"
                              variant="primary"
                              :disabled="label.trim().length === 0"
                    >
                        Anlegen
                    </b-button>
                    <!-- Button für existierende Klasse -->
                    <b-button v-else
                              type="submit"
                              variant="primary"
                              :disabled="label.trim().length === 0"
                              v-b-toggle="'collapse_' + group.id"
                    >
                        Ändern
                    </b-button>
                </b-form>

            </b-card>
        </b-collapse>
    </div>

</template>

<script>
    export default {
        props: {
            group: Object,
            index: Number
        },
        data: function () {
            return {
                label: this.index == 0 ? "" : this.group.label
            }
        },
        methods: {
            success(event) { //Attributwerte aus AJAX Antwort übernehmen und View updaten
                this.$emit("update:groups", {index: this.index, object: event.detail[0]});
            }
        },
        name: "group-form"
    }
</script>
