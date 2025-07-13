import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/shared/webViewDisplay/webViewDisplay_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewDisplayPage extends StatefulWidget {
  const WebViewDisplayPage({Key? key}) : super(key: key);

  @override
  _WebViewDisplayPageState createState() => _WebViewDisplayPageState();
}

class _WebViewDisplayPageState extends State<WebViewDisplayPage> {
  final _webViewDisplayBloc = WebViewDisplayBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;
  int count = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
      _webViewDisplayBloc.url = _arguments['url'] ?? '';
      _webViewDisplayBloc.id = _arguments['id'] ?? -1;
      _webViewDisplayBloc.title = _arguments['title'] ?? '';
      AppComponentBase.getInstance().showProgressDialog(true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
        initialData: null,
        stream: _webViewDisplayBloc.mainStream,
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: _appTheme.primaryColor,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AssetImages.left_arrow),
                ),
              ),
              title: Text(
                _webViewDisplayBloc.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            body: BlocProvider<WebViewDisplayBloc>(
              bloc: _webViewDisplayBloc,
              child: Container(
                color: Colors.white,
                child: _webViewDisplayBloc.url == null
                    ? Container()
                    : Stack(
                        children: [
                          Opacity(
                            opacity: count > 0 ? 0 : 1,
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).padding.top -
                                      AppBar().preferredSize.height,
                                  child: InAppWebView(
                                    initialUrlRequest: URLRequest(
                                      url:
                                          WebUri(_webViewDisplayBloc.url ?? ''),
                                    ),
                                    initialSettings: InAppWebViewSettings(
                                      javaScriptEnabled: true,
                                    ),
                                    shouldOverrideUrlLoading:
                                        (controller, navigationAction) async {
                                      final uri = navigationAction.request.url;
                                      if (uri != null &&
                                          uri
                                              .toString()
                                              .startsWith("mailto:")) {
                                        await launchUrl(Uri.parse(
                                            "mailto:team@myride901.com"));
                                        return NavigationActionPolicy.CANCEL;
                                      }
                                      return NavigationActionPolicy.ALLOW;
                                    },
                                    onWebViewCreated:
                                        (InAppWebViewController controller) {
                                      Future.delayed(
                                          Duration(milliseconds: 2000), () {});
                                    },
                                    onLoadStop:
                                        (InAppWebViewController controller,
                                            Uri? url) async {
                                      ejs(controller: controller);

                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        count = 0;
                                        setState(() {});
                                        AppComponentBase.getInstance()
                                            .showProgressDialog(false);
                                      });
                                    },
                                    onProgressChanged:
                                        (InAppWebViewController controller,
                                            int progress) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (count > 0)
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  //latest version of web view, tested and approved
  void ejs({InAppWebViewController? controller}) {
    switch (_webViewDisplayBloc.id) {
      case 1:
        controller!.evaluateJavascript(
            source:
                'var a = document.getElementsByClassName("post-title")[0];');
        controller.evaluateJavascript(
            source:
                'var b = document.getElementsByClassName("main_content")[0];');
        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("single-post")[0].innerHTML = "";');
        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("single-post")[0].style.padding = "20px";');
        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("single-post")[0].append(a);');
        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("single-post")[0].append(b);');
        break;
      case 2:
      case 3:
      case 5:
      case 6:
        _webViewDisplayBloc.id = 7;
        controller!.evaluateJavascript(
            source:
                'var a = document.getElementsByClassName("elementor-section-wrap")[0];');
        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("page-template-default page")[0].innerHTML = "";');

        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("page-template-default page")[0].append(a);');
        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("elementor-heading-title elementor-size-default")[0].children[0].remove();');
        controller.evaluateJavascript(
            source:
                'document.getElementsByClassName("elementor-heading-title elementor-size-default")[0].children[0].remove();');
        break;
      case 7:
    }
  }
}
