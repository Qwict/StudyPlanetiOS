//
// Created by Joris Van Duyse on 28/12/2023.
//

import SwiftUI

struct StopWatchUnit: View{
    var timeUnit: Int
    var timeUnitText: String
    var color: Color

    var timeUnitStr: String{
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }
    var body: some View {
        VStack{
            ZStack{
//                RoundedRectangle(cornerRadius: 15.0)
//                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
//                        .fill(color)
//                        .frame(width: 75, height: 75, alignment: .center)

                HStack{
                    Text(timeUnitStr.substring(index: 0))
//                            .font(.system(size: 48))
                            .frame(width: 10)

                    Text(timeUnitStr.substring(index: 1))
//                            .font(.system(size: 48))
                            .frame(width: 10)
                }
            }
//            Text(timeUnitText)
//                    .font(.system(size: 16))
        }
    }
}