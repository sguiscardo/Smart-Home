//
//  Device Controller.swift
//  Smart-Home-Project
//
//  Created by Sebastian Guiscardo on 2/15/23.
//

import Foundation


class DeviceController: Codable {
    
    
    // MARK: - Properties
    static let shared = DeviceController()
    
    private(set) var devices: [Device] = []
    
    init() {
        loadDevicesFromDisk()
    }
    
    // MARK: - Crud
    
    //Crud Functions
    
    func createDevice(text: String) {
        let newDevice = Device(text: text)
        devices.append(newDevice)
        saveDevicesToDisk()
    }
    
    func toggleIsON(device: Device) {
        device.isON.toggle()
        saveDevicesToDisk()
        
    }
    
    func turnAllOnButtonTapped() {
        devices.forEach { $0.isON = true }
        saveDevicesToDisk()
    }
    
    func turnAllOffButtonTapped() {
        devices.forEach { $0.isON = false }
    }
    
    //Persistence
    // Computed Property
    private var devicesURL: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let finalURL = documentsDirectory.appendingPathComponent("device.json")
        
        return finalURL
    }// End of URL
    
    func saveDevicesToDisk() {
        guard let saveLocation = devicesURL else { return }
        do {
            let jsonData = try JSONEncoder().encode(devices)
            try jsonData.write(to: saveLocation)
        } catch {
            print("Error saving devices", error.localizedDescription)
        }
    }
    
    func loadDevicesFromDisk() {
        guard let url = devicesURL else { return }
        do {
            let retrievedJSONData = try Data(contentsOf: url)
            let decodedDevices = try JSONDecoder().decode([Device].self, from: retrievedJSONData)
            self.devices = decodedDevices
        } catch {
            print("Error loading devices", error.localizedDescription)
        }
    }
}


