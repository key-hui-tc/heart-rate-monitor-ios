# heart-rate-monitor-ios

## Requirements

- Xcode 13.1
- Swift 5.5
- iOS 15

## Coding style reference

- https://google.github.io/swift/

## Heart rate detection reference

- https://github.com/athanasiospap/Pulse


## Getting started

### [iPhone]

1. Prepare a iPhone which is iOS 15+ and plugin the testing machine (Mac)
2. Open Xcode by clicking `HeartRateMonitor.xcodeproj`
3. Select Project Settings -> Select Signing & Capabilities -> Update Team & Bundle Identifier
4. Build to connected iPhone

### [iOS simulator]

1. Open Xcode by clicking `HeartRateMonitor.xcodeproj`
2. Build to simulator

- Remark: No camera feature in simulator

## Heart rate detection

1. 


## Testing strategy

1. For API & UI, use mock data for local testing
2. For UITests, test the existance of displaying elements in all views
3. For heart rate detection, prepare a recorded video for testing
