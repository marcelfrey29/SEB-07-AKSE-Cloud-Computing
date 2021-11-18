import {
    Body,
    Controller,
    Get,
    Logger,
    Param,
    Post,
    Req,
} from '@nestjs/common';
import { TodosService } from './todos.service';
import { TodoElement } from '../types/Todo.interface';

/**
 * The controller for managing {@link TodoElement}s.
 */
@Controller('/todos')
export class TodosController {
    private readonly logger = new Logger(TodosController.name);

    constructor(private todosService: TodosService) {}

    /**
     * The Endpoint to retrieve all todos from a list.
     *
     * @param request {AuthorizedRequest} the request with the user object
     * @param list {string} the unique id of the list
     * @return {TodoElement[]} all todos from the list
     */
    @Get('/:id')
    async getTodos(
        @Req() request: AuthorizedRequest,
        @Param('id') list: string,
    ): Promise<TodoElement[]> {
        this.logger.log(
            'User ' +
                request.user.sub +
                ' requested all todos of the list ' +
                list,
        );
        return await this.todosService.getTodos(request.user, list);
    }

    /**
     * The Endpoint to add a new todos to a list.
     *
     * @param request {AuthorizedRequest} the request with the user object
     * @param list {string} the unique id of the list
     * @param todoData {Partial<TodoElement>} the data
     * @return {TodoElement[]} all todos from the list
     */
    @Post('/:id')
    async addTodo(
        @Req() request: AuthorizedRequest,
        @Param('id') list: string,
        @Body() todoData: Partial<TodoElement>,
    ): Promise<TodoElement[]> {
        this.logger.log(
            'User ' + request.user.sub + '  creates a new todo in ' + list,
        );
        return await this.todosService.addTodo(request.user, list, todoData);
    }
}
