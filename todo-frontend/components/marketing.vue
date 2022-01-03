<template>
    <b-container>
        <b-row class="mt-5">
            <b-col>
                <h2>Get Things Done...</h2>
                <h2 style="padding-left: 31px">
                    ...with the <span class="text-primary">Todo App</span>!
                </h2>
                <b-button class="mt-3" variant="warning" @click="login"
                    >Login or Register
                </b-button>
            </b-col>
        </b-row>

        <b-row class="mt-1">
            <b-col>
                <b-card-group deck>
                    <b-card
                        class="mt-5"
                        title="Lists"
                        sub-title="Organize your Todos with Lists."
                        img-src="/lists.png"
                        img-top
                    ></b-card>

                    <b-card
                        class="mt-5"
                        title="Powerful organization"
                        sub-title="Add a description, a due date and tags to your todos."
                        img-src="/todos.png"
                        img-top
                    ></b-card>

                    <b-card
                        class="mt-5"
                        title="Tags"
                        sub-title="Tag your todos."
                        img-src="/tags.png"
                        img-top
                    ></b-card>
                </b-card-group>
            </b-col>
        </b-row>

        <b-row class="mt-5 mb-4">
            <b-col>
                <h4>Sounds good?</h4>
                <h4>Then get started now!</h4>
                <b-button variant="warning" @click="login"
                    >Login or Register
                </b-button>
            </b-col>
        </b-row>
    </b-container>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

@Component({})
export default class Marketing extends Vue {
    async login(): Promise<void> {
        await this.$auth.loginWith('keycloak')
    }
}
</script>
