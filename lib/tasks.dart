import 'dart:async';

class Task{

  Task({this.name, this.description});

  String name;
  String description;
  bool isComplete = false;
}

class TasksBloc{

  var _tasks = List<Task>();

  final _actionCreateTaskController = StreamController<Task>();

  final _actionCompleteTaskController = StreamController<Task>();
  
  final _tasksController = StreamController<List<Task>>();

  Stream<List<Task>> get tasks => _tasksController.stream;


  
  TasksBloc(){
    _actionCompleteTaskController.stream.listen((Task event) {
      event.isComplete = true;
      _tasksController.add(_tasks);
    });
    _actionCreateTaskController.stream.listen((Task event) {
      _tasks.add(event);
      _tasksController.add(_tasks);
    });


  }

  void actionCreateTask(Task task){
    _actionCreateTaskController.add(task);
  }

  void actionCompleteTask(Task task){
    _actionCompleteTaskController.add(task);
  }

  void dispose(){
    _actionCreateTaskController.close();
    _actionCompleteTaskController.close();
    _tasksController.close();
  }
}


class CreateTaskBloc{

  final _nameController = StreamController<String>();
  final _descriptionController = StreamController<String>();
  final _taskCreatedController = StreamController<Task>();

  String _name = "";
  String _description = "";

  Stream<Task> get createdTask => _taskCreatedController.stream;
  Stream<String> get name => _nameController.stream;
  Stream<String> get description => _descriptionController.stream;


  CreateTaskBloc(){
    _nameController.stream.listen((String event) {
      if(event == null){
        _name = "";
        _nameController.addError("一文字以上入力する必要があります");
      }else{
        _name = event;
      }
    });

    _descriptionController.stream.listen((String event) {
      if(event == null){
        _description = "";
      }else{
        _description = event;
      }
    });

  }

  void updateTitle(String text){
    _nameController.add(text);
  }

  void updateDescription(String text){
    _descriptionController.add(text);
  }

  void actionCreateTask(){
    if(_name == null || _name.isEmpty){
      _taskCreatedController.addError("入力に不備があります");
      return;
    }

    final description = _description == null ? "" : _description;

    final newTask = Task(
      name: _name,
      description: description
    );
    _taskCreatedController.add(newTask);


  }


  void dispose(){

    _nameController.close();
    _descriptionController.close();
    _taskCreatedController.close();
  }
}