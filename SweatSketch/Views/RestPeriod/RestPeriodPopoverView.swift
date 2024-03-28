//
//  RestPeriodPopoverView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.03.2024.
//

import SwiftUI

struct RestPeriodPopoverView: View {
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            Text ("Rest between exercises")
                .font(.title3)
            HStack {
                DurationView(durationInSeconds: 3601)
            }
        }
           
    }
}

struct RestPeriodPopoverView_Preview : PreviewProvider {
    
    static var previews: some View {
        RestPeriodPopoverView()
    }
}
