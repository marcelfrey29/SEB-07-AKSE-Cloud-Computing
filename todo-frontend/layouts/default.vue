<template>
    <div>
        <b-navbar type="dark" variant="primary">
            <b-navbar-brand>Todo App</b-navbar-brand>

            <b-navbar-nav class="ml-auto">
                <b-dropdown
                    id="account-actions"
                    variant="none"
                    no-caret
                    class="account-avatar"
                    right
                >
                    <!-- Avatar -->
                    <template #button-content>
                        <b-avatar
                            variant="light"
                            :text="getAvatarName"
                        ></b-avatar>
                    </template>

                    <!-- Dropdown -->
                    <b-dropdown-group header="Account">
                        <b-dropdown-text
                            ><b>{{ $auth.user.name }}</b></b-dropdown-text
                        >
                        <b-dropdown-text
                            >&commat;{{
                                $auth.user.preferred_username
                            }}</b-dropdown-text
                        >
                        <b-dropdown-text>{{
                            $auth.user.email
                        }}</b-dropdown-text>
                    </b-dropdown-group>

                    <b-dropdown-divider></b-dropdown-divider>

                    <b-dropdown-header>Settings</b-dropdown-header>
                    <b-dropdown-form>
                        <b-form-checkbox switch disabled
                            >Dark Mode</b-form-checkbox
                        >
                    </b-dropdown-form>

                    <b-dropdown-divider></b-dropdown-divider>

                    <b-dropdown-header>Sign out</b-dropdown-header>
                    <b-dropdown-form>
                        <b-button
                            variant="outline-primary"
                            block
                            @click="logout"
                            >Sign out</b-button
                        >
                    </b-dropdown-form>
                </b-dropdown>
            </b-navbar-nav>
        </b-navbar>

        <Nuxt />

        <Footer></Footer>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import LoggedInUser from '~/types/LoggedInUser.interface'

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

    get getAvatarName(): string {
        const user: LoggedInUser | null = this.$auth.user
        let name = ''
        if (user) {
            name = '' + user.given_name[0] + '' + user.family_name[0]
        }
        return name
    }
}
</script>

<style>
.account-avatar > .btn {
    padding: 0;
}
</style>
