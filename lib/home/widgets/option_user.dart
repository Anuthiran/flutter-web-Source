import 'package:experiments_with_web/app_level/constants/constants.dart';
import 'package:experiments_with_web/app_level/extensions/textstyle_extension.dart';
import 'package:experiments_with_web/app_level/extensions/widget_extension.dart';
import 'package:experiments_with_web/app_level/models/articles/articles.dart';
import 'package:experiments_with_web/app_level/models/user/user.dart';
import 'package:experiments_with_web/app_level/services/linker_service.dart';
import 'package:experiments_with_web/app_level/styles/colors.dart';
import 'package:experiments_with_web/app_level/widgets/desktop/parallax_btn.dart';
import 'package:experiments_with_web/app_level/widgets/desktop/sliver_scaffold.dart';
import 'package:experiments_with_web/app_level/widgets/desktop/spacer_view.dart';
import 'package:experiments_with_web/home/widgets/top_nav.dart';
import 'package:experiments_with_web/locator.dart';
import 'package:experiments_with_web/app_level/services/hive/hive_operations.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'grid_view.dart';
import 'option_edit_user.dart';

class OptionUser extends StatefulWidget {
  const OptionUser({Key key}) : super(key: key);

  static final _hiveService = locator<HiveOperationsService>();

  @override
  _OptionUserState createState() => _OptionUserState();
}

class _OptionUserState extends State<OptionUser> {
  ScrollController _controller;
  static final _linkService = locator<LinkerService>();

  Box<UserModel> usersBox;
  List<UserModel> usr;

