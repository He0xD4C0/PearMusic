import SwiftUI

/// Settings sheet for configuring NetEase API keys and AI translation keys.
struct SettingsView: View {
    @Environment(SetupViewModel.self) private var setupVM
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
                        neteaseSection
                    } else {
                        aiSection
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 420, minHeight: 400)
    }

    // MARK: - NetEase Section

    private var neteaseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("NetEase Cloud Music API")
                .font(.headline)

            Text("Required for lyric search and sync. Get your keys from the NetEase Developer Console.")
                .font(.caption)
                .foregroundStyle(.secondary)

            labeledField("App ID", text: $setupVM.neteaseAppId, prompt: "Your NetEase appId")
            labeledSecureField("App Secret", text: $setupVM.neteaseAppSecret, prompt: "Your app secret")

            LabeledContent("RSA Private Key (PKCS#8, base64)") {
                TextEditor(text: $setupVM.neteasePrivateKey)
                    .font(.system(size: 11, design: .monospaced))
                    .frame(height: 80)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            LabeledContent("RSA Public Key (X.509, base64)") {
                TextEditor(text: $setupVM.neteasePublicKey)
                    .font(.system(size: 11, design: .monospaced))
                    .frame(height: 60)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Text("Generate 2048-bit PKCS#8 keys at web.chacuo.net/netrsakeypair")
                .font(.caption2)
                .foregroundStyle(.tertiary)

            HStack {
                Spacer()
                saveButton
            }
        }
    }

    // MARK: - AI Section

    private var aiSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AI Translation")
                .font(.headline)

            Text("Optional. When NetEase doesn't have a translation, an LLM will translate lyrics on the fly.")
                .font(.caption)
                .foregroundStyle(.secondary)

            labeledSecureField("API Key", text: $setupVM.aiApiKey, prompt: "sk-...")
            labeledField("Model", text: $setupVM.aiModel, prompt: "deepseek-chat")
            labeledField("Base URL", text: $setupVM.aiBaseURL, prompt: "https://api.deepseek.com/v1")

            Text("Works with any OpenAI-compatible API: DeepSeek, OpenAI, Groq, etc.")
                .font(.caption2)
                .foregroundStyle(.tertiary)

            HStack {
                if setupVM.isAIConfigured {
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
            setupVM.saveToKeychain()
        } label: {
            if setupVM.isSaving {
                ProgressView()
                    .controlSize(.small)
            } else if setupVM.saveSuccess {
                Label("Saved", systemImage: "checkmark")
            } else {
                Text("Save")
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(setupVM.isSaving)
    }

    // MARK: - Field Helpers

    private func labeledField(
        _ label: String,
        text: Binding<String>,
        prompt: String
    ) -> some View {
        LabeledContent(label) {
            TextField(prompt, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    private func labeledSecureField(
        _ label: String,
        text: Binding<String>,
        prompt: String
    ) -> some View {
        LabeledContent(label) {
            SecureField(prompt, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    SettingsView()
        .environment(SetupViewModel())
        .preferredColorScheme(.dark)
}
