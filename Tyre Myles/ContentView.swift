//
//  ContentView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI
import CoreData


struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var dataModel: DataModel

	@State private var selectedTireSeason: TireType = .allSeason
	@State private var editing: EditMode = .inactive

	// Animation
	@State private var rotation: Double = 0

	@AppStorage("showIntroCard") var showIntroCard = true


	var body: some View {
		NavigationView {
			VStack {

				HStack(alignment: .firstTextBaseline) {
					EditButton()
						.padding(.leading)
					Spacer()
					NavigationLink {
						AddTireView()
					} label: {
						PlusButton
							.padding(.trailing)
					}
				}

				List {
					ForEach(dataModel.savedTires, id: \.id) { tire in
						Section(header: Text(tire.seasonType!)
									.font(.largeTitle.bold())
									.foregroundColor(.gray)
						) {
							VStack {
								Text(tire.name!)
									.font(Font.title2.bold())
								DateMilageView(currentTire: tire)
							}
						}.headerProminence(.increased)
					}.onDelete { index in
						dataModel.deleteTire(at: index)
					}
				}.listStyle(.insetGrouped)
			}
			.onAppear { animatePlusButton() }
			.navigationTitle("Tyre Myles")
		}

		.fullScreenCover(isPresented: $showIntroCard) {
			// View only displays on first use.
			// No action is made on dismiss.
		} content: {
			SplashScreen()
		}



	}

	private func animatePlusButton() {
		if dataModel.savedTires.isEmpty {
			withAnimation {
				rotation = 360
			}
		} else {
			 return
		}
	}

	private var PlusButton: some View {
		Image(systemName: "plus.circle")
			.font(.title)
			.foregroundColor(dataModel.savedTires.isEmpty ? .green : .blue)
			.rotationEffect(.degrees(rotation))
			.animation(Animation.easeInOut(duration: 1.0).repeatCount(4, autoreverses: true), value: rotation)
	}

	
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var animate = true

	static var previews: some View {
		Text("Tyre Myles")
			.font(Font.system(size: 55).weight(.semibold))
			.foregroundStyle(LinearGradient(colors: [.orange, .white, .orange], startPoint: .leading, endPoint: .trailing))
//		Image(systemName: "plus.circle")
//			.font(.largeTitle)
//			.foregroundStyle(.green)
	}
}
#endif
