# Wolt State Management Package

Welcome to the **Wolt State Management** package! This internal package provides
a simple and efficient way to manage and represent the state of asynchronous
data in your Flutter applications.

## Table of Contents

- [Getting Started](#getting-started)
    - [Adding the Package to Your Project](#adding-the-package-to-your-project)
    - [Importing the Package](#importing-the-package)
- [Core Concepts](#core-concepts)
    - [ValueState](#valuestate)
    - [StatefulValueNotifier](#statefulvaluenotifier)
    - [StatefulValueListenableBuilder](#statefulvaluelistenablebuilder)
- [Usage Examples](#usage-examples)
    - [Basic Usage](#basic-usage)
    - [Using StatefulValueListenableBuilder](#using-statefulvaluelistenablebuilder)
- [Additional Notes](#additional-notes)
    - [Handling Last Known Values](#handling-last-known-values)
    - [Optimizing with the `child` Parameter](#optimizing-with-the-child-parameter)

---

## Getting Started

### Adding the Package to Your Project

Since this is an internal package and not published on pub.dev, you can add it
to your project using a local path. In your `pubspec.yaml` file, add:

```yaml
dependencies:
  wolt_state_management:
    path: ./packages/state_management
```

### Importing the Package

Import the package in your Dart code:

```dart
import 'package:wolt_state_management/wolt_state_management.dart';
```

## Core Concepts

### ValueState

`ValueState<T>` is a sealed class that represents the current state of a value of type T. It can be in one of three states:

- **Idle**: The value is successfully loaded or initialized.
- **Loading**: The value is in the process of being loaded or processed.
- **Error**: An error occurred during loading or processing.

#### IdleValueState
Represents the successful state with an optional value.

```dart
ValueState<int> state = ValueState.idle(42);
```

#### LoadingValueState
Represents the loading state with an optional last known value.

```dart
ValueState<int> loadingState = ValueState.loading(lastKnownValue: 42);
ValueState<int> loadingState = ValueState.loading();
```

#### ErrorValueState
Represents the error state with an exception and an optional last known value.

```dart
ValueState<int> errorState = ValueState.error(Exception('An error occurred'), 42);
ValueState<int> errorState = ValueState.error(Exception('An error occurred'));
```

### StatefulValueNotifier

`StatefulValueNotifier<T> extends ValueNotifier<ValueState<T>>` and 
implements `StatefulValueListenable<T>`. It provides methods to update the 
state and retains the last known value automatically during state transitions.

```dart
final notifier = StatefulValueNotifier<int>(0);
```

Methods
- **setIdle([T? value])**: Sets the state to idle.
- **setLoading({T? lastKnownValue})**: Sets the state to loading.
- **setError([Exception? error, T? lastKnownValue])**: Sets the state to error.

### StatefulValueListenableBuilder

A widget that listens to a StatefulValueListenable<T> and rebuilds itself based on the current state.

```dart
StatefulValueListenableBuilder<int>(
  valueListenable: listenable,
  idleBuilder: (context, value, child) => Text('Value: $value'),
  loadingBuilder: (context, lastKnownValue, child) => CircularProgressIndicator(),
  errorBuilder: (context, error, lastKnownValue, child) => Text('Error: $error'),
);
```

## Usage Examples

### Basic Usage

Step 1: Create a `StatefulValueNotifier

```dart
final notifier = StatefulValueNotifier<String>();
```

Step 2: Update the State

```dart
// Set to idle state with a value
notifier.setIdle('Data loaded');

// Transition to loading state
notifier.setLoading();

// Transition to error state
notifier.setError(Exception('Failed to load data'));
```

Step 3: Listen to State Changes

```dart
notifier.addListener(() {
  final state = notifier.value;
  if (state.isIdle) {
    print('Idle: ${state.currentValue}');
  } else if (state.isLoading) {
    print('Loading, last known value: ${state.currentValue}');
  } else if (state.isError) {
    print('Error: ${(state as ErrorValueState).error}');
  }
});
```

### Using StatefulValueListenableBuilder

#### ViewModel

```dart
class CounterViewModel {
  final StatefulValueNotifier<int> _counterNotifier = StatefulValueNotifier<int>(0);

  StatefulValueListenable<int> get counter => _counterNotifier;

  void increment() {
    _counterNotifier.setLoading();
    Future.delayed(Duration(seconds: 1), () {
      _counterNotifier.setIdle((_counterNotifier.currentValue ?? 0) + 1);
    });
  }

  void causeError() {
    _counterNotifier.setError(Exception('An error occurred'));
  }
}
```

#### UI

```dart
class CounterView extends StatelessWidget {
  final CounterViewModel viewModel;

  CounterView(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return StatefulValueListenableBuilder<int>(
      valueListenable: viewModel.counter,
      idleBuilder: (context, value) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Value: $value'),
            ElevatedButton(
              onPressed: viewModel.increment,
              child: Text('Increment'),
            ),
            ElevatedButton(
              onPressed: viewModel.causeError,
              child: Text('Cause Error'),
            ),
          ],
        );
      },
      loadingBuilder: (context, lastKnownValue) {
        return Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, value) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error.toString()}'),
            ElevatedButton(
              onPressed: viewModel.increment,
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }
}
```

## Additional Notes

### Handling Last Known Values

The `lastKnownValue` is used in the Loading and Error states to retain the 
most recent successful value. This allows you to display or use the previous 
value while new data is being fetched or when an error occurs, improving 
user experience.

```dart
// Loading with last known value
notifier.setLoading();

// Accessing the last known value
final lastValue = notifier.currentValue;
```

### Optimizing with the `child` Parameter

The `child` parameter in `StatefulValueListenableBuilder` allows you to pass 
a widget that does not depend on the valueListenable. This widget is not 
rebuilt when the state changes, improving performance.

```dart
final staticButton = ElevatedButton(
  onPressed: () {},
  child: Text('Static Button'),
);

StatefulValueListenableBuilder<int>(
  valueListenable: notifier,
  child: staticButton,
  idleBuilder: (context, value) {
    return Column(
      children: [
        Text('Value: $value'),
        child!, // Use the child here
      ],
    );
  },
  // Other builders...
);
```

Important:

- Ensure that any widget passed as child does not depend on the valueListenable.
- Use the child parameter to improve performance by avoiding unnecessary rebuilds.
