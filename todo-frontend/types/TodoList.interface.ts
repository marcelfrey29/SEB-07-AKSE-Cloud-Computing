/**
 * TodoList is a collection of Todos.

 * @property partitionKey {string} the id of the user
 * @property sortKey {string} the id of the list
 * @property name {string} the name of the list
 * @property icon {string} the icon of the list
 * @property color {string} the color of the list
 */
export interface TodoList {
    partitionKey: string
    sortKey: string
    name: string
    icon: string
    color: string
}
