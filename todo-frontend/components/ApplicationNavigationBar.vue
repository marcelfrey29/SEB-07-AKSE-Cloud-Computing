<template>
    <div class="mt-2">
        <!-- Home -->
        <b-card-title>General</b-card-title>
        <div>
            <NuxtLink
                to="/dashboard"
                active-class="selected-list"
                class="list-link"
            >
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
            <NuxtLink
                :to="'/lists/' + list.sort.split('#')[1]"
                active-class="selected-list"
                class="list-link"
            >
                <BIcon :icon="list.icon" :variant="list.color"></BIcon>
                {{ list.name }}
            </NuxtLink>
        </div>

        <b-button
            variant="outline-primary"
            block
            class="mt-3"
            @click="$refs['create-list-modal'].show()"
            >Create List
        </b-button>

        <!-- Create List Popup -->
        <b-modal
            id="create-list-modal"
            ref="create-list-modal"
            centered
            title="Create a List"
            @ok="createList"
        >
            <b-form-group
                id="list-group-name"
                label="Name:"
                label-for="list-name"
                description="The name of the new Todo-List."
            >
                <b-form-input
                    id="list-name"
                    v-model="newListName"
                    type="text"
                    placeholder="My Todos"
                    required
                ></b-form-input>
            </b-form-group>

            <b-form-group
                id="list-group-color"
                v-slot="{ ariaDescribedby }"
                label="Color:"
                label-for="list-color"
                description="The color of the new Todo-List."
            >
                <b-form-radio-group
                    id="list-color"
                    v-model="newListColor"
                    :aria-describedby="ariaDescribedby"
                    name="list-color-selection"
                >
                    <b-form-radio value="primary"
                        ><span class="text-primary">Blue</span></b-form-radio
                    >
                    <b-form-radio value="danger"
                        ><span class="text-danger">Red</span></b-form-radio
                    >
                    <b-form-radio value="warning"
                        ><span class="text-warning">Orange</span></b-form-radio
                    >
                    <b-form-radio value="success"
                        ><span class="text-success">Green</span></b-form-radio
                    >
                </b-form-radio-group>
            </b-form-group>

            <b-form-group
                id="list-group-icon"
                v-slot="{ ariaDescribedby }"
                label="Icon:"
                label-for="list-icon"
                description="The icon of the new Todo-List."
            >
                <b-form-radio-group
                    id="list-icon"
                    v-model="newListIcon"
                    :aria-describedby="ariaDescribedby"
                    name="list-icon-selection"
                >
                    <b-form-radio value="check-circle-fill"
                        ><span><BIconCheckCircleFill /></span
                    ></b-form-radio>
                    <b-form-radio value="briefcase-fill"
                        ><span><BIconBriefcaseFill /></span
                    ></b-form-radio>
                    <b-form-radio value="terminal-fill"
                        ><span><BIconTerminalFill /></span
                    ></b-form-radio>
                    <b-form-radio value="person-fill"
                        ><span><BIconPersonCircle /></span
                    ></b-form-radio>
                </b-form-radio-group>
            </b-form-group>
        </b-modal>

        <hr />

        <!-- More -->
        <b-card-title>More</b-card-title>
        <div>
            <NuxtLink
                to="/account"
                active-class="selected-list"
                class="list-link"
            >
                <BIconPersonCircle></BIconPersonCircle>
                Account
            </NuxtLink>
        </div>
        <div>
            <NuxtLink
                to="/settings"
                active-class="selected-list"
                class="list-link"
            >
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
    BIcon,
    BIconGearFill,
    BIconGridFill,
    BIconPersonCircle,
    BIconTerminalFill,
    BIconPersonFill,
    BIconBriefcaseFill,
    BIconCheckCircleFill,
} from 'bootstrap-vue/src/icons'
import { TodoList } from '~/types/TodoList.interface'

/**
 * The navigation bar of the application.
 */
@Component({
    components: {
        BIcon,
        BIconGearFill,
        BIconGridFill,
        BIconPersonCircle,
        BIconTerminalFill,
        BIconPersonFill,
        BIconBriefcaseFill,
        BIconCheckCircleFill,
    },
})
export default class ApplicationNavigationBar extends Vue {
    private todoLists: TodoList[] = []
    private readonly BASE_URL =
        process.env.NUXT_ENV_TODO_SERVICE_URL ?? 'http://localhost:4000'

    private newListName = ''
    private newListColor = 'primary'
    private newListIcon = 'check-circle-fill'

    async mounted(): Promise<void> {
        try {
            this.todoLists = await this.$axios.$get(this.BASE_URL + '/lists')
        } catch (error) {}
    }

    async createList(): Promise<void> {
        const listData: Partial<TodoList> = {
            name: this.newListName,
            color: this.newListColor,
            icon: this.newListIcon,
        }
        try {
            this.todoLists = await this.$axios.$post(
                this.BASE_URL + '/lists',
                listData
            )
        } catch (error) {}

        // Reset Dialog
        this.newListName = ''
        this.newListColor = 'primary'
        this.newListIcon = 'check-circle-fill'
    }
}
</script>

<style>
a {
    color: black;
}

a:hover {
    text-decoration: none;
    color: dodgerblue;
}

.selected-list {
    font-weight: bold;
    background-color: #dddddd !important;
}

.list-link {
    background-color: #eeeeee;
    border-radius: 5px;
    display: block;
    margin: 5px 0;
    padding: 5px;
}
</style>
