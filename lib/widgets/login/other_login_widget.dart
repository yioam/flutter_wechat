import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/widgets/transition/slide_transition_x.dart';

import 'package:flutter_wechat/widgets/login/login_title_widget.dart';
import 'package:flutter_wechat/widgets/text_field/mh_text_field.dart';

import 'package:flutter_wechat/views/login/phone_login/phone_login_page.dart';

class OtherLoginWidget extends StatefulWidget {
  OtherLoginWidget({Key key}) : super(key: key);

  _OtherLoginWidgetState createState() => _OtherLoginWidgetState();
}

class _OtherLoginWidgetState extends State<OtherLoginWidget> {
  // 切换登陆方式
  bool _showPasswordWay = true;

  // 切换名称
  String get _changeLoginName => _showPasswordWay ? "用微信号/QQ号/邮箱登录" : "用手机号登录";

  // loginBtnTitle
  String get _loginBtnTitle => _showPasswordWay ? "下一步" : "登录";

  // 登录按钮是否无效
  bool get _loginBtnDisabled {
    print('xxx  ${_phoneController.text}');
    return _showPasswordWay
        ? _phoneController.text.isEmpty
        : _accountController.text.isEmpty || _passwordController.text.isEmpty;
  }

  // 屏幕宽
  double _screenWidth = 0;

  /// 按钮

  /// zone控制输入
  final TextEditingController _zoneController = TextEditingController(text: '');

  /// phone控制输入
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  /// account控制输入
  final TextEditingController _accountController =
      TextEditingController(text: '');

  /// password控制输入
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _zoneController.text = '86';
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return _buildChidWidgets();
  }

  /// -------------------- 事件 --------------------
  void _login() {
    if (_loginBtnDisabled) {
      return;
    }
    if (_showPasswordWay) {
      // 跳转到手机登陆
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (_) {
            print('xxxxoooo ${_phoneController.text}');
            return PhoneLoginPage(
              phone: _phoneController.text,
              zoneCode: _zoneController.text,
            );
          },
        ),
      );
    } else {
      // 登陆
    }
  }

  /// -------------------- UI --------------------

  /// 初始化子部件
  Widget _buildChidWidgets() {
    return Container(
      padding: EdgeInsets.only(top: 90.0),
      width: double.maxFinite,
      child: Column(
        children: <Widget>[
          _buildTitleInputWidget(),
          _buildChangeButtonWidget(),
          _buildLoginButtonWidget(),
        ],
      ),
    );
  }

  /// 构建标题+输入小部件
  Widget _buildTitleInputWidget() {
    // 动画组件
    var animatedSwitcher = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        //执行缩放动画
        return SlideTransitionX(
          child: child, position: animation,
          direction: AxisDirection.left, //右入左出
        );
      },
      child:
          _showPasswordWay ? _buildPhoneLoginWidget() : _buildQQLoginWidget(),
    );

    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: animatedSwitcher,
    );
  }

  /// 构建手机号登录的Widgets
  Widget _buildPhoneLoginWidget() {
    return Container(
      key: ValueKey('phone'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LoginTitleWidget(title: '手机号登录'),
          _buildSelectZoneWidget(),
          _buildDivider(),
          _buildZoneAndPhoneInputWidget(),
          _buildDivider(),
        ],
      ),
      width: double.maxFinite,
    );
  }

  /// 构建选择地区的Widget
  Widget _buildSelectZoneWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 105.0,
              child: Text(
                '国家/地区',
                style: TextStyle(
                  color: Style.pTextColor,
                  fontSize: 17.0,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '中国大陆',
                style: TextStyle(
                  color: Style.pTextColor,
                  fontSize: 17.0,
                ),
              ),
            ),
            Image.asset(
              Constant.assetsImages + 'tableview_arrow_8x13.png',
              width: 8.0,
              height: 13.0,
            )
          ],
        ),
      ),
    );
  }

  /// 构建地区部和手机 输入小部件
  Widget _buildZoneAndPhoneInputWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: MHTextField(
                    controller: _zoneController,
                    prefixMode: MHTextFieldWidgetMode.always,
                    clearButtonMode: MHTextFieldWidgetMode.never,
                    maxLength: 4,
                    prefix: Text(
                      '+',
                      style: TextStyle(
                        color: Style.pTextColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 10.0,
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: .5, color: Style.pDividerColor),
              ),
            ),
            child: SizedBox(
              height: 24.0,
              width: 10.0,
            ),
          ),
          Expanded(
            child: MHTextField(
              controller: _phoneController,
              hintText: '请填写手机号码',
              onChanged: (value) {
                // _phoneController.text = value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建微信号/QQ号/邮箱登录的Widgets
  Widget _buildQQLoginWidget() {
    return Container(
      key: ValueKey('account'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LoginTitleWidget(title: '微信号/QQ号/邮箱登录'),
          _buildAccountOrPasswordWidget(_accountController, '账号', '微信号/QQ号/邮箱'),
          _buildDivider(),
          _buildAccountOrPasswordWidget(_passwordController, '密码', '请填写密码'),
          _buildDivider(),
        ],
      ),
      width: double.maxFinite,
    );
  }

  /// 构建账号/密码小部件
  Widget _buildAccountOrPasswordWidget(
    TextEditingController controller,
    String title,
    String placeholder,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 105.0,
            child: Text(
              title,
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: 17.0,
              ),
            ),
          ),
          Expanded(
            child: MHTextField(
              controller: controller,
              hintText: placeholder,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建切换按钮部件
  Widget _buildChangeButtonWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 34.0, right: 20.0),
      width: double.maxFinite,
      child: InkWell(
        onTap: () {
          setState(() {
            _showPasswordWay = !_showPasswordWay;
          });
        },
        child: Text(
          _changeLoginName,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color(0xFF5b6a91),
            fontSize: 16.0,
          ),
        ),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
    );
  }

  /// 构建登陆按钮部件
  Widget _buildLoginButtonWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 63.0, right: 20.0, bottom: 0),
      child: Opacity(
        opacity: _loginBtnDisabled ? 0.5 : 1,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 24.0),
                color: Style.pTintColor,
                highlightColor:
                    _loginBtnDisabled ? Colors.transparent : Style.sTintColor,
                splashColor: _loginBtnDisabled ? Colors.transparent : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                onPressed: _login,
                child: Text(
                  _loginBtnTitle,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 构建分割线
  Widget _buildDivider() {
    return Divider(
      height: 0.5,
      indent: 20.0,
      endIndent: 20.0,
      color: Style.pDividerColor,
    );
  }
}
