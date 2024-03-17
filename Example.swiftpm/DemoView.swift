//
//  DemoView.swift
//  Example
//
//  Created by 伊藤史 on 2024/03/18.
//

import SwiftUI

struct DemoView: View {
    let observable: MessageSubject
    @State private var prompt = ""

    var body: some View {
        ScrollView {
            VStack {
                Text(observable.errorMessage)
                    .foregroundColor(.red)
                messageView
            }
            .padding()
        }
        .overlay(
            Group {
                if observable.isLoading {
                    ProgressView()
                } else {
                    EmptyView()
                }
            }
        ).safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                textArea
            }
        }
    }

    var textArea: some View {
        HStack(spacing: 4) {
            TextField("Enter prompt", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button {
                Task {
                    try await observable.streamMessage(text: prompt)
                }
            } label: {
                Image(systemName: "paperplane")
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    var messageView: some View {
        VStack(spacing: 24) {
            HStack {
                Button("Cancel") {
                    observable.cancelStream()
                }
                Button("Clear Message") {
                    observable.clearMessage()
                }
            }
            Text(observable.message)
        }
    }
}
