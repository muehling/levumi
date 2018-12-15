<template>

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
                 :value="label"
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

<style>
</style>