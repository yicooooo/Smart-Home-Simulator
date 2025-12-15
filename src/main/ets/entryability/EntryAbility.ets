import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.info('EntryAbility onCreate');
  }

  onDestroy() {
    console.info('EntryAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    console.info('EntryAbility onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        console.error('Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in loading the content. Data: ' + JSON.stringify(data));
    });
  }

  onWindowStageDestroy() {
    console.info('EntryAbility onWindowStageDestroy');
  }

  onForeground() {
    console.info('EntryAbility onForeground');
  }

  onBackground() {
    console.info('EntryAbility onBackground');
  }
}