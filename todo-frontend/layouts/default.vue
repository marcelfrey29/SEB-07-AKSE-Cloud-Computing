<template>
    <div>
        <!-- Header-->
        <b-navbar type="dark" variant="primary">
            <b-navbar-brand
                v-b-toggle.mobile-navigation-sidebar
                class="cursor-hover d-md-none"
            >
                <BIconList></BIconList>
            </b-navbar-brand>
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
                            >&commat;{{ $auth.user.preferred_username }}
                        </b-dropdown-text>
                        <b-dropdown-text
                            >{{ $auth.user.email }}
                        </b-dropdown-text>
                    </b-dropdown-group>

                    <b-dropdown-divider></b-dropdown-divider>

                    <b-dropdown-header>Settings</b-dropdown-header>
                    <b-dropdown-form>
                        <b-form-checkbox switch disabled
                            >Dark Mode
                        </b-form-checkbox>
                    </b-dropdown-form>

                    <b-dropdown-divider></b-dropdown-divider>

                    <b-dropdown-header>Sign out</b-dropdown-header>
                    <b-dropdown-form>
                        <b-button
                            variant="outline-primary"
                            block
                            @click="logout"
                            >Sign out
                        </b-button>
                    </b-dropdown-form>
                </b-dropdown>
            </b-navbar-nav>
        </b-navbar>

        <!-- Mobile-Navigation -->
        <b-sidebar
            id="mobile-navigation-sidebar"
            title="Navigation"
            shadow
            backdrop
        >
            <div class="px-3 py-2">
                <ApplicationNavigationBar></ApplicationNavigationBar>
            </div>
        </b-sidebar>

        <!-- Content -->
        <b-container fluid>
            <b-row cols="1" cols-md="2" cols-lg="3">
                <!-- Left: Navigation -->
                <b-col class="d-none d-md-block" md="4" lg="3">
                    <ApplicationNavigationBar></ApplicationNavigationBar>
                </b-col>

                <!-- Middle: Main-Content -->
                <b-col cols="12" md="8" lg="6">
                    <Nuxt />
                </b-col>

                <!-- Right: -->
                <b-col class="d-none d-lg-block" lg="3"> </b-col>
            </b-row>
        </b-container>

        <!-- Footer -->
        <Footer></Footer>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import { BIconList } from 'bootstrap-vue/src/icons'
import LoggedInUser from '~/types/LoggedInUser.interface'
import ApplicationNavigationBar from '~/components/ApplicationNavigationBar.vue'

/**
 * The default layout for all application pages.
 */
@Component({
    components: { ApplicationNavigationBar, BIconList },
    middleware: 'auth.middleware',
})
export default class Default extends Vue {
    async logout(): Promise<void> {
        await this.$auth.logout()
    }

    get getAvatarName(): string {
        const unknownUser: Record<string, unknown> | null = this.$auth.user
        let name = ''
        if (unknownUser) {
            const user: LoggedInUser = unknownUser as any as LoggedInUser
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

.cursor-hover {
    cursor: pointer;
}
</style>
