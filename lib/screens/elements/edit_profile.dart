import 'package:flutter/material.dart';
import 'package:locostall/screens/elements/input_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 40.0,
            child: Text(
              'EDIT',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: screenHeight * .025),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputField(
              labelText: 'Name',
              onChanged: (value) {},
              textInputAction: TextInputAction.next,
            ),
          ),
          SizedBox(height: screenHeight * .025),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputField(
              labelText: 'Phone',
              onChanged: (value) {},
              textInputAction: TextInputAction.next,
            ),
          ),
          SizedBox(height: screenHeight * .025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('SAVE'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
