import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'getit_utils.config.dart'; // Tệp được tạo tự động sau khi chạy lệnh build_runner

// Tạo một instance GetIt duy nhất (singleton)
final getIt = GetIt.instance;

// Hàm khởi tạo các phụ thuộc bằng Injectable

@injectableInit
void configureDependencies() => getIt.init();

class GetItUtils {
  static setup() async => configureDependencies();
}
