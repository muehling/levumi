<template>
    <div id="backend-menubar">
        <b-navbar toggleable="md" type="light" variant="faded">

            <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

            <b-navbar-brand href="#"><img src="favicon.ico" alt="Levumi" width="48" height="48"/>Levumi</b-navbar-brand>

            <b-collapse is-nav id="nav_collapse" class="justify-content-between">

                <!-- Left aligned -->
                <b-navbar-nav className="ml-auto">
                    <b-nav-item href="#">Start</b-nav-item>
                </b-navbar-nav>
                <b-navbar-nav className="ml-auto">
                    <b-nav-item href="#">Klassenbuch</b-nav-item>
                </b-navbar-nav>

                <b-navbar-nav className="ml-auto">
                    <b-nav-item href="#">Material</b-nav-item>
                    <b-nav-item href="#">Testinfo</b-nav-item>
                </b-navbar-nav>

                <!-- Right aligned  -->
                <b-navbar-nav className="mr-auto">

                    <b-nav-item-dropdown text="Hilfe" right>
                        <b-dropdown-item href="#">Handbuch</b-dropdown-item>
                        <b-dropdown-item href="#">Videos</b-dropdown-item>
                        <b-dropdown-item href="#">Blog</b-dropdown-item>
                    </b-nav-item-dropdown>

                    <b-nav-item-dropdown right>
                        <template slot="button-content">
                            <em>Mein Profil</em>
                        </template>
                        <b-dropdown-item href="#">Daten ändern</b-dropdown-item>
                        <b-dropdown-item href="#">Abmelden</b-dropdown-item>
                    </b-nav-item-dropdown>

                </b-navbar-nav>

            </b-collapse>
        </b-navbar>
    </div>
</template>

<script>
export default {
    name: "backend-menubar"
}
</script>

<style>
</style>