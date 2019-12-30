# 微信支付

## 微信支付时序图

![微信支付时序图](/img/wechat/wxa-7-2.jpg "时序图")

## 微信支付流程

1. 小程序内登陆，获取用户openid[【小程序登陆api】](https://developers.weixin.qq.com/miniprogram/dev/api/open-api/login/wx.login.html)
2. 服务端调用统一下单[【统一下单api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=9_1&index=1)
3. 服务端调用再次签名[【再次签名api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=7_7&index=3)
4. 服务端接受支付通知[【支付结果通知api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=9_7)
5. 服务端查询支付结果[【查询订单api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=9_2)

## 名次解释

1. 微信公众平台

> 微信公众平台是微信公众账号申请入口和管理后台。商户可以在公众平台提交基本资料、业务资料、财务资料申请开通微信支付功能。

> 平台入口：http://mp.weixin.qq.com。

2. 微信开放平台

> 微信开放平台是商户APP接入微信支付开放接口的申请入口，通过此平台可申请微信APP支付。

> 平台入口：http://open.weixin.qq.com。

3. 微信商户平台

> 微信商户平台是微信支付相关的商户功能集合，包括参数配置、支付数据查询与统计、在线退款、代金券或立减优惠运营等功能。

> 平台入口：http://pay.weixin.qq.com。

4. 微信企业号

> 微信企业号是企业号的申请入口和管理后台，商户可以在企业号提交基本资料、业务资料、财务资料申请开通微信支付功能。

> 企业号入口：http://qy.weixin.qq.com。

5. 微信支付系统

> 微信支付系统是指完成微信支付流程中涉及的API接口、后台业务处理系统、账务系统、回调通知等系统的总称。

6. 微信小程序

> 微信小程序是微信提供给商户实现APP的一种轻应用，开发起来简单，易用。

> 入口：https://mp.weixin.qq.com/debug/wxadoc/dev/。

7. 商户后台系统

> 商户后台系统是商户后台处理业务系统的总称，例如：商户网站、收银系统、进销存系统、发货系统、客服系统等。

8. 商户证书

> 商户证书是微信提供的二进制文件，商户系统发起与微信支付后台服务器通信请求的时候，作为微信支付后台识别商户真实身份的凭据。

9. 签名

> 商户后台和微信支付后台根据相同的密钥和算法生成一个结果，用于校验双方身份合法性。签名的算法由微信支付制定并公开，常用的签名方式有：MD5、SHA1、SHA256、HMAC等。

10. JSAPI网页支付

> JSAPI网页支付即前文说的公众号支付，可在微信公众号、朋友圈、聊天会话中点击页面链接，或者用微信“扫一扫”扫描页面地址二维码在微信中打开商户HTML5页面，在页面内下单完成支付。

11. 支付密码

> 支付密码是用户开通微信支付时单独设置的密码，用于确认支付完成交易授权。该密码与微信登录密码不同。

12. Openid

> 用户在小程序内的身份标识，不同小程序拥有不同的openid。商户后台系统通过登录授权、支付通知、查询订单等API可获取到用户的openid。主要用途是判断同一个用。可调用接口获取openid。
