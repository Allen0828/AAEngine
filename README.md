# AAEngine
Metal在iOS/MacOS/tvOS中的应用包括：全景地图、3D模型、AR游戏等

[English Document](https://github.com/Allen0828/AAEngine/blob/master/README_EN.md)


## Features
- [x] 光照
- [x] 基础材质
- [x] 法线
- [x] 纹理
- [ ] 阴影
- [ ] 粒子
- [ ] PBR
- [ ] 动画
- [ ] gLTF


## 使用方式
#### Swift Package Manager  推荐

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/Allen0828/AAEngine.git`
- Select "Up to Next Major" with "0.0.5"

#### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
  pod 'AAEngine', '~> 0.0.3'
end
```

## 展示全景地图
<view><img src="https://github.com/Allen0828/AAEngine/blob/main/images/img_01.jpg" width="400"></img><img src="https://github.com/Allen0828/AAEngine/blob/main/images/img_02.jpg" width="400"></img>
</view>

请参考demo中代码进行设置，如果只是加载全景地图，请对相机的位移增加限制。
