// import 'package:attendanaceapp/end_screen.dart';
// import 'package:attendanaceapp/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EmployeeHomePage extends StatefulWidget {
//   final String name;
//   final String id;
//   final String email;
//   final String phone;
//   final String imageUrl;
//   final String documentId;

//   EmployeeHomePage({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.imageUrl,
//     required this.documentId,
//   });

//   @override
//   _EmployeeHomePageState createState() => _EmployeeHomePageState();
// }

// class _EmployeeHomePageState extends State<EmployeeHomePage> {
//   late TimeOfDay selectedCheckInTime;
//   late TextEditingController checkInTimeController;
//   late TimeOfDay selectedCheckOutTime;
//   late TextEditingController checkOutTimeController;
//   late TextEditingController notesController;
//   String? selectedProject;

//   @override
//   void initState() {
//     super.initState();
//     selectedCheckInTime = TimeOfDay.now();
//     checkInTimeController =
//         TextEditingController(text: _formatTimeOfDay(selectedCheckInTime));
//     selectedCheckOutTime = TimeOfDay.now();
//     checkOutTimeController =
//         TextEditingController(text: _formatTimeOfDay(selectedCheckOutTime));
//     notesController = TextEditingController();
//   }

//   Future<Position?> _getCurrentLocation() async {
//   LocationPermission permission = await _checkLocationPermission(context);
//   if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//     print('Location permission not granted.');
//     return null;
//   }

//   try {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return position;
//   } catch (e) {
//     print('Error getting current location: $e');
//     return null;
//   }
// }



//   String _formatTimeOfDay(TimeOfDay timeOfDay) {
//     final now = DateTime.now();
//     final dateTime = DateTime(
//         now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
//     return DateFormat.Hm().format(dateTime);
//   }

//   Future<void> _showCheckInDialog() async {
//     // Use the current time by default
//     TimeOfDay selectedTime = TimeOfDay.now();
    

//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Check-in'),
//           content: Container(
//             width: 300,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         readOnly: true,
//                         controller: checkInTimeController,
//                         decoration: InputDecoration(labelText: 'Check-in Time'),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         TimeOfDay? pickedTime = await showTimePicker(
//                           context: context,
//                           initialTime: selectedTime,
//                         );

//                         if (pickedTime != null) {
//                           setState(() {
//                             selectedTime = pickedTime;
//                             checkInTimeController.text =
//                                 _formatTimeOfDay(selectedTime);
//                           });
//                         }
//                       },
//                       child: Text('Pick Time'),
//                       style: ElevatedButton.styleFrom(
//                         primary: Color.fromARGB(255, 247, 153, 14),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 DropdownButton<String>(
//                   value: selectedProject,
//                   onChanged: (String? value) {
//                     setState(() {
//                       selectedProject = value!;
//                     });
//                   },
//                   items: <String>['Project A', 'Project B', 'Project C']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   hint: Text('Select Project'),
//                 ),
//                 SizedBox(height: 15),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // Save the check-in time and selected project to 'emp_daily_activity'
//                     _saveCheckInTime();

//                     // Close the dialog
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Check-in'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Color.fromARGB(255, 247, 153, 14),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _showCheckOutDialog() async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return SingleChildScrollView(
//           child: AlertDialog(
//             title: Text('Check-out'),
//             content: Container(
//               width: 300,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   TextFormField(
//                     readOnly: true,
//                     controller: checkOutTimeController,
//                     decoration: InputDecoration(labelText: 'Check-out Time'),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () async {
//                       TimeOfDay? pickedTime = await showTimePicker(
//                         context: context,
//                         initialTime: selectedCheckOutTime,
//                       );

