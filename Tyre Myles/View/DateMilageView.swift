//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {
	@State private var showEditingSheet = false
//	@State private var totalMilage: Double = 0

	@State private var tireStatus: TireStatus = .inStorage

	@ObservedObject var currentTire: TireEntity

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Spacer()
				Text(currentTire.name ?? "")
					.font(Font.title2.bold())
					.minimumScaleFactor(0.5)
					.lineLimit(2)
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
//				Text(currentTire.totalTyreMyles, format: .number)
//					.bold()
//					.padding(.trailing)
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

			Text(currentTire.isInStorage ? "Removed" : "On Vehicle")
				.font(.title3.bold())
				.padding(.top)

			Group {
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

				HStack {
					Text("Total Tyre Myles").bold()

					Spacer()

					Button {
						showEditingSheet.toggle()
					} label: {
						Text(currentTire.totalTyreMyles, format: .number)
							.foregroundColor(.primary)
							.padding([.top, .bottom])
					}

				}.font(.title2)
			}.opacity(currentTire.isInStorage ? 1.0 : 0.25)
		}.font(.footnote.monospaced())
//			.onAppear {
//				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
//			}

			.sheet(isPresented: $showEditingSheet) {
				// on dismiss
//				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			} content: {
				EditTireView(currentTire: currentTire, previousInstallMileage: currentTire.installMiles, previousRemovalMilage: currentTire.removalMiles)
			}

			.background {
				if currentTire.isInStorage {
					Text("In Storage")
						.font(.largeTitle.bold())
						.opacity(0.08)
				}
			}
	}

//	private func totalMiles(installation: Double, removal: Double) {
//		totalMilage = (removal - installation).rounded()
//	}


}

//struct DateMilageView_Previews: PreviewProvider {
//    static var previews: some View {
//		DateMilageView(currentTire: entity.tires.first)
//			.preferredColorScheme(.dark)
//    }
//}
