//
//  ContentView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI


struct ContentView: View {
	@EnvironmentObject var model: CoreDataModel

	@State private var editing: EditMode = .inactive
	@State private var selectedTireSeason: TyreModel.SeasonType = .allSeason

	@State private var selectedTire: TireEntity? = nil

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
					ForEach(model.tires) { tire in
						Section(header: Text(tire.seasonType!)
							.font(.largeTitle.bold())
							.foregroundColor(.gray)
						) {
							DateMilageView(currentTire: tire)
						}.headerProminence(.increased)
					}.onDelete { index in
						model.deleteTire(at: index)
					}
				}.listStyle(.insetGrouped)
			}
			.onAppear { refreshList() }
			.navigationTitle("Tyre Myles")
		}

		.fullScreenCover(isPresented: $showIntroCard) {
			// View only displays on first use.
			// No action is made on dismiss.
		} content: {
			SplashScreen()
		}

	}

	private func refreshList() {
		if model.noTires {
			withAnimation {
				rotation = 360
			}
		}
	}

	private var PlusButton: some View {
		Image(systemName: "plus.circle")
			.font(.title)
			.symbolRenderingMode(.palette)
			.foregroundStyle(.primary, .blue)
			.rotationEffect(.degrees(rotation))
			.animation(Animation.easeInOut(duration: 1.0).repeatCount(4, autoreverses: true), value: rotation)
	}

	
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var animate = true

	static var previews: some View {
		Button {
//			selectedTire = tire
		} label: {
			Image(systemName: "note.text.badge.plus")
				.font(.title2)
				.symbolRenderingMode(.multicolor)
				.foregroundStyle(.gray, .blue)
		}
		.buttonStyle(.bordered)
	}
}
#endif
