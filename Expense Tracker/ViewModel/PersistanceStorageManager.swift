//
//  PersistanceStorageManager.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 07/05/23.
//

import Foundation

// MARK: Cache Manager
final class CacheManager<StorageType: Codable> {
    private let cacheFileName: String
    private var cacheCount: Int
    
    init(cacheFileName: String) {
        self.cacheFileName = cacheFileName
        self.cacheCount = 0
        setCacheCount()
    }
    
    // MARK: Private Methods
    private var storageURL:URL? {
        let documentDirectoryURL: URL? = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        return documentDirectoryURL?.appendingPathComponent(self.cacheFileName)
    }
    
    private func deleteCache() {
        if let fileURL = storageURL {
            do {
                try? FileManager.default.removeItem(at: fileURL)
                self.cacheCount = 0
            }
        }
    }
    
    private func setCacheCount() {
        self.cacheCount = getCachedList().count
    }
    
    // MARK: Public Methods
    var isCacheAvailable: Bool {
        if let path = storageURL?.path {
            return FileManager.default.fileExists(atPath: path)
        }
        return false
    }
    
    var getCacheCount: Int {
        return self.cacheCount
    }
    
    func removeCachedList() -> [StorageType] {
        if let url = storageURL {
            do {
                guard let data = try? Data(contentsOf: url) else { return [] }
                let jsonData = (try? JSONDecoder().decode([StorageType].self, from: data)) ?? []
                deleteCache()
                return jsonData
            }
        }
        return []
    }
    
    func getCachedList() -> [StorageType] {
        if let url = storageURL {
            do {
                guard let data = try? Data(contentsOf: url) else { return [] }
                let jsonData = (try? JSONDecoder().decode([StorageType].self, from: data)) ?? []
                return jsonData
            }
        }
        return []
    }
    
    func saveByOverwrite(_ list: [StorageType]) {
        do {
            guard let data = try? JSONEncoder().encode(list) else { return }
            if let url = storageURL {
                try? data.write(to: url)
                self.cacheCount = list.count
            }
        }
    }
    
    func saveByOverride(_ list: [StorageType]) {
        saveByOverwrite(getCachedList() + list)
    }
    
    func clearCache(){
        deleteCache()
    }
}
