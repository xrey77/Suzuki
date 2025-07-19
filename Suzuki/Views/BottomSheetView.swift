//
//  TestView.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/14/25.
//

import SwiftUI

struct BottomSheetView: View {
    @State private var showActionSheet = false
    
    var body: some View {
        Button {
            showActionSheet.toggle()
        } label: {
            Image(systemName: "person.fill")
        }
        .actionSheet(isPresented: $showActionSheet) {
            userSheet()
        }
    }
    
    func userSheet() -> ActionSheet {

        let picturButton = ActionSheet.Button.default(Text("Change Profile Picture")) {
                print("Change Profile")
            }
        let profileButton = ActionSheet.Button.default(Text("Edit Profile Information")) {
            print("Edit Profile")
        }
        let logOutButton = ActionSheet.Button.destructive(Text("Log Out")) {
            print("Log Out")
        }
        let cancelButton = ActionSheet.Button.cancel(Text("Cancel")) {
            print("Cancel")
        }

        let buttons: [ActionSheet.Button] = [picturButton, profileButton, logOutButton, cancelButton]

        
        return ActionSheet(title: Text("Change Your Profile"),
                           message: Text(""),
                           buttons: buttons)
    }
    
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView()
    }
}
