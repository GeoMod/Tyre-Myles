//
//  SplashScreen.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/11/21.
//

import SwiftUI

struct SplashScreen: View {

	var body: some View {
		ZStack {
			Color.gray.ignoresSafeArea()
			VStack {
				Text("Tyre Myles")
					.font(Font.system(size: 45).weight(.semibold))
					.foregroundStyle(LinearGradient(colors: [.orange, .white, .orange], startPoint: .leading, endPoint: .trailing))
				HStack {
					Spacer()
					VStack(alignment: .trailing) {
						Text("Track milage for multiple")
						Text("sets of tires for your ride.")
					}
					.padding(.trailing, 30)
				}
				.padding([.top, .bottom], 50)

				Button {
					//get started
				} label: {
					Text("Get Started")
						.font(.largeTitle)
				}.buttonStyle(.borderedProminent)
					.padding()
			}
		}
	}
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
