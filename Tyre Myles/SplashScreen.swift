//
//  SplashScreen.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/11/21.
//

import SwiftUI

struct SplashScreen: View {

	@State private var tabSelection = 0

	var body: some View {
		TabView(selection: $tabSelection) {
			SceneOne()
				.tag(0)

			SceneTwo()
				.tag(1)

			SceneThree()
				.tag(2)
		}
		.tabViewStyle(.page)
		.ignoresSafeArea()
	}
}


struct SceneOne: View {
	var body: some View {
		ZStack {
			Color.gray.ignoresSafeArea()
			VStack {
				Text("Tyre Myles")
					.font(Font.system(size: 55).weight(.semibold))
					.foregroundStyle(LinearGradient(colors: [.orange, .white, .orange], startPoint: .leading, endPoint: .trailing))
				GroupBox {
					Text("Track milage on multiple")
					Text("sets of tires for your ride.")
				}.font(.title2.bold())
			}
		}
	}
}

struct SceneTwo: View {
	var body: some View {
		ZStack {
			Color.gray.ignoresSafeArea()
			VStack {
				Text("Tyre Myles")
					.font(Font.system(size: 55).weight(.semibold))
					.foregroundStyle(LinearGradient(colors: [.orange, .white, .orange], startPoint: .leading, endPoint: .trailing))

				Image("Splash2")
					.resizable()
					.scaledToFit()
					.clipShape(RoundedRectangle(cornerRadius: 25))
					.frame(width: 300, height: 300)
				GroupBox {
					Text("Enter tire type, name,")
					Text("and miles on the vehicle")
					Text("when these tires were installed.")
				}.font(.title2.bold())
					.padding([.top, .bottom], 50)
			}
		}
	}
}

struct SceneThree: View {
	@Environment(\.dismiss) var dismiss

	var body: some View {
		ZStack {
			Color.gray.ignoresSafeArea()
			VStack {
				Image("Summary")
					.resizable()
					.scaledToFit()
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.frame(width: 400, height: 500)

				GroupBox {
					Text("Keep a log of your wheels.")
					Text("Sync's accross iCloud.")
				}.font(.title2.bold())

				Button {
					dismiss()
				} label: {
					Text("Get Started")
						.font(.title2)
				}.buttonStyle(.borderedProminent)
					.padding()
			}
		}
	}
}

#if DEBUG
struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
//        SplashScreen()
		SceneOne()
		SceneTwo()
		SceneThree()
    }
}
#endif
