//
//  PopUp.swift
//  Salahty
//
//  Created by shuruq alshammari on 03/04/1446 AH.
//

import Foundation
import SwiftUI

struct PopUp : View {
    @Binding var showPopup: Bool
    var checkpoint: Int
    var goal: String
    var onYesTap: () -> Void
    var onNoTap: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background
            //Color.black.opacity(0.4)
              //  .edgesIgnoringSafeArea(.all)
            Image("PopUpG")
                               .resizable()
                               .scaledToFit()
                               .frame(height: 320)
                             //  .background(in: Shape, fillStyle: FillStyle(color: .black.opacity(0.4)))
            
            
            VStack(spacing: 210) {
               

              //  Text("Checkpoint \(checkpoint + 1): ؟ '\(goal)'. هل صليت")
                Text(" هل صليت صلاه الفجر ؟")
                    .font(.headline)
                    .foregroundColor(.brown)
                    .bold()
                    .position(x: 190, y: 380)
                    .shadow(color: .white.opacity(0.9), radius: 3, x: 2, y: 2)

               
                HStack(spacing: 70) {
               
                   Button(action: {
                        onNoTap() // Handle No action
                   }) {
                        Image("Angry No") // Replace with your No button image asset
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80) // Adjust size as needed
                            .shadow(color: .red.opacity(0.9), radius: 10, x: 2, y: 2)
                    }
                       Button(action: {
                                           onYesTap() // Proceed to next checkpoint
                                       }) {
                                           Image("Happy Yes") // Replace with your Yes button image asset
                                               .resizable()
                                               .scaledToFit()
                                               .frame(height: 80) // Adjust size as needed
                                               .shadow(color: .green.opacity(0.9), radius: 10, x: 2, y: 2)
                                           
                                       } //.padding(Alignment( vertical: VerticalAlignment.center),30)
                }

                Button(action: {
                   showPopup = false
            }) {
            Image("Close Button")
                 .resizable()
                .scaledToFit()
                .frame(height: 30)
                .offset(x: 130 , y: -350)
               }
            }
            .padding()
            

        }
    }
}

    

struct PopUp_Previews: PreviewProvider {
@State static var showPopup = true
    
static var previews: some View {
       PopUp(
            showPopup: $showPopup,
           checkpoint: 0,
  goal: "Your goal here",
        onYesTap: { print("Yes tapped") },
           onNoTap: { print("No tapped") }
     )
    } }
