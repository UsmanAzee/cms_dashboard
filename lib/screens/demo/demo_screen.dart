import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/navigation/pages_data.dart';
import '../../common/views/page_wrapper.dart';
import '../../constants.dart';
import '../../providers/services/auth_provider.dart';
import '../../responsive.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  Future<void> checkCloudFirestoreData() async {
    try {
      final db = FirebaseFirestore.instance;
      CollectionReference<Map<String, dynamic>> cc = db.collection('category');
      QuerySnapshot<Map<String, dynamic>> sps = await cc.get();
      debugPrint("Check fetched categories");
      for (var doc in sps.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    } catch (err) {
      debugPrint("Error fetching data from firestore: ${err.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      page: Pages.demo,
      body: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Center(
              child: Text(
                "Demo Page",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Consumer(
              builder: (context, ref, child) => ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  ref.watch(firebaseAuthProvider).signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),
            Consumer(
              builder: (context, ref, child) => IconButton(
                icon: const Icon(Icons.ac_unit),
                onPressed: checkCloudFirestoreData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
