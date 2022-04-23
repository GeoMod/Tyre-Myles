//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {

	@State private var showEditingSheet = false
	@State private var showNotesView = false
	@State private var totalMilage: Double = 0

	@State private var tireStatus: TireStatus = .inStorage

	@ObservedObject var currentTire: TireEntity

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(currentTire.name!)
					.font(Font.title2.bold())
					.minimumScaleFactor(0.5)
					.lineLimit(2)
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				Text(currentTire.totalTyreMyles, format: .number)
					.bold()
					.padding(.trailing)

				Button {
					showNotesView.toggle()
				} label: {
					Image(systemName: "note.text.badge.plus")
						.font(.title)
						.symbolRenderingMode(.multicolor)
						.foregroundStyle(.gray, .blue)
				}

			}

			Divider()

			HStack(alignment: .firstTextBaseline) {
				Text("Installed")
					.font(.title3.bold())
			}
			HStack {
				Text("Date:")
				Text(currentTire.installDate ?? Date(), style: .date)
			}

			HStack {
				Text("Mileage:")
				Text(currentTire.installMiles.rounded(), format: .number)
			}

			Group {
				if currentTire.isInStorage {
					Text("Removed")
						.font(.title3.bold())
						.padding(.top)
				} else {
					Text("On Vehicle")
						.font(.title3.bold())
						.padding(.top)
						.opacity(0.5)
				}
				HStack {
					Text("Date:")
					Text(currentTire.removalDate ?? Date(), style: .date)
				}
				HStack {
					Text("Mileage:")
						.padding(.trailing)
					Text(currentTire.removalMiles.rounded(), format: .number)
						.padding(.leading, -10)
				}
			}.opacity(currentTire.isInStorage == true ? 1.0 : 0.25)

			HStack {
				Text("Total Tyre Myles")
					.bold()
					.opacity(currentTire.isInStorage == true ? 1.0 : 0.25)

				Spacer()

				Button {
					showEditingSheet.toggle()
				} label: {
					Text(totalMilage, format: .number)
						.opacity(!currentTire.isInStorage ? 0.25 : 1.0)
						.foregroundColor(.primary)
						.padding([.top, .bottom])
				}

//				if currentTire.isInStorage == false {
//					// Tires are on vehcile
//					Button {
//						showEditingSheet.toggle()
//					} label: {
//						Text(totalMilage, format: .number)
//							.opacity(0.25)
//							.foregroundColor(.primary)
//							.padding([.top, .bottom])
//					}
//				} else {
//					Button {
//						showEditingSheet.toggle()
//					} label: {
//						Text(totalMilage, format: .number)
//							.foregroundColor(.primary)
//							.padding([.top, .bottom])
//					}
//				}
			}.font(.title2)
		}.font(.footnote.monospaced())
			.onAppear {
				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			}

			.sheet(isPresented: $showEditingSheet) {
				// on dismiss
				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			} content: {
				EditTireView(currentTire: currentTire)
			}

//			.sheet(isPresented: $showNotesView) {
//				NotesView(currentTire: currentTire)
//			}
	}


	private func totalMiles(installation: Double, removal: Double) {
		totalMilage = (removal - installation).rounded()
	}


}

//struct DateMilageView_Previews: PreviewProvider {
//    static var previews: some View {
//		DateMilageView(currentTire: entity.tires.first)
//			.preferredColorScheme(.dark)
//    }
//}
