//
//  NetworkMonitor.swift
//  Authentication
//
//  Created by Mit Patel on 08/10/24.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    @Published var isConnected: Bool = true

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue.global(qos: .background)
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    func checkConnection() {
        let path = monitor.currentPath
        DispatchQueue.main.async {
            self.isConnected = path.status == .satisfied
        }
    }

    deinit {
        monitor.cancel()
    }
}
