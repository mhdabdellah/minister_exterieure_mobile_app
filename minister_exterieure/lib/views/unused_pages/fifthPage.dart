// import 'package:flutter/material.dart';
// import 'package:signature/signature.dart';

// class SignaturePage extends StatefulWidget {
//   const SignaturePage({super.key});

//   @override
//   _SignaturePageState createState() => _SignaturePageState();
// }

// class _SignaturePageState extends State<SignaturePage> {
//   final SignatureController _controller = SignatureController(
//     penStrokeWidth: 5,
//     penColor: Colors.black,
//   );
//   final TextEditingController _registrationNumberController =
//       TextEditingController();
//   final TextEditingController _placeController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     _registrationNumberController.dispose();
//     _placeController.dispose();
//     _dateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Signature Page'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           const Text('RÉSERVE À L\'ADMINISTRATION'),
//           TextFormField(
//             controller: _registrationNumberController,
//             decoration:
//                 const InputDecoration(labelText: 'N° d\'immatriculation'),
//           ),
//           TextFormField(
//             controller: _placeController,
//             decoration: const InputDecoration(labelText: 'Fait à'),
//           ),
//           TextFormField(
//             controller: _dateController,
//             decoration: const InputDecoration(labelText: 'Le'),
//             // You might want to use a DatePicker instead
//           ),
//           Signature(
//             controller: _controller,
//             height: 250,
//             backgroundColor: Colors.white,
//           ),
//           Container(
//             alignment: Alignment.center,
//             child: ElevatedButton(
//               onPressed: () async {
//                 if (_controller.isNotEmpty) {
//                   final signature = await _controller.toPngBytes();
//                   if (signature != null) {
//                     // Save the signature as an image file or use it as needed
//                   }
//                 }
//               },
//               child: const Text('Save Signature'),
//             ),
//           ),
//           // Add buttons for clearing or saving the signature
//         ],
//       ),
//     );
//   }
// }


// dependencies:
//   flutter:
//     sdk: flutter
//   signature: ^latest_version
