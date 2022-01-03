<template>
    <div>
        <!-- Header-->
        <b-navbar type="dark" variant="primary">
            <b-navbar-brand
                v-if="$store.state.auth.loggedIn"
                v-b-toggle.mobile-navigation-sidebar
                class="cursor-hover d-md-none"
            >
                <BIconList></BIconList>
            </b-navbar-brand>
            <b-navbar-brand>Todo App</b-navbar-brand>

            <!-- Authenticated NavBar -->
            <b-navbar-nav v-if="$store.state.auth.loggedIn" class="ml-auto">
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

            <!-- Login -->
            <b-navbar-nav v-else class="ml-auto">
                <b-button variant="light" @click="login">Sign in</b-button>
            </b-navbar-nav>
        </b-navbar>

        <!-- Mobile-Navigation -->
        <b-sidebar
            v-if="$store.state.auth.loggedIn"
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
        <b-container v-if="$store.state.auth.loggedIn" fluid>
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
                <b-col class="d-none d-lg-block" lg="3"></b-col>
            </b-row>
        </b-container>

        <b-container v-else>
            <b-row>
                <b-col>
                    <Marketing></Marketing>
                </b-col>
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
import Marketing from '~/components/marketing.vue'

/**
 * The default layout for all application pages.
 */
@Component({
    components: { Marketing, ApplicationNavigationBar, BIconList },
})
export default class Default extends Vue {
    mounted(): void {
        if (this.$route.path === '/login') {
            setTimeout(() => {
                this.$router.push('/')
                setTimeout(() => {
                    location.reload()
                }, 250)
            }, 250)
        }
    }

    async login(): Promise<void> {
        await this.$auth.loginWith('keycloak')
    }

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
