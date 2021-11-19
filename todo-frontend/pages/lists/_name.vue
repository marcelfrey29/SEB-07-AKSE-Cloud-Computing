<template>
    <div>
        <b-container fluid>
            <b-row>
                <b-col class="p-0">
                    <div v-for="todo in todos" :key="'todo-' + todo.sort">
                        <TodoComponent :todo-data="todo" @send-todo="editTodo($event)"></TodoComponent>
                    </div>
                </b-col>
            </b-row>
            <b-row>
                <b-col class="p-0">
                    <b-button
                        variant="primary"
                        class="mt-2"
                        @click="$refs['inline-editor'].$refs['create-todo-modal'].show()"
                        >Create Todo</b-button
                    >

                    <!-- Create List Popup -->
                    <TodoEditor ref="inline-editor" type="CREATE" @send-todo="createTodo($event)"></TodoEditor>
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
import TodoEditor from "~/components/TodoEditor.vue";

@Component({
    components: {TodoEditor, TodoComponent },
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
        } catch (error) {}
    }

    async editTodo(todoData: Partial<Todo>): Promise<void> {
        try {
            this.todos = await this.$axios.$post(
                this.BASE_URL + '/todos/' + this.listId + '/' + todoData.sort,
                todoData
            )
        } catch (error) {}
    }
}
</script>
