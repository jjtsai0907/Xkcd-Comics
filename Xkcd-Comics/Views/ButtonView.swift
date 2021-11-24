//
//  ButtonView.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI

struct ButtonView: View {
    
    var icon: String
     var title: String
     var function: () -> ()
    
    var body: some View {
        Button(action: {
            function()
        }, label: {
            HStack{
                Image(systemName: icon)
                Text(title)
            }
            
        }).padding()
    }
}

/*struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}*/
