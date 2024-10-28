//
//  ContentView.swift
//  NotificationInSwiftUi
//
//  Created by Muhammad Zeeshan on 25/10/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var localNManager: NotificationManager
    @Environment(\.scenePhase) var scenePhase
    @State private var scheduleDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                if localNManager.isGranted {
                    GroupBox("TimeInterval Notification ") {
                        Button("Interval Notification") {
                            Task {
                                var localNotification = LocalNotification(identifier: UUID().uuidString, title: "Notification", body: "some body", timeInterval: 10, repeats: false)
                                localNotification.subTitle = "This is Subtitle"
                                localNotification.bundleImageName = "images.jpeg"
                                localNotification.userInfo = ["nextView" : NextView.renew.rawValue]
                                await localNManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 300)
                    
                    GroupBox("Clander Notification") {
                        DatePicker("", selection: $scheduleDate)
                        
                        Button("Calender Notification") {
                            Task {
                                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduleDate)
                                let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Notification", body: "This is practice of Calender Notification", dateComponents: dateComponents, repeats: false)
                                await localNManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 300)
                    
                    //MARK: Showing pending notification request in list
                    List {
                        ForEach(localNManager.pendingRequests, id: \.identifier) { pendingNotif in
                            VStack(alignment: .leading) {
                                Text(pendingNotif.content.title)
                                HStack {
                                    Text(pendingNotif.identifier)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    localNManager.removePendingRequest(withIdentifier: pendingNotif.identifier)
                                } label: {
                                    Image(systemName: "delete.left.fill")
                                }
                            }
                        }
                    }
                    
                } else {
                    Button("Enable Notification") {
                        localNManager.openSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(item: $localNManager.nextView, content: { nextView in
                nextView.view()
            })
            .navigationTitle("Local Notification")
        }
        .navigationViewStyle(.stack)
        .task {
            try? await localNManager.requestAuthorization()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                Task {
                    await localNManager.getCurrentStattus()
                    await localNManager.getPendingRequests()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NotificationManager())
}
