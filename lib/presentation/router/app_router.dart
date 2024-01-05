import 'package:flutter/material.dart';

import '../screen/authentication/authentication_page.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AuthenticationPage());

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
