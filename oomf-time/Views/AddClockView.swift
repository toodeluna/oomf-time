import SwiftUI

struct AddClockView: View {
    @ObservedObject var viewModel: ClockViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var emoji = "🌍"
    @State private var label = ""
    @State private var selectedTimeZone = TimeZone.current
    @State private var searchText = ""
    
    var filteredTimeZones: [TimeZone] {
        let zones = TimeZone.knownTimeZoneIdentifiers.compactMap { TimeZone(identifier: $0) }
        if searchText.isEmpty { return zones }
        return zones.filter { $0.identifier.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    emojiSection
                    nameSection
                    timeZoneSection
                }
                .padding(.vertical)
            }
            
            Divider()
            
            actionButtons
        }
        .frame(width: 450, height: 600)
    }
    
    private var emojiSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Icon")
                .font(.system(size: viewModel.fontSize - 1, weight: .medium))
                .foregroundColor(.secondary)
            
            HStack {
                TextField("Paste emoji", text: $emoji)
                    .textFieldStyle(.plain)
                    .font(.system(size: viewModel.fontSize * 2))
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(8)
                    .multilineTextAlignment(.center)
                    
                if !emoji.isEmpty {
                    Button(action: { emoji = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name")
                .font(.system(size: viewModel.fontSize - 1, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField("e.g., Tokyo Office, Mom, London HQ", text: $label)
                .textFieldStyle(.plain)
                .font(.system(size: viewModel.fontSize))
                .padding(12)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    
    private var timeZoneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Zone")
                .font(.system(size: viewModel.fontSize - 1, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField("Search time zones", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: viewModel.fontSize))
                .padding(12)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(8)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredTimeZones.prefix(100), id: \.identifier) { tz in
                        timeZoneRow(tz)
                    }
                }
            }
            .frame(height: 220)
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    
    private func timeZoneRow(_ tz: TimeZone) -> some View {
        Button(action: { selectedTimeZone = tz }) {
            HStack {
                Text(tz.identifier.replacingOccurrences(of: "_", with: " "))
                    .font(.system(size: viewModel.fontSize - 1))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if selectedTimeZone.identifier == tz.identifier {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .font(.system(size: viewModel.fontSize - 1, weight: .semibold))
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(selectedTimeZone.identifier == tz.identifier ? Color.accentColor.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
    
    private var actionButtons: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)
            
            Spacer()
            
            Button("Add Clock") {
                viewModel.addClock(emoji: emoji, label: label, timeZone: selectedTimeZone)
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .buttonStyle(.borderedProminent)
            .disabled(label.isEmpty)
        }
        .padding()
    }
}
