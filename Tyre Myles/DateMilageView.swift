//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {
	@EnvironmentObject var dataModel: DataModel
	@ObservedObject var currentTire: TireEntity

	@State private var isEditingDetails = false
	@State private var totalMilage = "---"

	@State private var tireStatus: TireStatus = .inStorage


	var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .firstTextBaseline) {
				Text("Intallation")
					.font(.title3.bold())
			}
			HStack {
				Text("Date:")
				Text(currentTire.installDate ?? Date(), style: .date)
			}

			HStack {
				Text("Milage:")
				Text(String(format: "%.0f", currentTire.installMiles))
			}

			Group {
				Text("Removal")
					.font(.title3.bold())
					.padding(.top)
				HStack {
					Text("Date:")
					Text(currentTire.removalDate ?? Date(), style: .date)
				}
				HStack {
					Text("Milage:")
						.padding(.trailing)
					Text(String(format: "%.0f", currentTire.removalMiles))
						.padding(.leading, -10)
				}
			}

			//.opacity(tireStatus == .inStorage ? 1.0 : 0.25)

			HStack {
				Text("Total Tyre Myles")
					.bold()

				Spacer()

				Text(totalMilage)
					.underline()
					.foregroundColor(.blue)
					.padding([.top, .bottom])
					.onTapGesture {
						isEditingDetails.toggle()
					}
			}.font(.title2)
		}.font(.footnote.monospaced())
			.onAppear {
				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			}

			.sheet(isPresented: $isEditingDetails) {
				// on dismiss
				totalMiles(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			} content: {
				EditTireView(currentTire: currentTire)
			}

	}


	 private func totalMiles(installation: Double, removal: Double) {
		let total = removal - installation
		 if total > 0 {
			totalMilage = String(Int(total))
		} else {
			totalMilage = "On Vehicle"
		}
	}

	private func updateTireStatus() {
		// TODO: update tire status in coreData when toggle is changed.
//		dataModel.saveTireProfileWith(name: currentTire.name, season: currentTire.seasonType, isInStorage: tireStatus, installMiles: <#T##String#>, removalMiles: <#T##String#>, installDate: <#T##Date#>, removallDate: <#T##Date#>)
	}

	

}

//struct DateMilageView_Previews: PreviewProvider {
//    static var previews: some View {
//		DateMilageView()
//			.preferredColorScheme(.dark)
//    }
//}
