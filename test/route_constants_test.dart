import 'package:flutter_test/flutter_test.dart';
import 'package:hoodhelps/route_constants.dart';

void main() {
  group('RouteConstants tests', () {
    test('Routes should have correct paths', () {
      expect(RouteConstants.splash, '/splash');
      expect(RouteConstants.login, '/login');
      expect(RouteConstants.lobby, '/lobby');
      expect(RouteConstants.register, '/register');
      expect(RouteConstants.userList, '/userlist');
      expect(RouteConstants.userInfo, '/userinfo');
      expect(RouteConstants.editUser, '/userupdate');
      expect(RouteConstants.joinGroup, '/joingroup');
      expect(RouteConstants.forgotPassword, '/forgotpassword');
      expect(RouteConstants.forgotPasswordResetCode, '/forgotpasswordresetcode');
      expect(RouteConstants.forgotPasswordResetSuccess, '/forgotpasswordresetsuccess');
      // Continuez à tester les autres routes ici
    });
  });
}
