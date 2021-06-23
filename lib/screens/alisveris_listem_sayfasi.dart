import 'package:alisverislistem/helpers/database_helpers.dart';
import 'package:alisverislistem/models/task_model.dart';
import 'package:alisverislistem/screens/add_task_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlisverisListemSayfasi extends StatefulWidget {
  @override
  _AlisverisListemSayfasiState createState() => _AlisverisListemSayfasiState();
}

class _AlisverisListemSayfasiState extends State<AlisverisListemSayfasi> {

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState(){
    super.initState();
    _updateTaskList();
  }

  _updateTaskList(){
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }





  Widget _buildTask(Task task){
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(task.title, style: TextStyle(fontSize:15.0 ,decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough),

          ),
            subtitle: Text('${_dateFormatter.format(task.date)} * ${task.priority}', style: TextStyle(
              fontSize: 15.0,
              decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough,
            ),
            ),
            trailing: Checkbox(onChanged: (value){
              task.status = value ? 1 : 0;
              DatabaseHelper.instance.updateTask(task);
              _updateTaskList();
            },
              activeColor: Theme.of(context).accentColor,
              value: task.status == 1 ? true:false,
            ),
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>AddTaskScreen(
              updateTaskList: _updateTaskList,
              task: task,

                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),

    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Alışveriş Listem'),

      ),

      floatingActionButton: FloatingActionButton  (
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_)=>AddTaskScreen(
                updateTaskList: _updateTaskList,
              ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int completedTaskCount = snapshot.data.where((Task task)=>task.status == 1).toList().length;


          return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          itemCount: 1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
          if(index == 0){
          // ignore: missing_return
          return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Text("Alıncaklar", style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 30.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          SizedBox(height: 10.0),
          Text('$completedTaskCount of ${snapshot.data.length}', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 15.0, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
          ],
          ),
          );
          }
          return _buildTask(snapshot.data[index - 1]);
          },


          );

        },
      ),


    );
  }
}
