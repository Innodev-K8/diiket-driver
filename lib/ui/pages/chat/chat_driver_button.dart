import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/data/providers/firebase_provider.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/data/providers/order/chat/chat_channel_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/pages/chat/chat_page.dart';
import 'package:driver/ui/widgets/small_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatCustomerButton extends HookWidget {
  const ChatCustomerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: OutlinedButton(
        onPressed: () => _openChat(context, isLoading, isMounted),
        style: OutlinedButton.styleFrom(
          primary: ColorPallete.primaryColor,
        ),
        child: isLoading.value ? SmallLoading() : Text('Chat Pelanggan'),
      ),
    );
  }

  Future<void> _openChat(
    BuildContext context,
    ValueNotifier<bool> isLoading,
    bool Function() isMounted,
  ) async {
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
          reason: 'Channel ID: $channelId Token: $userToken  User ID: $userId',
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
  }
}
