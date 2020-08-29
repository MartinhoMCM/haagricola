
import 'package:get_it/get_it.dart';
import 'package:ha_angricola/service/api.dart';

import '../models/crudmodeproduct.dart';


GetIt locator =GetIt.instance;

void setupLocator()
{
  locator.registerLazySingleton(()=>Api('product'));
  locator.registerLazySingleton(()=>CRUDModelProduct());
  //locator.registerLazySingleton(()=>Api('requests'));
  //locator.registerLazySingleton(()=>CRUDModelProduct());
}
