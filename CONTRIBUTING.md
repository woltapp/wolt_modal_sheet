# Contributing to WoltModalSheet

To get started with contributing, please follow the steps below:

1. [Fork the wolt_modal_sheet repo](https://github.com/woltapp/wolt_modal_sheet/fork) on GitHub.
2. Clone your forked repo locally.
3. Ensure you have [Melos](https://pub.dev/packages/melos/install) installed.
   ```bash
   dart pub global activate melos
   ```
4. Use Melos to bootstrap the project.
   ```bash
   melos bootstrap
   ```
5. Create a new branch from the `main` branch.
6. Make your changes.
7. Run Melos format to format the code.
   ```bash
   melos format
   ```
8. Run Melos analyze to identify any issues.
   ```bash
   melos analyze
   ```
9. Make sure all existing tests pass and add new tests for the changes you made.
   Execute the following command to run the tests.
   ```bash
   melos test
   ```
10. Create a pull request.
