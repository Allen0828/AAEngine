# AAEngine
metal for iOS/MacOS

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
#### Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/Allen0828/AAEngine.git`
- Select "Up to Next Major" with "0.0.3"

#### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
  pod 'AAEngine', '~> 0.0.3'
end
```
