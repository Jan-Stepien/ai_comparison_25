import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:nomad_app/data/repositories/auth_repository_impl.dart';
import 'package:nomad_app/data/repositories/payment_repository_impl.dart';
import 'package:nomad_app/data/repositories/user_repository_impl.dart';
import 'package:nomad_app/domain/repositories/auth_repository.dart';
import 'package:nomad_app/domain/repositories/payment_repository.dart';
import 'package:nomad_app/domain/repositories/user_repository.dart';
import 'package:nomad_app/services/auth/firebase_auth_service.dart';
import 'package:nomad_app/services/database/firestore_service.dart';
import 'package:nomad_app/services/payment/stripe_payment_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External services
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  
  // Services
  sl.registerLazySingleton(() => FirebaseAuthService(sl()));
  sl.registerLazySingleton(() => FirestoreService(sl()));
  sl.registerLazySingleton(() => StripePaymentService());
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(sl()));
}