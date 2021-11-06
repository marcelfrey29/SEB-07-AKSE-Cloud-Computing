<template>
    <div class="">
        <div class="pt-4 pb-4"></div>
        <div class="bg-dark text-light app-footer">
            <b-container fluid>
                <b-row>
                    <b-col>
                        &copy; {{ new Date().getFullYear() }}
                        <span class="ml-1 mr-1">&CenterDot;</span>
                        Marcel Frey
                    </b-col>
                    <b-col class="mr-0">
                        <div class="d-flex">
                            <div class="ml-auto"></div>
                            <NuxtLink class="text-light" to="/about/imprint"
                                >Imprint</NuxtLink
                            >
                            <span class="ml-1 mr-1">&CenterDot;</span>
                            <NuxtLink class="text-light" to="/about/privacy"
                                >Privacy</NuxtLink
                            >
                        </div>
                    </b-col>
                </b-row>
            </b-container>
        </div>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

/**
 * The footer of the application.
 */
@Component({})
export default class Footer extends Vue {}
</script>

<style>
.app-footer {
    position: fixed;
    bottom: 0;
    width: 100%;
    font-size: 0.9rem;
}
</style>
