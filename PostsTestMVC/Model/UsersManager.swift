//
//  UsersManager.swift
//  PostsTestMVC
//
//  Created by Ivan Yavorin on 03.12.2020.
//

import Foundation
class UsersManager {
   
   private lazy var usersQueue = DispatchQueue(label: "Users.Serving.Queue")
   
   var dataLoader:DataLoader?
   
   convenience init(dataLoader:DataLoader?) {
      self.init()
      self.dataLoader = dataLoader
   }
   
   
   func getUserWithId(userId:Int, completion:((User?) -> ())? = nil) {
      guard userId > 0 else {
         performOnMainQueue {
            completion?(nil)
         }
         
         return
      }
      
      usersQueue.async {[weak self] in
         if let storedUser = self?.loadUserFromStorageBy(userId) {
            performOnMainQueue {
               completion?(storedUser)
            }
            return
         }
       
         //start loading user by Id
         
         guard let loader = self?.dataLoader else {
            completion?(nil)
            return
         }
         
         loader.loadUserWithID(userId) {[weak self] (aUser) in
            if let weakerSelf = self, let user = aUser {
               
               let savedUser = weakerSelf.saveUserToDocuments(user: user)
               
               #if DEBUG
               print("User '\(user.id)' was saved to documents: \(savedUser)")
               #endif
               
               if let user = weakerSelf.loadUserFromStorageBy(userId) {
                  performOnMainQueue {
                     completion?(user) //SUCCESS getUserWith
                  }
               }
               else {
                  performOnMainQueue {
                     completion?(nil)
                  }
               }
               
            }
            else {
               performOnMainQueue {
                  completion?(nil)
               }
            }
         }
      }
   }
   
   private func loadUserFromStorageBy(_ userId:Int) -> User? {
      
      var aUser:User?
      
      guard let userFileURL = userFileURL(for: userId),
            FileManager.default.fileExists(atPath: userFileURL.path)
      else {
         return nil
      }
      
      do {
         let data = try Data(contentsOf: userFileURL)
         let user = try JSONDecoder().decode(User.self, from: data)
         aUser = user
      }
      catch (let decodeError) {
         #if DEBUG
         print("loadUserFromStorageBy '\(userId)' ERROR: \(decodeError.localizedDescription)")
         #endif
      }
      
      return aUser
   }
   
   @discardableResult
   private func saveUserToDocuments(user:User) -> Bool {
      
      var saved = false
      
      guard let userFileURL = userFileURL(for: user.id) else {
         return saved
      }
      
      do {
         let encodedUser = try JSONEncoder().encode(user)
         try encodedUser.write(to: userFileURL, options: Data.WritingOptions.atomic)
         saved = true
      }
      catch(let saveError) {
         #if DEBUG
         print("saveUserToDocuments ERROR: \(saveError.localizedDescription)")
         #endif
         saved = false
      }
      
      return saved
   }
}

fileprivate func userFileURL(for userId:Int) -> URL? {
   guard let doscURL = documentsURL() else {
      return nil
   }
   
   let postsFileURL = doscURL.appendingPathComponent("User-\(userId).bin")
   return postsFileURL
}
