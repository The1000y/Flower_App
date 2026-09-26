import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:injectable/injectable.dart';

/// Password recovery now lives on [RemoteDataSource].
/// This local source is kept for injectable compatibility.
@Injectable(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  LocalDataSourceImpl();
}
