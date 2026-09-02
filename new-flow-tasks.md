# WaveX New Booking Flow Tasks

This task list is based on the new Figma flow.

The goal is to update the app from region selection until the user books a session, pays if needed, and sees success or failure.


## Task 1: Confirm Region Meaning

Priority: High

Type: Product / Backend

Goal:

Confirm whether the new Figma “region” means the existing backend “country”.

Scope:

- Review the current country data in the backend.
- Confirm the list of regions the client wants to show in the app.
- Decide if we will use the existing country system or add a new region layer.

Acceptance Criteria:

- We know exactly what the region dropdown should show.
- We know whether backend country data can be reused.
- No app work starts with unclear region rules.

## Task 2: Add Mobile Region API

Priority: High

Type: Backend

Goal:

Allow the mobile app to get the list of available regions.

Scope:

- Add or expose a clean mobile API for countries/regions.
- Return only active regions.
- Return the region name and ID needed by the app.

Acceptance Criteria:

- The app can request the list of regions from the backend.
- The backend returns the correct active regions.
- The response is simple and ready for the region selection screen.

## Task 3: Add Region Selection Screen

Priority: High

Type: App

Goal:

Add the new region selection screen from the Figma design.

Scope:

- Build the screen UI.
- Show the WaveX logo.
- Show the region dropdown.
- Add Confirm and Cancel actions.
- Connect the dropdown to the backend region list.

Acceptance Criteria:

- User can see and select a region.
- User can confirm their selected region.
- The screen matches the new Figma design.

## Task 4: Save Selected Region

Priority: High

Type: App

Goal:

Remember the user’s selected region and use it across the app.

Scope:

- Save the selected region on the device.
- Use the saved region when loading classes, locations, sessions, and prices.
- Skip the region screen if the user already selected a region before.

Acceptance Criteria:

- The app remembers the selected region after restart.
- The user does not need to choose the region every time.
- The app content changes based on the selected region.

## Task 5: Update Startup Flow

Priority: High

Type: App

Goal:

Update the app opening flow to match the new Figma journey.

Scope:

- Keep the current intro and splash screens.
- Add the region screen after splash.
- Then continue to login, signup, or guest mode.
- If region was already selected, continue directly to the next screen.

Acceptance Criteria:

- New users see splash, then region selection, then welcome/login.
- Returning users do not get blocked by region selection again.
- Guest, login, and signup still work.

## Task 6: Filter Classes By Region

Priority: High

Type: Backend / App

Goal:

Show only classes that belong to the selected region.

Scope:

- Backend accepts the selected region when loading programs/classes.
- App sends the selected region when requesting classes.
- Classes from other regions are hidden.

Acceptance Criteria:

- User only sees classes available in their selected region.
- Changing region changes the class list.
- Existing classes screen still works with the new design.

## Task 7: Update Home Screen UI

Priority: Medium

Type: App

Goal:

Update the Home screen to match the new Figma design.

Scope:

- Update the main banner.
- Add or update Book a Session shortcut.
- Add or update Programs shortcut.
- Add or update My Booking shortcut.
- Show featured programs.
- Show instructor preview.
- Show location/map preview.
- Keep bottom navigation working.

Acceptance Criteria:

- Home screen visually matches the new Figma screen.
- Shortcuts open the correct pages.
- Home content respects the selected region.

## Task 8: Update Classes Screen UI

Priority: Medium

Type: App

Goal:

Update the Classes screen to match the new Figma design.

Scope:

- Update the class cards.
- Show class image, name, description, and booking action.
- Keep navigation to the booking page.
- Show only region-related classes.

Acceptance Criteria:

- Classes screen matches the new Figma design.
- User can open a class booking page.
- User only sees classes for the selected region.

## Task 9: Filter Locations By Region

Priority: High

Type: Backend / App

Goal:

Show only locations available in the selected region.

Scope:

- Backend accepts the selected region when loading locations.
- App sends the selected region when requesting locations.
- Booking page only shows locations for the selected region.

Acceptance Criteria:

- User only sees locations available in their selected region.
- Location selection works on the booking page.
- Sessions update when the user changes location.

## Task 10: Update Booking Page UI

Priority: High

Type: App

Goal:

Update the class booking page to match the new Figma design.

Scope:

- Show class name, image, and description.
- Show location options.
- Show date options.
- Show available session cards.
- Show time, seats left, price, discount, and free session labels.
- Add Book Now button.

Acceptance Criteria:

