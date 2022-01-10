<template>
    <div class="mt-2">
        <!-- Home -->
        <b-card-title>General</b-card-title>
        <div>
            <NuxtLink to="/" active-class="selected-list" class="list-link">
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
                :to="'/lists/' + list.sortKey.split('#')[1]"
                active-class="selected-list"
                class="list-link"
            >
                <div class="d-flex">
                    <!-- Title & Icon -->
                    <div>
                        <BIcon :icon="list.icon" :variant="list.color"></BIcon>
                        {{ list.name }}
                    </div>
                    <!-- List Options -->
                    <div
                        class="ml-auto pr-2 pl-2"
                        @click="
                            selectListToDelete(list),
                                $refs['delete-list-modal'].show()
                        "
                    >
                        <BIcon icon="trash-fill" variant="danger"></BIcon>
                    </div>
                </div>
            </NuxtLink>
        </div>

        <b-button
            variant="outline-primary"
            block
            class="mt-3"
            @click="$refs['create-list-modal'].show()"
            >Create List
        </b-button>

        <!-- Delete List Modal -->
        <b-modal
            ref="delete-list-modal"
            centered
            title="Delete the List"
            @ok="deleteList()"
        >
            <p class="m-0">Are you sure that you want to delete the List?</p>
            <p class="m0">All Todos in this list will be deleted as well.</p>

            <template #modal-footer="{ ok, cancel }">
                <b-button variant="outline-secondary" @click="cancel()">
                    Cancel
                </b-button>
                <b-button variant="danger" @click="ok()"> Delete </b-button>
            </template>
        </b-modal>

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

        <!--        <hr />-->

        <!-- More -->
        <!--        <b-card-title>More</b-card-title>-->
        <!--        <div>-->
        <!--            <NuxtLink-->
        <!--                to="/account"-->
        <!--                active-class="selected-list"-->
        <!--                class="list-link"-->
        <!--            >-->
        <!--                <BIconPersonCircle></BIconPersonCircle>-->
        <!--                Account-->
        <!--            </NuxtLink>-->
        <!--        </div>-->
        <!--        <div>-->
        <!--            <NuxtLink-->
        <!--                to="/settings"-->
        <!--                active-class="selected-list"-->
        <!--                class="list-link"-->
        <!--            >-->
        <!--                <BIconGearFill></BIconGearFill>-->
        <!--                Settings-->
        <!--            </NuxtLink>-->
        <!--        </div>-->
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
    BIconTrashFill,
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
        BIconTrashFill,
    },
})
export default class ApplicationNavigationBar extends Vue {
    private todoLists: TodoList[] = []
    private readonly BASE_URL =
        process.env.NUXT_ENV_TODO_SERVICE_URL ?? 'http://localhost:4000'

    private newListName = ''
    private newListColor = 'primary'
    private newListIcon = 'check-circle-fill'
    private listToDelete: TodoList = {
        color: '',
        icon: '',
        name: '',
        partitionKey: '',
        sortKey: '',
    }

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

    /**
     * Select a list for deletion.
     *
     * @param list {TodoList} the list to delete
     */
    selectListToDelete(list: TodoList): void {
        this.listToDelete = list
    }

    /**
     * Apply the delete operation of the selected list.
     */
    async deleteList(): Promise<void> {
        try {
            this.todoLists = await this.$axios.$delete(
                this.BASE_URL +
                    '/lists/' +
                    encodeURIComponent(this.listToDelete.sortKey.split('#')[1])
            )
            this.$bvToast.toast(
                'Successfully deleted List "' + this.listToDelete.name + '".',
                {
                    title: 'List Deleted',
                    autoHideDelay: 7500,
                    appendToast: true,
                    variant: 'success',
                    solid: true,
                }
            )
            await this.$router.push('/')
        } catch (error) {}
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
