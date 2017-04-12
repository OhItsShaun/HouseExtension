//
//  CategoryHelpers.swift
//  House
//
//  Created by Shaun Merchant on 08/03/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

public extension LightControllerDelegate {
    
    public func didDetermineLightStatus(was status: LightStatus, at time: Date = Date()) {
        let data = HouseDevice.current().identifier.archive() + status.archive()
        let serviceBundle = ServiceBundle(package: 111, service: 4, data: data)!
        let message = Message(to: HouseIdentifier.hub, bundle: serviceBundle)
        
        HouseDevice.current().messageOutbox.add(message: message)
    }
    
}

public extension LightBrightnessControllerDelegate {
    
    func didDetermineLightBrightness(was lightBrightness: LightBrightness, at time: Date = Date()) {
        var data = lightBrightness.archive()
        data.append(time.archive())
        
        let serviceBundle = ServiceBundle(package: 111, service: 14, data: data)!
        let message = Message(to: HouseIdentifier.hub, bundle: serviceBundle)
        
        HouseDevice.current().messageOutbox.add(message: message)
    }
    
}

public extension LightTemperatureControllerDelegate {
    
    func didDetermineLightTemperature(was lightTemperature: LightTemperature, at time: Date = Date()) {
        var data = lightTemperature.archive()
        data.append(time.archive())
        
        let serviceBundle = ServiceBundle(package: 111, service: 24, data: data)!
        let message = Message(to: HouseIdentifier.hub, bundle: serviceBundle)
        
        HouseDevice.current().messageOutbox.add(message: message)
    }
    
}

public extension AmbientLightSensorDelegate {
    
    public func didDetermineAmbientLightReading(was ambientLight: AmbientLight, at time: Date = Date()) {
        let data = HouseDevice.current().identifier.archive() + ambientLight.archive()
        let serviceBundle = ServiceBundle(package: 112, service: 2, data: data)!
        let message = Message(to: HouseIdentifier.hub, bundle: serviceBundle)
        
        HouseDevice.current().messageOutbox.add(message: message)
    }
    
}

public extension SwitchControllerDelegate {
    
    func didDetermineSwitchState(was switchState: SwitchState, at time: Date = Date()) {
        let data = HouseDevice.current().identifier.archive() + switchState.archive()
        
        let serviceBundle = ServiceBundle(package: 113, service: 2, data: data)!
        let message = Message(to: HouseIdentifier.hub, bundle: serviceBundle)
        
        HouseDevice.current().messageOutbox.add(message: message)
    }
    
}

public extension MotionSensorDelegate {
    
    func didDetermineMotionSensorStatus(was motionStatus: MotionStatus, at time: Date = Date()) {
        var data = motionStatus.archive()
        data.append(time.archive())
        
        let serviceBundle = ServiceBundle(package: 114, service: 2, data: data)!
        let message = Message(to: HouseIdentifier.hub, bundle: serviceBundle)
        
        HouseDevice.current().messageOutbox.add(message: message)
    }
    
}

