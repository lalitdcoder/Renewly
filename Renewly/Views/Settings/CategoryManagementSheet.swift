//
//  CategoryManagementSheet.swift
//  Renewly
//

import SwiftUI

struct CategoryManagementSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var categoryManager = CategoryManager.shared
    
    @State private var showAddSheet = false
    @State private var newCategoryName = ""
    @State private var selectedIcon = "tag.fill"
    @State private var selectedColorHex = "6354EC"
    
    private let availableIcons = [
        "tag.fill", "film.fill", "music.note", "gamecontroller.fill", "doc.text.fill",
        "cloud.fill", "wrench.and.screwdriver.fill", "heart.fill", "book.fill",
        "cup.and.saucer.fill", "creditcard.fill", "cart.fill", "car.fill",
        "airplane", "tv.fill", "phone.fill", "wifi", "house.fill", "bolt.fill"
    ]
    
    private let availableColors = [
        "6354EC", "E50914", "1DB954", "9B51E0", "00C4CC", "3388FF",
        "FF9500", "FF2D55", "58CC02", "AF52DE", "007AFF", "FC4C02"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(categoryManager.allCategories) { category in
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(category.color.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: category.sfSymbolName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(category.color)
                            }
                            
                            Text(category.name)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.renewlyTextPrimary)
                            
                            Spacer()
                            
                            if category.isDefault {
                                Text("Default")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.renewlyTextMuted)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color(hex: "F2F2F6"))
                                    .clipShape(Capsule())
                            } else {
                                Button(action: {
                                    withAnimation {
                                        categoryManager.deleteCustomCategory(id: category.id)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 14))
                                        .foregroundColor(.renewlyAttention)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .padding(.vertical, 2)
                    }
                } header: {
                    Text("Categories")
                } footer: {
                    Text("Default categories cannot be removed. Custom categories you create can be used when adding or editing subscriptions.")
                }
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.renewlyPrimary)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.renewlyPrimary)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                NavigationStack {
                    Form {
                        Section("Category Name") {
                            TextField("e.g. Subscriptions, Hobbies", text: $newCategoryName)
                        }
                        
                        Section("Icon") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 10) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                    }) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(selectedIcon == icon ? Color.renewlyPrimaryLight : Color(hex: "F2F2F6"))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: icon)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(selectedIcon == icon ? Color.renewlyPrimary : Color.renewlyTextPrimary)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        
                        Section("Color") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 10) {
                                ForEach(availableColors, id: \.self) { hex in
                                    Button(action: {
                                        selectedColorHex = hex
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: hex))
                                                .frame(width: 34, height: 34)
                                            
                                            if selectedColorHex == hex {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .navigationTitle("New Category")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showAddSheet = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let trimmed = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmed.isEmpty {
                                    categoryManager.addCategory(
                                        name: trimmed,
                                        sfSymbolName: selectedIcon,
                                        colorHex: selectedColorHex
                                    )
                                    newCategoryName = ""
                                    showAddSheet = false
                                }
                            }
                            .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.renewlyPrimary)
                        }
                    }
                }
            }
        }
    }
}
