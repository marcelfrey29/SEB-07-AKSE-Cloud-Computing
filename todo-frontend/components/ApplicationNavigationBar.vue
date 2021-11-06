<template>
    <div class="mt-2">
        <!-- Home -->
        <b-card-title>General</b-card-title>
        <div>
            <NuxtLink to="/dashboard">
                <BIconGridFill></BIconGridFill>
                Dashboard
            </NuxtLink>
        </div>

        <hr />

        <!-- Lists -->
        <b-card-title>Lists</b-card-title>

        <b-card-sub-title v-if="todoLists.length <= 0" class="mt-3">
            You don't have a list yet. Create a new list by clicking the button.
        </b-card-sub-title>

        <div v-for="(list, index) in todoLists" :key="'list-' + index">
            <NuxtLink :to="'/list/' + list.name">
                <BIcon :icon="list.icon"></BIcon>
                {{ list.name }}
            </NuxtLink>
        </div>
        <b-button variant="outline-primary" block class="mt-3"
            >Create List</b-button
        >

        <hr />

        <!-- More -->
        <b-card-title>More</b-card-title>
        <div>
            <NuxtLink to="/account">
                <BIconPersonCircle></BIconPersonCircle>
                Account
            </NuxtLink>
        </div>
        <div>
            <NuxtLink to="/settings">
                <BIconGearFill></BIconGearFill>
                Settings
            </NuxtLink>
        </div>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import {
    BIconGearFill,
    BIconGridFill,
    BIconPersonCircle,
} from 'bootstrap-vue/src/icons'
import { TodoList } from '~/types/TodoList.interface'

/**
 * The navigation bar of the application.
 */
@Component({
    components: {
        BIconGearFill,
        BIconGridFill,
        BIconPersonCircle,
    },
})
export default class ApplicationNavigationBar extends Vue {
    private todoLists: TodoList[] = []
}
</script>

<style></style>