  final _userFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    usersBox = Hive.box<UserModel>('users');
  }

  @override
  Widget build(BuildContext context) {
    final _nav = Navigator.of(context);

    return SimpleSliverScaffold(
      controller: _controller,
      minHeight: 60.0,
      maxHeight: 60.0,
      menu: TopNavBar(controller: _controller),
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom:20.0),
          child: ValueListenableBuilder(
            builder: (_, Box<UserModel> model, child) {
              //

              if (model.values.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 80.0),
                      Text(
                        'Please add new user !!',
                        style:
                            Theme.of(context).textTheme.bodyText1.c(Colors.black45),
                      ),
                    ],
                  ),
                );
              } else{
                // ignore: omit_local_variable_types
                List<int> keys = model.keys.cast<int>().toList();
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) { 
                    return Container(
                      padding: EdgeInsets.only(left:20.0, right:20.0),
                      color: Colors.grey.shade100,
                      child: ListTile(
                        title: Text(model.get(keys[index]).userName),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.phone, size: 13.0, color: Colors.black26,),
                                SizedBox(width: 10.0),
                                Text(model.get(keys[index]).userPhone)
                              ]
                            ),
                            Row(
                              children: [
                                Icon(Icons.email, size: 13.0, color: Colors.black26,),
                                SizedBox(width: 10.0),
                                Text(model.get(keys[index]).userEmail)
                              ]
                            )
                          ],
                        ),
                        // leading: Text((keys[index]+1).toString()),
                        leading: CircleAvatar(
                          child: Icon(Icons.person, color: Colors.white),
                          backgroundColor: Colors.green.shade700
                        ),
                        dense: true,
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Color(0xFF002B5C)), 
                              onPressed: () { 
                                _openModal(model.get(keys[index]), keys[index], context);
                              },
                            ),
                            SizedBox(width: 20.0),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red.shade900,), 
                              onPressed: () { 
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Container(
                                        height: 100.0,
                                        child: Column(
                                          children: [
                                            Text('Do you want to delete this details?'),
                                            SizedBox(height: 25.0),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RaisedButton(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Text('Confirm',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.0
                                                    ),
                                                  ),
                                                  color: Colors.green.shade800,
                                                  onPressed:(){
                                                    usersBox.delete(keys[index]);
                                                    Navigator.pop(context);
                                                    print('---');
                                                  }
                                                ),
                                                RaisedButton(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Text('Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.0
                                                    )
                                                  ),
                                                  color: Color(0xFF002B5C),
                                                  onPressed:(){
                                                    Navigator.pop(context);
                                                  }
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                );
                                
                              },
                            )
                          ],
                        ),
                        onTap: (){

                          // _openModal(model.get(keys[index]), keys[index], context);
                          
                          // Navigator.push(context, MaterialPageRoute(builder: (context){
                          //   return OptionEditUser(); 
                          //   // return OptionEditUser(model.get(keys[index]).userName); 
                          // }));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //   return Abut(users.get(keys[index]).userId);
                          // }));
                        },
                      ),
                    );
                  
                  }, 
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    color: Colors.black26,
                    height: 20.0,
                  ), 
                  itemCount: keys.length,
                  shrinkWrap: true,
                );
              }

              // return HomeGridView(
              //   children: _displayOptions(_nav, model),
              // );
            },
            valueListenable: usersBox.listenable(),
          ),
        ),
        // const SizedBox(height: 80),
        // Text('I ma user page'),
        const SizedBox(height: 80),
        
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future _openModal(user, ind, context) async {
    setState(() {
      nameController.text = user.userName;
      phoneController.text = user.userPhone;
      emailController.text = user.userEmail;
      addressController.text = user.userAddress;
    });  
                        
    await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          scrollable: true,
          title: Text('Edit Details'),
          content: Container(
            width: 500.0,
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _userFormKey,
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                        controller: nameController,
                        style: TextStyle(
                          fontSize: 13.0
                        ),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person
                          ),
                          labelText: 'Name',
                        ),
                        validator: (String value) {
                          if(value.isEmpty){
                            return 'Please enter the name';
                          } else{
                            return null;
                          }
                        }
                    ),
                    SizedBox(height: 40.0),
                    TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 13.0
                        ),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone
                          ),
                          labelText: 'Phone Number',
                        ),
                        validator: (String value) {
                          if(value.isEmpty){
                            return 'Please enter the  phonenumber';
                          } else if( (value.length != 10) ){
                            return 'Phone number must be have 10 digits.';
                          } else if(!RegExp(r'^0[0-9]{9}$').hasMatch(value)){
                            return 'Invalid Phone number.';
                          } else{
                            return null;
                          }
                        }
                    ),
                    SizedBox(height: 40.0),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontSize: 13.0
                      ),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email
                            ),
                          labelText: 'Email Address',
                      //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none)
                      ),
                      validator: (String val) {
                        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        var regExp = RegExp(pattern);
                        if( val.isEmpty ){
                          return 'Please enter the email address.';
                        } else if(!regExp.hasMatch(val) ){
                          return 'Enter the valid email address.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 40.0),
                    TextFormField(
                      controller: addressController,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 13.0
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.credit_card
                        ),
                        labelText: 'Address',
                      ),
                      validator: (String value) {
                        if(value.isEmpty){
                          return 'Please enter the address';
                        } else{
                            return null;
                          }
                      }
                    ),
                    SizedBox(height: 60.0),
                    ButtonTheme(
                      // minWidth: double.infinity,
                      child: RaisedButton(
                          color: Color(0xFF002B5C),
                          // disabledColor: Color(0xFF068E50),
                          disabledTextColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                          onPressed: (){
                            if(_userFormKey.currentState.validate()){
                              // ReusableWidgets.showNormalMessage('Success', 'Your profile successfully edited.', Color(0xFFFF7427), context);
                              UserModel usr;
                              usr = UserModel(userName: nameController.text, userPhone: phoneController.text, userEmail: emailController.text, userAddress: addressController.text);
                              
                              usersBox.putAt(ind, usr);

                              Navigator.pop(context);
                              
                              showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Success'),
                                    content: Text('Profile updated.'),
                                  );
                                }
                              );


                            }
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0
                            ),
                          )
                      ),
                    )
                  ],
                ),
            ),
          ),
        );
      }
    );
  }

  // List<Widget> _displayOptions(NavigatorState nav, Box<UserModel> model) {
  //   var _list = <Widget>[];
  //   var _count = model.length;

  //   for (var i = 0; i < _count; i++) {
  //     final _model = model.getAt(i);

  //     _list.add(
  //       ParallaxButton(
  //         text: _model.articleName,
  //         medium: _model.articleLinks.first,
  //         website: _model.articleLinks[1],
  //         youtubeLink: _model.articleLinks.last,
  //         isFavorite: true,
  //         model: _model,
  //       ).clickable(() => nav.pushNamed(_model.articleRoute)),
  //     );
  //   }

  //   return _list;
  // }
}
