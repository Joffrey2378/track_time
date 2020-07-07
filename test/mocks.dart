import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:track_time/services/auth.dart';
import 'package:track_time/services/database.dart';

class MockAuth extends Mock implements AuthBase {}

class MockDatabase extends Mock implements Database {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
