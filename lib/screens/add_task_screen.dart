import 'package:alisverislistem/helpers/database_helpers.dart';
import 'package:alisverislistem/models/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {

  final Function updateTaskList;

  final Task task;
  AddTaskScreen({this.updateTaskList,this.task});


  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title ='';
  String _priority;
  DateTime _date=DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Düşük', 'Orta', 'Yüksek'];

  @override
  void initState(){
    super.initState();

    if(widget.task != null){
      _title = widget.task.title;
      _date = widget.task.date;
      _priority = widget.task.priority;
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }


  _handleDatePicker()async{
    final DateTime date = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000),lastDate: DateTime(2100));
    if(date != null && date != _date){
      setState(() {
        _date=date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }





  _delete(){
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }







  _sumbit(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      print('$_title, $_date, $_priority');
      Task task = Task(title: _title, date: _date, priority: _priority);
      if(widget.task == null){
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);

      }else{
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }


      widget.updateTaskList();

      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: ()=>Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, size: 30.0,color: Theme.of(context).accentColor,),

                ),
                SizedBox(height: 20.0,),
                Text(widget.task == null ? 'Eylüş alacaklarını yaz' : 'Eylüş alacaklarını güncelle veya sil',  style: widget.task == null ? TextStyle(color: Colors.black, fontSize: 30.0,fontWeight: FontWeight.bold):TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold) ,),
                SizedBox(height: 10.0,),
                Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(style: TextStyle(
                          fontSize: 18.0,),
                          decoration: InputDecoration(
                              labelText: 'Alınacaklar',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                          ),
                        validator: (input)=>input.trim().isEmpty ? 'Bir şeyler yaz' : null,
                        onSaved: (input)=>_title=input,
                        initialValue: _title,
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        style: TextStyle(fontSize: 18.0,),
                        onTap: _handleDatePicker,
                        decoration: InputDecoration(
                          labelText: 'Tarih',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.0),
                      child: DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22.0,
                        iconEnabledColor: Theme.of(context).accentColor,
                        items: _priorities.map((String priority){
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0
                            ),

                            ),
                          );
                        }).toList(),
                        style: TextStyle(
                        fontSize: 18.0,),
                        decoration: InputDecoration(
                          labelText: 'Öncelik',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                        ),
                        validator: (input)=>_priority == null ? 'Öncelik seç bakalım' : null,
                        onChanged: (value){
                          setState(() {
                            _priority = value;
                          });
                        },
                        value: _priority,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(30.0)
                      ),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        child:Text(widget.task == null ? 'Ekle' : 'Güncelle',style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: _sumbit,
                      ),
                    ),
                    widget.task != null ? Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(30.0)
                      ),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        child:Text('Sil',style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: _delete,
                      ),

                    ) : SizedBox.shrink(),
                  ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

