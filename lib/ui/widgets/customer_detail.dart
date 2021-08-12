import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/data/providers/firebase_provider.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/data/providers/order/chat/chat_channel_provider.dart';
import 'package:driver/ui/common/helper.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/pages/chat/chat_page.dart';
import 'package:driver/ui/widgets/small_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'detail_item.dart';

class CustomerDetail extends StatelessWidget {
  final Order order;

  const CustomerDetail({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 2),
      decoration: kBorderedDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detail Pelanggan",
            style: kTextTheme.headline3,
          ),
          SizedBox(
            height: 10,
          ),
          DetailItem(
            title: 'Nama',
            value: Text(
              order.user?.name ?? '-',
            ),
          ),
          SizedBox(
            height: 16,
          ),
          DetailItem(
            title: 'Alamat',
            value: Text(
              order.address ?? '-',
            ),
          ),
          SizedBox(
            height: 16,
          ),
          DetailItem(
            title: 'Jarak Pengiriman',
            value: Text(
              Helper.fmtMetricDistance(order.delivery_distance ?? 0),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Hubungi",
                  style: kTextTheme.headline5,
                ),
              ),
              Spacer(),
              TextButton.icon(
                style:
                    TextButton.styleFrom(primary: ColorPallete.secondaryColor),
                onPressed: () {
                  final phoneNumber = order.user?.phone_number;

                  if (phoneNumber == null) {
                    Utils.alert(context, 'Tidak  dapat menghubungi penjual');
                    return;
                  }

                  Utils.prompt(context, description: 'Telepon pelanggan?',
                      onConfirm: () async {
                    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
                  });
                },
                icon: Icon(
                  Icons.phone,
                  size: 18,
                ),
                label: Text("Telp"),
              ),
              OpenChatButton(),
            ],
          )
        ],
      ),
    );
  }
}

class OpenChatButton extends HookWidget {
  const OpenChatButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final isMounted = useIsMounted();

    return TextButton.icon(
      style: TextButton.styleFrom(primary: ColorPallete.secondaryColor),
      onPressed: isLoading.value
          ? null
          : () async {
              if (isMounted()) {
                isLoading.value = true;
              }

              final user = context.read(authProvider);
              final order = context.read(activeOrderProvider);

              final channelId = order?.stream_chat_channel;
              final userToken = user?.stream_chat_token;
              final userId = user?.id.toString();

              try {
                // check if null
                if (channelId == null || userToken == null || userId == null) {
                  throw CustomException(
                    message: 'Tidak dapat menghubungkan ke chat',
                    reason:
                        'Channel ID: $channelId Token: $userToken  User ID: $userId',
                  );
                }

                await context.read(orderChatChannelProvider.notifier).connect(
                      channelId: channelId,
                      userToken: userToken,
                      userId: userId,
                    );

                Navigator.of(context).pushNamed(ChatPage.route);
              } catch (exception, st) {
                context.read(crashlyticsProvider).recordError(exception, st);

                Utils.alert(context, 'Gagal menghubungkan ke chat');

                return;
              } finally {
                if (isMounted()) {
                  isLoading.value = false;
                }
              }
            },
      icon: Icon(
        Icons.chat_bubble,
        size: 18,
      ),
      label: isLoading.value ? SmallLoading() : Text("Chat"),
    );
  }
}
