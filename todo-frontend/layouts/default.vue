<template>
    <div>
        Todo App
        <div v-if="$auth.loggedIn">
            <b-button variant="primary" @click="logout">Logout</b-button>
        </div>
        <hr />
        <Nuxt />
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

/**
 * The default layout for all application pages.
 */
@Component({
    middleware: 'auth.middleware',
})
export default class Default extends Vue {
    async logout(): Promise<void> {
        await this.$auth.logout()
    }
}
</script>
