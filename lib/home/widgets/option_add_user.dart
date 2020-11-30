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

class OptionAddUser extends StatefulWidget {
  const OptionAddUser({Key key}) : super(key: key);

  static final _hiveService = locator<HiveOperationsService>();

  @override
  _OptionAddUserState createState() => _OptionAddUserState();
}

class _OptionAddUserState extends State<OptionAddUser> {
  ScrollController _controller;
  static final _linkService = locator<LinkerService>();

  Box<UserModel> usersBox;

  var _userFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool nameFocus = true;

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
          padding: EdgeInsets.only(left:100.0, right:100.0, top:50.0, bottom:50.0),
          child: Form(
            key: _userFormKey,
            child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                      autofocus: nameFocus,
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
                            usersBox.add(usr);

                            nameController.clear();
                            phoneController.clear();
                            emailController.clear();
                            addressController.clear();

                            setState(() {
                              nameFocus = true;
                            });
                            
                            var snackbar = SnackBar(
                                  content: Text('New user is created.')
                                );
                            Scaffold.of(context).showSnackBar(snackbar);
                          }
                        },
                        child: Text(
                          'ADD',
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
        const SizedBox(height: 80),
        Text('add user'),
        const SizedBox(height: 80),
        // SpacerView(
        //   child: Card(
        //     color: AppColors.brandColor,
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'See the implementation',
        //           style: Theme.of(context).textTheme.bodyText1.c(Colors.white),
        //         ),
        //         IconButton(
        //           color: Colors.white,
        //           icon: FaIcon(FontAwesomeIcons.youtube),
        //           iconSize: 20.0,
        //           padding: EdgeInsets.zero,
        //           onPressed: () => _linkService.openLink(BrandLinks.favYoutube),
        //         ),
        //         IconButton(
        //           color: Colors.white,
        //           iconSize: 20.0,
        //           icon: FaIcon(FontAwesomeIcons.medium),
        //           padding: EdgeInsets.zero,
        //           onPressed: () => _linkService.openLink(BrandLinks.favMedium),
        //         ),
        //         IconButton(
        //           iconSize: 20.0,
        //           color: Colors.white,
        //           icon: FaIcon(FontAwesomeIcons.chrome),
        //           padding: EdgeInsets.zero,
        //           onPressed: () => _linkService.openLink(BrandLinks.favWebsite),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  List<Widget> _displayOptions(NavigatorState nav, Box<ArticlesModel> model) {
    var _list = <Widget>[];
    var _count = model.length;

    for (var i = 0; i < _count; i++) {
      final _model = model.getAt(i);

      _list.add(
        ParallaxButton(
          text: _model.articleName,
          medium: _model.articleLinks.first,
          website: _model.articleLinks[1],
          youtubeLink: _model.articleLinks.last,
          isFavorite: true,
          model: _model,
        ).clickable(() => nav.pushNamed(_model.articleRoute)),
      );
    }

    return _list;
  }
}
