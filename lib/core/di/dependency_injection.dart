import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/core/signalr/signalr_service.dart';

final _signalRService = SignalRService();
SignalRService get signalRService => _signalRService;

Future<void> initDI() async {
  DioFactory.getDio();
}
