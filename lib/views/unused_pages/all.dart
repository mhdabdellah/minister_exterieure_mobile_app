// import 'package:flutter/material.dart';

// class StepOnePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 1: Identity and Birth Details'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: <Widget>[
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Full Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 10),
//           // Repeat TextFormField for each field required in step 1
//           // ...
//         ],
//       ),
//     );
//   }
// }



// class StepTwoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 2: Host Country Status and Contact Details'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: <Widget>[
//           // Use TextFormField for input fields and other widgets as needed
//           // ...
//         ],
//       ),
//     );
//   }
// }


// class StepThreePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 3: Additional Details'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: <Widget>[
//           // Use TextFormField for input fields and other widgets as needed
//           // ...
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Multi-Step Form',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: StepOnePage(),
//     );
//   }
// }

// class StepOnePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 1: Identity and Birth Details'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Go to Step 2'),
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepTwoPage()));
//           },
//         ),
//       ),
//     );
//   }
// }

// class StepTwoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 2: Host Country Status and Contact Details'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Go to Step 3'),
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepThreePage()));
//           },
//         ),
//       ),
//     );
//   }
// }

// class StepThreePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 3: Additional Details'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Submit Form'),
//           onPressed: () {
//             // Submit form logic goes here
//           },
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Multi-Step Form',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: StepOnePage(),
//     );
//   }
// }

// // Step 1 Page
// class StepOnePage extends StatefulWidget {
//   @override
//   _StepOnePageState createState() => _StepOnePageState();
// }

// class _StepOnePageState extends State<StepOnePage> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 1: Identity and Birth Details'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Full Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             // Add other form fields here
//             ElevatedButton(
//               child: Text('Go to Step 2'),
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepTwoPage()));
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Step 2 Page
// class StepTwoPage extends StatefulWidget {
//   @override
//   _StepTwoPageState createState() => _StepTwoPageState();
// }

// class _StepTwoPageState extends State<StepTwoPage> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 2: Host Country Status and Contact Details'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             // Add form fields here
//             ElevatedButton(
//               child: Text('Go to Step 3'),
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepThreePage()));
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Step 3 Page
// class StepThreePage extends StatefulWidget {
//   @override
//   _StepThreePageState createState() => _StepThreePageState();
// }

// class _StepThreePageState extends State<StepThreePage> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 3: Additional Details'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             // Add form fields here
//             ElevatedButton(
//               child: Text('Submit Form'),
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   // Implement form submission logic
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Multi-Step Form',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: StepOnePage(),
//     );
//   }
// }

// // Step 1 Page: Identity and Birth Details
// class StepOnePage extends StatefulWidget {
//   @override
//   _StepOnePageState createState() => _StepOnePageState();
// }

// class _StepOnePageState extends State<StepOnePage> {
//   final _formKey = GlobalKey<FormState>();
//   // Define TextEditingControllers for each field if necessary

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 1: Identity and Birth Details'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Full Name',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your full name';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 10),
//             // Repeat TextFormField for other fields required in step 1
//             ElevatedButton(
//               child: Text('Go to Step 2'),
//               onPressed: () {
//                 // Navigate to the next form page
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Step 2 Page: Host Country Status and Contact Details
// class StepTwoPage extends StatefulWidget {
//   @override
//   _StepTwoPageState createState() => _StepTwoPageState();
// }

// class _StepTwoPageState extends State<StepTwoPage> {
//   final _formKey = GlobalKey<FormState>();
//   // Define TextEditingControllers for each field if necessary

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 2: Host Country Status and Contact Details'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             // Repeat TextFormField for fields required in step 2
//             ElevatedButton(
//               child: Text('Go to Step 3'),
//               onPressed: () {
//                 // Navigate to the next form page
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Step 3 Page: Additional Details
// class StepThreePage extends StatefulWidget {
//   @override
//   _StepThreePageState createState() => _StepThreePageState();
// }

// class _StepThreePageState extends State<StepThreePage> {
//   final _formKey = GlobalKey<FormState>();
//   // Define TextEditingControllers for each field if necessary

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step 3: Additional Details'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             // Repeat TextFormField for fields required in step 3
//             ElevatedButton(
//               child: Text('Submit Form'),
//               onPressed: () {
//                 // Implement form submission logic
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
