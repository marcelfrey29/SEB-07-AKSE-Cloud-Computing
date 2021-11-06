<template>
    <div>
        About the Todo App
        <div v-if="!$auth.loggedIn">
            <b-button variant="primary" @click="login">Login</b-button>
        </div>
        <hr />
        <Nuxt />
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
