//
//  ContentView.swift
//  Wall Of Text
//
//  Created by Edward Hallam on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var textToShare: String = ""
    @State private var isEditing: Bool = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var showingSettings = false
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextEditor(text: $textToShare)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isEditing ? Color.blue : Color(.systemGray4), lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if textToShare.isEmpty {
                                Text("Compose your Draft")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .allowsHitTesting(false)
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isEditing = true
                        }
                    }
                    .onAppear {
                        isEditing = false
                    }
                
                ShareLink(
                    item: textToShare,
                    subject: Text("Shared from Chat Drafts"),
                    message: Text("Check out this text!")
                ) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Share")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(textToShare.isEmpty ? Color.blue.opacity(0.5) : Color.blue)
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .foregroundColor(.white)
                }
                .disabled(textToShare.isEmpty)
                .scaleEffect(buttonScale)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonScale = 0.98
                    }
                }
                .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 50, pressing: { pressing in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonScale = pressing ? 0.98 : 1.0
                    }
                }, perform: { })
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Chat Drafts")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .preferredColorScheme(colorScheme)
        }
    }
    
    private var colorScheme: ColorScheme? {
        switch appearanceMode {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}

#Preview {
    ContentView()
}
