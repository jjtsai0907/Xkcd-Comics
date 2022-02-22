//
//  ButtonView.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI

struct ButtonView: View {
    let icon: String
    let title: String
    let function: () -> Void
    
    var body: some View {
        Button(action: {
            function()
        }, label: {
            HStack {
                if title == "Next" {
                    Text(title)
                    Image(systemName: icon)
                } else {
                    Image(systemName: icon)
                    Text(title)
                }
            }
        }).padding()
    }
}

/*struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}*/
