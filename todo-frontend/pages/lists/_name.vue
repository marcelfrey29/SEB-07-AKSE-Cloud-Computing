<template>
    <div>
        <b-container fluid>
            <b-row v-if="todos.length > 0">
                <b-col class="p-0">
                    <div v-for="todo in todos" :key="'todo-' + todo.sortKey">
                        <TodoComponent
                            :todo-data="todo"
                            @send-todo="editTodo($event)"
                            @toggle-todo="toggleTodo($event)"
                            @delete-todo="deleteTodo($event)"
                        ></TodoComponent>
                    </div>
                </b-col>
            </b-row>
            <b-row v-else>
                <b-col class="p-0">
                    <b-card-sub-title class="mt-3">
                        You don't have any todos in this list. Create a new todo
                        by clicking the button below.
                    </b-card-sub-title>
                </b-col>
            </b-row>
            <b-row>
                <b-col class="p-0">
                    <b-button
                        variant="primary"
                        class="mt-2"
                        @click="
                            $refs['inline-editor'].$refs[
                                'create-todo-modal'
                            ].show()
                        "
                        >Create Todo
                    </b-button>

                    <!-- Create List Popup -->
                    <TodoEditor
                        ref="inline-editor"
                        type="CREATE"
                        @send-todo="createTodo($event)"
                    ></TodoEditor>
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
import TodoEditor from '~/components/TodoEditor.vue'

@Component({
    components: { TodoEditor, TodoComponent },
})
export default class List extends Vue {
    private listId = ''

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

    async createTodo(todoData: Partial<Todo>): Promise<void> {
        try {
            this.todos = await this.$axios.$post(
                this.BASE_URL + '/todos/' + this.listId,
                todoData
            )
            this.$bvToast.toast(
                'Your Todo "' + todoData.title + '" was created.',
                {
                    title: 'Todo Created',
                    autoHideDelay: 7500,
                    appendToast: true,
                    variant: 'success',
                    solid: true,
                }
            )
        } catch (error) {}
    }

    async editTodo(todoData: Partial<Todo>): Promise<void> {
        try {
            this.todos = await this.$axios.$put(
                this.BASE_URL +
                    '/list/' +
                    this.listId +
                    '/todo/' +
                    todoData.sortKey?.split('#')[1],
                todoData
            )
            this.$bvToast.toast(
                'Your Todo "' + todoData.title + '" was updated.',
                {
                    title: 'Todo Updated',
                    autoHideDelay: 7500,
                    appendToast: true,
                    variant: 'success',
                    solid: true,
                }
            )
        } catch (error) {}
    }

    async toggleTodo(todoData: Partial<Todo>): Promise<void> {
        todoData.isDone = !todoData.isDone
        try {
            this.todos = await this.$axios.$put(
                this.BASE_URL +
                    '/list/' +
                    this.listId +
                    '/todo/' +
                    todoData.sortKey?.split('#')[1],
                todoData
            )
            this.$bvToast.toast(
                'Your Todo "' +
                    todoData.title +
                    '" was marked as ' +
                    (todoData.isDone ? '"Done"' : '"Not Done"') +
                    '.',
                {
                    title: 'Todo: ' + (todoData.isDone ? 'Done' : 'Not Done'),
                    autoHideDelay: 7500,
                    appendToast: true,
                    variant: 'success',
                    solid: true,
                }
            )
        } catch (error) {}
    }

    async deleteTodo(todoData: Partial<Todo>): Promise<void> {
        try {
            this.todos = await this.$axios.$delete(
                this.BASE_URL +
                    '/list/' +
                    this.listId +
                    '/todo/' +
                    todoData.sortKey?.split('#')[1]
            )
            this.$bvToast.toast(
                'Your Todo "' + todoData.title + '" was deleted.',
                {
                    title: 'Todo Deleted',
                    autoHideDelay: 7500,
                    appendToast: true,
                    variant: 'success',
                    solid: true,
                }
            )
        } catch (error) {}
    }
}
</script>
