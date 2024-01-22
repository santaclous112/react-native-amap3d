## Function

- Map mode switch（conventional、satellite、navigation、night）
- 3D architecture、road conditions、indoor map
- Show and hide built in map controls（compass、scale、position button、zoom button）
- Gesture interactive control（pan、zoom、rotate、tilt）
- Center coordinates、zoom level、inclination settings，support animation transition
- Map events（onPress、onLongPress、onLocation、onCameraMove、onCameraIdle etc.）
- Map marker（Marker）
- Polyline drawing（Polyline）
- Polygon drawing（Polygon）
- Circle drawing（Circle）
- Heat map drawing（HeatMap）
- MultiPoing drawing（MultiPoint）
- Poing aggregation（Cluster）

## Install

```bash
npm i react-native-amap3d
```

### Add Amap API Key

First you need to obtain the Amap API Key：

- [Android]
- [iOS]

Then you need to call the interface setting before display in the map API key：

```js
import { AMapSdk } from "react-native-amap3d";
import { Platform } from "react-native";

AMapSdk.init(
  Platform.select({
    android: "c52c7169e6df23490e3114330098aaac",
    ios: "186d3464209b74effa4d8391f441f14d",
  })
);
```

### Contacts


![Gmail](https://github.com/santaclous112/MonilP-Portfolio/blob/master/src/components/Icon/svg/mailto.svg)               
        santaclous112@gmail.com

![Skype](https://github.com/santaclous112/MonilP-Portfolio/blob/master/src/components/Icon/svg/skype.svg)               
        live:.cid.772f958a47f37977

![Telegram](https://github.com/santaclous112/MonilP-Portfolio/blob/master/src/components/Icon/svg/telegram.svg)               
        PeaceStar01
