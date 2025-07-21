import 'package:ashub_chatai/repo/provider/chat_provider.dart';
import 'package:ashub_chatai/widgets/mainscreenwidget/alert_box.dart';
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
  void initState() {
    super.initState();
    // Load the most recent conversation when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider
          .loadSavedConversations()
          .then((_) {
            if (chatProvider.savedConversations.isNotEmpty) {
              chatProvider.loadConversation(
                chatProvider.savedConversations.first['conversationId'],
              );
            } else {
              print('No conversations found on startup'); // Debug
            }
          })
          .catchError((e) {
            print('Failed to load conversations on startup: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No previous conversations found')),
            );
          });
    });
  }

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
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF8E53),
                          ], // Gradient colors
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      "AskHubAi",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (_) => AlertBox());
                    },
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
                          Text(
                            "Hey there 👋",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "I'm your AI buddy – ready to chat, answer, and assist!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
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
                              child: Image.asset(
                                "assets/images/glogo.png",
                                width: 30.w,
                              ),
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
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
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
                              child: Image.asset(
                                "assets/images/glogo.png",
                                width: 30.w,
                              ),
                            ),
                          ),

                        // User or Bot Message
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              gradient: isUser
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFF6B6B), // Coral red
                                        Color(
                                          0xFFFF8E53,
                                        ), // Light reddish orange
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isUser
                                  ? null
                                  : Colors.grey[200], // Use color if not user
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
                            child: Container(
                              width: 35.w,
                              height: 35.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B), // Coral red
                                    Color(0xFFFF8E53), // Light coral/orange
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Iconsax.user,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
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