//                       if (pickedTime != null) {
//                         setState(() {
//                           selectedCheckOutTime = pickedTime;
//                           checkOutTimeController.text =
//                               _formatTimeOfDay(selectedCheckOutTime);
//                         });
//                       }
//                     },
//                     child: Text('Pick Time'),
//                     style: ElevatedButton.styleFrom(
//                       primary: Color.fromARGB(255, 247, 153, 14),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   DropdownButton<String>(
//                     value: selectedProject, // Should be null initially
//                     onChanged: (String? value) {
//                       setState(() {
//                         selectedProject = value!;
//                       });
//                     },
//                     items: <String>['Project A', 'Project B', 'Project C']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     hint: Text('Select Project'),
//                   ),
//                   SizedBox(height: 10),
//                   TextFormField(
//                     controller: notesController,
//                     decoration: InputDecoration(labelText: 'Notes'),
//                     maxLines: null,
//                   ),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Save the check-out time, selected project, and notes to 'emp_daily_activity'
//                   _saveCheckOutTime();

//                   // Close the dialog
//                   Navigator.of(context).pop();

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => EndScreen()),
//                   );
//                 },
//                 child: Text('Check-out'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _saveCheckInTime() async {
//   // Check location permission
//   LocationPermission permission = await _checkLocationPermission(context);

//   if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//     print('Location permission not granted.');
//     return;
//   }

//   // Get the current location
//   Position? currentPosition = await _getCurrentLocation();
//   if (currentPosition == null) {
//     print('Failed to get current location.');
//     return;
//   }
//   // Get the current date
//   DateTime currentDate = DateTime.now();
//   String formattedDate = DateFormat('yyyy-MMM-dd').format(currentDate);

//   // Construct the document ID for emp_daily_activity
//   String documentId = "${widget.id}_${selectedProject}_$formattedDate";

//   // Save the check-in time, selected project, location, and other details to 'emp_daily_activity'
//   FirebaseFirestore.instance
//       .collection('emp_daily_activity')
//       .doc(documentId)
//       .set({
//         'id': widget.id,
//         'project': selectedProject,
//         'date': formattedDate,
//         'login': _formatTimeOfDay(selectedCheckInTime),
//         'logout': null,
//         'name': widget.name,
//         'notes': "",
//         'location': 'Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}',
//       }, SetOptions(merge: true))
//       .then((value) {
//         print('Check-in time, project, and location saved successfully!');
//       })
//       .catchError((error) {
//         print('Error saving check-in time, project, and location: $error');
//       });
// }


// // Check location permission
// Future<LocationPermission> _checkLocationPermission(BuildContext context) async {
//   LocationPermission permission = await Geolocator.checkPermission();

//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
    
//     if (permission == LocationPermission.denied) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Location permission is required for this feature."),
//       ));
//     }
//   }

//   return permission;
// }



//   void _saveCheckOutTime() {
//     // Get the current date
//     DateTime currentDate = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MMM-dd').format(currentDate);

//     // Construct the document ID for emp_daily_activity
//     String documentId = "${widget.id}_${selectedProject}_$formattedDate";

