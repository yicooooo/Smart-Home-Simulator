import { DeviceModel } from './DeviceModel'; // 确保路径正确

/**
 * 智能摄像头设备模型
 */
export class CameraDevice extends DeviceModel {
  // 摄像头特有属性
  isRecording: boolean = false; // 是否正在录像
  privacyMode: boolean = true;  // 隐私模式（快门是否关闭）
  motionDetected: boolean = false; // 是否检测到移动

  // 构造函数
  constructor(id: string, name: string) {
    // 调用父类构造函数，类型设置为 'camera'
    super(id, name, 'camera');
    this.status = 'off'; // 默认关闭，节省资源
    this.isRecording = false;
  }

  // 开启/关闭录像
  toggleRecording(): void {
    if (this.status === 'on' && !this.privacyMode) {
      this.isRecording = !this.isRecording;
    } else {
      // 提示：必须先开启摄像头且关闭隐私模式
      console.warn("无法开始录像：摄像头未开启或处于隐私模式。");
      this.isRecording = false;
    }
  }

  // 切换隐私模式
  togglePrivacyMode(): void {
    this.privacyMode = !this.privacyMode;
    // 如果开启了隐私模式，则强制关闭录像和状态
    if (this.privacyMode) {
      this.isRecording = false;
      this.status = 'off';
    }
  }

  // 模拟侦测到移动
  triggerMotionAlert(): void {
    if (this.status === 'on' && !this.privacyMode) {
      this.motionDetected = true;
      console.log('🚨 移动侦测警报！');
      setTimeout(() => {
        this.motionDetected = false;
      }, 5000); // 5秒后警报解除
    }
  }

  // 重写父类的 toggleStatus 方法
  toggleStatus(): void {
    if (this.privacyMode) {
      // 如果处于隐私模式，不允许开启，必须先关闭隐私模式
      console.warn("请先关闭隐私模式才能开启摄像头。");
      this.status = 'off';
    } else {
      // 正常切换状态
      this.status = this.status === 'on' ? 'off' : 'on';
      // 如果关闭，则停止录像
      if (this.status === 'off') {
        this.isRecording = false;
      }
    }
  }
}