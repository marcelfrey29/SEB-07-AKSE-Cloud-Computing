import { DynamoTableDefinition } from './DynamoTableDefinition';

/**
 * TodoList describes a collection of Todos.
 *
 * The 'partition' property represents the 'user id'
 * The 'sort' property represents the 'list id'
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
