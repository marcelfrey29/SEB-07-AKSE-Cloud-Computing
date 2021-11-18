<template>
    <div>
        <b-container fluid>
            <b-row>
                <b-col class="p-0">
                    <div v-for="todo in todos" :key="'todo-' + todo.sort">
                        <TodoComponent :todo-data="todo"></TodoComponent>
                    </div>
                </b-col>
            </b-row>
            <b-row>
                <b-col class="p-0">
                    <b-button
                        v-b-modal:create-todo-modal
                        variant="primary"
                        class="mt-2"
                        >Create Todo</b-button
                    >

                    <!-- Create List Popup -->
                    <b-modal
                        id="create-todo-modal"
                        ref="create-todo-modal"
                        centered
                        title="Create a Todo"
                        @ok="createTodo"
                    >
                        <b-form-group
                            id="todo-group-name"
                            label="Title:"
                            label-for="todo-title"
                            description="The title of the new Todo."
                        >
                            <b-form-input
                                id="todo-title"
                                v-model="newTodoTitle"
                                type="text"
                                placeholder="Buy Coffee"
                                required
                            ></b-form-input>
                        </b-form-group>

                        <b-form-group
                            id="todo-group-desc"
                            label="Description:"
                            label-for="todo-desc"
                            description="The description of the new Todo."
                        >
                            <b-form-input
                                id="todo-desc"
                                v-model="newTodoDescription"
                                type="text"
                                placeholder="Get some new coffee to stay productive."
                                required
                            ></b-form-input>
                        </b-form-group>

                        <b-form-group
                            id="todo-group-date"
                            label="Date:"
                            label-for="todo-date"
                            description="The due date of the new Todo."
                        >
                            <b-form-datepicker
                                id="todo-date"
                                v-model="newTodoDate"
                                required
                            ></b-form-datepicker>
                        </b-form-group>

                        <b-form-group
                            id="todo-group-tags"
                            label="Tags:"
                            label-for="todo-tags"
                            description="Add tags to your Todo."
                        >
                            <b-form-tags
                                id="todo-tags"
                                v-model="newTodoTags"
                                required
                            ></b-form-tags>
                        </b-form-group>

                        <b-form-group
                            id="todo-group-flag"
                            label="Flag:"
                            label-for="todo-flag"
                            description="Mark the new Todo with high priority."
                        >
                            <b-form-checkbox
                                id="todo-flag"
                                v-model="newTodoFlag"
                                required
                                switch
                            ></b-form-checkbox>
                        </b-form-group>
                    </b-modal>
                </b-col>
            </b-row>
        </b-container>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import { Todo } from '~/types/Todo.interface'
import TodoComponent from '~/components/todoComponent.vue'

@Component({
    components: { TodoComponent },
})
export default class List extends Vue {
    private listId = ''
    private newTodoTitle = ''
    private newTodoDescription = ''
    private newTodoDate = ''
    private newTodoTags: string[] = []
    private newTodoFlag = false

    private todos: Todo[] = []

    private readonly BASE_URL =
        process.env.NUXT_ENV_TODO_SERVICE_URL ?? 'http://localhost:4000'

    async mounted(): Promise<void> {
        this.listId = this.$route.params.name

        try {
            this.todos = await this.$axios.$get(
                this.BASE_URL + '/todos/' + this.listId
            )
        } catch (error) {}
    }

    async createTodo(): Promise<void> {
        const todoData: Partial<Todo> = {
            title: this.newTodoTitle,
            description: this.newTodoDescription,
            dueDate: this.newTodoDate,
            isFlagged: this.newTodoFlag,
            tags: this.newTodoTags,
            isDone: false,
        }
        try {
            this.todos = await this.$axios.$post(
                this.BASE_URL + '/todos/' + this.listId,
                todoData
            )
        } catch (error) {}

        // Reset Dialog
        this.newTodoTitle = ''
        this.newTodoDescription = ''
        this.newTodoDate = ''
        this.newTodoTags = []
        this.newTodoFlag = false
    }
}
</script>
