/// A contract for managing access to dependency containers, including subscribing to,
/// unsubscribing from, and resolving container instances.
///
/// Implementations of this interface are responsible for adding and removing the subscription of
/// objects to containers, as well as resolving and providing active instances of
/// those containers.
///
/// This interface ensures that dependency containers are accessible, created, and
/// disposed of based on their usage within the application, promoting efficient
/// resource management and modular design.
abstract interface class DependencyContainerResolver {
  /// Subscribes an object to a dependency container of type [C].
  ///
  /// This method registers an object as a subscriber to the specified container type [C],
  /// ensuring that the container is instantiated and available for use. If no container
  /// instance of type [C] exists when a subscription is made, this method will create
  /// the container using the associated factory function. Otherwise, the existing container will
  /// be used, and the subscriber will be added to the list of subscribers for that container.
  ///
  /// [subscriber]: The object that subscribes to the container of type [C].
  ///
  /// **Example**:
  /// ```dart
  /// containerManager.subscribeToContainer<MyFeatureContainer>(this);
  /// ```
  void subscribeToContainer<C>(Object subscriber);

  /// Unsubscribes an object from a dependency container of type [C], managing its access.
  ///
  /// This method removes a subscriber from the specified container type [C]. If there are
  /// no remaining subscribers for the container after this operation, the container will
  /// be disposed of, releasing any resources it holds.
  ///
  /// [subscriber]: The object that unsubscribes from the container of type [C].
  ///
  /// **Example**:
  /// ```dart
  /// containerManager.unsubscribeFromContainer<MyFeatureContainer>(this);
  /// ```
  void unsubscribeFromContainer<C>(Object subscriber);

  /// Retrieves the active instance of a dependency container of type [C].
  ///
  /// This method returns the currently active container of the specified type [C]. If the
  /// container does not exist or has not been instantiated (since it has not been subscribed to)
  /// an error is thrown. Ensure that the container type [C] has been correctly registered with
  /// a factory function and has at least one active subscriber before calling this method.
  ///
  /// Throws [StateError] if the container of type [C] does not exist.
  ///
  /// **Example**:
  /// ```dart
  /// final myFeatureContainer = containerManager.getDependencyContainer<MyFeatureContainer>();
  /// ```
  C getDependencyContainer<C>();
}