//     // Save the check-out time, selected project, and notes to 'emp_daily_activity'
//     FirebaseFirestore.instance
//         .collection('emp_daily_activity')
//         .doc(documentId)
//         .set({
//       'id': widget.id,
//       'name': widget.name,
//       'phone': widget.phone,
//       'date': formattedDate,
//       'login': _formatTimeOfDay(selectedCheckInTime),
//       'logout': _formatTimeOfDay(selectedCheckOutTime),
//       'project': selectedProject,
//       'notes': notesController.text,
//     }, SetOptions(merge: true)).then((value) {
//       print('Check-out time, project, and notes saved successfully!');
//     }).catchError((error) {
//       print('Error saving check-out time, project, and notes: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Checkin-Checkout',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 59, 58, 58),
//           ),
//         ),
//         elevation: 0,
//         shape: ContinuousRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 233, 121, 46),
//                 Color.fromARGB(255, 247, 153, 14),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: NetworkImage(widget.imageUrl),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               widget.name,
//               style: TextStyle(
//                 fontSize: 29,
//                 fontFamily: 'lemon',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 95),
//             Row(
//               mainAxisAlignment:
//                   MainAxisAlignment.spaceAround, // Adjusted alignment
//               children: [
//                 ElevatedButton(
//                   onPressed: _showCheckInDialog,
//                   child: Text(
//                     'Check-in',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 59, 58, 58),
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     primary: Color.fromARGB(255, 247, 153, 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(20.0), // Circular border radius
//                     ),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 15), // Increase button size
//                     minimumSize: Size(150, 60),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _showCheckOutDialog,
//                   child: Text(
//                     'Check-out',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 59, 58, 58),
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     primary: Color.fromARGB(255, 247, 153, 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(20.0), // Circular border radius
//                     ),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 15), // Increase button size
//                     minimumSize: Size(150, 60),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:attendanaceapp/end_screen.dart';
import 'package:attendanaceapp/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeHomePage extends StatefulWidget {
  final String name;
  final String id;
  final String email;
  final String phone;
  final String imageUrl;
  final String documentId;

  EmployeeHomePage({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.documentId,
  });

  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  late TimeOfDay selectedCheckInTime;
  late TextEditingController checkInTimeController;
  late TimeOfDay selectedCheckOutTime;
  late TextEditingController checkOutTimeController;
  late TextEditingController notesController;
  String? selectedProject;
  late List<String> employeeProjects; // Store projects locally

  @override
  void initState() {
    super.initState();
    selectedCheckInTime = TimeOfDay.now();
    checkInTimeController =
        TextEditingController(text: _formatTimeOfDay(selectedCheckInTime));
    selectedCheckOutTime = TimeOfDay.now();
    checkOutTimeController =
        TextEditingController(text: _formatTimeOfDay(selectedCheckOutTime));
    notesController = TextEditingController();
    // Initialize employee projects
    _initEmployeeProjects();
  }

  Future<void> _initEmployeeProjects() async {
    employeeProjects = await _getEmployeeProjects();
  }

  Future<Position?> _getCurrentLocation() async {
  LocationPermission permission = await _checkLocationPermission(context);
  if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
    print('Location permission not granted.');
    return null;
  }

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  } catch (e) {
    print('Error getting current location: $e');
    return null;
  }
}



  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.Hm().format(dateTime);
  }

  GlobalKey _dropdownKey = GlobalKey();

Future<void> _showCheckInDialog() async {
  // Use the current time by default
  TimeOfDay selectedTime = TimeOfDay.now();
  selectedProject = 'Select Project';

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Check-in'),
        content: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: checkInTimeController,
                      decoration: InputDecoration(labelText: 'Check-in Time'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );

                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                          checkInTimeController.text =
                              _formatTimeOfDay(selectedTime);
                        });
                      }
                    },
                    child: Text('Pick Time'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 247, 153, 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              DropdownButton<String>(
                key: _dropdownKey, // Add a GlobalKey to the DropdownButton
                value: selectedProject,
                onChanged: (String? value) {
                  setState(() {
                    selectedProject = value!;
                  });
                },
                items: ['Select Project', 'Project A', 'Project B', 'Project C']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  // Save the check-in time and selected project to 'emp_daily_activity'
                  _saveCheckInTime();

                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('Check-in'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 247, 153, 14),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  Future<void> _showCheckOutDialog() async {
  List<String> loggedInProjects = await _getEmployeeProjects();
  print('Projects from _getEmployeeProjects: $loggedInProjects');

  // Use the current time by default
  TimeOfDay selectedTime = TimeOfDay.now();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
          title: Text('Check-out'),
          content: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  readOnly: true,
                  controller: checkOutTimeController,
                  decoration: InputDecoration(labelText: 'Check-out Time'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedCheckOutTime,
                    );

                    if (pickedTime != null) {
                      setState(() {
                        selectedCheckOutTime = pickedTime;
                        checkOutTimeController.text =
                            _formatTimeOfDay(selectedCheckOutTime);
                      });
                    }
                  },
                  child: Text('Pick Time'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 247, 153, 14),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedProject,
                  onChanged: (String? value) {
                    setState(() {
                      selectedProject = value!;
                      print('Selected project: $selectedProject');
                    });
                  },
                  items: loggedInProjects
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                      .toList(),
                  hint: Text('Select Project'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: 'Notes'),
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the check-out time, selected project, and notes to 'emp_daily_activity'
                _saveCheckOutTime();

                // Close the dialog
                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EndScreen()),
                );
              },
              child: Text('Check-out'),
            ),
          ],
        ),
      );
    },
  );
}



