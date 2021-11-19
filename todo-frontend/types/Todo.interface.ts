/**
 *
 */
export interface Todo {
    partitionKey: string
    sortKey: string
    title: string
    description: string
    dueDate: string
    isFlagged: boolean
    tags: string[]
    isDone: boolean
    owner: string
}
