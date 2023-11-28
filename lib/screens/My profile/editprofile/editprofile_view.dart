import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/colorconstants.dart';
import '../../../styles/text_style.dart';
import '../myprofile_controller.dart';
import '../myprofile_view.dart';

class EditProfileView extends GetView<MyProfileController> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 278.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: ColorConstants.white),
                  onPressed: () {
                    Get.to(() => MyProfileView());
                  },
                ),
              ),
              CircleAvatar(
                radius: 45.0,
                backgroundColor: Colors.white,
                child: Text(
                  (controller.userName.isNotEmpty)
                      ? controller.userName.value[0].toUpperCase()
                      : '',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                controller.userName.value,
                style: appbar,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Colors.white,
                ),
                width: 400,
                height: 1000,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Text(
                          "Display Name",
                          style: appbar1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 38.0, right: 38.0),
                        child: TextFormField(
                          controller: _displayNameController,
                          style: appbar2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a display name';
                            }
                            return null;
                          },
                        ),
                      ),


                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              controller.updateProfile(
                                _displayNameController.text,
                                _emailController.text,
                              );
                              // Get.back(); // Close the Edit Profile screen
                            }
                          },
                          child: Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
