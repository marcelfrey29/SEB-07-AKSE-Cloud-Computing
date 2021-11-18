import { DynamoTableDefinition } from './DynamoTableDefinition';

/**
 * TodoElement represents one task.
 *
 * The 'partition' property represents the 'list id'
 * The 'sort' property represents the 'task id'
 *
 * @property title {string} the title of the task
 * @property description {string} the description of the task
 * @property dueDate {string} the date when the task is shown as overdue
 * @property isFlagged {boolean} marks a task with high priority
 * @property tags {string[]} a list of tags for the task
 * @property isDone {boolean} marks weather the task is done
 * @property owner {string} the unique id of the user
 */
export interface TodoElement extends DynamoTableDefinition {
    title: string;
    description: string;
    dueDate: string;
    isFlagged: boolean;
    tags: string[];
    isDone: boolean;
    owner: string;
}
