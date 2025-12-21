import '../../../../../client/factuors/client_order/data/model/order_model.dart';

class PricingModel {
  final String orderId;
  final String clientName;
  final String clientPhone;
  final DateTime createdAt;


  final List<String> engFiles;
  final List<String> engImages;
  final String engNote;

  PricingModel({
    required this.createdAt,
    required this.orderId,
    required this.clientName,
    required this.clientPhone,
    required this.engFiles,
    required this.engImages,
    required this.engNote,
  });

  factory PricingModel.fromOrder(
      OrderModel order,
      Map<String, dynamic>? engReview,
      ) {
    return PricingModel(
      orderId: order.id,
      clientName: order.name,
      clientPhone: order.numper.toString(),
      engFiles: List<String>.from(engReview?['files'] ?? []),
      engImages: List<String>.from(engReview?['images'] ?? []),
      engNote: engReview?['note'] ?? '',
      createdAt: order.createdAt,
    );
  }
}
