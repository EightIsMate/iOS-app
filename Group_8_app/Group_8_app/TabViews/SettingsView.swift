//
//  SettingsView.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-04-05.
//
/*
import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    
    override init() {
        print("initializing BT")
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("scanning for devices")
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData advertismentData: [String: Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "Unnamed Device")
        }
    }
}

struct SettingsView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    var body: some View {
        NavigationView {
            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
                Text(peripheral)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
*/

/*

 struct ContentView: View {
     @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
     var body: some View {
         NavigationView {
             List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
                 Text(peripheral)
             }
             .navigationTitle("Peripherals")

         }
     }
 }
 
 */
