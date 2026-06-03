import SwiftUI

/// Settings sheet for configuring NetEase API keys and AI translation keys.
struct SettingsView: View {
    let viewModel: SetupViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = "netease"

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.title2.bold())
                Spacer()
                Button("Done") { dismiss() }
                    .keyboardShortcut(.escape)
            }
            .padding()

            Divider()

            // Tab Picker
            Picker("Section", selection: $selectedTab) {
                Text("NetEase").tag("netease")
                Text("AI Translation").tag("ai")
            }
            .pickerStyle(.segmented)
            .padding()
            .labelsHidden()

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if selectedTab == "netease" {
                        neteaseTab
                    } else {
                        aiTab
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 420, minHeight: 400)
    }

    // MARK: - NetEase Tab

    private var neteaseTab: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("NetEase Cloud Music API")
                .font(.headline)

            Text("Required for lyric search and sync. Get your keys from the NetEase Developer Console.")
                .font(.caption)
                .foregroundStyle(.secondary)

            FieldRow(label: "App ID", prompt: "Your NetEase appId") {
                TextField("Your NetEase appId", text: binding(\.neteaseAppId))
                    .textFieldStyle(.roundedBorder)
            }
            FieldRow(label: "App Secret", prompt: "Your app secret") {
                SecureField("Your app secret", text: binding(\.neteaseAppSecret))
                    .textFieldStyle(.roundedBorder)
            }

            FieldRow(label: "RSA Private Key (PKCS#8, base64)") {
                TextEditor(text: binding(\.neteasePrivateKey))
                    .font(.system(size: 11, design: .monospaced))
                    .frame(height: 80)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            FieldRow(label: "RSA Public Key (X.509, base64)") {
                TextEditor(text: binding(\.neteasePublicKey))
                    .font(.system(size: 11, design: .monospaced))
                    .frame(height: 60)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Text("Generate 2048-bit PKCS#8 keys at web.chacuo.net/netrsakeypair")
                .font(.caption2)
                .foregroundStyle(Color.secondary)

            HStack {
                Spacer()
                saveButton
            }
        }
    }

    // MARK: - AI Tab

    private var aiTab: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AI Translation")
                .font(.headline)

            Text("Optional. When NetEase doesn't have a translation, an LLM will translate lyrics on the fly.")
                .font(.caption)
                .foregroundStyle(.secondary)

            FieldRow(label: "API Key", prompt: "sk-...") {
                SecureField("sk-...", text: binding(\.aiApiKey))
                    .textFieldStyle(.roundedBorder)
            }
            FieldRow(label: "Model", prompt: "deepseek-chat") {
                TextField("deepseek-chat", text: binding(\.aiModel))
                    .textFieldStyle(.roundedBorder)
            }
            FieldRow(label: "Base URL", prompt: "https://api.deepseek.com/v1") {
                TextField("https://api.deepseek.com/v1", text: binding(\.aiBaseURL))
                    .textFieldStyle(.roundedBorder)
            }

            Text("Works with any OpenAI-compatible API: DeepSeek, OpenAI, Groq, etc.")
                .font(.caption2)
                .foregroundStyle(Color.secondary)

            HStack {
                if viewModel.isAIConfigured {
                    Label("Connected", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                Spacer()
                saveButton
            }
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        Button {
            viewModel.saveToKeychain()
        } label: {
            if viewModel.isSaving {
                ProgressView().controlSize(.small)
            } else if viewModel.saveSuccess {
                Label("Saved", systemImage: "checkmark")
            } else {
                Text("Save")
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isSaving)
    }

    // MARK: - Helpers

    private func binding<T>(_ keyPath: ReferenceWritableKeyPath<SetupViewModel, T>) -> Binding<T> {
        Binding(
            get: { viewModel[keyPath: keyPath] },
            set: { viewModel[keyPath: keyPath] = $0 }
        )
    }

    private struct FieldRow<Content: View>: View {
        let label: String
        var prompt: String = ""
        @ViewBuilder let content: () -> Content

        var body: some View {
            LabeledContent(label) {
                content()
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: SetupViewModel())
        .preferredColorScheme(.dark)
}
