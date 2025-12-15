import { UIAbility } from '@kit.AbilityKit';

export default class EntryBackupAbility extends UIAbility {
  onCreate() {
    console.info('EntryBackupAbility onCreate');
  }

  onDestroy() {
    console.info('EntryBackupAbility onDestroy');
  }
}