Future<List<String>> _getEmployeeProjects() async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('emp_daily_activity')
        .doc("${widget.name}_${widget.id}_dailyactivity")
        .get();

    print('Document data: ${documentSnapshot.data()}');

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('daily_activity')) {
        List<dynamic> dailyActivityList = data['daily_activity'];

        print('Daily activity list: $dailyActivityList');

        // Extract projects with null logout
        List<String> loggedInProjects = [];

        for (var activity in dailyActivityList) {
          if (activity.containsKey('projects')) {
            List<dynamic> projects = activity['projects'];
            for (var project in projects) {
              if (project['logout'] == null) {
                loggedInProjects.add(project['name'].toString());
              }
            }
          }
        }

        print('Fetched projects: $loggedInProjects');
        return loggedInProjects;
      }
    }
  } catch (e) {
    print('Error fetching employee projects: $e');
  }

  return [];
}

// Fetch the list of projects for which the user has checked in on the current day
Future<List<String>> _fetchLoggedInProjects() async {
  // Get the current date
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MMM-dd').format(currentDate);

  // Construct the document ID for emp_daily_activity
  String documentId = "${widget.id}_$formattedDate";

  // Retrieve the document from 'emp_daily_activity'
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('emp_daily_activity')
      .doc(documentId)
      .get();

  // Extract the list of logged-in projects from the document data
  Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
  if (data != null) {
    List<String> loggedInProjects = data.keys.where((key) => key != 'id' && key != 'date').toList();
    return loggedInProjects;
  }

  return [];
}

  Future<void> _saveCheckInTime() async {
  // Check location permission
  LocationPermission permission = await _checkLocationPermission(context);

  if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
    print('Location permission not granted.');
    return;
  }

  // Get the current location
  Position? currentPosition = await _getCurrentLocation();
  if (currentPosition == null) {
    print('Failed to get current location.');
    return;
  }

  // Get the current date
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MMM-dd').format(currentDate);

  // Construct the document ID for emp_daily_activity
  String documentId = "${widget.name}_${widget.id}_dailyactivity";

  // Get the existing document or create a new one
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('emp_daily_activity')
      .doc(documentId)
      .get();

  // Extract existing daily activity data
  List<Map<String, dynamic>> existingDailyActivity = [];
  if (snapshot.exists) {
    existingDailyActivity = List<Map<String, dynamic>>.from(snapshot['daily_activity']);
  }

  // Check if a record already exists for the current date
  int existingIndex = existingDailyActivity.indexWhere((entry) => entry['date'] == formattedDate);

  if (existingIndex != -1) {
    // Check if the project already exists for the current date
    int projectIndex = existingDailyActivity[existingIndex]['projects']
        .indexWhere((project) => project['name'] == selectedProject);

    if (projectIndex != -1) {
      // Update the existing project for the current date
      existingDailyActivity[existingIndex]['projects'][projectIndex]['login'] =
          _formatTimeOfDay(selectedCheckInTime);
      existingDailyActivity[existingIndex]['projects'][projectIndex]['checkin_location'] =
          'Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}';
    } else {
      // Add a new project to the existing day
      existingDailyActivity[existingIndex]['projects'].add({
        'id': widget.id,
        'name': selectedProject,
        'login': _formatTimeOfDay(selectedCheckInTime),
        'logout': null,
        'notes': "",
        'checkin_location': 'Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}',
      });

      // Remove the 'location' field if it exists (to prevent saving both location and checkin_location)
      if (existingDailyActivity[existingIndex]['projects'].last.containsKey('location')) {
        existingDailyActivity[existingIndex]['projects'].last.remove('location');
      }
    }
  } else {
    // Create a new day with the current project
    existingDailyActivity.add({
      'date': formattedDate,
      'projects': [
        {
          'id': widget.id,
          'name': selectedProject,
          'login': _formatTimeOfDay(selectedCheckInTime),
          'logout': null,
          'notes': "",
          'checkin_location': 'Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}',
        },
      ],
    });
  }

  // Save the updated daily activity to 'emp_daily_activity'
  await FirebaseFirestore.instance
      .collection('emp_daily_activity')
      .doc(documentId)
      .set({
        'id': widget.id,
        'name': widget.name,
        'daily_activity': existingDailyActivity,
      }, SetOptions(merge: true));

  print('Check-in time, project, and location saved successfully!');
}

