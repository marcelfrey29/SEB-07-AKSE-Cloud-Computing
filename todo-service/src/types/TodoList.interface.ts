import { Todo } from './Todo.interface';

/**
 * TodoList is a collection of Todos.
 */
export interface TodoList {
    owner: string;
    id: string;
    name: string;
    icon: string;
    color: string;
    todos: Todo[];
}
