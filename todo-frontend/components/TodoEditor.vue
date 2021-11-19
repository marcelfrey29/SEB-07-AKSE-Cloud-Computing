<template>
    <div>
        <b-modal
            id="create-todo-modal"
            ref="create-todo-modal"
            centered
            :title="type === 'CREATE' ? 'Create a Todo' : 'Edit Todo'"
            @ok="createTodo"
            @cancel="cancelAction"
        >
            <b-form-group
                id="todo-group-name"
                label="Title:"
                label-for="todo-title"
                description="The title of the Todo."
            >
                <b-form-input
                    id="todo-title"
                    v-model="newTodoTitle"
                    type="text"
                    :placeholder="type === 'CREATE' ? 'Buy Coffee' : ' '"
                    required
                ></b-form-input>
            </b-form-group>

            <b-form-group
                id="todo-group-desc"
                label="Description:"
                label-for="todo-desc"
                description="The description of the Todo."
            >
                <b-form-input
                    id="todo-desc"
                    v-model="newTodoDescription"
                    type="text"
                    :placeholder="
                        type === 'CREATE'
                            ? 'Get some new coffee to stay productive.'
                            : ' '
                    "
                    required
                ></b-form-input>
            </b-form-group>

            <b-form-group
                id="todo-group-date"
                label="Date:"
                label-for="todo-date"
                description="The due date of the Todo."
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
                description="Mark the Todo with high priority."
            >
                <b-form-checkbox
                    id="todo-flag"
                    v-model="newTodoFlag"
                    required
                    switch
                ></b-form-checkbox>
            </b-form-group>
        </b-modal>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import { Prop, Watch } from 'vue-property-decorator'
import { Todo } from '~/types/Todo.interface'

@Component({})
export default class TodoEditor extends Vue {
    // Fields
    private newTodoTitle = ''
    private newTodoDescription = ''
    private newTodoDate = ''
    private newTodoTags: string[] = []
    private newTodoFlag = false

    // Properties
    @Prop()
    type!: 'CREATE' | 'EDIT'

    @Prop()
    existingData!: Todo

    @Watch('existingData')
    see() {
        this.cancelAction()
    }

    mounted(): void {
        this.cancelAction()
    }

    createTodo(): void {
        let todoData: Todo | Partial<Todo>
        if (this.type === 'CREATE') {
            todoData = {
                title: this.newTodoTitle,
                description: this.newTodoDescription,
                dueDate: this.newTodoDate,
                isFlagged: this.newTodoFlag,
                tags: this.newTodoTags,
                isDone: false,
            }
        } else if (this.type === 'EDIT') {
            todoData = {
                partition: this.existingData.partition,
                sort: this.existingData.sort,
                title: this.newTodoTitle,
                description: this.newTodoDescription,
                dueDate: this.newTodoDate,
                isFlagged: this.newTodoFlag,
                tags: this.newTodoTags,
                isDone: false,
                owner: this.existingData.owner,
            }
        } else {
            // eslint-disable-next-line no-console
            console.error('Undefined Type: ' + this.type)
            todoData = {}
        }

        this.$emit('send-todo', todoData)

        // Reset Dialog
        this.cancelAction()
    }

    cancelAction(): void {
        if (this.type === 'CREATE') {
            // Reset Dialog for create state: Everything empty
            this.newTodoTitle = ''
            this.newTodoDescription = ''
            this.newTodoDate = ''
            this.newTodoTags = []
            this.newTodoFlag = false
        } else if (this.type === 'EDIT') {
            if (this.existingData) {
                // Reset Dialog for edit state: Reset to current values
                this.newTodoTitle = this.existingData.title
                this.newTodoDescription = this.existingData.description
                this.newTodoDate = this.existingData.dueDate
                this.newTodoTags = this.existingData.tags
                this.newTodoFlag = this.existingData.isFlagged
            }
        } else {
            // eslint-disable-next-line no-console
            console.error('Undefined Type: ' + this.type)
        }
    }
}
</script>

<style lang="scss" scoped></style>
