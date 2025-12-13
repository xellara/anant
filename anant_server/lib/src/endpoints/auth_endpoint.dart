import 'dart:math';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/repositories/auth_service.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../repositories/auth_repository_impl.dart';

class AuthEndpoint extends Endpoint {
  late final AuthService _authService;

  AuthEndpoint() {
    _authService = AuthService(AuthRepositoryImpl());
  }

  /// Generate a random password of the given length.
  String generateRandomPassword({int length = 10}) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Sign up a new user.
  Future<Map<String, dynamic>> signUp(
    Session session,
    UserRole role,
    String organizationName, {
    String? sectionName,
    String? admissionNumber,
    String? className,
    String? rollNumber,
    String? email,
    String? password,
    String? fullName,
    String? anantId,
    String? profileImageUrl,
    String? mobileNumber,
    String? parentMobileNumber,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? dob,
    String? bloodGroup,
    String? aadharNumber,
    List<String>? subjectTeaching,
    List<String>? classAndSectionTeaching,
  }) async {
    // Generate an anantId if not provided.
    int currentYear = DateTime.now().year;
    String lastTwoDigits = currentYear.toString().substring(currentYear.toString().length - 2);
    if ((anantId == null || anantId.isEmpty) && role == UserRole.student) {
      anantId = "$lastTwoDigits$sectionName$admissionNumber.$role@$organizationName.anant";
    } else if ((anantId == null || anantId.isEmpty) && role == UserRole.teacher) {
      anantId = "$lastTwoDigits$sectionName$admissionNumber.$role@$organizationName.anant";
    }

    try {
      // Use the provided password or generate one.
      String finalPassword = (password == null || password.isEmpty) ? generateRandomPassword() : password;

      final userToCreate = User(
        uid: '', // Placeholder, service generates it
        organizationName: organizationName,
        anantId: anantId,
        email: email,
        role: role,
        fullName: fullName,
        isActive: true,
        className: className,
        rollNumber: rollNumber,
        admissionNumber: admissionNumber,
        sectionName: sectionName,
        profileImageUrl: profileImageUrl,
        mobileNumber: mobileNumber,
        parentMobileNumber: parentMobileNumber,
        address: address,
        city: city,
        state: state,
        country: country ?? "India",
        pincode: pincode,
        dob: dob,
        bloodGroup: bloodGroup,
        aadharNumber: aadharNumber,
        subjectTeaching: subjectTeaching,
        classAndSectionTeaching: classAndSectionTeaching,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdUser = await _authService.signUp(session, userToCreate, finalPassword);

      return {
        "success": true,
        "anantId": createdUser.anantId,
        "password": finalPassword,
        "userId": createdUser.id,
        "uid": createdUser.uid,
      };
    } catch (e, st) {
      print("Error in signUp: $e\n$st");
      return {
        "success": false,
        "failReason": e.toString(),
      };
    }
  }

  /// Bulk sign up new users.
  Future<List<Map<String, dynamic>>> bulkSignUp(
    Session session,
    List<User> userList,
  ) async {
    List<Map<String, dynamic>> responses = [];
    for (var user in userList) {
      final response = await signUp(
        session,
        user.role,
        user.organizationName,
        sectionName: user.sectionName,
        admissionNumber: user.admissionNumber,
        className: user.className,
        rollNumber: user.rollNumber,
        email: user.email,
        password: null, // No password provided; a random one will be generated.
        fullName: user.fullName,
        anantId: user.anantId ?? '',
        profileImageUrl: user.profileImageUrl,
        mobileNumber: user.mobileNumber,
        parentMobileNumber: user.parentMobileNumber,
        address: user.address,
        city: user.city,
        state: user.state,
        country: user.country,
        pincode: user.pincode,
        dob: user.dob,
        bloodGroup: user.bloodGroup,
        aadharNumber: user.aadharNumber,
        subjectTeaching: user.subjectTeaching,
        classAndSectionTeaching: user.classAndSectionTeaching,
      );
      if (response["success"] == true) {
        responses.add({
          "userId": response["userId"],
          "uid": response["uid"],
          "admissionNumber": user.admissionNumber,
          "rollNumber": user.rollNumber,
          "className": user.className,
          "sectionName": user.sectionName,
          "anantId": response["anantId"],
          "password": response["password"],
        });
      } else {
        responses.add({
          "failReason": response["failReason"],
        });
      }
    }
    return responses;
  }

  /// Sign in a user by verifying their credentials.
  Future<auth.AuthKey> signIn(
    Session session,
    String anantId,
    String password,
  ) async {
    try {
      return await _authService.signIn(session, anantId, password);
    } catch (e) {
      // Log the error
      print("SignIn Error: $e");
      throw Exception("Invalid credentials");
    }
  }

  /// Update a user's details.
  Future<auth.AuthKey> updateUser(
    Session session,
    int userId, {
    String? newAnantId,
    String? newPassword,
    String? newEmail,
    String? newFullName,
    UserRole? newRole,
    bool? isActive,
    String? newClassName,
    String? newRollNumber,
    String? newAdmissionNumber,
    String? newSectionName,
    String? newOrganizationName,
    String? newProfileImageUrl,
    String? newMobileNumber,
    String? newParentMobileNumber,
    String? newAddress,
    String? newCity,
    String? newState,
    String? newCountry,
    String? newPincode,
    String? newDob,
    String? newBloodGroup,
    String? newAadharNumber,
    List<String>? newSubjectTeaching,
    List<String>? newClassAndSectionTeaching,
  }) async {
    try {
      // Update auth user info.
      var userInfo = await auth.Users.findUserByUserId(session, userId);
      if (userInfo == null) {
        throw Exception("User not found");
      }
      if (newAnantId != null) {
        userInfo = userInfo.copyWith(
          userIdentifier: newAnantId,
          userName: newAnantId,
        );
      }
      if (newEmail != null) {
        userInfo = userInfo.copyWith(email: newEmail);
      }
      userInfo = (await auth.UserInfo.db.update(session, [userInfo])).first;
      
      // Update custom user record.
      var user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception("Custom user record not found");
      }
      user = user.copyWith(
        anantId: newAnantId ?? user.anantId,
        email: newEmail ?? user.email,
        fullName: newFullName ?? user.fullName,
        role: newRole ?? user.role,
        isActive: isActive ?? user.isActive,
        className: newClassName ?? user.className,
        rollNumber: newRollNumber ?? user.rollNumber,
        admissionNumber: newAdmissionNumber ?? user.admissionNumber,
        sectionName: newSectionName ?? user.sectionName,
        organizationName: newOrganizationName ?? user.organizationName,
        profileImageUrl: newProfileImageUrl ?? user.profileImageUrl,
        mobileNumber: newMobileNumber ?? user.mobileNumber,
        parentMobileNumber: newParentMobileNumber ?? user.parentMobileNumber,
        address: newAddress ?? user.address,
        city: newCity ?? user.city,
        state: newState ?? user.state,
        country: newCountry ?? user.country,
        pincode: newPincode ?? user.pincode,
        dob: newDob ?? user.dob,
        bloodGroup: newBloodGroup ?? user.bloodGroup,
        aadharNumber: newAadharNumber ?? user.aadharNumber,
        subjectTeaching: newSubjectTeaching ?? user.subjectTeaching,
        classAndSectionTeaching: newClassAndSectionTeaching ?? user.classAndSectionTeaching,
        updatedAt: DateTime.now(),
      );
      user = (await User.db.update(session, [user])).first;
      
      // Update credentials if password or anantId changed.
      final creds = await UserCredentials.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );
      if (creds != null) {
        String updatedPasswordHash = creds.passwordHash;
        if (newPassword != null) {
          updatedPasswordHash = await hashPassword(newPassword);
        }
        final updatedCreds = creds.copyWith(
          passwordHash: updatedPasswordHash,
          anantId: newAnantId ?? creds.anantId,
          updatedAt: DateTime.now(),
        );
        await UserCredentials.db.update(session, [updatedCreds]);
      }
      
      // Generate and return a new authentication token.
      final authKey = await UserAuthentication.signInUser(
        session,
        userInfo.id!,
        'myAuth',
        scopes: {},
      );
      return authKey;
    } catch (e, st) {
      print("Error in updateUser: $e\n$st");
      throw Exception("Internal error");
    }
  }

  /// Delete a user.
  Future<bool> deleteUser(Session session, int userId) async {
    try {
      final userInfo = await auth.Users.findUserByUserId(session, userId);
      if (userInfo == null) return false;
      await session.db.transaction((transaction) async {
        await session.db.unsafeQuery(
          "DELETE FROM serverpod_user_info WHERE id = $userId",
          transaction: transaction,
        );
        await User.db.deleteWhere(
          session,
          where: (t) => t.id.equals(userId),
          transaction: transaction,
        );
        await UserCredentials.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(userId),
          transaction: transaction,
        );
      });
      return true;
    } catch (e, st) {
      print("Error in deleteUser: $e\n$st");
      return false;
    }
  }

  /// Hash a password using bcrypt.
  Future<String> hashPassword(String password) async {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Verify a password using bcrypt.
  Future<bool> verifyPassword(String password, String storedHash) async {
    return BCrypt.checkpw(password, storedHash);
  }
}
