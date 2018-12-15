<template>

    <b-form inline
            :action="index == 0 ? '/groups' : '/groups/' + groups[index].id"
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
        >
            Ändern
        </b-button>
    </b-form>

</template>

<script>
    export default {
        props: {
            groups: Array,
            index: Number
        },
        data: function () {
            return {
                label: this.index == 0 ? "" : this.groups[this.index].label
            }
        },
        methods: {
            update() { //Neu-Rendern der Übersicht erzwingen
                console.log(this.groups);
                this.$emit("update:groups", this.groups);
            },
            success(event) { //Klasse einfügen oder ändern und View updaten
                if (this.index === 0)
                    this.groups.splice(1, 0, event.detail[0]); //event.detail[0] enthält das Objekt der Ajax-Antwort in rails-ujs
                else
                    this.groups[this.index].label = event.detail[0].label;
                this.update();
            }
        },
        name: "group-form"
    }
</script>

<style>
</style>