import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bloc/bloc.dart';
import 'package:todoapp/src/bloc_implementation/todo_add_edit_bloc_impl.dart';
import 'package:todoapp/src/repository_impl/todo_repository_impl.dart';
import 'package:todoapp/src/base/base_bloc_component.dart';
import 'package:tuple/tuple.dart';

@Component(
  selector: 'todo-detail',
  templateUrl: 'todo_detail.html',
  directives: [
    coreDirectives,
    formDirectives,
    MaterialButtonComponent,
    MaterialSpinnerComponent,
    materialInputDirectives,
    BaseBlocComponent,
  ],
  providers: [
    overlayBindings,
    ClassProvider(ToDoRepository, useClass: ToDoRepositoryImpl),
    ClassProvider(TodoAddEditBloc, useClass: TodoAddEditBlocImpl),
    ExistingProvider(BaseBloc, TodoAddEditBloc)
  ],
  pipes: [commonPipes],
)

class TodoDetailComponent implements OnDestroy, AfterChanges {

  @Input()
  String todoId;

  @Output()
  Stream<bool> closeDetailStream;

  TodoAddEditBloc todoAddEditBloc;

  String titleStr = "Title";
  String descriptionStr = "Description";
  String titleErrString = "Title required!";
  String descriptionErrString = "Description required!";
  String saveStr = "Save";
  String todoTitle = "";
  String todoDescription = "";

  TodoDetailComponent(this.todoAddEditBloc){
    closeDetailStream =  todoAddEditBloc.closeDetailStream;
    todoAddEditBloc.todoStream.listen((todo){
      todoTitle = todo.title;
      todoDescription = todo.description;
    });
  }

  void addUpdate(String title, String description){
    todoAddEditBloc.titleDescrSink.add(Tuple2(title, description));
  }

  @override
  void ngAfterChanges() {
    todoAddEditBloc.todoIdSink.add(todoId);
  }

  @override
  void ngOnDestroy() {
    todoAddEditBloc.dispose();
  }
}