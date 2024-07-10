import SwiftUI
import AnthropicSwiftSDK_VertexAI
import AnthropicSwiftSDK
import AWSBedrockRuntime
import AnthropicSwiftSDK_Bedrock

struct ContentView: View {
    // MARK: Properties for Claude
    @State private var claudeAPIKey = ""
    @State private var isStreamClaude: Bool = false

    // MARK: Properties for Bedrock
    @State private var bedrockRegion = ""
    @State private var isStreamBedrock: Bool = false

    // MARK: Properties for Vertex
    @State private var vertexProjectID = ""
    @State private var vertexAuthToken = ""
    @State private var isStreamVertex: Bool = false

    var body: some View {
        TabView {
            // MARK: Claude
            NavigationStack {
                VStack {
                    Spacer()

                    TextField("Enter API Key", text: $claudeAPIKey)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                    Toggle(isOn: $isStreamClaude) {
                        Text("Enable Stream API")
                    }
                    .padding()

                    NavigationLink {
                        let claude = Anthropic(apiKey: claudeAPIKey)
                        if isStreamClaude {
                            let observable = StreamViewModel(messageHandler: claude.messages, title: "Stream \\w Claude")
                            StreamView(observable: observable)
                        } else {
                            let observable = SendViewModel(messageHandler: claude.messages, title: "Message \\w Claude")
                            SendView(observable: observable)
                        }
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
                .navigationTitle("Claude Demo")
            }
            .tabItem {
                Image(systemName: "pencil.and.scribble")
                Text("Claude")
            }

            // MARK: Bedrock
            NavigationStack {
                VStack {
                    Spacer()

                    TextField("Enter Region Code", text: $bedrockRegion)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                    Toggle(isOn: $isStreamBedrock) {
                        Text("Enable Stream API")
                    }
                    .padding()

                    NavigationLink {
                        let bedrockClient = try! BedrockRuntimeClient(region: bedrockRegion)
                        let claude = BedrockRuntimeClient.useAnthropic(bedrockClient, model: .claude_3_Opus)
                        if isStreamBedrock {
                            let observable = StreamViewModel(messageHandler: claude.messages, title: "Stream \\w Bedrock")
                            StreamView(observable: observable)
                        } else {
                            let observable = SendViewModel(messageHandler: claude.messages, title: "Message \\w Bedrock")
                            SendView(observable: observable)
                        }
                    } label: {
                        Text("Continue")
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                            .foregroundColor(
                                bedrockRegion.isEmpty ? .gray.opacity(0.2) : .blue
                            )
                        )
                    }
                    .padding()
                    .disabled(bedrockRegion.isEmpty)

                    Spacer()
                }
                .navigationTitle("Bedrock Demo")
            }
            .tabItem {
                Image(systemName: "globe.americas.fill")
                Text("Bedrock")
            }

            // MARK: Vertex
            NavigationStack {
                VStack {
                    Spacer()

                    TextField("Enter Project ID", text: $vertexProjectID)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                    TextField("Enter Auth Token", text: $vertexAuthToken)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                    Toggle(isOn: $isStreamVertex) {
                        Text("Enable Stream API")
                    }
                    .padding()

                    NavigationLink {
                        let claude = AnthropicVertexAIClient(projectId: vertexProjectID, accessToken: vertexAuthToken, region: .europeWest1)
                        if isStreamVertex {
                            let observable = StreamViewModel(messageHandler: claude.messages, title: "Stream \\w Vertex")
                            StreamView(observable: observable)
                        } else {
                            let observable = SendViewModel(messageHandler: claude.messages, title: "Message \\w Vertex")
                            SendView(observable: observable)
                        }
                    } label: {
                        Text("Continue")
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                            .foregroundColor(
                                vertexProjectID.isEmpty || vertexAuthToken.isEmpty ? .gray.opacity(0.2) : .blue
                            )
                        )
                    }
                    .padding()
                    .disabled(vertexProjectID.isEmpty || vertexAuthToken.isEmpty)

                    Spacer()
                }
                .navigationTitle("VertexAI Demo")
            }
            .tabItem {
                Image(systemName: "mountain.2.fill")
                Text("Vertex")
            }

        }
    }
}
