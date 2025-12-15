import router from '@ohos.router';
// 导入所有模型，确保路径正确
import { DeviceModel } from '../model/DeviceModel';
import { LightDevice } from '../model/LightDevice';
import { ACDevice } from '../model/ACDevice';
import { LockDevice } from '../model/LockDevice';
import { CameraDevice } from '../model/CameraDevice';

// 严格定义路由参数接口，修复 'any' 和 'Object' 错误
interface RouteParams {
  deviceId: string;
}

// 严格定义设备数据接口，修复数组和对象字面量错误
interface DeviceJson {
  id: string;
  name: string;
  type: 'light' | 'ac' | 'lock' | 'camera' | string;
}

@Entry
@Component
struct DeviceControl {
  @State device: DeviceModel | null = null;

  aboutToAppear() {
    // 修复 'any' 和 'Object' 错误：使用显式接口类型接收参数
    const params: RouteParams | null = router.getParams() as RouteParams | null;

    let deviceId: string = '';

    // 修复 'Object.keys()' 错误：因为我们已经严格定义了 RouteParams 且设备列表是硬编码的，
    // 我们直接安全地检查 deviceId 属性是否存在。
    if (params && params.deviceId) {
      deviceId = params.deviceId;
    }

    // --- 硬编码数据 (修复 Array literals 和 Object literal 错误) ---
    const MOCK_DATA: DeviceJson[] = [
      { id: "1", name: "客厅灯", type: "light" },
      { id: "2", name: "卧室空调", type: "ac" },
      { id: "3", name: "前门锁", type: "lock" },
      { id: "4", name: "走廊摄像头", type: "camera" }
    ];
    const data: DeviceJson[] = MOCK_DATA;
    // ---------------------------------------------

    if (deviceId) {
      const item: DeviceJson | undefined = data.find((d: DeviceJson) => d.id === deviceId);

      if (item) {
        switch (item.type) {
          case 'light':
            this.device = new LightDevice(item.id, item.name);
            break;
          case 'ac':
            this.device = new ACDevice(item.id, item.name);
            break;
          case 'lock':
            this.device = new LockDevice(item.id, item.name);
            break;
          case 'camera':
            this.device = new CameraDevice(item.id, item.name);
            break;
          default:
            this.device = new DeviceModel(item.id, item.name, item.type);
        }
      }
    }

    if (!this.device) {
      this.device = new LightDevice('default_001', '默认设备 (灯光)');
    }
  }

