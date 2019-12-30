# 微信支付

## 微信支付时序图

![微信支付时序图](/img/wechat/wxa-7-2.jpg "时序图")

## 微信支付流程

1. 小程序内登陆，获取用户openid[【小程序登陆api】](https://developers.weixin.qq.com/miniprogram/dev/api/open-api/login/wx.login.html)
2. 服务端调用统一下单[【统一下单api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=9_1&index=1)
3. 服务端调用再次签名[【再次签名api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=7_7&index=3)
4. 服务端接受支付通知[【支付结果通知api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=9_7)
5. 服务端查询支付结果[【查询订单api】](https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=9_2)