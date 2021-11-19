/**
 *
 */
export interface Todo {
    partition: string
    sort: string
    title: string
    description: string
    dueDate: string
    isFlagged: boolean
    tags: string[]
    isDone: boolean
    owner: string
}
