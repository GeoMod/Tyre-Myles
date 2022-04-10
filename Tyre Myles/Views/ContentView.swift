//
//  ContentView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI
import CoreData


struct ContentView: View {
	@EnvironmentObject var dataModel: CoreDataModel

	@State private var editing: EditMode = .inactive
	@State private var selectedTireSeason: TireType = .allSeason

	@State private var isShowingNotesView = false
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
					ForEach(dataModel.savedTires, id: \.id) { tire in
						Section(header: Text(tire.seasonType!)
									.font(.largeTitle.bold())
									.foregroundColor(.gray)
						) {
							Button {
								selectedTire = tire
							} label: {
								HStack {
									Text(tire.name!)
										.font(Font.title2.bold())
									Spacer()
									Image(systemName: "note.text.badge.plus")
										.font(.title2)
										.symbolRenderingMode(.multicolor)
										.foregroundStyle(.gray, .blue)
								}
							}.buttonStyle(.plain)

							DateMilageView(currentTire: tire)

						}.headerProminence(.increased)

					}.onDelete { index in
						dataModel.deleteTire(at: index)
					}
				}.listStyle(.insetGrouped)
			}
			.onAppear { animatePlusButton() }
			.navigationTitle("Tyre Myles")
		}

		.sheet(item: $selectedTire, content: { selection in
			NotesView(currentTire: selection)
		})


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
