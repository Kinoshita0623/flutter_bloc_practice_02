import 'package:flutter/material.dart';
import 'package:flutterblocpractice02/tasks.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
      MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context)=>TasksBloc(),
        dispose: (context, bloc)=>bloc.dispose(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(

              primarySwatch: Colors.blue,

              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: "/",
            routes: <String, WidgetBuilder>{
              "/" : (BuildContext context)=> TasksPage(),
              "/create" : (BuildContext context)=> Provider(
                create: (context)=>CreateTaskBloc(),
                dispose: (context, bloc)=>bloc.dispose(),
                child: CreateTaskPage()
              ),
            },
        )
    );
  }
}

class TasksPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final tasksBlockProvider = Provider.of<TasksBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("タスク一覧"),
      ),
      body: StreamBuilder(
        initialData: [],
        stream: tasksBlockProvider.tasks,
        builder: (context, snapshot){
          return ListView.builder(itemBuilder: (context, position){
            final task = snapshot.data[position];

            return Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      task.name,
                      style: Theme.of(context).textTheme.headline3
                    )
                  ],
                ),
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            );
          }, itemCount: snapshot.data.length,);
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed("/create");
        },
        child: Icon(Icons.create)
      ),

    );
  }
}

class CreateTaskPage extends StatelessWidget {

  final title = "タスクを作成";

  @override
  Widget build(BuildContext context) {

    final createTaskProvider = Provider.of<CreateTaskBloc>(context);
    final tasksBlocProvider = Provider.of<TasksBloc>(context);

    createTaskProvider.createdTask.listen((Task event) {
      if(event != null){
        tasksBlocProvider.actionCreateTask(event);
        Navigator.pop(context);

      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),

      ),
      body: Column(
        children: <Widget>[

          Container(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "タスク名"
              ),
              onChanged: (text){
                createTaskProvider.updateTitle(text);
              },

            ),
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "詳細"
              ),
              onChanged: (text){
                createTaskProvider.updateDescription(text);
              },
            ),
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:  (){
          createTaskProvider.actionCreateTask();
        },
        label: Text("保存"),
        icon: Icon(Icons.save)
      )
    );
  }

}

