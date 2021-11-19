<template>
    <b-card class="mt-3 mb-1">
        <b-container>
            <b-row>
                <b-col cols="1" class="p-0">
                    <b-checkbox
                        v-model="todoData.isDone"
                        @change="$emit('toggle-todo', todoData)"
                    ></b-checkbox>
                </b-col>
                <b-col class="p-0">
                    <b-card-title>
                        {{ todoData.title }}
                    </b-card-title>
                    <b-card-sub-title>
                        {{ todoData.description }}
                    </b-card-sub-title>
                    <p
                        v-if="todoData.dueDate && todoData.dueDate.length >= 2"
                        class="mb-0"
                    >
                        Scheduled for:
                        {{
                            new Intl.DateTimeFormat('de', {
                                weekday: 'long',
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric',
                            }).format(new Date(todoData.dueDate))
                        }}
                    </p>
                    <div>
                        <b-badge
                            v-for="tag in todoData.tags"
                            :key="'list-' + todoData.sort + 'tag-' + tag"
                            pill
                            variant="secondary"
                            class="mr-2"
                        >
                            {{ tag }}
                        </b-badge>
                    </div>
                </b-col>
                <b-col cols="1" class="p-0">
                    <div class="d-flex w-100 justify-content-center mt-1">
                        <b-dropdown
                            :id="'menu-' + todoData.sort"
                            variant="none"
                            no-caret
                            right
                        >
                            <!-- Icon -->
                            <template #button-content>
                                <BIconThreeDotsVertical
                                    scale="1.1"
                                ></BIconThreeDotsVertical>
                            </template>

                            <!-- Dropdown -->
                            <b-dropdown-item
                                @click="
                                    $refs['inline-editor'].$refs[
                                        'create-todo-modal'
                                    ].show()
                                "
                                >Edit</b-dropdown-item
                            >
                            <b-dropdown-item>Delete</b-dropdown-item>

                            <TodoEditor
                                ref="inline-editor"
                                type="EDIT"
                                :existing-data="todoData"
                                @send-todo="$emit('send-todo', $event)"
                            ></TodoEditor>
                        </b-dropdown>
                    </div>
                    <div class="d-flex w-100 justify-content-center mt-4">
                        <BIconFlagFill
                            v-if="todoData.isFlagged"
                            scale="1.2"
                        ></BIconFlagFill>
                    </div>
                </b-col>
            </b-row>
        </b-container>
    </b-card>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import { Prop } from 'vue-property-decorator'
import { BIconFlagFill, BIconThreeDotsVertical } from 'bootstrap-vue'
import { Todo } from '~/types/Todo.interface'
import TodoEditor from '~/components/TodoEditor.vue'

/**
 * The footer of the application.
 */
@Component({
    components: {
        TodoEditor,
        BIconFlagFill,
        BIconThreeDotsVertical,
    },
})
export default class TodoComponent extends Vue {
    @Prop()
    todoData!: Todo
}
</script>

<style></style>
