//
//  NotificationsView.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 08/12/2020.
//

import SwiftUI

struct NotificationsView: View {
    @State var notifications = [String]()
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            ForEach(notifications, id: \.self) { notify in
                Text(notify)
            }
        }
        .onAppear {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests(completionHandler: { requests in
                for request in requests {
                    print(request)
                    notifications.append(request.description)
                }
            })
        }

    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
