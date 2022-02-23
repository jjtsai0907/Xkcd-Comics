//
//  IconButtonView.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-26.
//

import SwiftUI

struct CustomIconButton: View {
    let icon: String
    let function: () -> Void
    
    var body: some View {
        Button(action: {
            function()
        }, label: {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: 20)
        }).padding(.trailing)
    }
}

/*struct IconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        IconButtonView()
    }
}*/