// Check location permission
Future<LocationPermission> _checkLocationPermission(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Location permission is required for this feature."),
      ));
    }
  }

  return permission;
}



  // Save the check-out time, selected project, and notes to 'emp_daily_activity'
Future<void> _saveCheckOutTime() async {
  // Check location permission
  LocationPermission permission = await _checkLocationPermission(context);

  if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
    print('Location permission not granted.');
    return;
  }

  // Get the current location
  Position? currentPosition = await _getCurrentLocation();
  if (currentPosition == null) {
    print('Failed to get current location.');
    return;
  }

  // Get the current date
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MMM-dd').format(currentDate);

  // Construct the document ID for emp_daily_activity
  String documentId = "${widget.name}_${widget.id}_dailyactivity";

  // Get existing data to preserve check-in information
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('emp_daily_activity')
      .doc(documentId)
      .get();

  if (!documentSnapshot.exists) {
    print('Document not found for ID: $documentId');
    return;
  }

  Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

  if (data != null && data.containsKey('daily_activity')) {
    List<dynamic> dailyActivity = data['daily_activity'];

    // Find the entry for the current date
    Map<String, dynamic>? currentDateEntry = dailyActivity.firstWhere(
      (entry) => entry['date'] == formattedDate,
      orElse: () => null,
    );

    if (currentDateEntry != null && currentDateEntry.containsKey('projects')) {
      // Update the check-out time, selected project, notes, and location for the specific project
      List<dynamic> projects = currentDateEntry['projects'];
      Map<String, dynamic>? currentProject = projects.firstWhere(
        (project) => project['name'] == selectedProject,
        orElse: () => null,
      );

      if (currentProject != null) {
        currentProject['logout'] = _formatTimeOfDay(selectedCheckOutTime);
        currentProject['notes'] = notesController.text;
        currentProject['checkout_location'] =
            'Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}';
      }

      // Save the updated data to 'emp_daily_activity'
      FirebaseFirestore.instance
          .collection('emp_daily_activity')
          .doc(documentId)
          .update({'daily_activity': dailyActivity})
          .then((value) {
        print('Check-out time, project, notes, and location saved successfully!');
      })
          .catchError((error) {
        print('Error saving check-out time, project, notes, and location: $error');
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Checkin-Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
        ),
        elevation: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 233, 121, 46),
                Color.fromARGB(255, 247, 153, 14),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 29,
                fontFamily: 'lemon',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 95),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Adjusted alignment
              children: [
                ElevatedButton(
                  onPressed: _showCheckInDialog,
                  child: Text(
                    'Check-in',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 58, 58),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 247, 153, 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Circular border radius
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15), // Increase button size
                    minimumSize: Size(150, 60),
                  ),
                ),
                ElevatedButton(
                  onPressed: _showCheckOutDialog,
                  child: Text(
                    'Check-out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 58, 58),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 247, 153, 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Circular border radius
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15), // Increase button size
                    minimumSize: Size(150, 60),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}