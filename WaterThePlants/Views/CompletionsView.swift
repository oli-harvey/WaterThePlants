//
//  CompletionsView.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 19/11/2020.
//

import SwiftUI

struct CompletionsView: View {
    var task: Task
    @Binding var dummy: Bool
    @State var doneSymbolSize: CGFloat = 1
    var doneSymbolSizeMax: CGFloat = 3
//    @State var doneSymbolOpacity: Double = 0
//    @State var doneSymbolColor: Color = .green
//    @State var doneSymbol: String = "checkmark.circle"
    
    var body: some View {
        HStack {
            ForEach(0 ..< maxTimes()) { comp in
                Image(systemName: imageNameFor(comp))
                    .foregroundColor(dummy ? colorFor(comp) : colorFor(comp))
                    .transition(.scale)
                    .scaleEffect(sizeFor(comp))
                    .onChange(of: imageNameFor(comp), perform: { value in
                        doneSymbolAnimation(symbol: value, comp: comp)
                    })
            }
        }
        .padding(.vertical)
    }
    
    func maxTimes() -> Int {
        return min(5,Int(task.repetitions))
    }
    
    func imageNameFor(_ comp: Int) -> String {
        if comp + 1 > task.lastCompletions.count {
            return "circle"
        } else if task.lastCompletions[comp] {
            return "checkmark.circle"
        } else {
            return "minus.circle"
        }
    }
    
    func colorFor(_ comp: Int) -> Color {
        if comp + 1 > task.lastCompletions.count {
            return .gray
        } else if task.lastCompletions[comp] {
            return .green
        } else {
            return .red
        }
    }
    func doneSymbolAnimation(symbol: String, comp: Int) {
        withAnimation(.easeIn(duration: 0.4)) {
            doneSymbolSize = doneSymbolSizeMax
        }

        let deadline2 = DispatchTime.now() + 0.45
        DispatchQueue.main.asyncAfter(deadline: deadline2) {
            withAnimation(Animation.linear(duration: 0.001)) {
                doneSymbolSize = 1
            }
        }
    }
    func sizeFor(_ comp: Int) -> CGFloat {
        if comp == task.lastCompletions.count - 1 {
            return doneSymbolSize
        } else {
            return 1
        }
    }
}

