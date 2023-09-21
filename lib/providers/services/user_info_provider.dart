import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils/UserStorageUtility.dart';
import 'fb_storage_provider.dart';

final userInfoProvider = NotifierProvider<UserInfoUtils, UserInfo>(() => UserInfoUtils());

class UserInfoUtils extends Notifier<UserInfo> {
  @override
  UserInfo build() {
    // Listen to user changes and update state accordingly
    FirebaseAuth.instance.userChanges().listen((User? user) {
      state = UserInfo.from(FirebaseAuth.instance.currentUser);
    });
    return UserInfo.from(FirebaseAuth.instance.currentUser);
  }

  Stream<bool> updateUserProfileImage() {
    StreamController<bool> controller = StreamController();

    selectFile(type: FileType.image, allowMultiple: false).then((FilePickerResult? selectedFile) {
      if (selectedFile == null) {
        controller.add(false);
      } else {
        // selectedFile.files.first.readStream.listen((event) {});

        FBStorageUtils storageUtils = ref.read(fbStorageProvider.notifier);
        storageUtils.uploadFileToFirebaseStorage("/profile_image.png", file: File(selectedFile.files.first.path!)).listen((List<dynamic> result) async {
          if (result.first == StreamStatus.running) {
            return;
          }

          if (result.first == StreamStatus.success) {
            Reference fileRef = result.last;
            String imageUrl = await fileRef.getDownloadURL();
            FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
            state = state.copyWith(photoURL: imageUrl);
            controller.add(true);
          }
        });
      }
    });

    return controller.stream;
  }
}

class UserInfo {
  final String displayName;
  final String email;
  final bool emailVerified;
  final bool isAnonymous;
  final UserMetadata metadata;
  final String phoneNumber;

  final String photoURL;
  final String refreshToken;
  final String tenantId;
  final String uid;

  const UserInfo({
    required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.isAnonymous,
    required this.metadata,
    required this.phoneNumber,
    required this.photoURL,
    required this.refreshToken,
    required this.tenantId,
    required this.uid,
  });

  UserInfo copyWith({
    String? displayName,
    String? email,
    bool? emailVerified,
    bool? isAnonymous,
    UserMetadata? metadata,
    String? phoneNumber,
    String? photoURL,
    String? refreshToken,
    String? tenantId,
    String? uid,
  }) {
    return UserInfo(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      metadata: metadata ?? this.metadata,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      refreshToken: refreshToken ?? this.refreshToken,
      tenantId: tenantId ?? this.tenantId,
      uid: uid ?? this.uid,
    );
  }

  static UserInfo from(User? fUser) {
    return UserInfo(
      displayName: fUser?.displayName ?? "Anonymous",
      email: fUser?.email ?? "",
      emailVerified: fUser?.emailVerified ?? false,
      isAnonymous: fUser?.isAnonymous ?? false,
      metadata: fUser?.metadata ??
          UserMetadata(
            DateTime.now().add(const Duration(minutes: -5)).millisecondsSinceEpoch,
            DateTime.timestamp().millisecondsSinceEpoch,
          ),
      phoneNumber: fUser?.phoneNumber ?? "",
      photoURL: fUser?.photoURL ?? "",
      refreshToken: fUser?.refreshToken ?? "",
      tenantId: fUser?.tenantId ?? "",
      uid: fUser?.uid ?? "",
    );
  }

// override for equality check
// @override
// bool operator ==(Object other) {
//   if (identical(this, other)) return true;
//   return other is UserInfo && other.displayName == displayName && other.email == email && other.emailVerified == emailVerified &&
//       other.isAnonymous == isAnonymous && other.metadata.toString() == metadata.toString() && other.phoneNumber == phoneNumber &&
//       other.photoURL == photoURL &&
//       other.refreshToken == refreshToken && other.tenantId == tenantId && other.uid == uid;
// }
//
// @override
// int get hashCode =>
//     Object.hash(
//       displayName,
//       email,
//       emailVerified,
//       isAnonymous,
//       metadata.toString(),
//       phoneNumber,
//       photoURL,
//       refreshToken,
//       tenantId,
//       uid,
//     );
}
