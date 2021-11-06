<template>
    <b-container>
        <b-row class="mt-4">
            <b-col>
                <h2>Get Things Done!</h2>
                <h3>With the Todo App</h3>
                <b-button variant="warning" @click="login"
                    >Start Getting Things Done!</b-button
                >
            </b-col>
        </b-row>

        <b-row cols="1" cols-md="2" cols-lg="3">
            <b-col>
                <b-card class="mt-5">Feature #1</b-card>
            </b-col>
            <b-col>
                <b-card class="mt-5">Feature #2</b-card>
            </b-col>
            <b-col>
                <b-card class="mt-5">Feature #3</b-card>
            </b-col>
        </b-row>

        <b-row class="mt-4">
            <b-col>
                <h2>Start getting productive</h2>
                <b-button variant="warning" @click="login"
                    >Sign in or Register</b-button
                >
            </b-col>
        </b-row>
    </b-container>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

@Component({
    layout: 'about',
})
export default class About extends Vue {
    async login(): Promise<void> {
        await this.$auth.loginWith('keycloak')
    }
}
</script>
