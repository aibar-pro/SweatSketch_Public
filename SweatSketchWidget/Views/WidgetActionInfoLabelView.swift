//
//  WidgetActionInfoLabelView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 17.04.2024.
//

import SwiftUI

struct WidgetActionInfoLabelView: View {
    var title: String
    var repsCount: Int16?
    var repsMax: Bool?
    var duration: Int?
    
    var body: some View {
        
        HStack(alignment: .top) {
            Text(title)
            Spacer()
            if let duration = duration {
                HStack(alignment: .center) {
                    Image(systemName: "timer")
                    let futureEndDate = futureDate(fromDuration: duration)
                    Text(futureEndDate, style: .timer)
                }
            } else if let maximumRepetitions = repsMax, maximumRepetitions {
                Text("xMAX")
            } else if let reps = repsCount {
                Text("x\(reps)")
            }
        }
    }
    
    func futureDate(fromDuration duration: Int) -> Date {
        let now = Date()
        return Calendar.current.date(byAdding: .second, value: duration, to: now)!
    }
}


#Preview {
    WidgetActionInfoLabelView(title: "Untitled", duration: 200)
}