  build() {
    Column() {
      // 检查 this.device 非空
      if (this.device) {
        // 使用非空断言 '!' 确保属性访问安全
        Text(this.device!.name)
          .fontSize(28)
          .margin({ top: 20, bottom: 20 })

        // --- 灯光控制 ---
        if (this.device instanceof LightDevice) {
          Text('状态: ' + this.device!.status.toUpperCase())
          Toggle({ type: ToggleType.Switch, isOn: this.device!.status === 'on' })
            .onChange(() => {
              if (this.device) {
                this.device!.toggleStatus();
              }
            })
            .margin(10)

          Text('亮度: ' + (this.device as LightDevice)!.brightness + '%')
          Slider({ value: (this.device as LightDevice)!.brightness, min: 0, max: 100 })
            .onChange((value: number) => {
              (this.device as LightDevice)!.setBrightness(value);
            })
            .width('80%')
            .margin(10)

          // --- 空调控制 ---
        } else if (this.device instanceof ACDevice) {
          Text('状态: ' + this.device!.status.toUpperCase())
          Toggle({ type: ToggleType.Switch, isOn: this.device!.status === 'on' })
            .onChange(() => {
              if (this.device) {
                this.device!.status = this.device!.status === 'on' ? 'off' : 'on';
              }
            })
            .margin(10)

          Text('温度: ' + (this.device as ACDevice)!.temperature + '°C')
            .margin({ top: 15 })
          Slider({ value: (this.device as ACDevice)!.temperature, min: 16, max: 30 })
            .onChange((value: number) => {
              (this.device as ACDevice)!.setTemperature(value);
            })
            .width('80%')
            .margin(10)

          // --- 门锁控制 (已增强) ---
        } else if (this.device instanceof LockDevice) {
          // ⚠️ 修复 UI 语法错误：将 (this.device as LockDevice)! 的断言和非空操作直接写入表达式中，避免使用 const 语句

          // 1. 操控开关：门锁是否在线/通电
          Text('设备通电状态: ' + (this.device as LockDevice)!.status.toUpperCase())
            .fontSize(20)
            .margin({ top: 10 })
          Toggle({ type: ToggleType.Switch, isOn: (this.device as LockDevice)!.status === 'on' })
            .onChange(() => {
              (this.device as LockDevice)!.toggleStatus();
            })
            .margin(10)

          // 2. 核心状态：锁定/解锁
          Text('门锁状态: ' + ((this.device as LockDevice)!.isLocked ? '🔒 已锁定' : '🔓 已解锁'))
            .fontSize(24)
            .fontColor((this.device as LockDevice)!.isLocked ? Color.Red : Color.Green)
            .margin({ top: 20 })
          Button((this.device as LockDevice)!.isLocked ? '解锁' : '锁定')
            .type(ButtonType.Normal)
            .onClick(() => {
              (this.device as LockDevice)!.toggleLock();
            })
            .margin(15)
            .enabled((this.device as LockDevice)!.status === 'on')

          // 3. 切换安全等级
          Text('安全等级: ' + (this.device as LockDevice)!.securityLevel)
            .fontSize(20)
            .margin({ top: 10 })
          Row() {
            Button('普通模式')
              .onClick(() => (this.device as LockDevice)!.setSecurityLevel('Normal'))
              .enabled((this.device as LockDevice)!.status === 'on')
              .backgroundColor((this.device as LockDevice)!.securityLevel === 'Normal' ? Color.Blue : Color.Gray)

            Button('高安全模式')
              .onClick(() => (this.device as LockDevice)!.setSecurityLevel('High'))
              .enabled((this.device as LockDevice)!.status === 'on')
              .backgroundColor((this.device as LockDevice)!.securityLevel === 'High' ? Color.Blue : Color.Gray)
              .margin({ left: 10 })
          }
          .margin(10)

          // 4. 远程访问开关
          Text('远程访问: ' + ((this.device as LockDevice)!.remoteAccessEnabled ? '✅ 开启' : '❌ 关闭'))
            .fontSize(20)
            .margin({ top: 10 })
          Toggle({ type: ToggleType.Switch, isOn: (this.device as LockDevice)!.remoteAccessEnabled })
            .onChange(() => {
              (this.device as LockDevice)!.toggleRemoteAccess();
            })
            .margin(10)
            .enabled((this.device as LockDevice)!.status === 'on')

          // 5. 警报状态提示 (修复属性访问错误)
          if ((this.device as LockDevice)!.alarm) {
            Text('🚨 警报中！请注意！')
              .fontColor(Color.Red)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin(20)
          } else {
            Button('📢 模拟触发警报')
              .type(ButtonType.Normal)
              .onClick(() => {
                (this.device as LockDevice)!.triggerAlarm();
              })
              .margin(15)
              .enabled((this.device as LockDevice)!.status === 'on')
          }


          // --- 智能摄像头控制 ---
        } else if (this.device instanceof CameraDevice) {
          // ⚠️ 修复 UI 语法错误：避免使用 const 语句，直接在表达式中进行类型断言

          // 1. 摄像头开关
          Text('状态: ' + (this.device as CameraDevice)!.status.toUpperCase())
            .fontSize(20)
            .margin({ top: 10 })
          Toggle({ type: ToggleType.Switch, isOn: (this.device as CameraDevice)!.status === 'on' })
            .onChange(() => {
              (this.device as CameraDevice)!.toggleStatus();
            })
            .margin(10)

          // 2. 隐私模式开关
          Text('隐私模式: ' + ((this.device as CameraDevice)!.privacyMode ? '开启' : '关闭'))
            .fontSize(20)
            .fontColor((this.device as CameraDevice)!.privacyMode ? Color.Red : Color.Green)
            .margin({ top: 10 })
          Toggle({ type: ToggleType.Switch, isOn: (this.device as CameraDevice)!.privacyMode })
            .onChange(() => {
              (this.device as CameraDevice)!.togglePrivacyMode();
            })
            .margin(10)

          // 3. 录像开关
          Text('录像: ' + ((this.device as CameraDevice)!.isRecording ? '进行中...' : '已停止'))
            .fontSize(20)
            .fontColor((this.device as CameraDevice)!.isRecording ? Color.Red : Color.Black)
            .margin({ top: 10 })
          Button((this.device as CameraDevice)!.isRecording ? '🔴 停止录像' : '录像')
            .type(ButtonType.Normal)
            .backgroundColor((this.device as CameraDevice)!.isRecording ? Color.Red : Color.Blue)
            .onClick(() => {
              (this.device as CameraDevice)!.toggleRecording();
            })
            .margin(15)
            .enabled((this.device as CameraDevice)!.status === 'on' && !(this.device as CameraDevice)!.privacyMode)

          // 4. 模拟警报
          if ((this.device as CameraDevice)!.motionDetected) {
            Text('🚨 移动侦测警报！')
              .fontColor(Color.Red)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin(20)
          } else {
            Button('📢 模拟移动侦测')
              .type(ButtonType.Normal)
              .onClick(() => {
                (this.device as CameraDevice)!.triggerMotionAlert();
              })
              .margin(15)
              .enabled((this.device as CameraDevice)!.status === 'on' && !(this.device as CameraDevice)!.privacyMode)
          }
        }

        // 默认图标或类型显示
        if (this.device.type) {
          Image($r(`app.media.${this.device.type}_icon`))
            .width(64)
            .height(64)
            .margin({ top: 30 })
        }
      }

      Button('返回设备列表')
        .type(ButtonType.Normal)
        .onClick(() => {
          router.back();
        })
        .margin({ top: 30 })
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}