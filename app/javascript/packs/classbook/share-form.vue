<template>

    <div>
        <!-- eigene Klasse => Infos anzeigen und teilen erlauben-->
        <div v-if="group.owner">
            <table class='table table-sm table-striped table-responsive-md' v-if="group.shares.length > 0">
                <thead>
                <tr>
                    <th>Geteilt mit</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                    <tr v-for="share in group.shares">
                        <td>{{share.user}}</td>
                        <td>
                            <a :class="'btn btn-sm ' + (share.read_only ? 'btn-primary' : 'btn-outline-primary')"
                               :href="'/groups/' + group.id + '/group_shares/' + share.id"
                               data-method='put'
                               data-remote='true'
                               data-params='group_share[read_only]=1'
                               v-on:ajax:success="success"
                            >
                                <i class='fas fa-glasses'></i> Nur Ansicht
                            </a>
                            <a :class="'btn btn-sm ' + (!share.read_only ? 'btn-primary' : 'btn-outline-primary')"
                               :href="'/groups/' + group.id + '/group_shares/' + share.id"
                               data-method='put'
                               data-remote='true'
                               data-params='group_share[read_only]=0'
                               v-on:ajax:success="success"
                            >
                                <i class='fas fa-edit'></i> Ansicht und verwenden
                            </a>
                            <!-- rails-ujs Link beinhaltet Auth_Token-->
                            <a class='btn btn-sm btn-outline-danger'
                               :href="'/groups/' + group.id + '/group_shares/' + share.id"
                               data-method='delete'
                               data-remote='true'
                               v-on:ajax:success="success"
                            >
                                <i class='fas fa-trash'></i> Nicht mehr teilen
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
            <b-btn  v-b-toggle="'collapse_share_' + group.id" variant='outline-secondary' size='sm'><i class='fas fa-handshake'></i>Klasse teilen</b-btn>
            <b-collapse :id="'collapse_share_' + group.id" class='mt-2' :visible="false">
                <b-form inline
                        :action="'/groups/' + group.id + '/group_shares'"
                        accept-charset='UTF-8'
                        method='post'
                        data-remote='true'
                        v-on:ajax:success="success"
                        v-on:ajax:error="failure"
                >
                    <label for='email'>Teilen mit&nbsp;&nbsp;</label>
                    <div>
                        <b-input class='mr-2'
                                 id='email'
                                 name='email'
                                 placeholder='E-Mail Adresse'
                                 size='sm'
                                 :state="exists || not_found ? false : null"
                        />
                        <b-form-invalid-feedback v-if="not_found">E-Mail Adresse nicht bekannt!</b-form-invalid-feedback>
                        <b-form-invalid-feedback v-else-if="exists">Klasse bereits mit dieser E-Mail geteilt!</b-form-invalid-feedback>
                    </div>
                    <b-form-radio-group id='rights' v-model="rights_selected" :options="options_rights" name='group_share[read_only]'>
                    </b-form-radio-group>
                    <b-button
                            type='submit'
                            variant='outline-success'
                            size='sm'
                            v-on:click="not_found = false; exists = false;"
                    >
                        <i class='fas fa-check'></i> Teilen
                    </b-button>
                </b-form>
            </b-collapse>
        </div>
        <!-- geteilte Klasse => Teilung beenden -->
        <div v-else>
            <p>Klasse wurde geteilt von: {{group.belongs_to}}</p>
            <p>Sie können die Klasse {{group.read_only ? ' nur ansehen' : ' ansehen und verwenden'}}</p>
            <a class='btn btn-sm btn-outline-danger'
               :href="'/groups/' + group.id + '/group_shares/' + group.share_id"
               data-method='delete'
               data-remote='true'
               data-confirm='Damit können Sie nicht weiter auf die Klasse und ihre Messergebnisse zugreifen! Sind Sie sicher?'
               v-on:ajax:success="$parent.remove(index)"
            >
                <i class='fas fa-trash'></i> Teilen beenden
            </a>
        </div>
    </div>

</template>

<script>
    export default {
        props: {
            group: Object,
            index: Number
        },
        data: function() {
          return {
              not_found: false,
              exists: false,
              rights_selected: 1
          }
        },
        methods: {
            success(event) { //Klasse updaten und View aktualisieren
                this.$emit('update:groups', {index: this.index, object: event.detail[0]});
            },
            failure(event) {
                if (event.detail[2].status == 404)
                    this.not_found = true
                else
                    this.exists = true;
            }
        },
        beforeCreate() {
            // "Konstanten" definieren - werden für die Form-Elemente und zur Anzeige verwendet.
            this.options_rights = [
                {text: 'Nur Ansicht', value: 1, disabled: 0},
                {text: 'Ansicht und verwenden', value: 0, disabled: 0}
            ];
        },
        name: 'share-form'
    }
</script>
