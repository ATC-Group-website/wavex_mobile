# WaveX Region, Branch, and Session Flow Plan

## Purpose

The primary new flow is region-first session discovery:

1. User opens the app.
2. User selects and confirms a region.
3. The app loads branches available in that region.
4. User selects a branch.
5. The app loads all available sessions for that branch.
6. User selects a session and continues through the existing booking/payment flow.

The Figma region page is a required entry step, not an optional settings feature.

## Figma Scope

The supplied design shows a WaveX welcome/entry screen and a dedicated region-selection page with a region dropdown, Confirm, and Cancel. The wider Figma file also has account and commerce screens, but they are secondary to this release’s region → branch → available sessions journey.

## Target Journey

### 1. Startup and Region Selection

- Keep the required splash/intro flow, then show the region page before session discovery.
- Load active regions from the backend.
- Keep Confirm disabled until a valid region is selected.
- Cancel returns to the prior entry screen and must not silently select a region.
- Persist the confirmed region locally for returning users.
- If a saved region becomes inactive or invalid, clear it and request a new selection.

### 2. Branch Discovery

- After region confirmation, request branches belonging to that region only.
- Do not show branches from another region.
- When the user changes region, clear the selected branch and session before loading the new branch list.
- Provide loading, empty, retry, and invalid-saved-region states.

### 3. Available Sessions

- After branch selection, request sessions for that branch.
- Display only bookable sessions with program/class name, date, time, price/free label, seats left, and availability status.
- Do not allow selection of fully booked, cancelled, expired, or unavailable sessions.
- Date or program filters added later may refine the selected branch’s sessions but cannot bypass the region/branch relationship.
- Show an empty state when a branch has no available sessions.

### 4. Booking and Payment

- Selecting an available session continues into the existing booking flow.
- Free sessions use the current free-booking endpoint; paid sessions use the backend-owned payment flow.
- Revalidate region, branch, session, and availability on the backend when booking is created.
- Never expose payment secret keys to the app.

## Data and API Contract

The app needs a connected hierarchy:

| Data | Relationship | Minimum fields |
| --- | --- | --- |
| Region | Top-level active selection | id, name, isActive |
| Branch | Belongs to one active region | id, name, regionId, address/contact details, isActive |
| Session | Belongs to one branch | id, branchId, program/class, start/end time, price, seats left, status, booking eligibility |

Required backend behavior:

1. Return active regions for the region page.
2. Return active branches for the selected region only.
3. Return bookable/available sessions for the selected branch only.
4. Reject a branch that does not belong to the supplied region.
5. Revalidate session availability and hierarchy during booking.

Confirm whether Figma’s “region” maps directly to the existing backend “country.” If so, reuse the country model through a mobile region API. Otherwise, add a distinct region-to-branch relationship.

## Secondary Scope

Home, Programs, Profile, More, My Sessions, packages, orders, addresses, settings, privacy, and logout remain secondary. They must respect the selected region where relevant, but they must not delay this core release.

## Delivery Phases

### Phase 1 — Region Foundation

- Confirm region meaning and data ownership.
- Expose active-region API.
- Build the Figma region screen.
- Persist and validate the selected region.

### Phase 2 — Branch and Session Discovery

- Expose region-scoped branches and build branch selection.
- Expose branch-scoped available sessions and build the session view.
- Add loading, empty, retry, and unavailable states.

### Phase 3 — Booking Integration

- Connect available sessions to existing free and paid booking.
- Revalidate hierarchy and capacity server-side.
- Refresh My Sessions/Bookings after success.

### Phase 4 — Secondary Screens and Quality

- Update remaining Figma screens in priority order.
- Test accessibility, slow/offline behavior, saved-selection recovery, authorization, and booking regression.

## Acceptance Checklist

- A new user cannot enter session discovery without confirming a region.
- Returning users reuse a valid saved region and are prompted again if it is invalid.
- Every displayed branch belongs to the selected region.
- Every displayed session belongs to the selected branch and is available to book.
- Changing region clears incompatible branch and session selections.
- The backend rejects cross-region branch/session requests and stale bookings.
