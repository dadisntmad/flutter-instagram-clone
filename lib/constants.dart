import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const accentGrey = Color(0xFFEFEFEF);
const accentBlue = Color(0xFF0095F6);

// instances
final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;
