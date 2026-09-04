# WaveX Region, Branch, and Session Flow Tasks

Priority release flow: select region → load branches in that region → load available sessions in the selected branch → continue to existing booking/payment.

## Task 1: Confirm Region and Branch Data Model

Priority: High

Type: Product / Backend

Scope:

- Confirm whether Figma “region” is the existing country model or a separate entity.
- Define the authoritative relationship: region → branch → session.
- Confirm which branches and sessions are active and mobile-visible.

Acceptance Criteria:

- Region, branch, and session ownership is documented.
- The team knows whether country data can be reused.
- No branch belongs to an undefined or inactive region.

## Task 2: Add Mobile Region API

Priority: High

Type: Backend

Scope:

- Expose active regions with stable IDs and display names.
- Exclude inactive/unavailable regions.

Acceptance Criteria:

- The app can load valid regions with id, name, and active state.
- API failures return a safe, actionable error.

## Task 3: Build the Figma Region Selection Page

Priority: High

Type: App

Scope:

- Build the displayed WaveX region page with dropdown, Confirm, and Cancel.
- Load options from the region API.
- Disable Confirm until a valid selection exists.

Acceptance Criteria:

- The screen matches the supplied Figma design.
- User can select and confirm a region.
- Cancel does not create or change a selected region.

## Task 4: Persist and Validate Selected Region

Priority: High

Type: App / Backend

Scope:

- Save confirmed region locally and restore it on later launches.
- Clear stale branch/session state when region changes.
- Handle inactive or deleted saved regions.

Acceptance Criteria:

- A valid region is reused without prompting again.
- An invalid saved region returns the user to selection.
- Changing region cannot retain another region’s branch/session.

## Task 5: Add Region-Scoped Branch API

Priority: High

Type: Backend

Scope:

- Return only active branches for a supplied region.
- Return branch ID, name, region ID, address/contact details, and active state.
- Reject invalid region IDs and cross-region relationships.

Acceptance Criteria:

- Every returned branch belongs to the selected region.
- Inactive branches are excluded.
- Empty regions return an explicit empty result.

## Task 6: Build Branch Selection

Priority: High

Type: App

Scope:

- Build a branch list or selector after region confirmation.
- Add loading, no-branches, error, and retry states.

Acceptance Criteria:

- User can select a branch in their region.
- Changing region reloads branches and clears the old branch.
- Branches from another region are never visible or selectable.

## Task 7: Add Branch-Scoped Available Sessions API

Priority: High

Type: Backend

Scope:

- Return current sessions for the branch with class/program, start/end time, price/free state, seats left, status, and booking eligibility.
- Enforce branch → region ownership server-side.

Acceptance Criteria:

- Sessions from another branch are never returned.
- Fully booked, cancelled, expired, and unavailable sessions are excluded or non-bookable.
- Availability comes from current backend data.

## Task 8: Build the Available Sessions View

Priority: High

Type: App

Scope:

- Load sessions only after branch selection.
- Show class/program, date, time, price/free state, seats left, and status.
- Support loading, empty, retry, and unavailable states.

Acceptance Criteria:

- User sees only available sessions for the selected branch.
- Unavailable sessions cannot be selected.
- Branches with no sessions show a useful empty state.

## Task 9: Connect Booking and Payment

Priority: High

Type: App / Backend

Scope:

- Send selected region, branch, and session through the existing booking flow.
- Revalidate hierarchy, availability, and capacity before booking.
- Use free booking for free sessions and current backend payment for paid sessions.

Acceptance Criteria:

- A booking cannot use a mismatched region, branch, or session.
- Newly full/stale sessions fail gracefully and refresh availability.
- Payment secrets remain backend-only.

## Task 10: Refresh My Sessions / Bookings

Priority: Medium

Type: App / Backend

Scope:

- Refresh sessions/bookings after free or paid booking.
- Show branch, session, date/time, booking status, and payment status.

Acceptance Criteria:

- Successful bookings appear without an app restart.
- Failed payments do not appear as confirmed bookings.

## Task 11: Secondary Figma Screens

Priority: Medium

Type: App / Backend

Scope:

- Schedule Home, Programs, Profile, More, packages, orders, addresses, settings, privacy, and logout after the core flow.
- Make branch/availability-dependent content use the selected region.

Acceptance Criteria:

- Secondary work does not block the core release.
- Region use is consistent anywhere branch-dependent content appears.

## Task 12: End-to-End QA

Priority: High

Type: QA / App / Backend

Scope:

- Test first launch, region selection, saved-region restore, region change, branches, sessions, free booking, paid booking, stale availability, and empty/error states.
- Test cross-region API rejection, authorization, and guest versus signed-in behavior.

Acceptance Criteria:

- The complete hierarchy works on supported devices.
- No cross-region branches or sessions can be viewed or booked.
- Users receive clear feedback for unavailable data and failed requests.

## Suggested Release Order

1. Confirm data model.
2. Region API and Figma region page.
3. Save/validate selected region.
4. Region-scoped branch API and branch selector.
5. Branch-scoped available-session API and session view.
6. Booking/payment integration and My Sessions refresh.
7. Secondary Figma screens and full QA.
