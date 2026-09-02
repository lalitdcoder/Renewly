//
//  CategoryManager.swift
//  Renewly
//

import SwiftUI
import Foundation

struct CustomCategoryItem: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var sfSymbolName: String
    var colorHex: String
    var isDefault: Bool
    
    var color: Color {
        Color(hex: colorHex)
    }
}

@Observable
final class CategoryManager {
    static let shared = CategoryManager()
    
    var customCategories: [CustomCategoryItem] = [] {
        didSet {
            saveCustomCategories()
        }
    }
    
    static let defaultCategories: [CustomCategoryItem] = [
        CustomCategoryItem(id: "entertainment", name: "Entertainment", sfSymbolName: "film.fill", colorHex: "E50914", isDefault: true),
        CustomCategoryItem(id: "music", name: "Music", sfSymbolName: "music.note", colorHex: "1DB954", isDefault: true),
        CustomCategoryItem(id: "gaming", name: "Gaming", sfSymbolName: "gamecontroller.fill", colorHex: "9B51E0", isDefault: true),
        CustomCategoryItem(id: "productivity", name: "Productivity", sfSymbolName: "doc.text.fill", colorHex: "00C4CC", isDefault: true),
        CustomCategoryItem(id: "storage", name: "Storage", sfSymbolName: "cloud.fill", colorHex: "3388FF", isDefault: true),
        CustomCategoryItem(id: "utilities", name: "Utilities", sfSymbolName: "wrench.and.screwdriver.fill", colorHex: "FF9500", isDefault: true),
        CustomCategoryItem(id: "health", name: "Health & Fitness", sfSymbolName: "heart.fill", colorHex: "FF2D55", isDefault: true),
        CustomCategoryItem(id: "education", name: "Education", sfSymbolName: "book.fill", colorHex: "58CC02", isDefault: true),
        CustomCategoryItem(id: "lifestyle", name: "Lifestyle", sfSymbolName: "cup.and.saucer.fill", colorHex: "AF52DE", isDefault: true),
        CustomCategoryItem(id: "finance", name: "Finance", sfSymbolName: "creditcard.fill", colorHex: "007AFF", isDefault: true),
        CustomCategoryItem(id: "other", name: "Other", sfSymbolName: "square.grid.2x2.fill", colorHex: "8E8E93", isDefault: true)
    ]
    
    private let userDefaultsKey = "renewly_custom_categories_v1"
    
    private init() {
        loadCategories()
    }
    
    var allCategories: [CustomCategoryItem] {
        CategoryManager.defaultCategories + customCategories
    }
    
    var allCategoryNames: [String] {
        allCategories.map { $0.name }
    }
    
    func category(forName name: String) -> CustomCategoryItem {
        if let match = allCategories.first(where: { $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame }) {
            return match
        }
        // Fallback
        return CustomCategoryItem(
            id: name.lowercased().replacingOccurrences(of: " ", with: "_"),
            name: name,
            sfSymbolName: "tag.fill",
            colorHex: "6354EC",
            isDefault: false
        )
    }
    
    func iconName(for categoryName: String) -> String {
        category(forName: categoryName).sfSymbolName
    }
    
    func color(for categoryName: String) -> Color {
        category(forName: categoryName).color
    }
    
    func addCategory(name: String, sfSymbolName: String = "tag.fill", colorHex: String = "6354EC") {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !allCategoryNames.contains(where: { $0.localizedCaseInsensitiveCompare(trimmed) == .orderedSame }) else { return }
        
        let newCat = CustomCategoryItem(
            id: UUID().uuidString,
            name: trimmed,
            sfSymbolName: sfSymbolName,
            colorHex: colorHex,
            isDefault: false
        )
        customCategories.append(newCat)
    }
    
    func deleteCustomCategory(id: String) {
        customCategories.removeAll { $0.id == id && !$0.isDefault }
    }
    
    private func loadCategories() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([CustomCategoryItem].self, from: data) {
            self.customCategories = decoded
        }
    }
    
    private func saveCustomCategories() {
        if let encoded = try? JSONEncoder().encode(customCategories) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
}
