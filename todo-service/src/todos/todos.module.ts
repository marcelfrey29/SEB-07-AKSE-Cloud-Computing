import { Module } from '@nestjs/common';
import { TodosService } from './todos.service';
import { TodosController } from './todos.controller';
import { DynamodbModule } from '../dynamodb/dynamodb.module';

@Module({
    imports: [DynamodbModule],
    providers: [TodosService],
    controllers: [TodosController],
})
export class TodosModule {}