- Booking page matches the new Figma design.
- User can choose location, date, and session.
- User can clearly see whether a session is free, paid, discounted, available, or fully booked.

## Task 11: Filter Sessions Correctly

Priority: High

Type: Backend / App

Goal:

Load the correct sessions based on region, class, location, and date.

Scope:

- Backend returns sessions for the selected region, class, location, and date.
- App sends the selected filters.
- App shows the correct session status.

Acceptance Criteria:

- User sees only matching sessions.
- Fully booked sessions cannot be booked.
- Available sessions can be selected.
- Session capacity and seats left are shown correctly.

## Task 12: Connect Free Booking Flow

Priority: High

Type: App / Backend

Goal:

Allow the user to book a free session directly.

Scope:

- App detects when a session is free.
- App calls the existing free booking backend flow.
- App shows success or failure after booking.

Acceptance Criteria:

- Free session can be booked without payment.
- Successful free booking appears in My Bookings / My Sessions.
- Failed booking shows a clear failure screen.

## Task 13: Connect Paid Booking And Payment Flow

Priority: High

Type: App / Backend

Goal:

Allow the user to book a paid session through the existing payment flow.

Scope:

- App starts payment from the selected session.
- Backend creates the payment safely.
- User completes payment.
- App shows success or failure.
- Secret payment keys stay only in the backend.

Acceptance Criteria:

- Paid session opens the payment flow.
- Successful payment creates the booking.
- Failed payment does not create a confirmed booking.
- User sees the correct success or failure screen.

## Task 14: Update Success Screen

Priority: Medium

Type: App

Goal:

Update the success screen to match the new design and show useful booking details.

Scope:

- Show booking success message.
- Show class name.
- Show location.
- Show date and time.
- Add action to go to My Bookings / My Sessions.
- Add action to return Home.

Acceptance Criteria:

- User clearly knows the booking succeeded.
- User can reach their booking after success.
- Screen matches the new Figma style.

## Task 15: Update Failure Screen

Priority: Medium

Type: App

Goal:

Update the failure screen to match the new design and help the user continue.

Scope:

- Show a clear failure message.
- Add Try Again action.
- Add Back to Booking action.
- Add Return Home action.

Acceptance Criteria:

- User clearly knows the booking or payment failed.
- User can retry without getting lost.
- Screen matches the new Figma style.

## Task 16: Confirm Booking Appears In My Bookings

Priority: High

Type: App / Backend

Goal:

Make sure successful bookings appear in My Bookings / My Sessions.

Scope:

- Check the existing My Sessions response.
- Show class name, instructor, location, date, time, booking status, and payment status.
- Refresh My Sessions after a successful booking.

Acceptance Criteria:

- Successful free booking appears in My Bookings / My Sessions.
- Successful paid booking appears in My Bookings / My Sessions.
- Failed payment does not appear as a confirmed booking.

## Task 17: Membership And Package API Check

Priority: Medium

Type: Backend / App

Goal:

Decide whether membership/package purchase is included in this release.

Scope:

- Check the existing backend package and membership code.
- If included now, expose safe mobile APIs for packages and memberships.
- If not included now, keep it out of the first booking release.

Acceptance Criteria:

- Client confirms whether membership/package screens are part of this phase.
- If included, the app can load and buy packages safely.
- If not included, the booking flow can launch without this work.

## Task 18: Full Flow Testing

Priority: High

Type: QA

Goal:

Test the complete user journey from app open to booking result.

Scope:

- Open app.
- Select region.
- Continue as guest.
- Log in.
- Sign up.
- Open Home.
- Choose a class.
- Choose location.
- Choose date and session.
- Book a free session.
- Book a paid session.
- Test successful payment.
- Test failed payment.
- Confirm booking appears in My Bookings / My Sessions.

Acceptance Criteria:

- Full flow works for guest where allowed.
- Full flow works for logged-in user.
- Free booking works.
- Paid booking works.
- Payment failure is handled clearly.
- Region filtering works across Home, Classes, Locations, and Sessions.

## Suggested Release Order

1. Confirm region rules.
2. Add mobile region API.
3. Add region selection screen.
4. Save selected region and update startup flow.
5. Add backend filtering for classes, locations, and sessions.
6. Update Home, Classes, and Booking UI.
7. Connect free booking.
8. Connect paid booking and payment.
9. Update success and failure screens.
10. Confirm My Bookings / My Sessions.
11. Decide membership/package scope.
12. Test the full flow.
