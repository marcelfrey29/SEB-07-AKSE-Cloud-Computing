import { DynamoTableDefinition } from './DynamoTableDefinition';

/**
 * TodoList describes a collection of Todos.
 *
 * @property name {string} the name of the list
 * @property icon {string} the icon of the list
 * @property color {string} the color of the list
 */
export interface TodoList extends DynamoTableDefinition {
    name: string;
    icon: string;
    color: string;
}
