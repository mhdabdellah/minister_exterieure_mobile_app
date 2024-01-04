// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Form Step 1',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Steper(),
//     );
//   }
// }

// class Steper extends StatefulWidget {
//   const Steper({super.key});


// List<Step> getSteps() => [
//   Step(title: Text("Title1"), content: Container()),
//   Step(title: Text("Title2"), content: Container()),
//   Step(title: Text("Title3"), content: Container()),
// ]

//   @override
//   _SteperState createState() => _SteperState();
// }

// class _SteperState extends State<Steper> {
//  int currentStep = 0

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Step 1: Identity and Filiation'),
//       ),
//       body: Stepper(
// type: StepperType.horizontal,
// steps: getSteps(),
// currentStep: currentStep
// oneStepContinue: (){
  // final isLastStep = currentStep == getSteps().length - 1
  // if(isLastStep){
  // print("completed data")
  // send data to server
  // }else {
// setState() => currentStep += 1
// }
// 
// }
// onStepCancel: currentStep==0? null : setState(() => currentStep -= 1)
// )
//     );
//   }
// }
