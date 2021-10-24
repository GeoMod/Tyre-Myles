//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI

struct DateMilageView: View {

	@State private var installDate = Date()
	@State private var removalDate = Date()

	@State private var savedInstallDate = ""
	@State private var savedRemovalDate = ""

	@AppStorage("installDistance") var installDistance = ""
	
	@State private var removalMilage = ""
	@State private var totalMilage = "0"

	@State private var isPresentingDateSheet = false
	@State private var isPresendingMilageSheet = false

	var body: some View {
		VStack {
			HStack {
				VStack (alignment: .center, spacing: 5) {
					Text("Install Date")
					TextField("Install Date", text: $savedInstallDate, prompt: Text("Make Selection"))
						.onTapGesture {
							isPresentingDateSheet.toggle()
						}
						.textFieldStyle(.roundedBorder)
				}.padding(.bottom)

				VStack(alignment: .center, spacing: 5) {
					Text("Removal Date")
					TextField("Removal Date", text: $savedRemovalDate, prompt: Text("Make Selection"))
						.textFieldStyle(.roundedBorder)
				}.padding(.bottom)
			}

			HStack {
				VStack(alignment: .center, spacing: 5) {
					Text("Install Milage")
					TextField("Install Milage", text: $installDistance, prompt: Text("Make Selection"))
						.textFieldStyle(.roundedBorder)
						.onTapGesture {
							isPresendingMilageSheet.toggle()
						}
				}

				VStack(alignment: .center, spacing: 5) {
					Text("Removal Milage")
					TextField("Removal Milage", text: $removalMilage, prompt: Text("Make Selection"))
						.textFieldStyle(.roundedBorder)
						.onTapGesture {
							isPresendingMilageSheet.toggle()
						}
				}
			}

			Text("Total Tyre Myles")
				.bold()
				.padding([.top, .bottom], 5)
			Text("\(totalMilage)")
				.font(.largeTitle)
				.bold()
		}
		.font(.title3)
		.padding([.leading, .trailing])

		.sheet(isPresented: $isPresentingDateSheet) {
//			print("date picker was dismissed")
		} content: {
			DateSheetView(installDate: $installDate, removalDate: $removalDate)
		}

		.sheet(isPresented: $isPresendingMilageSheet) {
			// do nothing if dismissed manually
		} content: {
			MilageSheetView(installMilage: $installDistance, removalMilage: $removalMilage, totalMilage: $totalMilage)
		}
	}

	

}

struct DateMilageView_Previews: PreviewProvider {

    static var previews: some View {
        DateMilageView()
			.preferredColorScheme(.dark)
    }
}
