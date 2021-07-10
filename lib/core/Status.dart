abstract class IStatus {
  bool get isSuccess;

  bool get isError;

  bool get isLoading;

  bool get isLoaded;

  Exception? get errorData;
}

class Status<T> implements IStatus {
  bool isSuccess = false;
  bool isError = false;
  bool isLoading = false;
  bool isLoaded = false;
  T? data;
  Exception? errorData;

  Status({this.data});

  factory Status.init(T data) {
    return Status(data: data);
  }

  setSuccess(T data) {
    isSuccess = true;
    isError = false;
    isLoading = false;
    isLoaded = true;
    errorData = null;
    this.data = data;
  }

  setError(Exception e) {
    isSuccess = false;
    isError = true;
    isLoading = false;
    isLoaded = true;
    errorData = e;
    data = null;
  }

  setLoading() {
    isSuccess = false;
    isError = false;
    isLoading = true;
    isLoaded = false;
  }
}

class StatusList<T> implements IStatus {
  bool isSuccess = false;
  bool isError = false;
  bool isLoading = false;
  bool isLoaded = false;
  List<T> items = [];
  Exception? errorData;

  setSuccess(List<T> items) {
    isSuccess = true;
    isError = false;
    isLoading = false;
    isLoaded = true;
    errorData = null;
    this.items = items;
  }

  setError(Exception e) {
    isSuccess = false;
    isError = true;
    isLoading = false;
    isLoaded = true;
    errorData = e;
    items = [];
  }

  setLoading() {
    isSuccess = false;
    isError = false;
    isLoading = true;
    isLoaded = false;
  }
}
