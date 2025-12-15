// DeviceList.ets

import router from '@ohos.router';
import { DeviceModel } from '../model/DeviceModel';
import { LightDevice } from '../model/LightDevice';
import { ACDevice } from '../model/ACDevice';
import { LockDevice } from '../model/LockDevice';
// ⚠️ 导入新增的 CameraDevice
import { CameraDevice } from '../model/CameraDevice';

@Entry
@Component
struct DeviceList {
  @State devices: DeviceModel[] = [];

  aboutToAppear(): void {
    // ⚠️ 新增 CameraDevice 实例
    this.devices = [
      new LightDevice('1', '客厅灯'),
      new ACDevice('2', '卧室空调'),
      new LockDevice('3', '前门锁'),
      new CameraDevice('4', '走廊摄像头') // 新增设备
    ];
    console.info('DeviceList: 已加载硬编码设备列表。');
  }

  private getIcon(type: string): Resource {
    // ⚠️ 添加 'camera' 类型的图标路径
    switch (type) {
      case 'light': return $r('app.media.light_on'); // 假设 media 文件夹内有 light_on.png
      case 'ac': return $r('app.media.ac_icon');     // 假设 media 文件夹内有 ac_icon.png
      case 'lock': return $r('app.media.lock_icon'); // 假设 media 文件夹内有 lock_icon.png
      case 'camera': return $r('app.media.camera_icon'); // 假设 media 文件夹内有 camera_icon.png
      default: return $r('app.media.light_on');
    }
  }

  build() {
    Column() {
      Text('智能家居设备列表')
        .fontSize(28)
        .margin({ bottom: 30 })

      List({ space: 15 }) {
        ForEach(this.devices, (device: DeviceModel) => {
          ListItem() {
            Row() {
              Image(this.getIcon(device.type))
                .width(56)
                .height(56)

              Column() {
                Text(device.name)
                  .fontSize(20)
                Text(`类型: ${device.type}, 状态: ${device.status}`)
                  .fontSize(15)
                  .fontColor(Color.Gray)
              }
              .margin({ left: 16 })
            }
            .padding(20)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .onClick(() => {
              router.pushUrl({ url: 'pages/DeviceControl', params: { deviceId: device.id } });
            })
          }
        }, (device: DeviceModel) => device.id)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
    .padding({ top: 50 })
    .justifyContent(FlexAlign.Start)
  }
}