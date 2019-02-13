<template>

    <div>
        <!-- index > 0 => Klasse umbenennen / Ins Archiv verschieben-->
        <div v-if="index > 0">
            <b-btn  v-if="!group.demo" v-b-toggle="'collapse_' + group.id" variant='outline-secondary' size='sm'><i class='fas fa-edit'></i>Klasse umbenennen</b-btn>

            <a class='btn btn-sm btn-outline-primary'
               :href="'/groups/' + group.id"
               data-method='put'
               data-remote='true'
               data-params='group[archive]=1'
               v-on:ajax:success="success"
            >
                <i class='fas fa-file-export'></i> Klasse in Archiv verschieben
            </a>
        </div>
        <!-- Ausklappbare Edit-Form - falls index == 0, direkt anzeigen -->
        <b-collapse :id="'collapse_' + group.id" class='mt-2' :visible="index == 0" v-if="!group.demo">

                <b-form inline
                        :action="index == 0 ? '/groups' : '/groups/' + group.id"
                        accept-charset='UTF-8'
                        method='post'
                        data-remote='true'
                        v-on:ajax:success="success"
                >
                    <!-- Hidden Field für Rails/Update, damit POST/PUT unterschieden wird -->
                    <input v-if="index > 0"
                           type='hidden'
                           value='put'
                           name='_method'
                    />
                    <label class='sr-only' for='label'>Klassenbezeichner</label>
                    <b-input class='mr-2'
                             id='label'
                             v-model="label"
                             name='group[label]'
                             placeholder='Klassenbezeichner'
                             size='sm'
                    />
                    <div v-if="index === 0">
                        <!-- Button für neue Klasse, Validierung Name nicht leer -->
                        <b-button
                                type='submit'
                                variant='outline-success'
                                size='sm'
                                :disabled="label.trim().length === 0"
                        >
                            <i class='fas fa-plus'></i> Anlegen
                        </b-button>
                    </div>
                    <div v-else>
                        <!-- Button für existierende Klasse Validierung Name nicht leer  -->
                        <b-button type='submit'
                                  variant='outline-success'
                                  size='sm'
                                  title='Speichern'
                                  :disabled="label.trim().length === 0"
                                  v-b-toggle="'collapse_' + group.id"
                        >
                            <i class='fas fa-check'></i>
                        </b-button>
                        <b-button v-b-toggle="'collapse_' + group.id" variant='outline-dark' size='sm' title='Abbrechen'><i class='fas fa-times'></i></b-button>
                    </div>
                </b-form>

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
                label: this.index == 0 ? '' : this.group.label
            }
        },
        methods: {
            success(event) { //Attributwerte aus AJAX Antwort übernehmen und View updaten
                this.$emit('update:groups', {index: this.index, object: event.detail[0]});
            }
        },
        name: 'group-form'
    }
</script>
