enum LoadState { 
  loading, loaded, notInitalized }


extension LoadStateExtensions on LoadState{
  bool get isLoading => this == LoadState.loading;
  bool get isLoaded => this == LoadState.loaded;
  bool get isNotInitalized => this == LoadState.notInitalized;
  bool get isInitalized => this != LoadState.notInitalized;
}