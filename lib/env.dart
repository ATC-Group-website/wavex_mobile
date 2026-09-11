/// Client-side configuration values injected at build time.
///
/// Stripe publishable keys are safe to ship in a mobile client. Keep secret
/// Stripe keys exclusively on the backend.
const String stripeKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
