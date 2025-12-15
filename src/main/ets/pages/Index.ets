import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('欢迎使用智能家居模拟器')
        .fontSize(24)
        .margin({ top: 50 })
      Button('进入设备列表')
        .onClick(() => {
          router.pushUrl({ url: 'pages/DeviceList' });
        })
        .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}