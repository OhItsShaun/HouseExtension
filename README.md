# House

A home automation platform written entirely in Swift. The House platform is made of two parts:

* Hub
* Extensions

House Extensions act as units that can feed information to, or opt in to be controlled by, the House Hub. For example; lights, environment sensors, switches.

The House Hub acts as a central unit to automate tasks at pre-defined times or in response to events from House Extensions.

The current repository is the Swift Package for developing House Extensions.

## Pre-Requisites 

### macOS & iOS

* Xcode 8 or later
* Swift 3.0 or later (provided with Xcode 8)
* macOS 10.12.0 or later (Sierra)

### Linux 
Prior to compilation ensure:

* A `kqueue` ABI for GCD. `sudo apt-get install libkqueue-dev` is recommended.
* All dependencies of Swift are installed. A full list of Swift dependencies can be found on [Swift's GitHub](https://github.com/apple/swift#system-requirements). 

####(x86)

* [Swift 3.0 or later](https://swift.org/download/)
* Ubuntu 16.04

#### (ARMv6/Rasperry Pi 0)

* Swift 3.0 or later (pre-compiled binary available from [here](https://www.uraimo.com/2016/12/30/Swift-3-0-2-for-raspberrypi-zero-1-2-3/))


## Getting Started

Create a new directory and create a new Swift Package:

```bash
swift package init 
```

A file `Package.swift` will be created with the directories `Sources` and `Tests`.

Include the `HouseExtension` dependency (this repository) within `Package.swift`.

```swift
import PackageDescription

let package = Package(
    name: "My-Awesome-Package",
    dependencies: [
        .Package(url: "https://www.github.com/OhItsShaun/HouseExtension.git", majorVersion: 0),
    ]
)
```

Now fetch the package:

```bash
swift package fetch
```

macOS users with Xcode installed can generate an Xcode project using:

```bash
swift package generate-xcodeproj
```

### The Run Loop

Most programs have a finite lifetime. However, we wish to keep our Extension devices, such as light bulbs and sensors, running indefinitely. We do this through contacting `HouseRuntime`.

All House Extensions must provide a main delegate to run, this can be either:

* `StartableProcess`
* `UpdatableProcess`

Note: It is recommended to use `UpdatableProcess` as the run loop is handled for you. You declare how often you wish to be updated by `updateFrequency: TimeInterval`.

Declare a type which conforms to either process protocol within `Sources/main.swft` and call `HouseRuntime.call(YourType())`. 

Your type will now be called to run!

An example of declaring an Updatable process is as follows:

```swift 
class ExtensionDelegate: UpdateableProcess {
    
    // I will be updated every 5 seconds
    var updateFrequency = 5
    
    func updatesWillStart() {
        print("I'm about to be updated in a run loop!")
    }
    
    func update(at time: Date) {
        print("I'm being updated in the run loop!")
    }
    
}

HouseRuntime.run(ExtensionDelegate())
```

### Category Delegates 

Depending upon what behaviour we have hardware support for, we can conform to categories. A catergory could be a light controller, light brightness controller or an ambient light sensor. 

To declare support for a behaviour create a delegate which conforms to the appropriate Category Protocol (e.g. `LightBrightnessController`) and register it to the appropriate category within `HouseDevice.current().categoryDelegate`.

An example of declaring support for a light controller is as follows:

```swift 
class HouseDelegate: UpdateableProcess, LightControllerDelegate {
    
   var updateFrequency = 10
    
   func updatesWillStart() {
        HouseDevice.current().categoryDelegate.lightControllerDelegate = self
    }
    
    var lightStatus: LightStatus = .on
    
    func turnOnLight() {
        print("Turning on...")
        // control hardware
        self.lightStatus = .on
    }
    
    func turnOffLight() {
        print("Turning off...")
        // control hardware
        self.lightStatus = .off
    }
    
    func didRequestLightStatus() {
    
    }  
}
```

Sometimes a House Hub might ask for your current state. To fulfill this the House Extension SDK will call your implementation of `didRequestLightStatus()`. Don't worry, you won't have to handle any networking. We can use the Extension SDK's callback `didDetermineLightStatus` to message the Hub for us:

```swift
func didRequestLightStatus() {
    self.didDetermineLightStatus(was: self.lightStatus)
} 
```

### House Network 

Once we've registered the categories we support we can fire up the networking stack to connect to a House Hub on the network. To do this we simply call `HouseNetwork.current().open()` once within our `updatesWillStart()`.

### Done!
A complete example of our Light Extension is:

```swift 
class HouseDelegate: UpdateableProcess, LightControllerDelegate {
    
   var updateFrequency = 10
    
   func updatesWillStart() {
        HouseDevice.current().categoryDelegate.lightControllerDelegate = self
        HouseNetwork.current().open()
    }
    
    var lightStatus: LightStatus = .on
    
    func turnOnLight() {
        print("Turning on...")
        // control hardware
        self.lightStatus = .on
    }
    
    func turnOffLight() {
        print("Turning off...")
        // control hardware
        self.lightStatus = .off
    }
    
    func didRequestLightStatus() {
        self.didDetermineLightStatus(was: self.lightStatus)
    }  
}
```

Once you have a House Hub running on the network the above is all the code you need to deploy an automatable light. The Extension SDK will handle all the networking and communication for you, and will call the appropraite sections of your code when necessary.

## Building

### Swift Package Manager (SPM)

Inside your Extension run:

```bash
swift build 
```

Your binary will be available under `.build/`

### Without SPM

See the the `HouseBuild` repository for an alternative build tool.