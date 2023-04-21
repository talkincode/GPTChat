import 'package:flutter/material.dart';
import 'package:laotchat/common/appcontext.dart';
import 'package:laotchat/common/smsapi.dart';

void showApikeyAuthForm(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String apikey = "";
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('设置 APIKey ', style:  TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        contentPadding: const EdgeInsets.all(16.0),
        content: SizedBox(
          width: AppContext.isMobile() || AppContext.isWebMobile(context) ? 340 : 480,
          height: 200,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("您可以设置自己的 API key 继续使用，您的 key 将被保存在本地，仅供您使用。"),
                  TextFormField(
                    initialValue: apikey,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'APIKey', prefixIcon: Icon(Icons.key)),
                    onChanged: (value) => apikey = value,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter apikey' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(15)),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          TextButton(
             style: TextButton.styleFrom(padding: const EdgeInsets.all(15)),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                SmsApi.doLogin(apikey).then((result){
                    AppContext.showMessage(context, result.msg);
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('保存', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
