// ACDevice.ets

import { DeviceModel } from './DeviceModel';

export class ACDevice extends DeviceModel {
  temperature: number = 25; // Celsius
  mode: string = 'cool'; // cool, heat, fan
  fanSpeed: string = 'medium'; // low, medium, high

  constructor(id: string, name: string) {
    super(id, name, 'ac');
  }

  setTemperature(value: number): void {
    if (value >= 16 && value <= 30) {
      this.temperature = value;
      this.status = 'on'; // 调整温度时自动打开
    }
  }

  setMode(mode: string): void {
    if (['cool', 'heat', 'fan'].includes(mode)) {
      this.mode = mode;
      this.status = 'on'; // 调整模式时自动打开
    }
  }

  setFanSpeed(speed: string): void {
    if (['low', 'medium', 'high'].includes(speed)) {
      this.fanSpeed = speed;
      this.status = 'on'; // 调整风速时自动打开
    }
  }
}