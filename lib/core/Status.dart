class Status {
  bool isSuccess = false;
  bool isError = false;
  bool isLoading = true;
  bool isLoaded = false;
  Exception? errorData;

  setSuccess() {
    isSuccess = true;
    isError = false;
    isLoading = false;
    isLoaded = true;
    errorData = null;
  }

  setError(Exception e) {
    isSuccess = false;
    isError = true;
    isLoading = false;
    isLoaded = true;
    errorData = e;
  }

  setLoading() {
    isSuccess = false;
    isError = false;
    isLoading = true;
    isLoaded = false;
  }
}
