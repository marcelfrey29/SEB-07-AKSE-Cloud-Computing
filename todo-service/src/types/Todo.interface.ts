/**
 *
 */
export interface Todo {
    id: string;
    title: string;
    description: string;
    due_date: string;
    isFlagged: boolean;
    tags: string[];
}
