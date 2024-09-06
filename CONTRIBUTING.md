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

5. Ensure DCM (dcm.dev) is installed and activated
      - Enabling and activating DCM is optional. When you open a PR, the CI bots will show you any DCM warnings introduced
      by your change which should be fixed before submitting. please follow instructions at <https://dcm.dev/pricing/>. You can either use the free tier of DCM, or purchase a pro or team license. Note that the free tier doesn't support all the rules of the paid tier, so you will also need to consult the output of the `Dart Code Metrics workflow on Github` when you open your PR. To enable DCM check this [quick start guide](https://dcm.dev/docs/quick-start/)

6. Create a new branch from the `main` branch.
7. Make your changes.
8. Run Melos format to format the code.

      ```bash
      melos format
      ```

9. Run Melos analyze to identify any issues.
      - Note, if you don't have DCM install locally, this command will fail, but you can check PR's CI output after sending your PR.

      ```bash
      melos analyze
      ```

10. Make sure all existing tests pass and add new tests for the changes you made. Execute the following command to run the tests.

      ```bash
      melos test
      ```

11. Create a pull request.
