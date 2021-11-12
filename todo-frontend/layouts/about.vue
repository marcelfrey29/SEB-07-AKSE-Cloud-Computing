<template>
    <div>
        <b-navbar type="dark" variant="primary">
            <b-navbar-brand>Todo App</b-navbar-brand>

            <b-navbar-nav v-if="!$auth.loggedIn" class="ml-auto">
                <b-button variant="light" @click="login">Sign in</b-button>
            </b-navbar-nav>

            <b-navbar-nav v-else class="ml-auto">
                <b-button variant="light" @click="$router.push('/dashboard')"
                    >Open Application</b-button
                >
            </b-navbar-nav>
        </b-navbar>

        <b-container>
            <b-row>
                <b-col>
                    <Nuxt />
                </b-col>
            </b-row>
        </b-container>

        <Footer></Footer>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

/**
 * The layout for all marketing pages of the application.
 */
@Component({})
export default class About extends Vue {
    async login(): Promise<void> {
        await this.$auth.loginWith('keycloak')
    }
}
</script>
