import 'package:flutter/material.dart';
import 'package:laotchat/common/appcontext.dart';
import 'package:laotchat/common/models.dart';
import 'package:laotchat/common/smsapi.dart';
import 'package:laotchat/widgets/info_item.dart';

void showUsage(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('使用详情', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        contentPadding: const EdgeInsets.all(16.0),
        content: SizedBox(
          width: AppContext.isMobile() || AppContext.isWebMobile(context) ? 340 : 480,
          height: 240,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<SubsUsageResult>(
                    future: SmsApi.getSubsUsage(),
                    builder: (BuildContext context, AsyncSnapshot<SubsUsageResult> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('加载失败: ${snapshot.error}'));
                      } else {
                        var resultData = snapshot.data;
                        if (resultData == null) {
                          return Center(child: Text('加载失败: ${snapshot.error}'));
                        }
                        SubscriptionUsage? subsUsage = resultData.data;
                        if (subsUsage == null) {
                          return const Center(child: Text(''));
                        }
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InfoItem(name: "已使用请求", value: ' ${subsUsage!.useRequests}'),
                              InfoItem(name: "已使用令牌", value: ' ${subsUsage.useTokens}'),
                              InfoItem(name: "剩余请求", value: ' ${subsUsage.remainRequests}'),
                              InfoItem(name: "剩余令牌", value: ' ${subsUsage.remainTokens}'),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(15)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('关闭', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
