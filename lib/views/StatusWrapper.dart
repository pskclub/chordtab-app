import 'package:chordtab/core/Status.dart';
import 'package:flutter/cupertino.dart';

class StatusWrapper extends StatelessWidget {
  final Status status;
  final Widget body;
  final Widget? loading;
  final Widget? error;

  const StatusWrapper({
    Key? key,
    required this.status,
    required this.body,
    this.loading,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status.isSuccess) {
      return body;
    }

    if (status.isLoading) {
      if (loading != null) {
        return loading!;
      }
    }

    if (status.isError) {
      if (error != null) {
        return error!;
      }
    }

    return Container();
  }
}
