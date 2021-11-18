import { DynamoTableDefinition } from './DynamoTableDefinition';

/**
 * TodoElement represents one task.
 *
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
