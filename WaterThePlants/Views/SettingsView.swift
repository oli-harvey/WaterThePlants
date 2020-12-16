
import StoreKit
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Feedback")) {
                    NavigationLink(destination: RateView()) {
                        Text("Please Rate Water The Plants")
                        }
                    NavigationLink(destination: ContactUsView()) {
                        Text("Contact Us")
                        }
                }
                Section(header: Text("Info")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                        }
                    NavigationLink(destination: AboutView()) {
                        Text("About")
                        }
                }
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Back") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct RateView: View {
    var body: some View {
        VStack {
            Link("See Water The Plants on the App Store", destination: URL(string: "https://apps.apple.com/us/app/water-the-plants/id1544652292")!)
                .padding()
                .foregroundColor(.blue)
            Spacer()
        }
        .onAppear {
            if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
        }
    
    }
}

struct ContactUsView: View {
    var body: some View {
        VStack {
            Text("Get in Touch")
                .font(.headline)
                .padding()
            Text("Please send feedback to meetwickapps@gmail.com")
                .padding()
            Spacer()
        }

    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        VStack {
            Text("Privacy Policy")
                .font(.headline)
                .padding()
            Text("No data is transmitted outside of your device and iCloud backup (if enabled). In order to work this app needs to store your tasks on your device and will attempt to sync to your personal iCloud account in order to allow you to access your reminders on different devices or if you reinstall on the same device. However this data is never accessed by or accessible to anyone except you, the user.")
                .padding()
            Spacer()
        }

    }
}

struct AboutView: View {
    var body: some View {
        VStack {
            Text("Hi!")
                .font(.headline)
                .padding()
            Text("I am a solo App Developer and appreciate the support. Please check out my other apps if you like this one.")
                .padding()
            Spacer()
        }
       
    }
}
