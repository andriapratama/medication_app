# Architecture Decisions

These are the main decisions I made while building the app, and why.

## 1. Splitting the code into layers

The project has three main layers, `domain`, `data`, and `presentation`, plus `core` for things they all share.

`domain` is plain Dart. It has the entities, the `MedicationRepository` contract, and the use cases, and it doesn't import Flutter, Dio, or Hive. `data` is where the real work with openFDA and Hive happens. `presentation` only talks to use cases and never touches the network or storage directly.

The main benefit is that changes stay small. If openFDA changes its JSON, I only touch `MedicationModel`. If I wanted to replace Hive with SQLite, only the local data source would change. It also makes testing much easier, since any layer can be swapped for a mock.

The downside is more files than an app this size strictly needs. The use cases are thin and mostly just pass calls to the repository. I kept them anyway, because they're the natural place for business rules once the app grows (more on that at the end).

## 2. Cubit for state management

I went with Cubits from `flutter_bloc` instead of full Blocs. The screens don't do anything complicated, just load, refresh, load more, and toggle a favorite, so events would have added boilerplate without a real payoff.

Each set of states is a `sealed` class with `Equatable`. Because it's sealed, the `switch` in each screen has to handle every state or the code won't compile. Equatable is what lets `bloc_test` compare states, and it also avoids pointless rebuilds.

Some small things I paid attention to:

- If the next page fails to load, the items already on screen stay there. Only the last row turns into an error with a Retry button.
- If you pull to refresh while the next page is still loading, the late page is thrown away instead of being added to the fresh list.
- Search ignores results for an old query if you kept typing.
- The favorite star changes as soon as you tap it, and flips back if saving fails.

## 3. Handling errors with Failure and Result

Data sources are allowed to throw. The repository catches everything and turns it into one of five `Failure` types: network, server error, rate limit, invalid data, or unknown. It then returns a `Result`, which is either `Ok(value)` or `Err(failure)`.

I wrote my own `Result` instead of pulling in `dartz`. It's about 15 lines, needs no extra package, and works nicely with Dart 3 pattern matching.

On the UI side, each `Failure` type maps to a translated message. That's what lets error messages show up in Indonesian even though openFDA only answers in English.

For rate limits, a Dio interceptor retries a 429 up to three times, waiting 1, 2, and then 4 seconds. Only if all of those fail does the user see the rate limit message.

## 4. get_it for dependency injection

Everything is registered by hand in `injection_container.dart`. There are only about a dozen things to register, so adding `injectable` and another code generation step didn't seem worth it. Services are lazy singletons. Cubits are created by `BlocProvider` inside each screen, which also takes care of closing them when the screen goes away.

## 5. Hive for favorites

Favorites are stored in a Hive box, using the medication ID as the key. Hive is quick, doesn't need any native database setup, and `box.watch()` gives a stream for free. The Favorites tab listens to that stream, so when you star something on the detail page, it's already in the tab when you switch over.

I store the whole medication rather than just the ID, so the Favorites tab still works without internet.

One catch is that `hive_generator` isn't maintained anymore and is stuck on an old analyzer. That's why the code avoids newer Dart 3.10 syntax. If I kept working on this, I'd look at moving to `hive_ce`.

## 6. go_router for navigation

`StatefulShellRoute.indexedStack` gives two tabs that each keep their own state and scroll position. The detail route is outside that shell, so it opens full screen over the bottom bar. It uses a path like `/medications/:id`, which should make deep links simple to add later.

## 7. Testing

Repository tests mock both data sources and check that each kind of error ends up as the right `Failure`. The 429 case is simulated with a fake Dio error, so the real API is never called.

Cubit tests use `bloc_test` to check the state changes: loading to loaded, loading to error, pagination, retrying a failed page, and the favorite toggle with its revert.

Widget tests run the detail and favorites screens with their real cubits, with mocked use cases registered in get_it.

## 8. If this became a hospital app

Say this grew into an app with appointments, medical records, lab results, prescriptions, and notifications. Here's roughly what I'd change.

Each of those areas would get its own feature folder with its own repository, like `AppointmentRepository` and `LabResultRepository`. A single repository for everything would get hard to maintain very quickly.

The use cases would finally earn their place. Booking an appointment means checking the date, looking for clashes, saving it, and scheduling a reminder. That logic belongs in a `BookAppointment` use case, not in a cubit.

The network setup would need to grow up: a base URL in Dio's options, an interceptor that adds and refreshes auth tokens, and logging in debug builds only.

Security matters a lot more with medical data. I'd encrypt anything stored on the device, make sure no health data ends up in logs, and log the user out after a period of inactivity.

Clinics and hospitals often have patchy signal, so records and lab results should be cached locally and synced when the connection comes back.

Reminders for appointments and alerts for new lab results would come through FCM push notifications, with deep links that open the right screen.

Finally, I'd set up CI to run the analyzer and tests on every pull request, and add golden tests for the important screens.
