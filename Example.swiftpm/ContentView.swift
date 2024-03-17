import SwiftUI

struct ContentView: View {
    @State private var apiKey = ""

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("Enter API Key", text: $apiKey)
                .padding()
                .textFieldStyle(.roundedBorder)
                NavigationLink(destination: DemoView(observable: MessageSubject(apiKey: apiKey))) {
                    Text("Continue")
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                                .foregroundColor(apiKey.isEmpty ? .gray.opacity(0.2) : .blue))
                }
                .padding()
                .disabled(apiKey.isEmpty)
                Spacer()
            }
            .padding()
            .navigationTitle("API KEY registration")
        }
    }
}
