import { Module } from '@nestjs/common';
import { ListController } from './list.controller';
import { ListService } from './list.service';
import { DynamodbModule } from '../dynamodb/dynamodb.module';
import { TodosModule } from '../todos/todos.module';

@Module({
    imports: [DynamodbModule, TodosModule],
    controllers: [ListController],
    providers: [ListService],
})
export class ListModule {}
