import 'package:flutter_test/flutter_test.dart';
import 'package:wavex/features/book_program_screen/data/models/payment_response.dart'
    as payment;
import 'package:wavex/features/book_program_screen/data/repository/book_programs_repository.dart';
import 'package:wavex/features/sessions_screen/data/models/my_sessions_response.dart'
    as sessions;
import 'package:wavex/features/sessions_screen/data/repository/sessions_repository.dart';

void main() {
  group('V2 booking and payment contract', () {
    test('builds paid and free booking payloads with the selected slots', () {
      expect(BookProgramsRepository.paymentEndpoint, 'v2/payment');
      expect(
        BookProgramsRepository.paymentPayload(sessionId: 17, slots: 3),
        {'session_id': 17, 'slots': 3},
      );

      expect(
          BookProgramsRepository.freeBookingEndpoint, 'v2/book_free_session');
      expect(
        BookProgramsRepository.freeBookingPayload(sessionId: 17, slots: 2),
        {'session_id': 17, 'slots': 2},
      );
    });

    test('parses Stripe and Paymob V2 payment responses', () {
      final stripe = payment.PaymentResponse.fromJson({
        'success': true,
        'gateway': 'stripe',
        'client_secret': 'pi_secret',
        'payment_record': {
          'id': 44,
          'status': 'pending',
          'slots': 2,
          'session_id': 17,
        },
      });
      final paymob = payment.PaymentResponse.fromJson({
        'success': true,
        'gateway': 'paymob',
        'redirect_url': 'https://checkout.example.test',
      });

      expect(stripe.gateway, 'stripe');
      expect(stripe.clientSecret, 'pi_secret');
      expect(stripe.paymentRecord?.slots, 2);
      expect(stripe.paymentRecord?.sessionId, 17);
      expect(stripe.supportsStripePaymentSheet, isTrue);
      expect(paymob.gateway, 'paymob');
      expect(paymob.redirectUrl, 'https://checkout.example.test');
      expect(paymob.clientSecret, isNull);
      expect(paymob.supportsStripePaymentSheet, isFalse);
    });

    test('builds V2 refund requests with booking IDs', () {
      expect(SessionsRepository.sessionRefundEndpoint, 'v2/refunds/request');
      expect(
        SessionsRepository.sessionRefundPayload(
          bookingId: 61,
          reason: 'Schedule conflict',
        ),
        {'booking_id': 61, 'reason': 'Schedule conflict'},
      );
      expect(SessionsRepository.cancellationEndpoint(61), 'bookings/61/cancel');
    });

    test('reads booking IDs from the user sessions response', () {
      final session = sessions.Sessions.fromJson({
        'id': 17,
        'booking_id': 61,
      });

      expect(session.id, 17);
      expect(session.bookingId, 61);
    });
  });
}
