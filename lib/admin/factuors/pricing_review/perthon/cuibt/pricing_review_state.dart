import '../../data/model/pricing_review_model.dart';

abstract class PricingReviewState {}

class PricingReviewInitial extends PricingReviewState {}

class PricingReviewLoading extends PricingReviewState {}

class PricingReviewLoaded extends PricingReviewState {
  final List<PricingReviewModel> reviews;

  PricingReviewLoaded(this.reviews);
}

class PricingReviewUpdated extends PricingReviewState {}

class PricingReviewError extends PricingReviewState {
  final String message;
  PricingReviewError(this.message);
}
