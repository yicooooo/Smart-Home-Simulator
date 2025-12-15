// LightDevice.ets

import { DeviceModel } from './DeviceModel';

export class LightDevice extends DeviceModel {
  brightness: number = 50; // 0-100

  constructor(id: string, name: string) {
    super(id, name, 'light');
  }

  setBrightness(value: number): void {
    if (value >= 0 && value <= 100) {
      this.brightness = value;
      // 当亮度大于0时，状态应为 on
      if (value > 0 && this.status === 'off') {
        this.status = 'on';
      } else if (value === 0 && this.status === 'on') {
        this.status = 'off';
      }
    }
  }

  toggleStatus(): void {
    super.toggleStatus();
    // 确保状态和亮度同步
    if (this.status === 'off') {
      this.brightness = 0;
    } else if (this.brightness === 0) {
      this.brightness = 50;
    }
  }
}