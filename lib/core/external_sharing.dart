import 'package:data_soft/core/toast_message.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showlaunchUrl(url, {msg}) async {
  var urli = Uri.parse(url);
  try {
    if (!await launchUrl(urli)) {
      showToast(msg ?? "could not launch");
    }
  } catch (e) {
    showToast(msg ?? e);
  }
}

openAttachFile(attachUrl) {
  if (attachUrl != null) {
    showlaunchUrl("http://154.38.165.213:1212$attachUrl");
  }
}
