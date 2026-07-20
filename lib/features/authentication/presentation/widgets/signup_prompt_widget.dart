// import 'package:flutter/material.dart';

// class SignupPromptWidget extends StatelessWidget {
//   final VoidCallback? onSignupPressed;

//   const SignupPromptWidget({
//     super.key,
//     this.onSignupPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF0060A9);

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           "Don't have an account? ",
//           style: TextStyle(
//             fontSize: 14,
//             color: Color(0xFF404752),
//           ),
//         ),
//         GestureDetector(
//           onTap: onSignupPressed,
//           child: const Text(
//             'Sign up',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: primaryColor,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
