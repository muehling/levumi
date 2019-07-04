<template>
    <div v-if="full">
        <p class='text-light bg-secondary'>&nbsp;Beschreibung</p>
        <div v-html="material.description.full">
        </div>
        <br/>
        <p class='text-light bg-secondary'>&nbsp;Benutzungshinweise</p>
        <div v-html="material.description.usage">
        </div>
        <br/>
        <p class='text-light bg-secondary'>&nbsp;Material</p>
            <ul>
                <li v-for="(f, i) in material.files" :key="i"><a :href="f.path" target='_blank'>{{f.name}}</a></li>
            </ul>
    </div>
    <div v-else>
        <p class='text-light bg-secondary'>&nbsp;Beschreibung</p>
        <div v-html="material.description.short">
        </div>
        <br/>
        <p class='text-light bg-secondary'>&nbsp;Material</p>
        <ul>
            <li v-for="(f, i) in material.files" :key="i"><a :href="f.path" target='_blank'>{{f.name}}</a></li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "material-view",
        props: {
            material: Object,
            full: Boolean
        }
    }
</script>
