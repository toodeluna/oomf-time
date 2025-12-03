import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ClockViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.clocks.isEmpty {
                emptyStateView
            } else {
                clockListView
                
                addButtonSection
            }
        }
        .frame(width: 320)
        .sheet(isPresented: $viewModel.showAddClock) {
            AddClockView(viewModel: viewModel)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: viewModel.fontSize * 2.5))
                .foregroundColor(.secondary)
            
            Text("No clocks yet")
                .font(.system(size: viewModel.fontSize + 1, weight: .medium))
            
            Text("Add your first clock to get started")
                .font(.system(size: viewModel.fontSize - 1))
                .foregroundColor(.secondary)
            
            Button("Add Clock") {
                viewModel.showAddClock = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var clockListView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.clocks) { clock in
                ClockRow(clock: clock, timeOffset: viewModel.timeOffset, fontSize: viewModel.fontSize, viewModel: viewModel)
                    .id(clock.id)
                
                Divider()
            }
        }
    }
    
    private var addButtonSection: some View {
        HStack {
            Button(action: { viewModel.showAddClock.toggle() }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: viewModel.fontSize + 3))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
