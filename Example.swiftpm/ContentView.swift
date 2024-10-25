import SwiftUI
import AnthropicSwiftSDK

struct ContentView: View {
    // MARK: Properties for Claude
    @State private var claudeAPIKey = ""

    var body: some View {
        TabView {
            // MARK: Claude Messages API
            NavigationStack {
                VStack {
                    Spacer()

                    TextField("Enter API Key", text: $claudeAPIKey)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                    NavigationLink {
                        let claude = Anthropic(apiKey: claudeAPIKey)
                        let observable = SendViewModel(messageHandler: claude.messages, title: "Message \\w Claude")
                        SendView(observable: observable)
                    } label: {
                        Text("Continue")
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                            .foregroundColor(
                                claudeAPIKey.isEmpty ? .gray.opacity(0.2) : .blue
                            )
                        )
                    }
                    .padding()
                    .disabled(claudeAPIKey.isEmpty)

                    Spacer()
                }
                .navigationTitle("Claude Send Message Demo")
            }
            .tabItem {
                Image(systemName: "pencil.and.scribble")
                Text("Send Message")
            }
            
            // MARK: Claude Stream Messages API
            NavigationStack {
                VStack {
                    Spacer()

                    TextField("Enter API Key", text: $claudeAPIKey)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                    NavigationLink {
                        let claude = Anthropic(apiKey: claudeAPIKey)
                        let observable = StreamViewModel(messageHandler: claude.messages, title: "Stream \\w Claude")
                        StreamView(observable: observable)
                    } label: {
                        Text("Continue")
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                            .foregroundColor(
                                claudeAPIKey.isEmpty ? .gray.opacity(0.2) : .blue
                            )
                        )
                    }
                    .padding()
                    .disabled(claudeAPIKey.isEmpty)

                    Spacer()
                }
                .navigationTitle("Claude Stream Message Demo")
            }
            .tabItem {
                Image(systemName: "pencil.and.scribble")
                Text("Stream Message")
            }

            // MARK: Claude Send Message Batches API
            NavigationStack {
                VStack {
                    Spacer()

                    TextField("Enter API Key", text: $claudeAPIKey)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                    NavigationLink {
                        let claude = Anthropic(apiKey: claudeAPIKey)
                        let observable = SendMessageBatchesViewModel(messageHandler: claude.messageBatches, title: "Batch \\w Claude")
                        SendMessageBatchView(observable: observable)
                    } label: {
                        Text("Continue")
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                            .foregroundColor(
                                claudeAPIKey.isEmpty ? .gray.opacity(0.2) : .blue
                            )
                        )
                    }
                    .padding()
                    .disabled(claudeAPIKey.isEmpty)

                    Spacer()
                }
                .navigationTitle("Claude Batch Message Demo")
            }
            .tabItem {
                Image(systemName: "pencil.and.scribble")
                Text("Batch Message")
            }

        }
    }
}
