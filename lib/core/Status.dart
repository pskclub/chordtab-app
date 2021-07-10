abstract class IStatus {
  bool get isSuccess;

  bool get isError;

  bool get isLoading;

  bool get isLoaded;

  Exception? get errorData;
}

class BaseStatus implements IStatus {
  bool isSuccess = false;
  bool isError = false;
  bool isLoading = false;
  bool isLoaded = false;
  Exception? errorData;

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

class Status<T> extends BaseStatus implements IStatus {
  T? data;

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

  @override
  setError(Exception e) {
    super.setError(e);
    data = null;
  }
}

class StatusList<T> extends BaseStatus implements IStatus {
  List<T> items = [];

  setSuccess(List<T> items) {
    isSuccess = true;
    isError = false;
    isLoading = false;
    isLoaded = true;
    errorData = null;
    this.items = items;
  }

  @override
  setError(Exception e) {
    super.setError(e);
    items = [];
  }
}
