// DeviceModel.ets

export class DeviceModel {
  id: string;
  name: string;
  type: string; // light, ac, lock
  status: string = 'off'; // on/off, locked/unlocked

  constructor(id: string, name: string, type: string) {
    this.id = id;
    this.name = name;
    this.type = type;
  }

  toggleStatus(): void {
    this.status = this.status === 'on' ? 'off' : 'on';
  }
}