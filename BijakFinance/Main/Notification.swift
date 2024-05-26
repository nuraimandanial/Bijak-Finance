//
//   Notification.swift
//   BijakFinance
//
//   Created by @kinderBono on 12/05/2024.
//

import SwiftUI

struct Notification: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var notifications: [Notifications] = Notifications.allNotifications
    private var notificationGroups: [NotificationGroup] {
        let groups = NotificationGroup.group(notifications)
        switch display {
        case .all:
            return groups
        case .unread:
            return groups.map { group in
                let unread = group.notifications.filter { $0.unread }
                return NotificationGroup(date: group.date, notifications: unread)
            }.filter { !$0.notifications.isEmpty }
        }
    }
    
    @State var display: NotificationDisplay = .all
    var unreadCount: Int {
        return notifications.filter({ $0.unread }).count
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    Picker("", selection: $display) {
                        Text("All").tag(NotificationDisplay.all)
                        Text("Unread").tag(NotificationDisplay.unread)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .environment(\.colorScheme, .light)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(notificationGroups, id: \.date) { group in
                            VStack {
                                HStack {
                                    Text(group.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.title3)
                                        .bold()
                                    VStack {
                                        Spacer()
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(.teals)
                                        Spacer()
                                    }
                                }
                                ForEach(group.notifications) { notification in
                                    Button(action: {
                                        markAsRead(notification)
                                    }, label: {
                                        notificationContent(notification).padding(1)
                                    })
                                    .disabled(!notification.unread)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .foregroundStyle(.blacks)
            .task {
                notifications = appModel.dataManager.currentUser.notifications
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.yellows)
                    })
                    Spacer()
                    Text("Notification")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blacks)
                    if unreadCount > 0 {
                        Button(action: {
                            display = .unread
                        }, label: {
                            Text("\(unreadCount)")
                                .font(.caption)
                                .foregroundStyle(.whites)
                                .padding(5)
                                .background(.red)
                                .clipShape(Circle())
                                .offset(x: -25, y: -10)
                        })
                    }
                }
            }
        }
    }
    
    func notificationContent(_ notification: Notifications) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(notification.unread ? .turqois.opacity(0.5) : .whites)
            RoundedRectangle(cornerRadius: 15)
                .stroke(.blacks.opacity(0.3), lineWidth: 2)
            VStack(alignment: .leading) {
                HStack {
                    Text(notification.title)
                        .bold()
                    Spacer()
                    Text(notification.date.formatted(date: .omitted, time: .shortened))
                }
                Text(notification.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .italic()
                Text(notification.message)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .foregroundStyle(.blacks)
        }
    }
    
    func markAsRead(_ notification: Notifications) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].read()
        }
    }
}

#Preview {
    Notification()
        .environmentObject(AppModel())
}
