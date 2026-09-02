# WaveX New Booking Flow Plan

## Purpose

We will update the WaveX mobile app to match the new Figma flow, starting from region selection and ending with booking success or failure.

Important note: many booking and payment parts already exist in the app and backend. This is not a full rebuild. Some parts need to be added, and some existing parts need to be updated to match the new design and flow.

## New Flow

1. User opens the app.
2. User sees the intro and splash screens.
3. User selects their region.
4. User continues as guest, logs in, or creates an account.
5. User reaches the Home screen.
6. User chooses a class.
7. User opens the booking page.
8. User chooses a location.
9. User chooses a date and session.
10. User taps Book Now.
11. If the session is free, booking is completed directly.
12. If the session is paid, user completes payment.
13. User sees a success or failure screen.
14. Successful bookings appear in My Bookings / My Sessions.

## What Already Exists

The current app and backend already include many parts of this flow.

Already available:

- Intro and splash screens
- Login
- Signup
- Guest mode
- Home screen
- Classes/programs screen
- Program booking page
- Locations
- Sessions by date and location
- Free session booking
- Paid session payment
- Success screen
- Failure screen
- My Sessions / My Bookings
- Backend support for programs
- Backend support for locations
- Backend support for sessions
- Backend support for booking
- Backend support for payment
- Backend support for countries
- Backend support for payment success and failure handling
- Backend package and membership code exists, but it is not fully connected to the mobile API yet

## What Is New Or Needs To Change

## 1. Region Selection

This is the most important new starting point from the Figma design.

We need to add a new region selection screen before the user enters the app.

The app should:

- Show the new region selection design
- Let the user choose a region
- Remember the selected region
- Use that region when showing classes, locations, sessions, and prices

The backend already has country support, but we need to confirm if this is the same thing as the new Figma “region” selection.

If “region” means country, we can use the existing country system.

If “region” means something different, the backend will need a small update.

Backend change needed:

- Add a clean mobile API for the app to get the available countries/regions.
- Example: the app asks the backend “what regions can the user choose from?”
- The backend returns only active regions.

This should be a small backend change because the country data already exists.

## 2. Startup Flow

The app currently goes from splash to the welcome/login screen.

We need to update it so the flow becomes:

- Splash
- Region selection
- Welcome/login screen

If the user already selected a region before, the app can skip the region screen.

## 3. Home Screen Design

The Home screen already exists.

We need to update the design to match the new Figma version.

The updated Home screen should show:

- Main banner
- Book a Session button
- Programs shortcut
- My Booking shortcut
- Featured programs
- Instructor preview
- Location/map preview
- Bottom navigation

## 4. Classes Screen Design

The Classes screen already exists.

We need to update the design and make sure it shows the correct classes for the selected region.

Backend change needed:

- Classes/programs should be filtered by the selected region.
- This means the app should not show classes from another region after the user chooses their region.

## 5. Booking Page Design

The booking page already exists.

We need to update it to match the new Figma design.

The updated page should show:

- Class name
- Class image
- Class description
- Location choices
- Date choices
- Available sessions
- Session time
- Seats left
- Price
- Discounts
- Free session information
- Book Now button

Backend change needed:

- Locations should be filtered by the selected region.
- Sessions should be filtered by selected class, location, and date.
- The backend already supports sessions, locations, prices, capacity, and booking status.
- The main backend update is making sure the selected region is used correctly.

## 6. Session Rules

The backend already supports session availability, capacity, booking, and payment.

We need to confirm the app displays these states clearly:

- Available
- Fully booked
- Scheduled
- Free session
- Discounted session
- Already booked

Fully booked sessions should not be bookable.

## 7. Payment

Payment already exists.

We need to connect it cleanly to the new booking page design.

For paid sessions:

- App starts payment
- User completes payment
- Success screen appears if payment succeeds
- Failure screen appears if payment fails

Security note: the mobile app should not contain any secret payment key. Secret payment keys must stay only in the backend.

Backend change needed:

- No new payment system is needed.
- We only need to make sure the app uses the correct backend payment flow.
- The backend should keep all secret payment keys.
- The app should only receive the safe payment information it needs to complete checkout.

## 8. Success And Failure Screens

Success and failure screens already exist.

We need to update their design and make sure they show the right result after booking or payment.

Success should confirm:

- Booking completed
- Class name
- Location
- Date
- Time

Failure should allow:

- Try again
- Go back to booking
- Return Home

## 9. My Bookings / My Sessions

My Sessions already exists.

We need to make sure a successful booking appears there with:

- Class name
- Instructor
- Location
- Date
- Time
- Booking status
- Payment status

Backend change needed:

- No major new backend work is expected here.
- We only need to make sure the existing My Sessions data includes the information shown in the new design.

## Backend Work Confirmed From Current Code

After checking the backend, these are the backend changes that are actually needed:

1. Add or expose a proper mobile API for countries/regions.
2. Confirm that Figma “region” means the existing backend “country”.
3. Filter programs/classes by selected region.
4. Filter locations by selected region.
5. Filter sessions by selected region, class, location, and date.
6. Make sure the app uses the newer session and payment flow where needed.
7. Keep payment secret keys only in the backend.

These backend changes are mostly connection and filtering work. The backend already has the main booking, session, payment, country, package, and membership foundations.

## Backend Work That Is Not Needed As A Full Rebuild

We do not need to rebuild these from zero:

- Booking system
- Payment system
- Session system
- Location system
- Program/class system
- Success and failure handling
- My Sessions base API
- Country database structure

These already exist and should be reused.

## Main Work Summary

The main work is:

- Add the new region selection step
- Connect selected region to the app flow
- Confirm whether backend country support matches the Figma region requirement
- Add backend filtering so region affects programs, locations, and sessions
- Update the UI to match the new Figma screens
- Reconnect the existing booking and payment logic to the new design
- Clean up membership/package APIs only if those screens are included now
- Test the full journey from app open to booking success or failure

## Final Testing Flow

We will test:

1. Open app.
2. Select region.
3. Continue as guest or log in.
4. Open Home.
5. Choose a class.
6. Choose location.
7. Choose date and session.
8. Book a free session.
9. Book a paid session.
10. Complete successful payment.
11. Test failed payment.
12. Confirm booking appears in My Bookings.

## Final Result

The user will have a complete booking flow that matches the new Figma design, while reusing the booking and payment work that already exists.
