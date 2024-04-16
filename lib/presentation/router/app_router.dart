import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../screen/authentication/authentication_page.dart';
import '../screen/home/homePage.dart';
import '../screen/note/addNote.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AuthenticationPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      // case '/addNote':
      //   Map<String, dynamic> routeArguments =
      //       settings.arguments as Map<String, dynamic>;
      //   QuillController quillController =
      //       routeArguments['quillController'] ?? QuillController.basic();
      //   return MaterialPageRoute(
      //       builder: (_) => AddNote(
      //             quillController: quillController,
      //           ));

      case '/addNote':
        final Map<String, dynamic>? routeArguments =
            settings.arguments as Map<String, dynamic>?;

        if (routeArguments != null) {
          QuillController? quillController = routeArguments['quillController'];
          bool isNewNote = routeArguments['isNewNote'] ?? true;
          String noteId = routeArguments['noteId'] ?? "";

          return MaterialPageRoute(
            builder: (_) => AddNote(
              quillController: quillController ?? QuillController.basic(),
              isNewNote: isNewNote,
              noteId: noteId,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => AddNote(
              quillController: QuillController.basic(),
              isNewNote: true,
              noteId: '',
            ),
          );
        }

      // case '/dashboard':
      //   return MaterialPageRoute(builder: (_) => Dashboard());
      // case '/challenge-details':
      //   Map<String, dynamic> routeArguments =
      //   settings.arguments as Map<String, dynamic>;
      //   Contest contest = routeArguments['contest'] as Contest;
      //   bool completed = routeArguments['boolValue'] as bool;
      //   return MaterialPageRoute(
      //       builder: (_) => ContestDetails(
      //         contest: contest,
      //         completed: completed,
      //       ));
      // case '/play-challenge':
      //   dynamic args = settings.arguments;
      //   Contest contest = args['contest'];
      //   List<ChallengeStep> steps = args['steps'];
      //   return MaterialPageRoute(
      //       builder: (_) => PlayContest(steps: steps, contest: contest));
      default:
        return null;
    }
  }
}
