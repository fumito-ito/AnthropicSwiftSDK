//
//  SendView.swift
//
//
//  Created by 伊藤史 on 2024/07/07.
//

import SwiftUI

struct SendView: View {
    @State var observable: SendMessagesSubject
    @State private var prompt = ""

    var body: some View {
        VStack {
            List(observable.messages) { message in
                HStack {
                    if message.user == .assistant {
                        Image(systemName: "brain.filled.head.profile").frame(alignment: .leading)
                        Text(message.text).frame(maxWidth: .infinity, alignment: .leading)

                    } else {
                        Text(message.text).frame(maxWidth: .infinity, alignment: .trailing)
                        Image(systemName: "person.fill").frame(alignment: .trailing)
                    }
                }
            }
            .padding(.bottom, 1)
            .alert("Error", isPresented: $observable.isShowingError) {
                Button("OK") {}
            } message: {
                Text(observable.errorMessage)
            }
            .overlay(
                Group {
                    if observable.isLoading {
                        ProgressView()
                    } else {
                        EmptyView()
                    }
                }
            )
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                textArea
            }
        }
        .navigationTitle(observable.title)
    }

    var textArea: some View {
        HStack(spacing: 2) {
            Button {
                observable.clear()
            } label: {
                Image(systemName: "eraser")
            }
            .buttonStyle(.bordered)
            TextField("Enter prompt", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button {
                Task {
                    do {
                        try await observable.sendMessage(text: prompt)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Image(systemName: "paperplane")
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    SendView(observable: MockViewModel.init(messageHandler: MockMessagesSendable(), title: ""))
}
