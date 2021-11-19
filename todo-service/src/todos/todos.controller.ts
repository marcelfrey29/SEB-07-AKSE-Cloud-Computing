import {
    Body,
    Controller,
    Delete,
    Get,
    Logger,
    Param,
    Post,
    Put,
    Req,
} from '@nestjs/common';
import { TodosService } from './todos.service';
import { TodoElement } from '../types/Todo.interface';

/**
 * The controller for managing {@link TodoElement}s.
 */
@Controller('')
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
    @Get('/todos/:id')
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
    @Post('/todos/:id')
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

    /**
     * The Endpoint to edit a task to a list.
     *
     * @param request {AuthorizedRequest} the request with the user object
     * @param list {string} the unique id of the list
     * @param task {string} the unique id of the task
     * @param todoData {Partial<TodoElement>} the data
     * @return {TodoElement[]} all todos from the list
     */
    @Put('/list/:id/todo/:task')
    async editTodo(
        @Req() request: AuthorizedRequest,
        @Param('id') list: string,
        @Param('task') task: string,
        @Body() todoData: Partial<TodoElement>,
    ): Promise<TodoElement[]> {
        this.logger.log(
            'User ' +
                request.user.sub +
                ' updates the todo ' +
                task +
                ' in ' +
                list,
        );
        return await this.todosService.editTodo(
            request.user,
            list,
            task,
            todoData,
        );
    }

    /**
     * The Endpoint to delete a task from a list.
     *
     * @param request {AuthorizedRequest} the request with the user object
     * @param list {string} the unique id of the list
     * @param task {string} the unique id of the task
     * @return {TodoElement[]} all remaining todos from the list
     */
    @Delete('/list/:id/todo/:task')
    async deleteTodo(
        @Req() request: AuthorizedRequest,
        @Param('id') list: string,
        @Param('task') task: string,
    ): Promise<TodoElement[]> {
        this.logger.log(
            'User ' +
                request.user.sub +
                ' deletes the todo ' +
                task +
                ' in ' +
                list,
        );
        return await this.todosService.deleteTodo(request.user, list, task);
    }
}
