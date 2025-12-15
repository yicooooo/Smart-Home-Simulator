// model/LockDevice.ets

import { DeviceModel } from './DeviceModel';

export class LockDevice extends DeviceModel {
  isLocked: boolean = true; // 门的锁定状态：默认锁定
  securityLevel: 'Normal' | 'High' = 'Normal'; // 安全级别
  remoteAccessEnabled: boolean = false; // 远程访问是否开启
  alarm: boolean = false; // 警报状态（旧功能，保留）

  constructor(id: string, name: string) {
    super(id, name, 'lock');
    this.status = 'on'; // 默认通电/在线
    this.isLocked = true;
  }

  // 1. 操控开关：实现 DeviceModel 中的 toggleStatus，控制设备是否通电/在线
  toggleStatus(): void {
    this.status = this.status === 'on' ? 'off' : 'on';
    // 如果断电，强制关闭所有高级功能
    if (this.status === 'off') {
      this.remoteAccessEnabled = false;
      this.isLocked = false; // 模拟断电后解锁
      this.securityLevel = 'Normal';
      this.alarm = false;
    }
  }

  // 2. 核心功能：切换锁定状态
  toggleLock(): void {
    if (this.status === 'on') {
      this.isLocked = !this.isLocked;
    }
  }

  // 3. 新功能：设置安全等级
  setSecurityLevel(level: 'Normal' | 'High'): void {
    if (this.status === 'on') {
      this.securityLevel = level;
    }
  }

  // 4. 新功能：切换远程访问
  toggleRemoteAccess(): void {
    if (this.status === 'on') {
      this.remoteAccessEnabled = !this.remoteAccessEnabled;
    }
  }

  // 5. 触发警报
  triggerAlarm(): void {
    if (this.status === 'on') {
      this.alarm = true;
      setTimeout(() => {
        this.alarm = false;
      }, 5000); // 5秒后自动解除警报
    }
  }
}