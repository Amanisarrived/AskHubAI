import 'package:ashub_chatai/repo/provider/chat_provider.dart';
import 'package:ashub_chatai/widgets/mainscreenwidget/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ashub_chatai/widgets/mainscreenwidget/bot_message.dart';
import '../../widgets/mainscreenwidget/chat_inputfeild.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideDrawer(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(Iconsax.menu5, size: 24.sp),
                  ),
                  Text(
                    'AskHubAI',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF6B6B),
                    ),
                  ),
                  IconButton(
                    onPressed: () => chatProvider.clearMessages(),
                    icon: Icon(Iconsax.trash, size: 24.sp),
                    tooltip: 'Clear Chat',
                  ),
                ],
              ),
            ),

            // Chat Area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: chatProvider.messages.isEmpty
                    ? 1
                    : chatProvider.messages.length +
                    (chatProvider.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (chatProvider.messages.isEmpty &&
                      index == 0 &&
                      !chatProvider.isLoading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Column(
                        children: [
                          Text("Hey there 👋", style: TextStyle(fontSize: 20.sp)),
                          SizedBox(height: 5.h),
                          Text(
                            "I'm your AI buddy – ready to chat, answer, and assist!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                          ),
                        ],
                      ),
                    );
                  }

                  if (chatProvider.isLoading &&
                      index == chatProvider.messages.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.w, top: 2.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset("assets/images/logo.png", width: 30.w),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Lottie.asset(
                                'assets/images/typing.json',
                                width: 40.w,
                                height: 20.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final message = chatProvider.messages[index];
                  final isUser = message.role == 'user';

                  return Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isUser)
                          Padding(
                            padding: EdgeInsets.only(right: 8.w, top: 8.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset("assets/images/logo.png", width: 30.w),
                            ),
                          ),

                        // User or Bot Message
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color(0xFFFF6B6B)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: isUser
                                ? Text(
                              message.content,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            )
                                : BotMessage(data: message.content),
                          ),
                        ),

                        if (isUser)
                          Padding(
                            padding: EdgeInsets.only(left: 8.w, top: 8.h),
                            child: Icon(
                              Iconsax.user,
                              size: 20.sp,
                              color: const Color(0xFFFF6B6B),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Error Display
            if (chatProvider.errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chatProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red, size: 20.sp),
                      onPressed: () => chatProvider.clearError(),
                      tooltip: 'Dismiss Error',
                    ),
                  ],
                ),
              ),

            // Input Field
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: ChatInputfeild(
                controller: _controller,
                onSend: () {
                  chatProvider.sendMessage(_controller.text);
                  _controller.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
